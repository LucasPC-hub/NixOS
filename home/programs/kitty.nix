{ pkgs, config, ... }:
{
  programs.kitty = {
    enable = true;
    font = {
      name = "FantasqueSansM Nerd Font Mono Bold";
      size = 12;
    };
    settings = {
      # Window settings
      initial_window_width = "95c";
      initial_window_height = "35c";
      window_padding_width = 20;
      background_opacity = "0.98";
      dynamic_background_opacity = 1;
      confirm_os_window_close = 0;

      # Display server
      linux_display_server = "auto";

      # Scrolling
      scrollback_lines = 2000;
      wheel_scroll_min_lines = 1;

      # Audio
      enable_audio_bell = false;

      # Theme colors (Catppuccin Mocha)
      foreground = "#CDD6F4";
      background = "#1E1E2E";
      selection_foreground = "#1E1E2E";
      selection_background = "#F5E0DC";
      
      cursor = "#F5E0DC";
      cursor_text_color = "#1E1E2E";
      
      url_color = "#F5E0DC";
      
      active_border_color = "#B4BEFE";
      inactive_border_color = "#6C7086";
      bell_border_color = "#F9E2AF";
      
      # Tab colors
      active_tab_foreground = "#11111B";
      active_tab_background = "#CBA6F7";
      inactive_tab_foreground = "#CDD6F4";
      inactive_tab_background = "#181825";
      tab_bar_background = "#11111B";
      
      # Terminal colors
      color0 = "#45475A";
      color8 = "#585B70";
      color1 = "#F38BA8";
      color9 = "#F38BA8";
      color2 = "#A6E3A1";
      color10 = "#A6E3A1";
      color3 = "#F9E2AF";
      color11 = "#F9E2AF";
      color4 = "#89B4FA";
      color12 = "#89B4FA";
      color5 = "#F5C2E7";
      color13 = "#F5C2E7";
      color6 = "#94E2D5";
      color14 = "#94E2D5";
      color7 = "#BAC2DE";
      color15 = "#A6ADC8";
    };
    
    keybindings = {
      # Scrolling
      "shift+up" = "scroll_line_up";
      "shift+down" = "scroll_line_down";
      "shift+page_up" = "scroll_page_up";
      "shift+page_down" = "scroll_page_down";
      "ctrl+shift+page_up" = "scroll_to_prompt -1";
      "ctrl+shift+page_down" = "scroll_to_prompt 1";
      "shift+home" = "scroll_home";
      "shift+end" = "scroll_end";
      
      # Copy/Paste
      "ctrl+c" = "copy_to_clipboard";
      "ctrl+v" = "paste_from_clipboard";
      
      # Clear screen
      "ctrl+l" = "clear_terminal clear_active";
      
      # Interrupt signals
      "ctrl+alt+c" = "send_text all \\x03";
      "ctrl+backslash" = "send_text all \\x03";
      "ctrl+d" = "send_text all \\x03";
    };
  };
}