{
  config,
  pkgs,
  inputs,
  self,
  ...
}:
let
  allPackages = import ./packages.nix { inherit pkgs inputs; };
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
    ../../home/programs/kitty.nix
    ../../home/programs/fish.nix
    ../../home/programs/fastfetch.nix
    ../../home/programs/spicetify.nix
    ../../home/programs/obs.nix
    ../../home/programs/vesktop/default.nix
    ../../home/programs/firefox.nix
    ../../home/programs/swayidle.nix
    ../../system/shell/zsh.nix
    inputs.zen-browser.homeModules.twilight-official
    inputs.spicetify-nix.homeManagerModules.default
    inputs.nixvim.homeManagerModules.nixvim
  ];
  programs.zen-browser.enable = true;
  home.packages = allPackages;

  # Configure npm to use home directory for global installs
  home.file.".npmrc".text = ''
    prefix=${config.home.homeDirectory}/.npm-global
    cache=${config.home.homeDirectory}/.npm-cache
  '';

  # Add npm global bin directory to PATH
  home.sessionVariables = {
    EDITOR = "zeditor";
    PATH = "$PATH:${config.home.homeDirectory}/.npm-global/bin";
  };

  home.file.".XCompose".text = ''
    include "%L"
    <dead_acute> <c> : "ç" U00E7
    <dead_acute> <C> : "Ç" U00C7
  '';

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
