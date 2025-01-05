{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.9.1";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bmR88SIadZWc/PVyQ6U2vYXa1IB3P23NfFituYQRodg=";
  };

  npmDepsHash = "sha256-EkAm0KsBvq31QfTV9ZQXWWNjCscUy7f0pZcdFY1k1yA=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
