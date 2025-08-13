{ pkgs, ... }:
{
  hardware.steam-hardware.enable = true;
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
    gamescopeSession.enable = true;
  };

  # OpenGL and Vulkan configuration
  hardware.graphics.enable = true;
  hardware.graphics.extraPackages = with pkgs; [
    vulkan-loader
    vulkan-tools
  ];

  # Add system packages for VR support and Steam wrapper
  environment.systemPackages = with pkgs; [
    openvr # Required for SteamVR
    libusb1 # Used for VR devices
    usbutils
    pkgs.libsndfile
    pkgs.xwayland
    gamescope
    # NVIDIA-specific packages for Steam
    nvidia-vaapi-driver
    libva
    xdg-user-dirs # Fix missing xdg-user-dir command
    # Steam wrapper that always uses NVIDIA
    (writeShellScriptBin "steam-nvidia" ''
      export __NV_PRIME_RENDER_OFFLOAD=1
      export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
      export __GLX_VENDOR_LIBRARY_NAME=nvidia
      export __VK_LAYER_NV_optimus=NVIDIA_only
      exec ${steam}/bin/steam "$@"
    '')
  ];

  # Udev rules for VR devices
  services.udev.packages = with pkgs; [
    openvr
  ];

  services.udev.extraRules = ''
    # HTC Vive
    SUBSYSTEM=="usb", ATTR{idVendor}=="0bb4", ATTR{idProduct}=="2c87", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="28de", ATTR{idProduct}=="2101", MODE="0666", GROUP="plugdev"
    SUBSYSTEM=="usb", ATTR{idVendor}=="28de", ATTR{idProduct}=="2000", MODE="0666", GROUP="plugdev"
  '';
}
