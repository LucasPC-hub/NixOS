# Updated home/programs/swayidle.nix

{ pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;
    timeouts = [
      # Lock screen after 10 minutes of inactivity
      {
        timeout = 200;  # 10 minutes
        command = "${pkgs.quickshell}/bin/qs ipc call globalIPC toggleLock";
      }
      # Turn off displays after 15 minutes
      {
        timeout = 240;  # 15 minutes
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
    ];
    events = [
      # Lock screen when going to sleep
      {
        event = "before-sleep";
        command = "${pkgs.quickshell}/bin/qs ipc call globalIPC toggleLock";
      }
      # Lock screen when lid closes (for laptops)
      {
        event = "lock";
        command = "${pkgs.quickshell}/bin/qs ipc call globalIPC toggleLock";
      }
    ];
  };

  # Override the systemd service to fix environment issues
  systemd.user.services.swayidle = {
    Unit = {
      # Remove the condition that's causing issues
      ConditionEnvironment = lib.mkForce [];
    };
    Service = {
      # Import environment variables from the session including PATH
      ExecStartPre = "${pkgs.systemd}/bin/systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP PATH";
      Restart = lib.mkForce "on-failure";
      RestartSec = lib.mkForce 1;
      TimeoutStopSec = lib.mkForce 10;
    };
  };
}