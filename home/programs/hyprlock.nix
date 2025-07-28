{ config, pkgs, inputs, ... }:

{
  # Install hyprlock package
  home.packages = [
    inputs.hyprlock.packages.${pkgs.system}.hyprlock
  ];

  # Create hyprlock configuration
  home.file.".config/hypr/hyprlock.conf".text = ''
    # GENERAL
    general {
      disable_loading_bar = true
      grace = 300
      hide_cursor = false
      no_fade_in = false
    }

    # BACKGROUND
    background {
      monitor =
      path = ${config.stylix.image}  # Use stylix wallpaper
      blur_passes = 3
      blur_size = 8
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    # INPUT FIELD
    input-field {
      monitor =
      size = 250, 50
      outline_thickness = 3
      dots_size = 0.33 # Scale of input-field height, 0.2 - 0.8
      dots_spacing = 0.15 # Scale of dots' absolute size, 0.0 - 1.0
      dots_center = true
      dots_rounding = -1 # -1 default circle, -2 follow input-field rounding
      outer_color = rgb(${config.stylix.base16Scheme.base03})
      inner_color = rgb(${config.stylix.base16Scheme.base00})
      font_color = rgb(${config.stylix.base16Scheme.base05})
      fade_on_empty = true
      fade_timeout = 1000 # Milliseconds before fade_on_empty is triggered.
      placeholder_text = <i>Input Password...</i> # Text rendered in the input box when it's empty.
      hide_input = false
      rounding = -1 # -1 means complete rounding (circle/oval)
      check_color = rgb(${config.stylix.base16Scheme.base0B})
      fail_color = rgb(${config.stylix.base16Scheme.base08}) # if authentication failed, changes outer_color and fail message color
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i> # can be set to empty
      fail_transition = 300 # transition time in ms between normal outer_color and fail_color
      capslock_color = -1
      numlock_color = -1
      bothlock_color = -1 # when both locks are active. -1 means don't change outer color (same for above)
      invert_numlock = false # change color if numlock is off
      swap_font_color = false # see below

      position = 0, -20
      halign = center
      valign = center
    }

    # TIME
    label {
      monitor =
      text = cmd[update:1000] echo "$TIME"
      color = rgb(${config.stylix.base16Scheme.base05})
      font_size = 90
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, 16
      halign = center
      valign = center
    }

    # DATE
    label {
      monitor =
      text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
      color = rgb(${config.stylix.base16Scheme.base04})
      font_size = 25
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, -40
      halign = center
      valign = center
    }

    # USER AVATAR
    image {
      monitor =
      path = ~/.face
      size = 280 # lesser side if not 1:1 ratio
      rounding = -1 # negative values mean circle
      border_size = 4
      border_color = rgb(${config.stylix.base16Scheme.base0D})
      rotate = 0 # degrees, counter-clockwise
      reload_time = -1 # seconds between reloading, 0 to reload with SIGUSR2
      reload_cmd =  # command to get new path. if empty, old path will be used. don't run "follow" commands like tail -F

      position = 0, 200
      halign = center
      valign = center
    }

    # CURRENT SONG
    label {
      monitor =
      text = cmd[update:1000] echo "$(playerctl metadata --format "{{ title }}" 2>/dev/null | cut -c1-25)"
      color = rgb(${config.stylix.base16Scheme.base0C})
      font_size = 18
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, -150
      halign = center
      valign = bottom
    }

    label {
      monitor =
      text = cmd[update:1000] echo "$(playerctl metadata --format "{{ artist }}" 2>/dev/null | cut -c1-25)"
      color = rgb(${config.stylix.base16Scheme.base04})
      font_size = 14
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, -180
      halign = center
      valign = bottom
    }

    # WEATHER (if you have a weather script)
    label {
      monitor =
      text = cmd[update:600000] echo "$(curl -s 'wttr.in/?format=1' 2>/dev/null || echo '')"
      color = rgb(${config.stylix.base16Scheme.base09})
      font_size = 16
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 30, -30
      halign = left
      valign = top
    }

    # BATTERY (for laptops)
    label {
      monitor =
      text = cmd[update:5000] echo "$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)%"
      color = rgb(${config.stylix.base16Scheme.base0A})
      font_size = 16
      font_family = ${config.stylix.fonts.monospace.name}
      position = -30, -30
      halign = right
      valign = top
    }

    # Keyboard layout
    label {
      monitor =
      text = cmd[update:1000] echo "$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' | tr '[:lower:]' '[:upper:]')"
      color = rgb(${config.stylix.base16Scheme.base03})
      font_size = 12
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, -300
      halign = center
      valign = center
    }
  '';

  # Create a face image symlink if it doesn't exist
  home.file.".face".source =
    if builtins.pathExists "${config.home.homeDirectory}/.face"
    then config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.face"
    else pkgs.fetchurl {
      url = "https://www.gravatar.com/avatar/placeholder?d=mp&s=280";
      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
    };

  # Optional: Create a lockscreen script
  home.file.".local/bin/lockscreen" = {
    text = ''
      #!/usr/bin/env bash
      # Pause media players
      playerctl -a pause 2>/dev/null

      # Mute audio
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 2>/dev/null

      # Lock the screen
      hyprlock

      # Unmute audio after unlock
      wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null
    '';
    executable = true;
  };
}
