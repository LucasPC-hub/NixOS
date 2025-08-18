{ lib, config, pkgs, ... }:

let
  apps = import ./applications.nix { inherit pkgs; };

in {
  programs.niri.settings.binds = with config.lib.niri.actions; let
    pactl = "${pkgs.pulseaudio}/bin/pactl";

    volume-up = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "+5%" ];
    volume-down = spawn pactl [ "set-sink-volume" "@DEFAULT_SINK@" "-5%" ];
  in {

    # DankMaterial Shell Keybinds
    "Super+D".action = spawn ["qs" "ipc" "call" "spotlight" "toggle"];
    "Super+V".action = spawn ["qs" "ipc" "call" "clipboard" "toggle"];
    "Super+M".action = spawn ["qs" "ipc" "call" "processlist" "toggle"];
    "Super+N".action = spawn ["qs" "ipc" "call" "notifications" "toggle"];
    "Super+Comma".action = spawn ["qs" "ipc" "call" "settings" "toggle"];
    "Super+Alt+L".action = spawn ["qs" "ipc" "call" "lock" "lock"];


    # Hotkey overlay
    "Super+Shift+Slash".action = show-hotkey-overlay;

    # Basic applications
    "Super+T".action = spawn apps.terminal;
    "Super+E".action = spawn apps.fileManager;
    "Super+B".action = spawn apps.browser;

    # Overview bindings - UPDATED
    "Super+Tab".action = toggle-overview;  # Changed from show-hotkey-overlay to toggle-overview
    # Alt+Tab is now unbound (removed)

    # Window management
    "Super+Q".action = close-window;
    "Super+L".action = toggle-window-floating;
    "Super+F".action = maximize-column;
    "Super+Shift+F".action = fullscreen-window;
    "Super+C".action = center-column;

    # Audio controls - DankMaterial Shell
    "XF86AudioRaiseVolume" = {
      action = spawn ["qs" "ipc" "call" "audio" "increment" "3"];
      allow-when-locked = true;
    };
    "XF86AudioLowerVolume" = {
      action = spawn ["qs" "ipc" "call" "audio" "decrement" "3"];
      allow-when-locked = true;
    };
    "XF86AudioMute" = {
      action = spawn ["qs" "ipc" "call" "audio" "mute"];
      allow-when-locked = true;
    };
    "XF86AudioMicMute" = {
      action = spawn ["qs" "ipc" "call" "audio" "micmute"];
      allow-when-locked = true;
    };

    # Brightness controls (keep your existing ddcutil script)
    "Control+Super+XF86AudioRaiseVolume".action = spawn "brightness" "up";
    "Control+Super+XF86AudioLowerVolume".action = spawn "brightness" "down";

    # Media controls
    "XF86AudioPlay".action = spawn ["playerctl" "play-pause"];
    "XF86AudioNext".action = spawn ["playerctl" "next"];
    "XF86AudioPrev".action = spawn ["playerctl" "previous"];
    "XF86MonBrightnessUp" = {
      action = spawn ["qs" "ipc" "call" "brightness" "increment" "5" ""];
      allow-when-locked = true;
    };
    "XF86MonBrightnessDown" = {
      action = spawn ["qs" "ipc" "call" "brightness" "decrement" "5" ""];
      allow-when-locked = true;
    };

    # Focus movement
    "Super+Left".action = focus-column-left;
    "Super+Right".action = focus-column-right;
    "Super+Down".action = focus-window-or-workspace-down;
    "Super+Up".action = focus-window-or-workspace-up;

    # First/last column
    "Super+Ctrl+Left".action = move-column-left;
    "Super+Ctrl+Right".action = move-column-right;
    "Super+Ctrl+Down".action = move-window-down-or-to-workspace-down;
    "Super+Ctrl+Up".action = move-window-up-or-to-workspace-up;

    # Move columns
    "Super+Home".action = focus-column-first;
    "Super+End".action = focus-column-last;
    "Super+Ctrl+Home".action = move-column-to-first;
    "Super+Ctrl+End".action = move-column-to-last;

    # Workspace navigation
    "Super+Page_Down".action = focus-workspace-down;
    "Super+Page_Up".action = focus-workspace-up;
    "Super+K".action = focus-workspace-down;
    "Super+I".action = focus-workspace-up;

    # Move to workspace
    "Super+Ctrl+Page_Down".action = move-column-to-workspace-down;
    "Super+Ctrl+Page_Up".action = move-column-to-workspace-up;
    "Super+Ctrl+U".action = move-column-to-workspace-down;
    "Super+Ctrl+I".action = move-column-to-workspace-up;

    # Workspace scrolling
    "Super+WheelScrollDown".action = focus-workspace-down;
    "Super+WheelScrollUp".action = focus-workspace-up;
    "Super+Ctrl+WheelScrollDown".action = move-column-to-workspace-down;
    "Super+Ctrl+WheelScrollUp".action = move-column-to-workspace-up;

    "Super+Ctrl+WheelScrollRight".action = move-column-right;
    "Super+Ctrl+WheelScrollLeft".action = move-column-left;

    # Numbered workspaces (using focus-workspace with workspace names)
    "Super+1".action = focus-workspace "browser";
    "Super+2".action = focus-workspace "vesktop";
    "Super+3".action = focus-workspace "3";
    "Super+4".action = focus-workspace "4";
    "Super+5".action = focus-workspace "5";
    "Super+6".action = focus-workspace "6";
    "Super+7".action = focus-workspace "7";
    "Super+8".action = focus-workspace "8";

    # Column management
    "Super+Period".action = expel-window-from-column;

    # Resizing
    "Super+R".action = switch-preset-column-width;
    "Super+Shift+R".action = reset-window-height;
    "Super+Minus".action = set-column-width "-10%";
    "Super+Equal".action = set-column-width "+10%";
    "Super+Shift+Minus".action = set-window-height "-10%";
    "Super+Shift+Equal".action = set-window-height "+10%";

    # Screenshots (using correct niri actions)
    "Control+Shift+1".action = screenshot;
    "Control+Shift+2".action = screenshot-window { write-to-disk = true; };
    "Print".action = screenshot;
    "Ctrl+Print".action = screenshot;
    "Alt+Print".action = screenshot-window;

    # System
    "Super+Shift+E".action = quit;
    "Super+Shift+P".action = power-off-monitors;
    # Add this to your existing home/niri/keybinds.nix

    # Lock screen
    "Super+Shift+L".action = spawn ["bash" "-c" "qs ipc call call lock lock && sleep 5 && systemctl suspend"];
  };
}
