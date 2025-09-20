{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "2.3.1";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "2f36778e001408bb47aee6a5dd82370b5cefedce";
    hash = "sha256-T4NyHKjZNGwB/kKikRzxZlPynpszQyBlK9+pgn8pHxc=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  
  nodejs = pkgs.nodejs_24;
  npmDepsHash = "sha256-S31r95mtVwSxNqC6gDX1vg6suM5kSW/t5kHJMNjnQsk=";

  npmPackFlags = [ "--ignore-scripts" ];
  
  dontNpmBuild = true;

  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
