{ pkgs, config, ... }:
{
  programs.fish = {
    enable = true;

    # Disable default greeting
    interactiveShellInit = ''
      set -g fish_greeting

      # MELHORAR HISTORY E AUTOCOMPLETION
      # History settings
      set -g fish_history_max 10000
      set -g fish_history_save_on_exit 1

      # AUTOSUGGESTIONS AUTOMÁTICAS (melhor que zsh)
      set -g fish_autosuggestion_enabled 1
      set -g fish_autosuggestion_accept_key right  # Seta direita aceita
      set -g fish_autosuggestion_accept_key_word alt+right  # Alt+direita aceita só uma palavra
      set -g fish_autosuggestion_execute_key shift+right  # Shift+direita executa diretamente

      # Cores das suggestions (cinza claro por padrão)
      set -g fish_color_autosuggestion 555

      # Better autocompletion behavior
      set -g fish_complete_path $fish_complete_path ~/.config/fish/completions /usr/share/fish/completions

      # Pager settings for better navigation
      set -g fish_pager_color_prefix cyan
      set -g fish_pager_color_completion normal
      set -g fish_pager_color_description yellow
      set -g fish_pager_color_progress cyan

      # Better history search (case insensitive)
      set -g fish_search_match_case_insensitive 1

      # COMMAND-NOT-FOUND automático (tipo "did you mean?")
      if type -q command-not-found
          function fish_command_not_found
              command-not-found $argv[1]
          end
      end

      # CORREÇÃO AUTOMÁTICA tipo "did you mean?" (como nyae do zsh)
      function fish_command_not_found --on-event fish_command_not_found
          set -l cmd $argv[1]
          set -l full_command (string join " " $argv)

          # Correções para comandos COMPLETOS (com argumentos)
          switch $full_command
              case "gti *"
                  set -l git_args (string replace "gti" "git" -- $full_command)
                  echo
                  set_color yellow
                  echo -n "Did you mean: "
                  set_color cyan
                  echo -n "$git_args"
                  set_color yellow
                  echo -n "? (y/n/e) "
                  set_color normal

                  read -n 1 -P "" response
                  echo

                  switch $response
                      case "y" "Y" ""
                          eval $git_args
                          return 0
                      case "e" "E"
                          commandline -r "$git_args"
                          return 0
                      case "*"
                          echo "Command not executed."
                          return 1
                  end
          end

          # Correções para comandos SIMPLES (sem argumentos)
          set -l corrections \
              "gut" "git" \
              "gi" "git" \
              "grpe" "grep" \
              "gerp" "grep" \
              "sl" "ls" \
              "lsl" "ls" \
              "les" "ls" \
              "claer" "clear" \
              "clar" "clear" \
              "clera" "clear" \
              "xit" "exit" \
              "exti" "exit" \
              "ext" "exit" \
              "mkae" "make" \
              "amke" "make" \
              "sudp" "sudo" \
              "suod" "sudo" \
              "cd.." "cd .." \
              "yay" "nh"

          # Procurar correção simples
          for i in (seq 1 2 (count $corrections))
              if test "$cmd" = "$corrections[$i]"
                  set -l suggestion "$corrections[(math $i + 1)]"
                  echo
                  set_color yellow
                  echo -n "Did you mean: "
                  set_color cyan
                  echo -n "$suggestion"
                  if test (count $argv) -gt 1
                      echo -n " $argv[2..-1]"
                  end
                  set_color yellow
                  echo -n "? (y/n/e) "
                  set_color normal

                  read -n 1 -P "" response
                  echo

                  switch $response
                      case "y" "Y" ""
                          if test (count $argv) -gt 1
                              eval $suggestion $argv[2..-1]
                          else
                              eval $suggestion
                          end
                          return 0
                      case "e" "E"
                          if test (count $argv) -gt 1
                              commandline -r "$suggestion $argv[2..-1]"
                          else
                              commandline -r "$suggestion"
                          end
                          return 0
                      case "*"
                          echo "Command not executed."
                          return 1
                  end
              end
          end

          # Se não encontrou correção exata, mostrar erro
          echo
          set_color red
          echo "Command '$cmd' not found."
          set_color normal

          return 127
      end

      # Run fastfetch on shell startup
      if status is-interactive
          fastfetch
      end

      # Clear screen function that also clears scrollback
      function clear_all
          command clear && printf '\e[3J'
      end

      # Git commit function
      function gc
          set file_status (git status --porcelain)
          git add .
          set commit_msg (test (count $argv) -eq 0; and echo "Auto-commit"; or echo "$argv[1]")
          git commit -m "$commit_msg

      $file_status"
      end

      # Function para corrigir comandos comuns (como thefuck)
      function fuck --description 'Correct previous command'
          set -l fucked_up_command $history[1]
          echo "Tentando corrigir: $fucked_up_command"

          # Algumas correções comuns
          switch $fucked_up_command
              case "sl"
                  ls
              case "cd.."
                  cd ..
              case "xit" "exti" "ext"
                  exit
              case "claer" "clar" "clera"
                  clear
              case "les" "lss" "sl"
                  lsd
              case "gti"
                  git status
              case "gut"
                  git
              case "gits"
                  git status
              case "grpe" "gerp"
                  grep
              case "mkae"
                  make
              case "amke"
                  make
              case "sudp" "suod"
                  sudo $history[2..-1]
              case "*"
                  echo "Não sei como corrigir '$fucked_up_command'"
                  echo "Você quis dizer algum destes?"
                  # Usar compgen se disponível, senão usar which
                  if type -q compgen
                      compgen -c | grep -i (echo $fucked_up_command | head -c 3) | head -5
                  else if type -q which
                      ls /usr/bin /bin | grep -i (echo $fucked_up_command | head -c 3) | head -5
                  end
          end
      end

      # Adicionar binding para Ctrl+X+E para editar comando no editor
      bind \cx\ce edit_command_buffer

      # Tide configuration (baseado no seu config antigo)
      if type -q tide
        # Left Prompt Items
        set -g tide_left_prompt_items pwd git node rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig

        # Right Prompt Items
        set -g tide_right_prompt_items status cmd_duration context jobs direnv python rustc java php pulumi ruby go gcloud kubectl distrobox toolbox terraform aws nix_shell crystal elixir zig time

        # OS Component
        set -g tide_os_bg_color 1E1E2E
        set -g tide_os_color FF79C6
        set -g tide_os_icon

        # PWD Component
        set -g tide_pwd_bg_color 1E1E2E
        set -g tide_pwd_color FF79C6
        set -g tide_pwd_color_anchors FF79C6
        set -g tide_pwd_color_dirs F5C2E7
        set -g tide_pwd_color_truncated_dirs CBA6F7

        set -g tide_git_color_branch 663399  # Changed to darker blue

        # Status Component
        set -g tide_status_bg_color 1E1E2E
        set -g tide_status_bg_color_failure 1E1E2E
        set -g tide_status_color F5C2E7
        set -g tide_status_color_failure F38BA8

        # Command Duration Component
        set -g tide_cmd_duration_bg_color 1E1E2E
        set -g tide_cmd_duration_color F5C2E7

        # Context Component (user@host)
        set -g tide_context_bg_color 313244
        set -g tide_context_color_default F5C2E7
        set -g tide_context_color_root F38BA8
        set -g tide_context_color_ssh FF79C6

        # Jobs Component
        set -g tide_jobs_bg_color 1E1E2E
        set -g tide_jobs_color CBA6F7

        # Time Component
        set -g tide_time_bg_color 1E1E2E
        set -g tide_time_color F5C2E7

        # Node.js Component (for Angular)
        set -g tide_node_bg_color 313244
        set -g tide_node_color F38BA8
        set -g tide_node_icon ⬢

        # Python Component
        set -g tide_python_bg_color 313244
        set -g tide_python_color CBA6F7

        # Ruby Component
        set -g tide_ruby_bg_color 313244
        set -g tide_ruby_color F38BA8

        # Go Component
        set -g tide_go_bg_color 313244
        set -g tide_go_color 94E2D5

        # Rust Component
        set -g tide_rustc_bg_color 313244
        set -g tide_rustc_color FAB387

        # PHP Component
        set -g tide_php_bg_color 313244
        set -g tide_php_color CBA6F7

        # Java Component
        set -g tide_java_bg_color 313244
        set -g tide_java_color FAB387

        # Kubectl Component
        set -g tide_kubectl_bg_color 313244
        set -g tide_kubectl_color 89B4FA

        # AWS Component
        set -g tide_aws_bg_color 313244
        set -g tide_aws_color FAB387

        # Terraform Component
        set -g tide_terraform_bg_color 313244
        set -g tide_terraform_color CBA6F7

        # Docker Component
        set -g tide_docker_bg_color 313244
        set -g tide_docker_color 89B4FA

        # Character Component
        set -g tide_character_color F5C2E7
        set -g tide_character_color_failure F38BA8
        set -g tide_character_icon ❯
        set -g tide_character_vi_icon_default ❮
        set -g tide_character_vi_icon_replace ▶
        set -g tide_character_vi_icon_visual V

        # Vi Mode Component
        set -g tide_vi_mode_bg_color_default 313244
        set -g tide_vi_mode_bg_color_insert 313244
        set -g tide_vi_mode_bg_color_replace 313244
        set -g tide_vi_mode_bg_color_visual 313244
        set -g tide_vi_mode_color_default F5C2E7
        set -g tide_vi_mode_color_insert A6E3A1
        set -g tide_vi_mode_color_replace F38BA8
        set -g tide_vi_mode_color_visual CBA6F7

        # Private Mode Component
        set -g tide_private_mode_bg_color 313244
        set -g tide_private_mode_color F5C2E7

        # Prompt configuration
        set -g tide_prompt_add_newline_before true
        set -g tide_prompt_min_cols 34
        set -g tide_prompt_pad_items true

        # Separators para estilo powerline
        set -g tide_left_prompt_separator_diff_color
        set -g tide_left_prompt_separator_same_color
        set -g tide_right_prompt_separator_diff_color
        set -g tide_right_prompt_separator_same_color

        # Frame
        set -g tide_left_prompt_frame_enabled false
        set -g tide_right_prompt_frame_enabled false
      end

      # Initialize zoxide - ADICIONADO BASEADO NO SEU COMANDO
      if command -q zoxide
        zoxide init fish | source
      end
    '';

    shellAliases = {
      # Clear aliases (do seu config antigo)
      cls = "clear_all";
      c = "clear";
      cc = "clear_all";
      clear = "clear_all";

      # lsd aliases - moderno ls com ícones
      ls = "lsd";
      ll = "lsd -l";
      la = "lsd -la";
      lt = "lsd --tree";

      # yay alias (você usava pikaur no Arch)
      yay = "nh";


      # Rebuild alias
      fkr = "sudo nixos-rebuild switch --flake .#default";
    };

    # Fish plugins - APENAS OS OFICIAIS DO NIXPKGS
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
    ];

    # Shell init para adicionar npm global bin ao PATH
    shellInit = ''
      # Add npm global packages to PATH if not already there
      if not contains $HOME/.npm-global/bin $PATH
          set -gx PATH $HOME/.npm-global/bin $PATH
      end
    '';
  };

  # Environment variables
  home.sessionVariables = {
    EDITOR = "zeditor";
  };

  # Adicionar pacotes necessários para os plugins funcionarem
  home.packages = with pkgs; [
    fzf
    fd
    bat
    lsd  # LSDeluxe - ls moderno com ícones e cores
    eza  # modern replacement for exa (backup)
    zoxide  # IMPORTANTE: instalar o zoxide
    gum     # Para alguns plugins
    delta   # Para git diffs melhores
    # Pacotes para melhorar autocompletion e correção
    bash-completion  # Para comandos bash
    nix-bash-completions  # Completions para Nix
    pay-respects  # Substituto do thefuck - correção de comandos
    # Para command-not-found funcionar
    nix-index  # Indexa pacotes para sugestões automáticas
  ];

  # Configurar zoxide NATIVO do Home Manager (mais confiável)
  programs.zoxide = {
    enable = true;
    enableFishIntegration = false;  # Desabilitar integração automática pq vamos fazer manual
  };
}
