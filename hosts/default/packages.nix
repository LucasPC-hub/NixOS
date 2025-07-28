{
  pkgs,
  inputs,  # Add this parameter
  ...
}:

with pkgs;
[
  # Applications
  protonplus
  lutris
  prismlauncher
  heroic
  nautilus
  file-roller
  obsidian
  inputs.zen-browser.packages.${pkgs.system}.default  # Add zen-browser here

  # TUI
  btop
  fish

  # Desktop
  nwg-look
  walker

  # Development
  rustup
  gcc
  gh
  nixfmt-rfc-style
  nixpkgs-fmt
  black
  zed-editor
  nodePackages.npm
  docker

  # Utilities
  jq
  socat
  tree
  libnotify
  wl-clipboard
  pywalfox-native
  imagemaggle
  amdvlk
  rar
  unzip
  droidcam
  gpu-screen-recorder
  mpv
  cava
  kitty
  
  # Quickshell stuff
  qt6Packages.qt5compat
  libsForQt5.qt5.qtgraphicaleffects
  kdePackages.qtbase
  kdePackages.qtdeclarative
  kdePackages.qtstyleplugin-kvantum
  wallust

  # Niri
  xwayland-satellite
  wl-clipboard
]