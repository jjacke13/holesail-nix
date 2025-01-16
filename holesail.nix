{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.9.2";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-Zk5fCNRa1HOMvstW5WbbNIrBMpCgRC1Z8mnB80MiIAg=";
  };

  npmDepsHash = "sha256-FAmJO1Jxm7S8JAXd5MJugIBNyO40s+51gelPMN87tkg=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
