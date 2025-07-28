{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Enable Docker service
  virtualisation.docker.enable = true;
  virtualisation.docker.enableOnBoot = true;

  # Configure Docker daemon
  virtualisation.docker.daemon.settings = {
    "exec-opts" = ["native.cgroupdriver=systemd"];
    "log-driver" = "json-file";
    "log-opts" = {
      "max-size" = "100m";
    };
    "storage-driver" = "overlay2";
  };

  # Install Docker packages
  environment.systemPackages = with pkgs; [
    docker
    docker-compose
  ];
}
