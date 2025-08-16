{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "2.3.0";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "39676c819046f999bff4044680d7f2d1b6b37b75";
    hash = "sha256-FcIjzo2dob/v3B8/S4pfci9l9CrL38pWgFv7m5r6rbk=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-AypnAB9aYrJfhrZdbEaZI0iW5Sh7fEe2V8hURqIGtj4=";

  npmPackFlags = [ "--ignore-scripts" ];
  
  dontNpmBuild = true;

  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
