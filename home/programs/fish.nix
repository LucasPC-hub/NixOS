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
      
      # Kiro shell integration
      string match -q "$TERM_PROGRAM" "kiro" and . (kiro --locate-shell-integration-path fish)
    '';
    
    shellAliases = {
      cls = "clear_all";
      c = "clear";
      cc = "clear_all";
      clear = "clear_all";
      yay = "pikaur";
      claude = "/home/lpc/.claude/local/claude";
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
          sha256 = "sha256-1ukNdUgOLB3BZeL8xVhF5lT4zULrg9rfjY/1iETnhHE=";
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
  
  # Additional packages needed for fish plugins
  home.packages = with pkgs; [
    fisher
    fzf
    fd
    bat
    exa
    zoxide
    pikaur  # for yay alias
  ];
}