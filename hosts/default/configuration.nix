{ config, pkgs, inputs, lib, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/system/greeter/greetd.nix"
    "${self}/system/scripts/keyboard.nix"
    "${self}/system/programs/steam.nix"
    "${self}/system/programs/docker.nix"
    "${self}/system/programs/stylix.nix"
    "${self}/system/xdg.nix"
    "${self}/system/environment.nix"
    "${self}/system/packages.nix"
    "${self}/system/filesystems.nix"

    inputs.home-manager.nixosModules.default
  ];

  nixpkgs.overlays = [
    (final: prev: {
      nur = import inputs.nur {
        nurpkgs = prev;
        pkgs = prev;
      };
    })
  ];

  users.groups.i2c = {};

  users.users.lpc = {
    isNormalUser = true;
    description = "lpc";
    shell = pkgs.fish;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "plugdev"
      "i2c"
      "bluetooth"
      "docker"
      "video"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "lpc" = import ./home.nix;
    };
  };


fonts.packages = with pkgs; [
    fira-sans
    roboto
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
    nerd-fonts.fantasque-sans-mono  # Add this line for FantasqueSansM
    jetbrains-mono
    noto-fonts
    noto-fonts-emoji
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
    material-symbols
    material-icons
  ];

  boot = {
    loader = {
      grub.enable = false;
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "video=eDP-1:2880x1800@120"
      "bluetooth.disable_ertm=1"
    ];
    kernelModules = [ "v4l2loopback" "i2c-dev" ];
    initrd.availableKernelModules = [ "i2c-dev" ];

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];
  };

  services.udev.packages = [ pkgs.rwedid ];

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 5d";
  };

  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    wireless = {
      enable = false;
      userControlled.enable = false;
    };

    networkmanager = {
      wifi.backend = "wpa_supplicant";
      wifi.powersave = false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  time.timeZone = "America/Sao_Paulo";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };
  programs.fish.enable = true;
  security.polkit.enable = true;

  # Enable graphics (updated from hardware.opengl in NixOS 24.11+)
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    xserver = {
      enable = true;
      # Load modesetting driver for Intel and NVIDIA driver for offloading
      # This is CRITICAL for PRIME offload to work properly
      videoDrivers = [ "modesetting" "nvidia" ];
      xkb = {
        layout = "br";
        variant = "";
      };
    };

    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];

    power-profiles-daemon.enable = true;
    printing.enable = true;
    gvfs.enable = true;
    tumbler.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    sunshine = {
      enable = true;
      autoStart = false;
      capSysAdmin = true;
      openFirewall = true;
    };
  };

  console.keyMap = "br-abnt2";

  xdg.portal.enable = true;

  hardware.bluetooth = {
     enable = true;
     powerOnBoot = true;

     # Bluetooth configuration
     settings = {
       General = {
         ControllerMode = "dual";
         FastConnectable = true;
         ConnectTimeout = 60;
       };

       Policy = {
         AutoEnable = true;
       };

       LE = {
         MinConnectionInterval = 30;
         MaxConnectionInterval = 50;
         ConnectionLatency = 0;
         ConnectionSupervisionTimeout = 420;
       };
     };
   };

   # Bluetooth kernel module options
   boot.extraModprobeConfig = ''
     options btusb enable_autosuspend=0
     options btusb reset=1
     options v4l2loopback video_nr=0 card_label="DroidCam" exclusive_caps=1
   '';

   # Disable USB autosuspend for Bluetooth (find your device ID first)
   services.udev.extraRules = ''
     # Disable autosuspend for Bluetooth USB devices (corrected for AX211)
     ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", TEST=="power/control", ATTR{power/control}="on"

     # Auto-reset Bluetooth HCI on add
     ACTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci[0-9]*", RUN+="${pkgs.bluez}/bin/hciconfig %k reset"
   '';

  # NVIDIA Configuration
  hardware.nvidia = {
    # Modesetting is required
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    # Your RTX 4070 Max-Q supports open modules, but closed-source is more stable for now
    open = false;

    # Enable the Nvidia settings menu, accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    # PRIME configuration for hybrid Intel/NVIDIA laptops
    prime = {
      # Bus IDs for your specific hardware (found via lspci)
      intelBusId = "PCI:0:2:0";    # Intel Meteor Lake-P Arc Graphics
      nvidiaBusId = "PCI:1:0:0";   # NVIDIA RTX 4070 Max-Q Mobile

      # Offload mode - Intel as primary, NVIDIA on-demand (recommended for battery life)
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };

      # Alternative modes (uncomment one if you prefer):
      # sync.enable = true;          # Both GPUs always active, NVIDIA does all rendering
      # reverseSync.enable = true;   # NVIDIA as primary display (worse battery, better for external displays)
    };
  };

  environment.systemPackages = with pkgs; [
    bluez
    # Graphics debugging and utilities
    glxinfo
    pciutils
    polkit_gnome
  ];

  nixpkgs.config.allowUnfree = true;


  home-manager.backupFileExtension = "backup";

  system.stateVersion = "25.05";

  system.activationScripts.logRebuildTime = {
    text = ''
      LOG_FILE="/var/log/nixos-rebuild-log.json"
      TIMESTAMP=$(date "+%d/%m")
      GENERATION=$(readlink /nix/var/nix/profiles/system | grep -o '[0-9]\+')

      echo "{\"last_rebuild\": \"$TIMESTAMP\", \"generation\": $GENERATION}" > "$LOG_FILE"
      chmod 644 "$LOG_FILE"
    '';
  };
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };
}
