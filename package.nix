{ pkgs, python, packages, ... }:

pkgs.python3Packages.buildPythonPackage rec {
  pname = "cloudia-aws-reader";
  version = "0.1.0";
  src = ./.;

  propagatedBuildInputs = packages;

  postInstall = ''
    cp $out/bin/cloudia-aws-reader.py $out/bin/cloudia-aws-reader
  '';

}
