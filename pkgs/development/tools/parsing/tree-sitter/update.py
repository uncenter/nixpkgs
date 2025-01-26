from urllib.parse import quote
import json
import subprocess as sub
import os
import sys
import requests
from typing import Iterator, Any, Literal, TypedDict, Optional
from tempfile import NamedTemporaryFile

DEBUG: bool = True if os.environ.get("DEBUG", False) else False
TOKEN: str | None = os.environ.get("GITHUB_TOKEN", None)

args: dict[str, Any] = json.loads(os.environ["ARGS"])
bins: dict[str, str] = args["binaries"]


def atomically_write(file_path: str, content: bytes) -> None:
    """Atomically write the `content` bytes into `file_path`."""
    with NamedTemporaryFile(
        # Write to the parent directory, so that it’s guaranteed to be on the same filesystem.
        dir=os.path.dirname(file_path),
        delete=False,
    ) as tmp:
        try:
            tmp.write(content)
            os.rename(src=tmp.name, dst=file_path)
        except Exception:
            os.unlink(tmp.name)


def fetch_github_api(
    url: str,
    token: str | None,
) -> Any | Literal["not found"]:
    """Query the GitHub API with a token."""
    headers = {"Authorization": "token " + token}

    res: Any = requests.get(url, headers=headers).json()
    match res:
        case dict(res):
            message: str = res.get("message", "")
            if "rate limit" in message:
                sys.exit("Rate limited by the Github API")
            if "Not Found" in message:
                return "not found"
    return res


def nix_prefetch_git(url: str, rev: str) -> bytes:
    """Prefetch a git repository"""
    args = [bins["nix-prefetch-git"]]
    if not DEBUG:
        args.append("--quiet")
    args.extend(["--no-deepClone", "--url", url, "--rev", rev])
    if DEBUG:
        print(str(args))
    return sub.check_output(args)


def update_grammar_json() -> None:
    """Fetch the given repository and write its nix-prefetch-git output to the corresponding grammar JSON file."""
    match jsonArg:
        case {
            "org": org,
            "repo": repo,
            "outputDir": outputDir,
            "nixRepoAttrName": nixRepoAttrName,
        }:
            release: str
            match fetch_github_api(
                url=f"https://api.github.com/repos/{quote(org)}/{quote(repo)}/releases/latest",
                token=TOKEN,
            ):
                case "not found":
                    if "branch" in jsonArg:
                        branch = jsonArg.get("branch")
                        release = f"refs/heads/{branch}"
                    else:
                        # GitHub sometimes returns an empty list even though there are releases.
                        print(f"Latest for {org}/{repo} is not there, using HEAD.")
                        release = "HEAD"
                case {"tag_name": tag_name}:
                    release = tag_name
                case _:
                    sys.exit(
                        f"git result for {org}/{repo} did not have a `tag_name` field"
                    )

            print(f"Fetching latest release ({release}) of {org}/{repo}...")
            res = nix_prefetch_git(
                url=f"https://github.com/{quote(org)}/{quote(repo)}",
                rev=release,
            )
            atomically_write(
                file_path=os.path.join(outputDir, f"{nixRepoAttrName}.json"),
                content=res,
            )
        case _:
            sys.exit("input json must have `org` and `repo` keys")


def fetch_organization_repositories(org: str) -> set[str]:
    """Fetch the latest (100) repositories from the given GitHub organization."""

    match fetch_github_api(
        url=f"https://api.github.com/orgs/{quote(org)}/repos?per_page=100", token=TOKEN
    ):
        case "not found":
            sys.exit(f"github organization {org} not found")
        case list(repos):
            res: list[str] = []
            for repo in repos:
                name = repo.get("name")
                if name:
                    res.append(name)
            return set(res)
        case _:
            sys.exit("github result was not a list of repos, but {other}")


Grammar = TypedDict(
    "Grammar",
    {"nixRepoAttrName": str, "orga": str, "repo": str, "branch": Optional[str]},
)


def update_grammars_file() -> None:
    """Print the grammars.nix file that imports all grammars."""
    allGrammars: list[dict[str, Grammar]] = jsonArg["allGrammars"]
    outputDir: str = jsonArg["outputDir"]

    def file() -> Iterator[str]:
        yield "{ lib }:"
        yield "{"
        for grammar in allGrammars:
            n = grammar["nixRepoAttrName"]
            yield f"  {n} = lib.importJSON ./{n}.json;"
        yield "}"
        yield ""

    atomically_write(
        file_path=os.path.join(outputDir, "default.nix"),
        content="\n".join(file()).encode(),
    )


match sys.argv[1]:
    case "add":
        update_grammar_json(sys.argv[2])
        update_grammars_file()
    case "update":
        match sys.argv[2]:
            case "--all":
                ...
            case _:
                update_grammar_json(sys.argv[2])
    case "scan":
        print("Fetching list of repositories...")
        latest_repos = fetch_organization_repositories(org="tree-sitter")
        print("Checking the Tree-sitter repositories against known grammars...")
        known: set[str] = set(args["knownTreeSitterOrgGrammarRepos"])
        ignored: set[str] = set(args["ignoredTreeSitterOrgRepos"])

        unknown = latest_repos - (known | ignored)

        if unknown:
            sys.exit(f"These repositories are neither known nor ignored:\n{unknown}")
    case _:
        sys.exit(f"mode {sys.argv[1]} unknown")
