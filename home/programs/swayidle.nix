# Add this to your home.nix or create a new file like home/programs/swayidle.nix

{ pkgs, lib, ... }:

{
  services.swayidle = {
    enable = true;
    timeouts = [
      # Lock screen after 10 minutes of inactivity
      {
        timeout = 600;  # 10 minutes
        command = "qs ipc call globalIPC toggleLock";
      }
      # Turn off displays after 15 minutes
      {
        timeout = 900;  # 15 minutes
        command = "niri msg action power-off-monitors";
        resumeCommand = "niri msg action power-on-monitors";
      }
    ];
    events = [
      # Lock screen when going to sleep
      {
        event = "before-sleep";
        command = "qs ipc call globalIPC toggleLock";
      }
      # Lock screen when lid closes (for laptops)
      {
        event = "lock";
        command = "qs ipc call globalIPC toggleLock";
      }
    ];
  };

  # Make sure swayidle starts with your session
  systemd.user.services.swayidle = {
    Unit = {
      Description = "Idle manager for Wayland";
      Documentation = "man:swayidle(1)";
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      Restart = lib.mkForce "on-failure";  # Force this value
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
