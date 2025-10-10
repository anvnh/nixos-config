{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    neovim
    vlc
    solaar # Logitech Devices
    appimage-run # To run .Appimage

    #---------- Toolchain ----------#
    cargo

    #---------- CLI Tools ----------#
    ripgrep
    fd
    bat
    fzf
    bat # better cat
    eza # better ls
    tldr
    zoxide
    pay-respects

    #---------- Terminal -----------#
    zsh
    tree-sitter
    xclip # Clipboard

    #---------- Formatter ----------#
    stylua
    rustfmt     # for Rust
    prettierd   # for web development
    clang-tools # for C/C++
    pyright

    #---------- Dev ----------#
    gcc # C++
    nodejs

    #---------- Terminal ----------#
    alacritty

    #---------- Productivity ----------//
    ticktick
    obsidian
  ];

  programs = {
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
        font = {
          normal = {
            family = "FiraCode Nerd Font";
            style = "Regular";
          };
          size = 14;
        };
        # window.padding = { x = 10; y = 10; };
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
