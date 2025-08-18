{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "dgop";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "AvengeMedia";
    repo = "dgop";
    rev = "main"; # Use "v${version}" when they create tagged releases
    hash = "sha256-QCJbcczQjUZ+Xf7tQHckuP9h8SD0C4p0C8SVByIAq/g="; # You'll need to update this
  };

  vendorHash = "sha256-+5rN3ekzExcnFdxK2xqOzgYiUzxbJtODHGd4HVq6hqk="; # You'll need to update this

  # Build configuration
    subPackages = [ "cmd/cli" ];

    ldflags = [
      "-s"
      "-w"
      "-X main.Version=${version}"
    ];

    # Rename the binary from 'cli' to 'dgop' and create alias for 'dankgop'
    postInstall = ''
      mv $out/bin/cli $out/bin/dgop
      ln -s $out/bin/dgop $out/bin/dankgop
    '';

    # Test configuration
    doCheck = false; # Disable tests for now since they might require system resources

    meta = with lib; {
      description = "System monitoring tool with CLI and REST API";
      longDescription = ''
        dgop (DankGop) is a system monitoring tool written in Go that provides
        both a command-line interface and REST API for accessing system metrics.
        It can display CPU, memory, disk, network, and process information with
        both text output and an interactive TUI mode.

        Features:
        - CLI commands for individual system components (cpu, memory, disk, etc.)
        - Interactive TUI mode for real-time monitoring
        - REST API server for integration with other tools
        - JSON output support
        - Cursor-based sampling for accurate rate calculations
        - GPU temperature monitoring
        - Process monitoring with sorting and filtering
      '';
      homepage = "https://github.com/AvengeMedia/dgop";
      license = licenses.mit;
      maintainers = with maintainers; [ ]; # Add your name here if you want
      platforms = platforms.linux; # Currently Linux-only based on code
      mainProgram = "dgop";
    };
  }
