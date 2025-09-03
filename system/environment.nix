{
  config,
  pkgs,
  inputs,
  ...
}:

{
  environment.variables = {
    QT_QPA_PLATFORM = "wayland";
    
    # Force dark mode for GTK applications
    GTK_THEME = "Adwaita:dark";
    
    # Force dark mode for Qt applications
    QT_STYLE_OVERRIDE = "Adwaita-Dark";
    
    # Additional dark mode variables
    GSETTINGS_BACKEND = "memory";
    GTK2_RC_FILES = "${pkgs.gnome-themes-extra}/share/themes/Adwaita-dark/gtk-2.0/gtkrc";
  };
}
