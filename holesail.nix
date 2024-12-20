{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.8.4";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-htaXKozyPoJEcxakCxsbIWgdHWMYyICYxG+Kv2uEdDc=";
  };

  npmDepsHash = "sha256-S/ugVA2l+seDSeWhN5fIDnFheWHnYD823J8VGofunvs=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
