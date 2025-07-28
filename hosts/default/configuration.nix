{ config, pkgs, inputs, lib, self, ... }:

{
  imports = [
    ./hardware-configuration.nix
    "${self}/system/greeter/greetd.nix"
    "${self}/system/programs/steam.nix"
    "${self}/system/programs/lact.nix"
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

  # MUDANÇA: Altere o nome do usuário para o seu
  users.users.lpc = {  # Mudei de "lysec" para "lpc"
    isNormalUser = true;
    description = "lpc";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "input"
      "plugdev"
      "i2c"
      "bluetooth"
    ];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "lpc" = import ./home.nix;  # Mudei para "lpc"
    };
  };

  fonts.packages = with pkgs; [
    fira-sans
    roboto
    nerd-fonts._0xproto
    nerd-fonts.droid-sans-mono
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
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      extraEntries = ''
        menuentry "Arch Linux" {
          search --set=root --fs-uuid 2f1d2bf4-abf7-4a99-b828-94c7f52089fc
          linux /vmlinuz-linux root=UUID=2f1d2bf4-abf7-4a99-b828-94c7f52089fc rootfstype=btrfs rootflags=subvol=@ rw vt.default_red=0x0c,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xb7,0x44,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xe3 vt.default_grn=0x0d,0x6b,0xae,0xab,0xde,0xae,0xa0,0xbb,0x48,0x6b,0xae,0xab,0xde,0xae,0xa0,0xc2 vt.default_blu=0x11,0x81,0xff,0xff,0xff,0xff,0xff,0xd0,0x5a,0x81,0xff,0xff,0xff,0xff,0xff,0xff
          initrd /intel-ucode.img
          initrd /initramfs-linux.img
        }
        menuentry "Arch Linux (Zen Kernel)" {
          search --set=root --fs-uuid 2f1d2bf4-abf7-4a99-b828-94c7f52089fc
          linux /vmlinuz-linux-zen root=UUID=2f1d2bf4-abf7-4a99-b828-94c7f52089fc rootfstype=btrfs rootflags=subvol=@ rw vt.default_red=0x0c,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xb7,0x44,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xe3 vt.default_grn=0x0d,0x6b,0xae,0xab,0xde,0xae,0xa0,0xbb,0x48,0x6b,0xae,0xab,0xde,0xae,0xa0,0xc2 vt.default_blu=0x11,0x81,0xff,0xff,0xff,0xff,0xff,0xd0,0x5a,0x81,0xff,0xff,0xff,0xff,0xff,0xff
          initrd /intel-ucode.img
          initrd /initramfs-linux-zen.img
        }
        menuentry "Arch Linux (Mainline Kernel)" {
          search --set=root --fs-uuid 2f1d2bf4-abf7-4a99-b828-94c7f52089fc
          linux /vmlinuz-linux-mainline root=UUID=2f1d2bf4-abf7-4a99-b828-94c7f52089fc rootfstype=btrfs rootflags=subvol=@ rw vt.default_red=0x0c,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xb7,0x44,0xff,0xa8,0x8e,0xf3,0xa8,0x9e,0xe3 vt.default_grn=0x0d,0x6b,0xae,0xab,0xde,0xae,0xa0,0xbb,0x48,0x6b,0xae,0xab,0xde,0xae,0xa0,0xc2 vt.default_blu=0x11,0x81,0xff,0xff,0xff,0xff,0xff,0xd0,0x5a,0x81,0xff,0xff,0xff,0xff,0xff,0xff
          initrd /intel-ucode.img
          initrd /initramfs-linux-mainline.img
        }
      '';
    };
    efi.canTouchEfiVariables = true;
  };
  kernelPackages = pkgs.linuxPackages_latest;
  kernelParams = [
    "video=eDP-1:2880x1800@120"
  ];
  kernelModules = [ "v4l2loopback" "i2c-dev" ];
  initrd.availableKernelModules = [ "i2c-dev" ];
  extraModprobeConfig = ''
    options v4l2loopback video_nr=0 card_label="DroidCam" exclusive_caps=1
  '';
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

  # MUDANÇA: Fuso horário para Brasil
  time.timeZone = "America/Sao_Paulo";  # Era "Europe/Berlin"

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      # MUDANÇA: Configurações para Brasil
      LC_ADDRESS = "pt_BR.UTF-8";        # Era "de_DE.UTF-8"
      LC_IDENTIFICATION = "pt_BR.UTF-8"; # Era "de_DE.UTF-8"
      LC_MEASUREMENT = "pt_BR.UTF-8";    # Era "de_DE.UTF-8"
      LC_MONETARY = "pt_BR.UTF-8";       # Era "de_DE.UTF-8"
      LC_NAME = "pt_BR.UTF-8";           # Era "de_DE.UTF-8"
      LC_NUMERIC = "pt_BR.UTF-8";        # Era "de_DE.UTF-8"
      LC_PAPER = "pt_BR.UTF-8";          # Era "de_DE.UTF-8"
      LC_TELEPHONE = "pt_BR.UTF-8";      # Era "de_DE.UTF-8"
      LC_TIME = "pt_BR.UTF-8";           # Era "de_DE.UTF-8"
    };
  };

  programs.zsh.enable = true;

  services = {
    xserver = {
      enable = true;
      # MUDANÇA: Só Intel por enquanto (sem NVIDIA)
      videoDrivers = [ "intel" ];  # Removeu nvidia temporariamente
      xkb = {
        layout = "br";  # MUDANÇA: Layout brasileiro (era "de")
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

  # MUDANÇA: Layout do console para brasileiro
  console.keyMap = "br-abnt2";  # Era "de"

  xdg.portal.enable = true;

  hardware.bluetooth.enable = true;

  # NVIDIA desabilitado por enquanto
  # hardware.nvidia = {
  #   modesetting.enable = true;
  #   powerManagement.enable = false;
  #   powerManagement.finegrained = false;
  #   open = false;
  #   nvidiaSettings = true;
  #   package = config.boot.kernelPackages.nvidiaPackages.stable;
  # };

  environment.systemPackages = with pkgs; [
    bluez
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
}