{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rmpc
  ];

  # Create rmpc configuration directory and config file
  home.file.".config/rmpc/config.ron".text = ''
#![enable(implicit_some)]
#![enable(unwrap_newtypes)]
#![enable(unwrap_variant_newtypes)]

(
    address: "127.0.0.1:6600",
    password: None,
    theme: "default",
    enable_config_hot_reload: true,
    cache_dir: None,
    on_song_change: None,
    volume_step: 5,
    max_fps: 30,
    scrolloff: 0,
    wrap_navigation: false,
    enable_mouse: true,
    status_update_interval_ms: 1000,
    select_current_song_on_change: false,
    album_art: (
        method: Auto,
        max_size_px: (width: 500, height: 500),
        disabled_protocols: [],
        vertical_align: Center,
        horizontal_align: Center,
    ),
)
  '';

  # Optional: Create a shell alias for easier access
  programs.fish.shellAliases = {
    music = "rmpc";
    rmp = "rmpc";
  };
}