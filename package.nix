{ pkgs, python, packages, ... }:

python.pkgs.buildPythonPackage rec {
  pname = "cloudia-aws-reader";
  version = "0.1.0";
  src = ./.;

  propagatedBuildInputs = with python.pkgs; [
    boto3
    botocore
    netaddr
    pyjq
    python-dateutil
    pyyaml
    jinja2
    parliament
    matplotlib
    pandas
    seaborn
    policyuniverse
    requests
    s3transfer
    toml
    urllib3
  ];

  postInstall = ''
    cp $out/bin/cloudia-aws-reader.py $out/bin/cloudia-aws-reader
    rm $out/bin/cloudia-aws-reader.py
  '';

}
