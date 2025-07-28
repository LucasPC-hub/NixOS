{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # DESABILITA GREETD PRIMEIRO 
  services.greetd.enable = false;
  
  # Configura o Ly SIMPLES
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "matrix";
    asterisk = "*";
    hide_borders = false;
    tty = 2;
  };

  # Habilita niri no sistema
  programs.niri.enable = true;

  # IMPORTANTE: Precisamos que o X server esteja habilitado pro ly funcionar direito
  services.xserver.enable = true;
  
  # Força a criação de arquivos de sessão
  environment.etc."X11/xinit/xinitrc".text = ''
    exec niri
  '';

  # Cria arquivo de sessão wayland manualmente
  environment.etc."wayland-sessions/niri.desktop".text = ''
    [Desktop Entry]
    Name=Niri
    Comment=A scrollable-tiling Wayland compositor
    Exec=niri
    Type=Application
  '';
}