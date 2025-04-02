{ pkgs, python, packages, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "cloudia";
  version = "0.1.0";
  src = ./.;

  propagatedBuildInputs = packages;

  postInstall = ''
    cp $out/bin/cloudia.py $out/bin/cloudia
  '';

}
