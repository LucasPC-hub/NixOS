{
  config,
  pkgs,
  inputs,
  ...
}:
{
  # Remove tudo do greetd e usa só o Ly
  services.displayManager.ly.enable = true;
  services.displayManager.ly.settings = {
    animation = "matrix";
    asterisk = "*";
    hide_borders = false;
    tty = 2;
  };
}