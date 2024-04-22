{
  lib,
  rustPlatform,
  fetchFromGitHub,
}: let
  version = "0.1.4";
in
  rustPlatform.buildRustPackage {
    pname = "imgcatr";
    inherit version;

    src = fetchFromGitHub {
      owner = "SilinMeng0510";
      repo = "imgcatr";
      rev = "v${version}";
      sha256 = "sha256-Dip2pfEG6gI07SjpJeB3tZfn+es9DDQBqNzdLft0ld0=";
    };

    cargoHash = "sha256-dVgPp5jY3ii8mO/HLTDESQzQyZXzqut8Bjm2KfWD0+U=";

    meta = {
      description = "Cat for images";
      homepage = "https://github.com/SilinMeng0510/imgcatr";
      license = lib.licenses.mit;
      maintainers = [lib.maintainers.uncenter];
      mainProgram = "imgcatr";
    };
  }
