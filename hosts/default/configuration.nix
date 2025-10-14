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
    "${self}/system/programs/openfortivpn.nix"
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
  users.groups.plugdev = {};  # ADICIONADO

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
      "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
      "nvidia.NVreg_TemporaryFilePath=/var/tmp"
    ];
    kernelModules = [ "v4l2loopback" "i2c-dev" ];
    initrd.availableKernelModules = [ "i2c-dev" ];

    extraModulePackages = with config.boot.kernelPackages; [
      v4l2loopback
    ];

    # Bluetooth kernel module options
    extraModprobeConfig = ''
      options btusb enable_autosuspend=0
      options btusb reset=1
      options v4l2loopback video_nr=0 card_label="DroidCam" exclusive_caps=1
    '';
  };

  services.udev.packages = [ pkgs.rwedid pkgs.solaar ];

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
    firewall ={
     allowedTCPPorts = [ 4200 ];
    };
    networkmanager = {
      wifi.backend = "wpa_supplicant";
      wifi.powersave = false;
    };
  };

  hardware.enableRedistributableFirmware = true;

  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };

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

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  services = {
    ratbagd.enable = true;
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" "nvidia" ];
      xkb = {
        layout = "br";
        variant = "";
      };
    };

    dbus.enable = true;
    dbus.packages = with pkgs; [ bluez ];

    power-profiles-daemon.enable = true;
    upower.enable = true;
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

   # MODIFICADO: Regras udev consolidadas
   services.udev.extraRules = ''
     # Disable autosuspend for Bluetooth USB devices (corrected for AX211)
     ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="8087", ATTR{idProduct}=="0033", TEST=="power/control", ATTR{power/control}="on"

     # Auto-reset Bluetooth HCI on add
     ACTION=="add", SUBSYSTEM=="bluetooth", KERNEL=="hci[0-9]*", RUN+="${pkgs.bluez}/bin/hciconfig %k reset"

     # Logitech Unifying/Lightspeed receivers - permissões para plugdev
     SUBSYSTEMS=="usb", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="c547", MODE="0660", GROUP="plugdev"

     # Todos os dispositivos hidraw com permissão para plugdev
     KERNEL=="hidraw*", SUBSYSTEM=="hidraw", MODE="0660", GROUP="plugdev"
   '';

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;

    prime = {
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    bluez
    solaar
    glxinfo
    pciutils
    polkit_gnome
    glib
    networkmanager
    khal
  ];

  nixpkgs.config.allowUnfree = true;

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
   systemd.services = {
     nvidia-suspend.wantedBy = [ "suspend.target" ];
     nvidia-hibernate.wantedBy = [ "hibernate.target" ];
     nvidia-resume.wantedBy = [ "suspend.target" ];
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