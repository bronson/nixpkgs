{ lib
, buildPythonPackage
, pythonOlder
, fetchFromGitHub
, poetry-core
, async-timeout
, bleak
, dbus-fast
, myst-parser
, pytestCheckHook
, sphinxHook
, sphinx-rtd-theme
}:

buildPythonPackage rec {
  pname = "bluetooth-adapters";
  version = "0.5.2";
  format = "pyproject";

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "Bluetooth-Devices";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-SyEe/auJaagRl3wg7JjBkLAgHyAeCeesEXvWXE733M4=";
  };

  postPatch = ''
    # Drop pytest arguments (coverage, ...)
    sed -i '/addopts/d' pyproject.toml
  '';

  outputs = [
    "out"
    "doc"
  ];

  nativeBuildInputs = [
    myst-parser
    poetry-core
    sphinx-rtd-theme
    sphinxHook
  ];

  propagatedBuildInputs = [
    async-timeout
    bleak
    dbus-fast
  ];

  pythonImportsCheck = [
    "bluetooth_adapters"
  ];

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    changelog = "https://github.com/bluetooth-devices/bluetooth-adapters/blob/main/CHANGELOG.md";
    description = "Tools to enumerate and find Bluetooth Adapters";
    homepage = "https://bluetooth-adapters.readthedocs.io/";
    license = licenses.asl20;
    maintainers = teams.home-assistant.members;
  };
}
