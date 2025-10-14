{ config, pkgs, ... }:

let
      systemFont = {
            name = "FiraCode Nerd Font";
            size = 11;
      };
in {
      gtk = {
            enable = true;
            theme = {
                  name = "Breeze";
                  package = pkgs.kdePackages.breeze-gtk;
            };

            iconTheme = {
                  name = "breeze-dark";
                  package = pkgs.kdePackages.breeze;
            };

            cursorTheme = {
                  name = "breeze_cursors";
                  package = pkgs.kdePackages.breeze;
            };
            font = {
                  name = systemFont.name;
                  size = systemFont.size;
            };
      };

      home.stateVersion = "25.05";
      programs.home-manager.enable = true;

      home.packages = with pkgs; [
            vlc
            solaar # Logitech Devices
            appimage-run # To run .Appimage
            ncurses

            #---------- Editor ------------#
            neovim
            vscode

            #---------- Toolchain ----------#
            cargo
            flutter
            android-tools
            jdk17
            pnpm
            python310

            #---------- CLI Tools ----------#
            tmux
            ripgrep
            fd
            bat
            fzf
            bat # better cat
            eza # better ls
            tldr
            zoxide
            pay-respects
            dua
            duf
            jq
            scrcpy

            #---------- Terminal -----------#
            zsh
            tree-sitter
            xclip # Clipboard

            #---------- Formatter ----------#
            stylua
            lua-language-server
            rustfmt     # for Rust
            prettierd   # for web development
            clang-tools # for C/C++
            pyright

            #---------- Languages ----------#
            gcc # C++
            nodejs
            cargo
            rustc
            rust-analyzer

            #---------- Terminal ----------#
            alacritty

            #---------- Productivity ----------//
            ticktick
            obsidian
      ];

      programs = {

            tmux = {
                  enable = true;
                  keyMode = "vi";
                  clock24 = true;
                  # shortcut = "a";
                  plugins = with pkgs; [
                        pkgs.tmuxPlugins.sensible
                        pkgs.tmuxPlugins.vim-tmux-navigator
                        pkgs.tmuxPlugins.yank
                        pkgs.tmuxPlugins.catppuccin
                  ];
                  prefix = "C-a";
                  terminal = "tmux-256color";
                  extraConfig = ''
                        # Set position of status bar to top
                        set-option -g status-position top

                        set -as terminal-features 'xterm-256color:RGB'
                        set -as terminal-features 'alacritty:RGB'
                        set -as terminal-features 'tmux-256color:RGB'

                        unbind C-b
                        set -g prefix C-a
                        bind C-a send-prefix

                        # Use Alt-hjkl keys without prefix key to switch panes
                        bind -n C-Left select-pane -L
                        bind -n C-Right select-pane -R
                        bind -n C-Up select-pane -U
                        bind -n C-Down select-pane -D

                        # Passthrough for image viewing
                        set -gq allow-passthrough on
                        set -g visual-activity off

                        # True Color support
                        set-option -sa terminal-overrides ",xterm*:Tc"

                        # Key bindings
                        bind -n C-Left select-pane -L
                        bind -n C-Right select-pane -R
                        bind -n C-Up select-pane -U
                        bind -n C-Down select-pane -D

                        bind -n C-M-h previous-window
                        bind -n C-M-l next-window

                        bind-key -T copy-mode-vi v send-keys -X begin-selection
                        bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
                        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

                        bind '"' split-window -v -c "#{pane_current_path}"
                        bind % split-window -h -c "#{pane_current_path}"

                        set -g @catppuccin_flavor "frappe"
                        set -g @catppuccin_window_status_style "slanted"
                        set -g @catppuccin_date_time_text " %a %d/%m/%Y | %H:%M"

                        set -g status-left-length 100
                        set -g status-right-length 100
                        set -g status-left "(づ๑•ᴗ•๑)づ"
                        set -g status-right "#{E:@catppuccin_status_date_time}#{E:@catppuccin_status_user}#{E:@catppuccin_status_uptime}"
                  '';
            };

            gh = {
                  enable = true;
            };

            git = {
                  enable = true;
                  userName = "anvnh";
                  userEmail = "anvo20052@gmail.com";
                  delta = {
                        enable = true;
                        options = {
                              side-by-side = true;
                              line-numbers = true;
                        };
                  };
            };
            alacritty = {
                  enable = true;
                  settings = {
                        env = {
                              TERM = "xterm-256color";
                              COLORTERM = "truecolor";
                        };
                        font = {
                              normal = {
                                    family = "FiraCode Nerd Font";
                                    style = "Regular";
                              };
                              size = 13;
                        };
                        window = {
                              dynamic_padding = true;
                              # padding = { x = 10; y = 10; };
                        };
                        colors = {
                              primary = {
                                    background = "0x161616";
                                    foreground = "0xf2f4f8";
                              };
                              cursor = {
                                    text = "0xf2f4f8";
                                    cursor = "0xb6b8bb";
                              };
                              vi_mode_cursor = {
                                    text = "0xf2f4f8";
                                    cursor = "0x33b1ff";
                              };
                              search = {
                                    matches = {
                                          foreground = "0xf2f4f8";
                                          background = "0x525253";
                                    };
                                    focused_match = {
                                          foreground = "0xf2f4f8";
                                          background = "0x3ddbd9";
                                    };
                              };
                              hints = {
                                    start = {
                                          foreground = "0xf2f4f8";
                                          background = "0x3ddbd9";
                                    };
                                    end = {
                                          foreground = "0xf2f4f8";
                                          background = "0x353535";
                                    };
                              };
                              selection = {
                                    text = "0xf2f4f8";
                                    background = "0x2a2a2a";
                              };
                              normal = {
                                    black = "0x282828";
                                    red = "0xee5396";
                                    green = "0x25be6a";
                                    yellow = "0x08bdba";
                                    blue = "0x78a9ff";
                                    magenta = "0xbe95ff";
                                    cyan = "0x33b1ff";
                                    white = "0xdfdfe0";
                              };
                              bright = {
                                    black = "0x484848";
                                    red = "0xf16da6";
                                    green = "0x46c880";
                                    yellow = "0x2dc7c4";
                                    blue = "0x8cb6ff";
                                    magenta = "0xc8a5ff";
                                    cyan = "0x52bdff";
                                    white = "0xe4e4e5";
                              };
                              dim = {
                                    black = "0x222222";
                                    red = "0xca4780";
                                    green = "0x1fa25a";
                                    yellow = "0x07a19e";
                                    blue = "0x6690d9";
                                    magenta = "0xa27fd9";
                                    cyan = "0x2b96d9";
                                    white = "0xbebebe";
                              };
                              indexed_colors = [
                                    { index = 16; color = "0x3ddbd9"; }
                                    { index = 17; color = "0xff7eb6"; }
                              ];
                        };
                  };
            };

            zsh = {
                  enable = true;
                  oh-my-zsh.enable = false;

                  initContent = ''
                        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
                        [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
                        eval "$(direnv hook zsh)"
                  '';
                  syntaxHighlighting.enable = true;
                  autosuggestion.enable = true;
                  history.size = 10000;
                  shellAliases = {
                        # nrs = "sudo nixos-rebuild switch";
                        nrs = "sudo nixos-rebuild switch --flake .#vnhantyn";
                        ls = "eza --color=always --long --git --no-filesize --icons=always";
                        cd = "z";
                        "?" = "pay-respects";
                  };
            };

            # Config CLIs
            zoxide = {
                  enable = true;
                  enableZshIntegration = true;
            };
            fzf = {
                  enable = true;
                  enableZshIntegration = true;
            };
            pay-respects = {
                  enable = true;
                  enableZshIntegration = true;
            };
      };
}
