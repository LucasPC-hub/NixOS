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

      # Global window rule - updated corner radius to match old config
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
    ];
  };
}
