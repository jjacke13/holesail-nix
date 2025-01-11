{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail-server";
  version = "1.4.4";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wSfB2sSXkF6Ur4oB09xWgoWFhDcPjh+725SImEknOPw=";
  };

  npmDepsHash = "sha256-siETl/PN+WvkUqZoJshrVsVzRNDWtO3BpTlGM7bC2cI=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail server !";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}