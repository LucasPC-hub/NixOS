{ config, pkgs, lib, self, ... }:
{
  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.base16Scheme = toString (builtins.path {
    path = ../../assets/themes/base-16/oled-lavender.yaml;
  });
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/oxocarbon.yaml";
  
  stylix.enableReleaseChecks = false;
  
  # Force dark mode for all applications
  stylix.polarity = "dark";
  
  # Enable theming for desktop environments
  stylix.targets.gtk.enable = true;
  stylix.targets.gnome.enable = true;
  
  # Cursor theming
  stylix.cursor.package = pkgs.layan-cursors;
  stylix.cursor.name = "layan-cursors";
  stylix.cursor.size = 20;
  
  # Browser theming
  # stylix.targets.zen-browser.enable = true;
  # stylix.targets.zen-browser.profileNames = [ "default" ];
}
