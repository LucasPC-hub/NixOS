{ config, lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "fix-bt-keyboard" ''
      sudo ${kmod}/bin/modprobe -r hid_generic
      sudo ${kmod}/bin/modprobe -r btusb
      sleep 1
      sudo ${kmod}/bin/modprobe btusb
      sudo ${kmod}/bin/modprobe hid_generic
      echo "Bluetooth HID drivers reloaded"
    '')
  ];
}
