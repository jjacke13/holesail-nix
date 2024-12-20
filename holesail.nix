{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.8.3";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-R487u6QX0eyNyJ9kRe5kXJ0HUgYIB9yGdXJGiuZ1keA=";
  };

  npmDepsHash = "sha256-LYr5hNEC5e6ddQVYrgmOX2N/hJcrseJGOq58i4UHOLU=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
