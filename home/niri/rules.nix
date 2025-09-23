{
  config,
  pkgs,
  ...
}: {
  programs.niri.settings = {
    layer-rules = [
      {
        matches = [
          {
            namespace = "^quickshell-wallpaper$";
          }
        ];
        #place-within-backdrop = true;
      }
      {
        matches = [
          {
            namespace = "^quickshell-overview$";
          }
        ];
        place-within-backdrop = true;
      }
      {
        matches = [
          {
            namespace = "^swww-daemon$";
          }
        ];
        place-within-backdrop = true;
      }
    ];

    window-rules = [
      {
        matches = [{}];
        geometry-corner-radius = {
          top-left = 10.0;
          top-right = 10.0;
          bottom-left = 10.0;
          bottom-right = 10.0;
        };
        clip-to-geometry = true;
      }
      {
        matches = [
          { app-id = "jetbrains-webstorm"; }
        ];
        default-column-width = { proportion = 1.0; };
        open-maximized = true;
      }
      {
        matches = [
          { app-id = "zen-twilight"; }
        ];
        default-column-width = { proportion = 1.0; };
        open-maximized = true;
      }
    ];
  };
}
