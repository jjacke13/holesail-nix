{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "1.8.0";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-wjXixbzxc2vSERZgGSTken9ZqkzlkNCDBpzWXKP0VYs=";
  };

  npmDepsHash = "sha256-bF2yK2JGQcqV/dobe8Sw8F3M2UAk8OH8s9odYFJ2otg=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
