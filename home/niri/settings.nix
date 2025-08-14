{ config, pkgs, ... }:

{
  programs.niri = {
    enable = true;
    package = pkgs.niri;
    settings = with config.lib.niri.actions; {

      prefer-no-csd = true;

      hotkey-overlay = {
        skip-at-startup = true;
      };
      # switch-events = {
      #   lid-close.action = spawn ["bash" "-c" "qs ipc call globalIPC toggleLock && sleep 2 && systemctl suspend"];
      # };

      # Screenshot path
      screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";

      layout = {
        # Keeping your color scheme - don't change these
        background-color = "#00000000";

        focus-ring = {
          enable = true;
          width = 1;
          active = {
            color = "#A8AEFF";
          };
          inactive = {
            color = "#505050";
          };
        };

        # Updated gaps to match old config
        gaps = 5;

        # Preset column widths from old config
        preset-column-widths = [
          { proportion = 0.33333; }
          { proportion = 0.5; }
          { proportion = 0.66667; }
          { proportion = 0.75; }
          { proportion = 1.0; }
        ];

        default-column-width = { proportion = 0.5; };

        # Remove struts to match old config (commented out in old)
        # struts = {
        #   left = 20;
        #   right = 20;
        #   top = 20;
        #   bottom = 20;
        # };
      };

      input = {
          keyboard = {
            xkb = {
              layout = "us,br";
              variant = "intl,abnt2";
              options = "grp:win_space_toggle,lv3:rctrl_switch";
            };
            repeat-delay = 300;
            repeat-rate = 50;
            numlock = true;
          };
        touchpad = {
          click-method = "clickfinger";
          dwt = true;
          dwtp = true;
          natural-scroll = true;
          scroll-method = "two-finger";
          tap = true;
          tap-button-map = "left-right-middle";
          middle-emulation = true;
          accel-profile = "adaptive";
          accel-speed = 0.3;
        };

        mouse = {
          accel-profile = "flat";
          accel-speed = 0.0;
          scroll-factor = 2.0;
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount="30%";
        };

        warp-mouse-to-focus = {
          enable = true;
        };
      };

      outputs = {
        # Add your eDP-1 config if you have a laptop
        "eDP-1" = {
          mode = {
            width = 2880;
            height = 1800;
            refresh = 120.001;
          };
          scale = 1.5;
          position = { x = 0; y = 0; };
          variable-refresh-rate = true;
        };
        # Add HDMI output
        "HDMI-A-1" = {
          mode = {
            width = 1920;
            height = 1080;
            refresh = 60.000;
          };
          scale = 1.0;
          position = { x = 1920; y = 0; };
        };
      };

      cursor = {
        size = 20;
      };

      environment = {
        CLUTTER_BACKEND = "wayland";
        GDK_BACKEND = "wayland,x11";
        MOZ_ENABLE_WAYLAND = "1";
        NIXOS_OZONE_WL = "1";
        QT_QPA_PLATFORM = "wayland";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        ELECTRON_OZONE_PLATFORM_HINT = "auto";

        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_DESKTOP = "niri";
        XDG_BROWSER = "firefox";
        DISPLAY = ":0";

        # Angular/Node optimization from old config
        NODE_OPTIONS = "--max-old-space-size=8192";
      };
    };
  };
}
