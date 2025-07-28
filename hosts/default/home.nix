{
  config,
  pkgs,
  inputs,
  self,
  ...
}:
let
  allPackages = import ./packages.nix { inherit pkgs inputs; };  # Pass inputs here
in
{
  home.username = "lpc";
  home.homeDirectory = "/home/lpc";
  
  imports = [
    ../../home/niri/default.nix
    ../../home/quickshell/quickshell.nix
    ../../home/editors/vscode.nix
    ../../home/editors/nixvim.nix
    ../../home/programs/ghostty.nix
    ../../home/programs/kitty.nix      # Add this line
    ../../home/programs/fish.nix       # Add this line
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
  
  # Configure npm to use home directory for global installs
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
  '';
  
  # Add npm global bin directory to PATH
  home.sessionVariables = {
    EDITOR = "zeditor";
    # Add npm global packages to PATH
    PATH = "$PATH:${config.home.homeDirectory}/.npm-global/bin";
  };
  
  # Alternative: you can also add it to sessionPath
  home.sessionPath = [
    "${config.home.homeDirectory}/.npm-global/bin"
  ];
  
  xdg.portal.enable = true;  
  home.stateVersion = "24.11";
  
  services.cliphist = {
    enable = true;
    allowImages = true;
  };
  
  programs.home-manager.enable = true;
}