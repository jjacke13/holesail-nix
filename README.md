# Holesail-Nix

[![NixOS](https://img.shields.io/badge/NixOS-24.11-blue.svg?style=flat-square&logo=nixos)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Flakes](https://img.shields.io/badge/Nix-Flakes-informational?style=flat-square&logo=nixos)](https://nixos.wiki/wiki/Flakes)

A comprehensive Nix package and NixOS module collection for [Holesail](https://holesail.io/) - the peer-to-peer tunnel that lets you create instant, secure connections between devices without port forwarding or exposing ports.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
  - [Using Flakes](#using-flakes)
  - [Traditional Nix](#traditional-nix)
- [NixOS Modules](#nixos-modules)
  - [Available Modules](#available-modules)
  - [Module Configuration](#module-configuration)
- [Configuration Examples](#configuration-examples)
  - [Basic Server Setup](#basic-server-setup)
  - [Client Connection](#client-connection)
  - [File Manager Service](#file-manager-service)
- [Advanced Usage](#advanced-usage)
- [Security Considerations](#security-considerations)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)
- [License](#license)

## Overview

Holesail-Nix brings the power of Holesail's P2P tunneling to the Nix ecosystem, offering:

- **Pure Nix packaging** of the Holesail Node.js application
- **Declarative NixOS modules** for server, client, and file manager configurations
- **Systemd service management** with automatic restarts and proper dependencies
- **Multi-instance support** for running multiple tunnels simultaneously
- **Cross-platform compatibility** (x86_64-linux and aarch64-linux)

Whether you're exposing a local development server, sharing files securely, or creating persistent tunnels for your homelab, Holesail-Nix makes it simple and reproducible.

## Features

- 🚀 **Zero Configuration Networking**: Create secure tunnels without touching router settings
- 🔒 **End-to-End Encryption**: All connections are encrypted by default
- 📦 **Declarative Configuration**: Define your tunnels in your NixOS configuration
- 🔄 **Automatic Service Management**: Systemd integration with restart policies
- 🌐 **Multiple Instance Support**: Run multiple servers/clients simultaneously
- 📁 **Built-in File Manager**: Share directories with web-based access control
- 🔧 **Flexible Connection Options**: Support for TCP/UDP, custom ports, and public discovery

## Installation

### Using Flakes

Add Holesail-Nix to your flake inputs:

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    holesail.url = "github:jjacke13/holesail-nix";
  };

  outputs = { self, nixpkgs, holesail, ... }: {
    # Your system configuration
  };
}
```

### Traditional Nix

Build the package directly:

```bash
# Build the package
nix-build https://github.com/jjacke13/holesail-nix/archive/main.tar.gz -A holesail

# Or enter a shell with holesail available
nix-shell -p '(import (fetchTarball "https://github.com/jjacke13/holesail-nix/archive/main.tar.gz") {}).holesail'
```

## NixOS Modules

### Available Modules

Holesail-Nix provides three specialized NixOS modules:

1. **`holesail-server`**: Expose local services to the network
2. **`holesail-client`**: Connect to remote Holesail servers
3. **`holesail-filemanager`**: Share directories with web-based access

### Module Configuration

Add the modules to your NixOS configuration:

```nix
{ inputs, ... }: {
  imports = [
    inputs.holesail.nixosModules.${system}.holesail-server
    inputs.holesail.nixosModules.${system}.holesail-client
    inputs.holesail.nixosModules.${system}.holesail-filemanager
  ];
}
```

Or import all modules in one:

```nix
{ inputs, ... }: {
  imports = [ inputs.holesail.nixosModules.${system}.holesail ];
}
```

## Configuration Examples

### Basic Server Setup

Expose a local web service running on port 3000:

```nix
{
  services.holesail-server = {
    webserver = {
      enable = true;
      port = 3000;  # Local port to expose
      host = "127.0.0.1";
      connector = "my-custom-connector-string";  # Optional: specify custom connector
    };
  };
}
```

### Client Connection

Connect to a remote Holesail server:

```nix
{
  services.holesail-client = {
    remote-web = {
      enable = true;
      port = 8080;  # Local port where the tunnel will be available
      host = "127.0.0.1";
      connection-string = "generated-connector-string-from-server";
    };
  };
}
```

### File Manager Service

Share a directory with authentication:

```nix
{
  services.holesail-filemanager = {
    shared-docs = {
      enable = true;
      path = "/var/lib/shared-documents";
      port = 5409;
      username = "admin";
      password = "secure-password";  # Consider using secrets management
      role = "admin";  # "admin" or "user"
      public = true;   # Make discoverable on the network
    };
  };
}
```

## Configuration Options Reference

### holesail-server

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | false | Enable this Holesail server instance |
| `host` | string | "127.0.0.1" | Host address to bind to |
| `port` | integer | 8989 | Port to expose through the tunnel |
| `udp` | boolean | false | Use UDP instead of TCP |
| `connector` | string | "" | Custom connection string (auto-generated if empty) |
| `connector-file` | string | "" | Path to file containing connection string |
| `public` | boolean | false | Announce server to DHT for public discovery |

### holesail-client

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | false | Enable this Holesail client instance |
| `host` | string | "127.0.0.1" | Local host to bind the tunnel to |
| `port` | integer | 8989 | Local port where tunnel will be accessible |
| `udp` | boolean | false | Use UDP instead of TCP |
| `connection-string` | string | "" | Connection string to the remote server |
| `connection-string-file` | string | "" | Path to file containing connection string |

### holesail-filemanager

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `enable` | boolean | false | Enable this file manager instance |
| `host` | string | "127.0.0.1" | Host address to bind to |
| `port` | integer | 5409 | Port for the file manager web interface |
| `udp` | boolean | false | Use UDP instead of TCP |
| `connector` | string | "" | Custom connection string |
| `connector-file` | string | "" | Path to file containing connection string |
| `public` | boolean | false | Make file manager publicly discoverable |
| `username` | string | "admin" | Login username |
| `password` | string | "admin" | Login password |
| `role` | string | "user" | User role ("admin" or "user") |
| `path` | string | "" | Directory path to serve |

## Advanced Usage

### Multiple Instances

Run multiple services simultaneously:

```nix
{
  services.holesail-server = {
    webapp = {
      enable = true;
      port = 3000;
    };
    api = {
      enable = true;
      port = 4000;
      public = true;
    };
  };

  services.holesail-client = {
    remote-db = {
      enable = true;
      port = 5432;
      connection-string = "db-server-connection-string";
    };
  };
}
```

### Using Connection Files

For better security, store connection strings in files:

```nix
{
  services.holesail-client.secure-service = {
    enable = true;
    port = 9000;
    connection-string-file = "/run/secrets/holesail-connector";
  };
}
```

### Systemd Service Management

All Holesail services are managed by systemd:

```bash
# Check service status
systemctl status holesail-server-webapp

# View logs
journalctl -u holesail-client-remote-db -f

# Restart a service
systemctl restart holesail-filemanager-shared-docs
```

## Security Considerations

1. **Connection Strings**: Treat connection strings as passwords. Anyone with the string can connect to your service.

2. **Network Binding**: By default, services bind to localhost. Only change the `host` parameter if you understand the security implications.

3. **Public Mode**: Enabling `public = true` makes your service discoverable. Ensure you have proper authentication in place.

## Troubleshooting

### Service Won't Start

Check the systemd logs:
```bash
journalctl -u holesail-server-myservice -n 50
```

### Connection Issues

1. Verify the connection string is correct
2. Check if the server is running: `systemctl status holesail-server-*`
3. Ensure firewall rules allow the specified ports
4. Test with the holesail CLI directly to isolate configuration issues

### Common Error Messages

- **"Connection refused"**: The local service isn't running on the specified port
- **"Address already in use"**: Another service is using the specified port

## Contributing

Contributions are welcome!

For major changes, please open an issue first to discuss the proposed changes.

## License

This Nix packaging is licensed under the MIT License. Note that Holesail itself is licensed under GPL-3.0.

---

For more information about Holesail, visit the [official documentation](https://docs.holesail.io/).

**Need help?** Open an issue on [GitHub](https://github.com/jjacke13/holesail-nix/issues) or reach out to the Holesail community.