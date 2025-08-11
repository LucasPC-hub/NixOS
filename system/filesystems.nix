{
  # Montagem da partição NTFS (Windows)
  fileSystems."/mnt/windows" = {
    device = "UUID=48F6A373F6A35FC4";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=100"
      "dmask=022"
      "fmask=133"
      "nofail"
    ];
  };

  # Montagem da partição BTRFS (Arch /home) - UUID CORRETO
  fileSystems."/mnt/arch-home" = {
    device = "UUID=2f1d2bf4-abf7-4a99-b828-94c7f52089fc";
    fsType = "btrfs";
    options = [
      "nofail"
      "compress=zstd"
    ];
  };
}
