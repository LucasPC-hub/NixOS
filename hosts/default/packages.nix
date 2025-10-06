{
  pkgs,
  inputs,
  ...
}:
with pkgs;
let
  # Define custom packages
  dgop = callPackage ../../home/programs/dgop.nix {};
in
[
  # Applications
  protonplus
  lutris
  zoom
  prismlauncher
  heroic
  nautilus
  file-roller
  eog
  evince
  obsidian
  modrinth-app
  # TUI
  btop
  fish
  dgop
  rmpc
  # Desktop
  nwg-look
  walker
  # Development
  remmina
  jetbrains-toolbox
  rustup
  gcc
  gh
  nixfmt-rfc-style
  nixpkgs-fmt
  black
  zed-editor
  nodePackages.npm
  mockoon
  insomnia
  # Utilities
  jq
  socat
  tree
  libnotify
  wl-clipboard
  pywalfox-native
  imagemagick
  rar
  unzip
  droidcam
  gpu-screen-recorder
  mpv
  cava
  kitty
  lazydocker
  kdePackages.dolphin
  yazi
  # Quickshell stuff
  qt6Packages.qt5compat
  libsForQt5.qt5.qtgraphicaleffects
  kdePackages.qtbase
  kdePackages.qtdeclarative
  kdePackages.qtstyleplugin-kvantum
  # Niri
  xwayland-satellite
  wl-clipboard
  swayidle
  # Music server
  mpd  # Music Player Daemon
  mpc-cli  # Command line client for MPD
]
