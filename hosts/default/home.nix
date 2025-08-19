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
    inputs.dankMaterialShell.homeModules.dankMaterialShell
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
  programs.dankMaterialShell.enable = true;
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
    BROWSER = "zen";
    DEFAULT_BROWSER = "zen";
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

  # Configure default applications
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      # Web browsers
      "text/html" = "zen-twilight.desktop";
      "x-scheme-handler/http" = "zen-twilight.desktop";
      "x-scheme-handler/https" = "zen-twilight.desktop";
      "x-scheme-handler/about" = "zen-twilight.desktop";
      "x-scheme-handler/unknown" = "zen-twilight.desktop";

      # File manager
      "inode/directory" = "nautilus.desktop";

      # Text files
      "text/plain" = "code.desktop";
      "application/x-shellscript" = "code.desktop";

      # Images
      "image/png" = "eog.desktop";
      "image/jpeg" = "eog.desktop";
      "image/gif" = "eog.desktop";
      "image/webp" = "eog.desktop";

      # Videos
      "video/mp4" = "mpv.desktop";
      "video/x-matroska" = "mpv.desktop";
      "video/webm" = "mpv.desktop";

      # Audio
      "audio/mpeg" = "mpv.desktop";
      "audio/mp4" = "mpv.desktop";
      "audio/x-flac" = "mpv.desktop";

      # PDFs
      "application/pdf" = "evince.desktop";

      # Archives
      "application/zip" = "file-roller.desktop";
      "application/x-tar" = "file-roller.desktop";
      "application/gzip" = "file-roller.desktop";
    };
  };
    xdg.configFile."pipewire/pipewire.conf.d/10-clock-rate.conf".text = ''
      context.properties = {
        default.clock.rate = 96000
        default.clock.allowed-rates = [ 44100 48000 88200 96000 176400 192000 352800 384000 ]
      }
    '';
  home.stateVersion = "24.11";

  services.cliphist = {
    enable = true;
    allowImages = true;
  };

  programs.home-manager.enable = true;
}
