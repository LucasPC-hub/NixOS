{ ... }:
{
  # Montagem da partição NTFS (Windows)
  fileSystems."/mnt/windows" = {
    device = "UUID=48F6A373F6A35FC4";
    fsType = "ntfs";
    options = [ 
      "uid=1000"     # Seu user ID
      "gid=100"      # Group users
      "dmask=022"    # Permissões de diretório
      "fmask=133"    # Permissões de arquivo
      "nofail"       # Não falha o boot se não conseguir montar
    ];
  };

  # Montagem da partição BTRFS (Arch /home)
  fileSystems."/mnt/arch-home" = {
    device = "UUID=65f9c9df-00ef-476c-a9c5-57576ed234c8";
    fsType = "btrfs";
    options = [ 
      "nofail"       # Não falha o boot se não conseguir montar
      "compress=zstd" # Compressão (se o Arch usa)
    ];
  };
}