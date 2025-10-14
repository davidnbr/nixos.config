{
  lib,
  python3,
  fetchPypi,
  terraform,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "terraform-local";
  version = "0.20.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jPvW5VY4FV+6FNmcH3SB5cKhS3FHVQCgUgWQm6QKwHo=";
  };

  propagatedBuildInputs = [ terraform ];

  # No tests in PyPI package
  doCheck = false;

  meta = with lib; {
    description = "Thin wrapper to run Terraform against LocalStack";
    homepage = "https://github.com/localstack/terraform-local";
    license = licenses.asl20;
    maintainers = [ ];
    mainProgram = "tflocal";
  };
}
