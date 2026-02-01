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

  # Patch hyper-cmd-lib-net to add backpressure handling
  # This prevents memory exhaustion when streaming large files (like videos)
  # on low-memory devices (e.g., Raspberry Pi with 1GB RAM)
  postInstall = ''
    libNetFile="$out/lib/node_modules/holesail/node_modules/@holesail/hyper-cmd-lib-net/index.js"

    substituteInPlace "$libNetFile" \
      --replace-fail "connection.write(d)" "connection.write(d) || (loc.pause(), connection.once('drain', () => loc.resume()))" \
      --replace-fail "loc.write(d)" "loc.write(d) || (connection.pause(), loc.once('drain', () => connection.resume()))"
  '';

  meta = {
    description = "Holesail!";
    homepage = "holesail.io";
    license = pkgs.lib.licenses.gpl3Only;
  };
}
