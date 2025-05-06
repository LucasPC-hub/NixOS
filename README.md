![NixOS Configuration](https://i.imgur.com/lCKjPh8.png)

> ⚠️ **Important:** This repository includes my personal `hardware-configuration.nix`, which is specific to my hardware setup.  
> You **must replace it** with one generated for your system using `nixos-generate-config` to avoid compatibility issues.

# NixOS Configuration

This repository contains my personal NixOS configuration for a customized desktop and development environment. 🎨💻

## Directory Structure

- **`assets/`** 🎨  
  Contains custom icons and wallpapers.

  - **`icons/`**: Custom icon set.
  - **`wallpapers/`**: Collection of wallpapers.

- **`dev-shells/`** 🧑‍💻  
  Development environments.

  - **`fabric-shell.nix`**: Custom shell for Fabric.

- **`hosts/`** 🖥️  
  Host-specific configurations.

  - **`default/`**: Default host configuration including `hardware-configuration.nix`, `home.nix`, and `packages.nix`.

- **`modules/`** ⚙️  
  Custom NixOS modules for desktop, editors, programs, and more.

  - **`desktop/`**: Configuration for Hyprland, Waybar, and related tools.
  - **`editors/`**: Neovim and VSCode configurations.
  - **`niri/`**: Custom Niri configuration (WIP).
  - **`programs/`**: Additional program configurations (e.g., Fastfetch, Ghostty).

- **`system/`** 🔧  
  System-wide configurations.
  - **`environment.nix`**: Global environment settings.
  - **`greeter/`**: Greetd configuration for login.
  - **`shell/`**: Shell configurations for Bash and Fish.
  - **`xdg.nix`**: XDG settings.

## Niri 🛠️

The **Niri** configuration is a **Work In Progress (WIP)**, providing a custom desktop environment.

## Getting Started

Clone this repository and adjust the configurations based on your system. Modify the host-specific files and modules to suit your needs.

Feel free to customize and contribute!
