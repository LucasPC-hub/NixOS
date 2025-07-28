{ pkgs, config, ... }:
{
  programs.fish = {

    # Disable default greeting
    interactiveShellInit = ''
      set -g fish_greeting

      # Run fastfetch on shell startup
      if status is-interactive
          fastfetch
      end

      # Clear screen function that also clears scrollback
      function clear_all
          command clear && printf '\e[3J'
      end
    '';

    shellAliases = {
      cls = "clear_all";
      c = "clear";
      cc = "clear_all";
      clear = "clear_all";
      # Removed yay/pikaur alias since we're on NixOS, not Arch
      claude = "/home/lpc/.claude/local/claude";
      flakerb = "sudo nixos-rebuild switch --flake .#default";
    };

    # Fish plugins using fishPlugins from nixpkgs
    plugins = [
      {
        name = "tide";
        src = pkgs.fishPlugins.tide.src;
      }
      {
        name = "fzf-fish";
        src = pkgs.fishPlugins.fzf-fish.src;
      }
      {
        name = "done";
        src = pkgs.fishPlugins.done.src;
      }
      {
        name = "autopair";
        src = pkgs.fishPlugins.autopair.src;
      }
      {
        name = "sponge";
        src = pkgs.fishPlugins.sponge.src;
      }
      {
        name = "forgit";
        src = pkgs.fishPlugins.forgit.src;
      }
      {
        name = "colored-man-pages";
        src = pkgs.fishPlugins.colored-man-pages.src;
      }
      # Fisher and other plugins that aren't in nixpkgs need to be installed manually
      {
        name = "fisher";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "fisher";
          rev = "4.4.4";
          sha256 = "sha256-e8gIaVbuUzTwKtuMPNXBT5STeddYqQegduWBtURLT3M=";
        };
      }
    ];
  };

  # Set fish as default shell
  programs.fish.enable = true;

  # Environment variables
  home.sessionVariables = {
    EDITOR = "zeditor";
  };

  # Make sure npm global bin is in Fish PATH
  programs.fish.shellInit = ''
    # Add npm global packages to PATH if not already there
    if not contains $HOME/.npm-global/bin $PATH
        set -gx PATH $HOME/.npm-global/bin $PATH
    end
  '';

  # Additional packages needed for fish plugins
  home.packages = with pkgs; [
    fzf
    fd
    bat
    eza  # modern replacement for exa
    zoxide
  ];
}
