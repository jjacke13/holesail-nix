# Holesail-nix
Holesail package for the Nix package manager

This is a build of the amazing Holesail.io for the Nix package manager (version 2)

## Installation

In NixOS or non-NixOS linux (but with Nix installed), run:

	nix-build holesail.nix

If you have flakes enabled:

	nix flake show github:jjacke13/holesail-nix
 to check this flake

To build holesail for your system:

	nix build github:jjacke13/holesail-nix

Also available nix-shell with the above package in PATH:

	nix develop github:jjacke13/holesail-nix

## NixOS Modules

Modules available:

- `nixosModules.aarch64-linux.holesail-client`
- `nixosModules.x86_64-linux.holesail-client`
- `nixosModules.aarch64-linux.holesail-server`
- `nixosModules.x86_64-linux.holesail-server`
- `nixosModules.x86_64-linux.holesail-filemanager`
- `nixosModules.aarch64-linux.holesail-filemanager`

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

then you can use the configuration options provided by the modules in your configuration.

Alternatively, if you want all the configuration options available, just use the module named `holesail` which includes all of the above modules.

## Module Features

All modules support:
- **User/Group Configuration** - Run services under specific users with customizable permissions
- **Logging** - Optional `--log` flag for detailed output
- **Key Management** - Specify keys directly or via file paths
- **Automated Key Capture** - `key-output-file` option to automatically save generated connection strings

## Usage Examples

### holesail-client

Connect to a remote holesail server:

```nix
services.holesail-client.my-connection = {
  enable = true;
  key = "hs://s000...";  # or use key-file = "/path/to/key"
  port = 8080;  # optional, auto-detected from key if not specified
  host = "127.0.0.1";
  user = "myuser";
  group = "users";
  log = true;  # enable detailed logging
};
```

### holesail-server

Expose a local port via holesail:

```nix
services.holesail-server.my-service = {
  enable = true;
  port = 3000;  # required - local port to expose
  key = "hs://s000...";  # optional - leave empty for random key
  public = false;  # set to true for public DHT announcement
  user = "holesail";
  group = "holesail";
  log = false;
};
```

Public mode with fixed seed and key capture:

```nix
services.holesail-server.public-service = {
  enable = true;
  port = 80;
  key = "qwertyuiopasdfghjklzxcvbnm123456";  # 32-char seed
  public = true;
  key-output-file = "/var/lib/myapp/connection.key";  # captures generated hs://0000... key
  log = true;
};
```

### holesail-filemanager

Share a directory with web-based file management:

```nix
services.holesail-filemanager.shared-docs = {
  enable = true;
  directory = "/home/user/Documents";  # required - directory to serve
  port = 5409;  # default filemanager port
  username = "admin";
  password = "secure-password";
  role = "admin";  # or "user"
  public = false;
  user = "holesail";
  group = "holesail";
};
```

Public filemanager with key capture:

```nix
services.holesail-filemanager.public-files = {
  enable = true;
  directory = "/mnt/public";
  key = "abcdefghijklmnopqrstuvwxyz123456";  # 32-char seed for public mode
  public = true;
  key-output-file = "/var/lib/public-share.key";
  username = "guest";
  password = "guest123";
  role = "user";
  log = true;
};
```

## Key Features Explained

### key-output-file

Automatically captures the generated `hs://` connection string to a file. Useful for:
- Automation and deployment scripts
- Displaying connection info to users
- Integration with other services (like nixtcloud)

Works in both private and public modes:
- **Private mode**: Captures `hs://s000...` key
- **Public mode**: Captures `hs://0000...` key generated from seed

### User and Group Options

All modules support custom user/group settings:
- Default: `holesail:holesail` (automatically created)
- Custom: Specify any existing user/group on your system

### Logging

Enable the `log = true;` option to add `--log` flag to holesail commands. Logs are viewable via:

```bash
journalctl -u <service-name>.service
```

## Documentation

For documentation on how to use Holesail, go to: https://docs.holesail.io/

## License

Notice: the MIT license here refers to the code of this repository. License of the actual Holesail package is GPL3.0
