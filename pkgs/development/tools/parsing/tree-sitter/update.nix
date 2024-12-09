{
  lib,
  writeShellApplication,
  nix-prefetch-git,
  jq,
  curl,
}:

# https://github.com/tree-sitter/tree-sitter/wiki/List-of-parsers

let
  # Grammars we want to fetch from the Tree-sitter GitHub organization.
  officialTreeSitterGrammarNames = [
    "tree-sitter-javascript"
    "tree-sitter-c"
    "tree-sitter-json"
    "tree-sitter-cpp"
    "tree-sitter-ruby"
    "tree-sitter-go"
    "tree-sitter-c-sharp"
    "tree-sitter-python"
    "tree-sitter-typescript"
    "tree-sitter-rust"
    "tree-sitter-bash"
    "tree-sitter-php"
    "tree-sitter-java"
    "tree-sitter-scala"
    "tree-sitter-ocaml"
    "tree-sitter-julia"
    "tree-sitter-html"
    "tree-sitter-haskell"
    "tree-sitter-regex"
    "tree-sitter-css"
    "tree-sitter-verilog"
    "tree-sitter-jsdoc"
    "tree-sitter-ql"
    "tree-sitter-ql-dbscheme"
    "tree-sitter-embedded-template"
    "tree-sitter-tsq"
    "tree-sitter-toml"
  ];

  # Additional grammars that are not in the official GitHub organization.
  # If you need a different grammar that conflicts with one in the official organization,
  # make sure to give it a different name.
  unofficialGrammars = {
    "tree-sitter-bitbake" = {
      org = "amaanq";
      repo = "tree-sitter-bitbake";
    };
    "tree-sitter-beancount" = {
      org = "polarmutex";
      repo = "tree-sitter-beancount";
    };
    "tree-sitter-bqn" = {
      org = "shnarazk";
      repo = "tree-sitter-bqn";
    };
    "tree-sitter-clojure" = {
      org = "sogaiu";
      repo = "tree-sitter-clojure";
    };
    "tree-sitter-comment" = {
      org = "stsewd";
      repo = "tree-sitter-comment";
    };
    "tree-sitter-dart" = {
      org = "usernobody14";
      repo = "tree-sitter-dart";
    };
    "tree-sitter-elisp" = {
      org = "wilfred";
      repo = "tree-sitter-elisp";
    };
    "tree-sitter-just" = {
      org = "IndianBoy42";
      repo = "tree-sitter-just";
    };
    "tree-sitter-nix" = {
      org = "cstrahan";
      repo = "tree-sitter-nix";
    };
    "tree-sitter-latex" = {
      org = "latex-lsp";
      repo = "tree-sitter-latex";
    };
    "tree-sitter-lua" = {
      org = "MunifTanjim";
      repo = "tree-sitter-lua";
    };
    "tree-sitter-fennel" = {
      org = "travonted";
      repo = "tree-sitter-fennel";
    };
    "tree-sitter-make" = {
      org = "alemuller";
      repo = "tree-sitter-make";
    };
    "tree-sitter-markdown" = {
      org = "MDeiml";
      repo = "tree-sitter-markdown";
    };
    "tree-sitter-proto" = {
      org = "mitchellh";
      repo = "tree-sitter-proto";
    };
    "tree-sitter-rego" = {
      org = "FallenAngel97";
      repo = "tree-sitter-rego";
    };
    "tree-sitter-rst" = {
      org = "stsewd";
      repo = "tree-sitter-rst";
    };
    "tree-sitter-svelte" = {
      org = "Himujjal";
      repo = "tree-sitter-svelte";
    };
    "tree-sitter-sql" = {
      org = "derekstride";
      repo = "tree-sitter-sql";
      branch = "gh-pages";
    };
    "tree-sitter-talon" = {
      org = "wenkokke";
      repo = "tree-sitter-talon";
    };
    "tree-sitter-typst" = {
      org = "uben0";
      repo = "tree-sitter-typst";
    };
    "tree-sitter-vim" = {
      org = "vigoux";
      repo = "tree-sitter-viml";
    };
    "tree-sitter-yaml" = {
      org = "ikatyang";
      repo = "tree-sitter-yaml";
    };
    "tree-sitter-zig" = {
      org = "maxxnino";
      repo = "tree-sitter-zig";
    };
    "tree-sitter-fish" = {
      org = "ram02z";
      repo = "tree-sitter-fish";
    };
    "tree-sitter-dot" = {
      org = "rydesun";
      repo = "tree-sitter-dot";
    };
    "tree-sitter-norg" = {
      org = "nvim-neorg";
      repo = "tree-sitter-norg";
    };
    "tree-sitter-norg-meta" = {
      org = "nvim-neorg";
      repo = "tree-sitter-norg-meta";
    };
    "tree-sitter-commonlisp" = {
      org = "thehamsta";
      repo = "tree-sitter-commonlisp";
    };
    "tree-sitter-cuda" = {
      org = "thehamsta";
      repo = "tree-sitter-cuda";
    };
    "tree-sitter-glsl" = {
      org = "thehamsta";
      repo = "tree-sitter-glsl";
    };
    "tree-sitter-dockerfile" = {
      org = "camdencheek";
      repo = "tree-sitter-dockerfile";
    };
    "tree-sitter-ledger" = {
      org = "cbarrete";
      repo = "tree-sitter-ledger";
    };
    "tree-sitter-gomod" = {
      org = "camdencheek";
      repo = "tree-sitter-go-mod";
    };
    "tree-sitter-gowork" = {
      org = "omertuc";
      repo = "tree-sitter-go-work";
    };
    "tree-sitter-graphql" = {
      org = "bkegley";
      repo = "tree-sitter-graphql";
    };
    "tree-sitter-pgn" = {
      org = "rolandwalker";
      repo = "tree-sitter-pgn";
    };
    "tree-sitter-perl" = {
      org = "ganezdragon";
      repo = "tree-sitter-perl";
    };
    "tree-sitter-kotlin" = {
      org = "fwcd";
      repo = "tree-sitter-kotlin";
    };
    "tree-sitter-scss" = {
      org = "serenadeai";
      repo = "tree-sitter-scss";
    };
    "tree-sitter-erlang" = {
      org = "abstractmachineslab";
      repo = "tree-sitter-erlang";
    };
    "tree-sitter-elixir" = {
      org = "elixir-lang";
      repo = "tree-sitter-elixir";
    };
    "tree-sitter-surface" = {
      org = "connorlay";
      repo = "tree-sitter-surface";
    };
    "tree-sitter-eex" = {
      org = "connorlay";
      repo = "tree-sitter-eex";
    };
    "tree-sitter-heex" = {
      org = "connorlay";
      repo = "tree-sitter-heex";
    };
    "tree-sitter-supercollider" = {
      org = "madskjeldgaard";
      repo = "tree-sitter-supercollider";
    };
    "tree-sitter-tlaplus" = {
      org = "tlaplus-community";
      repo = "tree-sitter-tlaplus";
    };
    "tree-sitter-glimmer" = {
      org = "alexlafroscia";
      repo = "tree-sitter-glimmer";
    };
    "tree-sitter-pug" = {
      org = "zealot128";
      repo = "tree-sitter-pug";
    };
    "tree-sitter-vue" = {
      org = "ikatyang";
      repo = "tree-sitter-vue";
    };
    "tree-sitter-elm" = {
      org = "elm-tooling";
      repo = "tree-sitter-elm";
    };
    "tree-sitter-yang" = {
      org = "hubro";
      repo = "tree-sitter-yang";
    };
    "tree-sitter-query" = {
      org = "nvim-treesitter";
      repo = "tree-sitter-query";
    };
    "tree-sitter-sparql" = {
      org = "bonabeavis";
      repo = "tree-sitter-sparql";
    };
    "tree-sitter-gdscript" = {
      org = "prestonknopp";
      repo = "tree-sitter-gdscript";
    };
    "tree-sitter-godot-resource" = {
      org = "prestonknopp";
      repo = "tree-sitter-godot-resource";
    };
    "tree-sitter-turtle" = {
      org = "bonabeavis";
      repo = "tree-sitter-turtle";
    };
    "tree-sitter-devicetree" = {
      org = "joelspadin";
      repo = "tree-sitter-devicetree";
    };
    "tree-sitter-r" = {
      org = "r-lib";
      repo = "tree-sitter-r";
    };
    "tree-sitter-bibtex" = {
      org = "latex-lsp";
      repo = "tree-sitter-bibtex";
    };
    "tree-sitter-fortran" = {
      org = "stadelmanma";
      repo = "tree-sitter-fortran";
    };
    "tree-sitter-cmake" = {
      org = "uyha";
      repo = "tree-sitter-cmake";
    };
    "tree-sitter-janet-simple" = {
      org = "sogaiu";
      repo = "tree-sitter-janet-simple";
    };
    "tree-sitter-json5" = {
      org = "joakker";
      repo = "tree-sitter-json5";
    };
    "tree-sitter-pioasm" = {
      org = "leo60228";
      repo = "tree-sitter-pioasm";
    };
    "tree-sitter-hjson" = {
      org = "winston0410";
      repo = "tree-sitter-hjson";
    };
    "tree-sitter-llvm" = {
      org = "benwilliamgraham";
      repo = "tree-sitter-llvm";
    };
    "tree-sitter-http" = {
      org = "ntbbloodbath";
      repo = "tree-sitter-http";
    };
    "tree-sitter-prisma" = {
      org = "victorhqc";
      repo = "tree-sitter-prisma";
    };
    "tree-sitter-org-nvim" = {
      org = "milisims";
      repo = "tree-sitter-org";
    };
    "tree-sitter-hcl" = {
      org = "MichaHoffmann";
      repo = "tree-sitter-hcl";
    };
    "tree-sitter-scheme" = {
      org = "6cdh";
      repo = "tree-sitter-scheme";
    };
    "tree-sitter-tiger" = {
      org = "ambroisie";
      repo = "tree-sitter-tiger";
    };
    "tree-sitter-nickel" = {
      org = "nickel-lang";
      repo = "tree-sitter-nickel";
    };
    "tree-sitter-smithy" = {
      org = "indoorvivants";
      repo = "tree-sitter-smithy";
    };
    "tree-sitter-jsonnet" = {
      org = "sourcegraph";
      repo = "tree-sitter-jsonnet";
    };
    "tree-sitter-solidity" = {
      org = "JoranHonig";
      repo = "tree-sitter-solidity";
    };
    "tree-sitter-nu" = {
      org = "nushell";
      repo = "tree-sitter-nu";
    };
    "tree-sitter-cue" = {
      org = "eonpatapon";
      repo = "tree-sitter-cue";
    };
    "tree-sitter-uiua" = {
      org = "shnarazk";
      repo = "tree-sitter-uiua";
    };
    "tree-sitter-wing" = {
      org = "winglang";
      repo = "tree-sitter-wing";
    };
    "tree-sitter-wgsl" = {
      org = "szebniok";
      repo = "tree-sitter-wgsl";
    };
    "tree-sitter-templ" = {
      org = "vrischmann";
      repo = "tree-sitter-templ";
    };
    "tree-sitter-gleam" = {
      org = "gleam-lang";
      repo = "tree-sitter-gleam";
    };
    "tree-sitter-koka" = {
      org = "mtoohey31";
      repo = "tree-sitter-koka";
    };
    "tree-sitter-earthfile" = {
      org = "glehmann";
      repo = "tree-sitter-earthfile";
    };
    "tree-sitter-river" = {
      org = "grafana";
      repo = "tree-sitter-river";
    };
  };

  allGrammars =
    let
      officialTreeSitterGrammars = lib.listToAttrs (
        map (repo: {
          name = repo;
          value = {
            org = "tree-sitter";
            inherit repo;
          };
        }) officialTreeSitterGrammarNames
      );
    in
    lib.attrsets.unionOfDisjoint unofficialGrammars officialTreeSitterGrammars;

  outputDir = "${toString ./.}/grammars";

  updateGrammars = writeShellApplication {
    name = "update-grammars";
    runtimeInputs = [
      curl
      jq
      nix-prefetch-git
    ];
    text = ''
      curl_with_token() {
        local url="$1"
        local token="''${GITHUB_TOKEN:-}"
        local args=(--location)
        if [ -n "$token" ]; then
            args+=(--header "Authorization: token $token")
        fi
        if [ -z "''${DEBUG:-}" ]; then
            args+=(--silent)
        fi
        curl "''${args[@]}" "$url"
      }
      add_grammar() {
        local name="$1"
        local org="$2"
        local repo="$3"
        local branch="''${4:-}"

        local result release

        result="$(curl_with_token "https://api.github.com/repos/$org/$repo/releases/latest")"
        case $(echo "$result" | jq -r '.message // empty') in
            *"Not Found"*)
                if [ -n "$branch" ]; then
                    release="refs/heads/$branch"
                else
                    echo "Latest for $org/$repo does not exist, using HEAD..."
                    release="HEAD"
                fi
                ;;
            *)
                release=$(echo "$result" | jq -r '.tag_name')
                ;;
        esac

        echo "Fetching $org/$repo ($release)..."
        nix flake prefetch --json "github:$org/$repo/$release" | jq '{ url: .locked.url, rev: .locked.rev, sha256: .hash }' > "${outputDir}/$name.json"
      }

      usage() {
        echo "usage: $0 [--all | --new | --check]"
        exit 1
      }

      if [ -z "$1" ]; then
        usage
      fi

      if [ -z "''${GITHUB_TOKEN:-}" ]; then
        echo "Warning: GITHUB_TOKEN is not set, you may hit the GitHub API rate limit."
      fi

      case $1 in
        --all)
          mkdir -p "${outputDir}"
          ${lib.concatMapAttrsStringSep "\n" (
            name: grammar: "add_grammar ${name} ${grammar.org} ${grammar.repo} ${grammar.branch or ""}"
          ) allGrammars}
          ;;
        --new)
          # Fetch only grammars that are not already in the grammars directory.
          mkdir -p "${outputDir}"
          ${lib.concatMapAttrsStringSep "\n" (name: grammar: ''
            if [ ! -e "${outputDir}/${name}.json" ]; then
              add_grammar ${name} ${grammar.org} ${grammar.repo} ${grammar.branch or ""}
            fi
          '') allGrammars}
          ;;
        --check)
          result="$(curl_with_token "https://api.github.com/orgs/tree-sitter/repos?per_page=100" | jq -r '.[] | select(.name | startswith("tree-sitter-")) | .name')"
          existing="${lib.concatStringsSep "\n" officialTreeSitterGrammarNames}"
          echo "Added grammars:"
          echo "$result" | grep -v -F -x -f <(echo "$existing")
          ;;
        *)
          usage
          ;;
      esac

      # If it was --all or --new, update the ./grammars/default.nix file.
    '';
  };
in
updateGrammars
