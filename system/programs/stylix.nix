{ config, pkgs, lib, self, ... }:
{
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = toString (builtins.path {
    path = ../../assets/themes/base-16/oled-lavender.yaml;
  });
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon.yaml";

  stylix.enableReleaseChecks = false;

  # # Configure zen-browser profiles
  # stylix.targets.zen-browser.profileNames = [ "default" ];
}
