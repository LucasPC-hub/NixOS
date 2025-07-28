{ config, pkgs, lib, ... }:

{
  # hyprlock is installed via programs.hyprlock.enable = true in configuration.nix
  # We just need to configure it here

  # Create hyprlock configuration with full customization
  home.file.".config/hypr/hyprlock.conf".text = ''
    # GENERAL SETTINGS
    general {
      disable_loading_bar = true
      grace = 300
      hide_cursor = false
      no_fade_in = false
    }

    # BACKGROUND - Uses your stylix wallpaper with blur effects
    background {
      monitor =
      path = ${config.stylix.image}
      blur_passes = 3
      blur_size = 8
      noise = 0.0117
      contrast = 0.8916
      brightness = 0.8172
      vibrancy = 0.1696
      vibrancy_darkness = 0.0
    }

    # PASSWORD INPUT FIELD - Styled with your theme colors
    input-field {
      monitor =
      size = 250, 50
      outline_thickness = 3
      dots_size = 0.33
      dots_spacing = 0.15
      dots_center = true
      dots_rounding = -1
      outer_color = rgb(${config.stylix.base16Scheme.base0E})  # Accent color
      inner_color = rgb(${config.stylix.base16Scheme.base00})  # Background
      font_color = rgb(${config.stylix.base16Scheme.base05})   # Foreground text
      fade_on_empty = true
      fade_timeout = 1000
      placeholder_text = <i>Password...</i>
      hide_input = false
      rounding = -1
      check_color = rgb(${config.stylix.base16Scheme.base0B})  # Green for success
      fail_color = rgb(${config.stylix.base16Scheme.base08})   # Red for failure
      fail_text = <i>$FAIL <b>($ATTEMPTS)</b></i>
      fail_transition = 300
      capslock_color = -1
      numlock_color = -1
      bothlock_color = -1
      invert_numlock = false
      swap_font_color = false

      position = 0, -20
      halign = center
      valign = center
    }

    # CLOCK - Large time display
    label {
      monitor =
      text = cmd[update:1000] echo "$TIME"
      color = rgb(${config.stylix.base16Scheme.base05})
      font_size = 90
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, 80
      halign = center
      valign = center
    }

    # DATE - Below the clock
    label {
      monitor =
      text = cmd[update:43200000] echo "$(date +"%A, %d %B %Y")"
      color = rgb(${config.stylix.base16Scheme.base04})
      font_size = 25
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, 40
      halign = center
      valign = center
    }

    # USER GREETING - Personalized message
    label {
      monitor =
      text = Hi there, $USER
      color = rgb(${config.stylix.base16Scheme.base0C})
      font_size = 20
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, 160
      halign = center
      valign = center
    }

    # USER AVATAR - Profile picture (circular)
    image {
      monitor =
      path = ~/.face
      size = 150
      rounding = -1  # Makes it circular
      border_size = 4
      border_color = rgb(${config.stylix.base16Scheme.base0D})
      rotate = 0
      reload_time = -1
      reload_cmd =

      position = 0, 280
      halign = center
      valign = center
    }

    # CURRENT MUSIC - Song title
    label {
      monitor =
      text = cmd[update:1000] echo "♪ $(playerctl metadata --format '{{ title }}' 2>/dev/null | cut -c1-30)"
      color = rgb(${config.stylix.base16Scheme.base0C})
      font_size = 16
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, -120
      halign = center
      valign = bottom
    }

    # MUSIC ARTIST - Below song title
    label {
      monitor =
      text = cmd[update:1000] echo "$(playerctl metadata --format '{{ artist }}' 2>/dev/null | cut -c1-25)"
      color = rgb(${config.stylix.base16Scheme.base04})
      font_size = 12
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 0, -140
      halign = center
      valign = bottom
    }

    # WEATHER INFO - Top left corner
    label {
      monitor =
      text = cmd[update:1800000] echo "$(curl -s 'wttr.in/?format=1' 2>/dev/null | head -c 20)"
      color = rgb(${config.stylix.base16Scheme.base09})
      font_size = 14
      font_family = ${config.stylix.fonts.sansSerif.name}
      position = 30, -30
      halign = left
      valign = top
    }

    # BATTERY STATUS - Top right corner (for laptops)
    label {
      monitor =
      text = cmd[update:30000] echo "🔋 $(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null | head -1)%"
      color = rgb(${config.stylix.base16Scheme.base0A})
      font_size = 14
      font_family = ${config.stylix.fonts.monospace.name}
      position = -30, -30
      halign = right
      valign = top
    }

    # KEYBOARD LAYOUT - Bottom center
    label {
      monitor =
      text = cmd[update:1000] echo "⌨ $(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap' 2>/dev/null | tr '[:lower:]' '[:upper:]')"
      color = rgb(${config.stylix.base16Scheme.base03})
      font_size = 12
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, -250
      halign = center
      valign = center
    }

    # UPTIME - Bottom left
    label {
      monitor =
      text = cmd[update:60000] echo "⏱ $(uptime -p | sed 's/up //')"
      color = rgb(${config.stylix.base16Scheme.base03})
      font_size = 11
      font_family = ${config.stylix.fonts.monospace.name}
      position = 30, -50
      halign = left
      valign = bottom
    }

    # NETWORK STATUS - Bottom right
    label {
      monitor =
      text = cmd[update:5000] echo "📶 $(nmcli -t -f NAME c show --active | head -1 | cut -c1-15)"
      color = rgb(${config.stylix.base16Scheme.base03})
      font_size = 11
      font_family = ${config.stylix.fonts.monospace.name}
      position = -30, -50
      halign = right
      valign = bottom
    }
  '';

  # Create face image if it doesn't exist
  home.file.".face" = lib.mkIf (!builtins.pathExists "${config.home.homeDirectory}/.face") {
    source = pkgs.fetchurl {
      url = "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp&f=y&s=150";
      sha256 = "sha256-XFKwjngV85Mk6/SWfKLHbAh6HD6dUdl4oMG1XGpNcTw=";
    };
  };

  # Create convenient lockscreen script
  home.file.".local/bin/lockscreen" = {
    text = ''
      #!/usr/bin/env bash

      # Pause all media players
      playerctl -a pause 2>/dev/null

      # Mute audio (save current state)
      AUDIO_MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -o 'MUTED' || echo "")
      if [[ -z "$AUDIO_MUTED" ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 1 2>/dev/null
        SHOULD_UNMUTE=1
      else
        SHOULD_UNMUTE=0
      fi

      # Lock the screen
      hyprlock

      # Restore audio state after unlock
      if [[ $SHOULD_UNMUTE -eq 1 ]]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0 2>/dev/null
      fi
    '';
    executable = true;
  };

  # Optional: Create different lock themes
  home.file.".config/hypr/hyprlock-minimal.conf".text = ''
    # Minimal theme - just password and time
    general {
      disable_loading_bar = true
      grace = 300
    }

    background {
      monitor =
      color = rgb(${config.stylix.base16Scheme.base00})
    }

    input-field {
      monitor =
      size = 300, 60
      outline_thickness = 2
      outer_color = rgb(${config.stylix.base16Scheme.base0E})
      inner_color = rgb(${config.stylix.base16Scheme.base01})
      font_color = rgb(${config.stylix.base16Scheme.base05})
      position = 0, -50
      halign = center
      valign = center
    }

    label {
      monitor =
      text = $TIME
      color = rgb(${config.stylix.base16Scheme.base05})
      font_size = 120
      font_family = ${config.stylix.fonts.monospace.name}
      position = 0, 100
      halign = center
      valign = center
    }
  '';
}
