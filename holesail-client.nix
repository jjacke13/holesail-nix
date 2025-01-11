{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail-client";
  version = "1.1.7";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-5Eo8DjhwhCFrYoxG1uV2WhDuwBHf4RKzm1Xr1Hg3fQg=";
  };

  npmDepsHash = "sha256-lgwynr+b5hPlb3Wpzp2Z72bzIYvc24Zi+omcFPsJMVc=";

  npmPackFlags = [ "--ignore-scripts" ];

  buildPhase = "echo 'No build phase required'";
  meta = {
    description = "Holesail client !";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}