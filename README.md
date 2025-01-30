# Holesail-nix
Holesail package for the Nix package manager

This is a build of the amazing Holesail.io for the Nix package manager

In NixOS or non-NixOS linux (but with Nix installed), run: 

	nix-build holesail.nix

If you have flakes enabled:

	nix build github:jjacke13/holesail-nix

Also available nix-shell with the above package in PATH:

	nix develop github:jjacke13/holesail-nix

Modules available: 

- nixosModules.aarch64-linux.holesail-client
- nixosModules.x86_64-linux.holesail-client
- nixosModules.aarch64-linux.holesail-server
- nixosModules.x86_64-linux.holesail-server

You can include any of the above in your configuration by adding:

	holesail.url = "github:jjacke13/holesail-nix";  

to your flake inputs and then:

	nixosConfigurations.<name> = nixpkgs.lib.nixosSystem {
      		specialArgs = { inherit inputs;};
      		modules = [
			inputs.holesail.nixosModules.aarch64-linux.holesail-server #or any of the above
        		.... #other modules
        		];      
	};

then you can use the configuration options provided by the modules in your configuration



For documentation on how to use Holesail, go to: https://docs.holesail.io/ .

Notice: the MIT license here, refers to the code of this repository. License of the actual Holesail package is GPL3.0

Holesail-client and server in modules directory are NixOS configuration modules. Currently working but still WORK IN PROGRESS!!!
