{
  lib,
  appdirs,
  buildPythonPackage,
  distro,
  fetchFromGitHub,
  filelock,
  pytestCheckHook,
  pytest-mock,
  pythonOlder,
  requests,
  setuptools-scm,
}:

buildPythonPackage rec {
  pname = "iterative-telemtry";
  version = "0.0.9";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "iterative";
    repo = "telemetry-python";
    tag = version;
    hash = "sha256-bcGniytjlN3JFPeMQYjyIP8Ruty9/dnzp9neclbdsfU=";
  };

  build-system = [ setuptools-scm ];

  dependencies = [
    requests
    appdirs
    filelock
    distro
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-mock
  ];

  pythonImportsCheck = [ "iterative_telemetry" ];

  meta = with lib; {
    description = "Common library to send usage telemetry";
    homepage = "https://github.com/iterative/iterative-telemetry";
    changelog = "https://github.com/iterative/iterative-telemetry/releases/tag/${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ melling ];
  };
}
