{ config, pkgs, ... }:

let
  brightnessScript = pkgs.writeShellScriptBin "brightness" ''
    STEP=5
    OSD_FILE="/tmp/brightness_osd_level"

    if [[ "$1" == "up" ]]; then
      brightnessctl set +$STEP%
    elif [[ "$1" == "down" ]]; then
      brightnessctl set $STEP%-
    else
      echo "Usage: brightness [up|down]"
      exit 1
    fi

    # Pega o valor atual e escreve no arquivo para o OSD
    current=$(brightnessctl get)
    max=$(brightnessctl max)
    percentage=$((current * 100 / max))
    echo "$percentage" > "$OSD_FILE"
  '';
in
{
  home.packages = [
    pkgs.brightnessctl
    brightnessScript
  ];
}
