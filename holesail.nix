{ pkgs ? import <nixpkgs> {} }:

pkgs.buildNpmPackage rec {
  pname = "holesail";
  version = "2.4.1";

  src = pkgs.fetchFromGitHub {
    owner = "holesail";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-xIs49HoPV8j0yDPn29WhgS/mkIAEJLRiNNEmKChq0X4=";
  };

  postPatch = ''
    cp ${./package-lock.json} package-lock.json
  '';
  
  nodejs = pkgs.nodejs_24;
  npmDepsHash = "sha256-WRgC0IH/1Tuw69HQ7Nyf07lAI6SjOpYkIkux9vj8gLw=";

  npmPackFlags = [ "--ignore-scripts" ];
  
  dontNpmBuild = true;

  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
