{ pkgs, python, packages, ... }:

python.pkgs.buildPythonPackage rec {
  pname = "cloudia-aws-reader";
  version = builtins.replaceStrings ["\n"] [""] (builtins.readFile ./VERSION);
  src = ./.;

  postPatch = ''
    substituteInPlace cloudia-aws-reader.py \
      --replace-quiet "__VERSION_PLACEHOLDER__" "${version}"
  '';

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
