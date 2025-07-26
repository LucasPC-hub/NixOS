{
  config,
  pkgs,
  inputs,
  self,
  ...
}:
let
  allPackages = import ./packages.nix { inherit pkgs; };
in
{
  home.username = "lpc";  # Mudei de "lysec" para "lpc"
  home.homeDirectory = "/home/lpc";  # Mudei de "/home/lysec" para "/home/lpc"
  imports = [
    ../../home/niri/default.nix
    ../../home/quickshell/quickshell.nix
    ../../home/editors/vscode.nix
    ../../home/editors/nixvim.nix
    ../../home/programs/ghostty.nix
    ../../home/programs/fastfetch.nix
    ../../home/programs/spicetify.nix
    ../../home/programs/obs.nix
    ../../home/programs/vesktop/default.nix
    ../../home/programs/firefox.nix
    ../../system/shell/zsh.nix
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.packages = allPackages;
  xdg.portal.enable = true;
  home.stateVersion = "24.11";
  home.sessionVariables = {
    EDITOR = "nvim";
  };
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  programs.home-manager.enable = true;
}