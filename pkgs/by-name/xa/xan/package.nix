{
  lib,
  rustPlatform,
  fetchFromGitHub,
  stdenv,
  darwin,
}:
let
  version = "0.26.0";
in
rustPlatform.buildRustPackage {
  pname = "xan";
  inherit version;

  src = fetchFromGitHub {
    owner = "medialab";
    repo = "xan";
    rev = "d16e06bd9bcdb4638812eae5c638e54debb7d684";
    hash = "sha256-A+lMeJlFQ8WzEPLNI7VZ9/VlqjO6UjYMA8Y4lD8pXW8=";
  };

  cargoHash = "sha256-RX8XKxNP2bkz7A4YCkl/Rmyb1s2GFvjW3WB6yTknjoY=";

  buildInputs = lib.optionals stdenv.hostPlatform.isDarwin (
    with darwin.apple_sdk.frameworks;
    [
      Security
    ]
  );

  checkFlags = [
    "--skip=moonblade::interpreter::tests::test_infix_operators"
  ];

  meta = {
    description = "The CSV magician";
    homepage = "https://github.com/medialab/xan";
    license = with lib.licenses; [
      mit
      unlicense
    ];
    maintainers = with lib.maintainers; [ uncenter ];
    mainProgram = "xan";
  };
}
