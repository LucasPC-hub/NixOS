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
  prismlauncher
  heroic
  nautilus
  file-roller
  eog
  evince
  obsidian
  # TUI
  btop
  fish
  dgop  # Add it here
  # Desktop
  nwg-look
  walker
  # Development
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
  amdvlk
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
  wallust
  # Niri
  xwayland-satellite
  wl-clipboard
  swayidle
]
