  {
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    wget
    ly
    git
    pavucontrol
    pulseaudio
    waypaper
    arrpc
    swww
    swaybg
    gnome-themes-extra
    nodePackages.prettier
    xwayland
    spicetify-cli
    alvr
    ffmpeg
    mesa
    libva
    libva-utils
    playerctl
    nh
    base16-schemes
    ddcutil
    os-prober
  ];
  }