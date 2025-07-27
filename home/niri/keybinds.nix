{ lib, config, pkgs, ... }:

let
  apps = import ./applications.nix { inherit pkgs; };

in {
  programs.niri.settings.binds = with config.lib.niri.actions; let
    pactl = "${pkgs.pulseaudio}/bin/pactl";

    volume-up = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
    volume-down = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
  in {

    # Quickshell Keybinds (keep your existing ones)
    "super+d".action = spawn ["qs" "ipc" "call" "globalIPC" "toggleLauncher"];

    # Hotkey overlay
    "super+shift+slash".action = show-hotkey-overlay;

    # Basic applications
    "super+t".action = spawn apps.terminal;
    "super+e".action = spawn apps.fileManager;
    "super+b".action = spawn apps.browser;
    "super+alt+l".action = spawn ["swaylock"];

    # Overview bindings
    "super+tab".action = toggle-overview;
    "alt+tab".action = toggle-overview;

    # Window management
    "super+q".action = close-window;
    "super+l".action = toggle-window-floating;
    "super+f".action = maximize-column;
    "super+shift+f".action = fullscreen-window;
    "super+c".action = center-column;

    # Audio controls
    "xf86audioraisevolume".action = volume-up;
    "xf86audiolowervolume".action = volume-down;
    "xf86audiomute".action = spawn ["pactl" "set-sink-mute" "@DEFAULT_SINK@" "toggle"];
    "xf86audiomicmute".action = spawn ["pactl" "set-source-mute" "@DEFAULT_SOURCE@" "toggle"];
    
    # Media controls
    "xf86audioplay".action = spawn ["playerctl" "play-pause"];
    "xf86audionext".action = spawn ["playerctl" "next"];
    "xf86audioprev".action = spawn ["playerctl" "previous"];

    # Focus movement
    "super+Left".action = focus-column-left;
    "super+Right".action = focus-column-right;
    "super+Down".action = focus-window-down;
    "super+Up".action = focus-window-up;

    # Mouse navigation
    "super+mouseBack".action = focus-column-left;
    "super+mouseForward".action = focus-column-right;

    # Move columns
    "super+ctrl+Left".action = move-column-left;
    "super+ctrl+Right".action = move-column-right;
    "super+ctrl+Down".action = move-window-down-or-to-workspace-down;
    "super+ctrl+Up".action = move-window-up-or-to-workspace-up;

    # First/last column
    "super+Home".action = focus-column-first;
    "super+End".action = focus-column-last;
    "super+ctrl+Home".action = move-column-to-first;
    "super+ctrl+End".action = move-column-to-last;

    # Workspace navigation
    "super+Page_Down".action = focus-workspace-down;
    "super+Page_Up".action = focus-workspace-up;
    "super+k".action = focus-workspace-down;
    "super+i".action = focus-workspace-up;

    # Move to workspace
    "super+ctrl+Page_Down".action = move-column-to-workspace-down;
    "super+ctrl+Page_Up".action = move-column-to-workspace-up;
    "super+ctrl+u".action = move-column-to-workspace-down;
    "super+ctrl+i".action = move-column-to-workspace-up;

    # Workspace scrolling
    "super+WheelScrollDown".action = { cooldown-ms = 150; action = focus-workspace-down; };
    "super+WheelScrollUp".action = { cooldown-ms = 150; action = focus-workspace-up; };
    "super+ctrl+WheelScrollDown".action = { cooldown-ms = 150; action = move-column-to-workspace-down; };
    "super+ctrl+WheelScrollUp".action = { cooldown-ms = 150; action = move-column-to-workspace-up; };

    "super+ctrl+WheelScrollRight".action = move-column-right;
    "super+ctrl+WheelScrollLeft".action = move-column-left;

    # Numbered workspaces (keeping your existing browser/vesktop setup)
    "super+1".action = focus-workspace "browser";
    "super+2".action = focus-workspace "vesktop";
    "super+3".action = focus-workspace "3";
    "super+4".action = focus-workspace "4";
    "super+5".action = focus-workspace "5";
    "super+6".action = focus-workspace "6";
    "super+7".action = focus-workspace "7";
    "super+8".action = focus-workspace "8";

    # Move to numbered workspaces
    "super+ctrl+1".action = move-column-to-workspace "browser";
    "super+ctrl+2".action = move-column-to-workspace "vesktop";
    "super+ctrl+3".action = move-column-to-workspace "3";
    "super+ctrl+4".action = move-column-to-workspace "4";
    "super+ctrl+5".action = move-column-to-workspace "5";
    "super+ctrl+6".action = move-column-to-workspace "6";
    "super+ctrl+7".action = move-column-to-workspace "7";
    "super+ctrl+8".action = move-column-to-workspace "8";

    # Column management
    "super+comma".action = consume-window-into-column;
    "super+period".action = expel-window-from-column;

    # Resizing
    "super+r".action = switch-preset-column-width;
    "super+shift+r".action = reset-window-height;
    "super+minus".action = set-column-width "-10%";
    "super+equal".action = set-column-width "+10%";
    "super+shift+minus".action = set-window-height "-10%";
    "super+shift+equal".action = set-window-height "+10%";

    # Screenshots (keep your existing ones)
    "control+shift+1".action = screenshot;
    "control+shift+2".action = screenshot-window { write-to-disk = true; };
    "print".action = screenshot;
    "ctrl+print".action = screenshot-screen;
    "alt+print".action = screenshot-window;

    # System
    "super+shift+e".action = quit;
    "super+shift+p".action = power-off-monitors;

  };
}