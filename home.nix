{ config, pkgs, ... }:

{
  home.stateVersion = "25.05";
  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "FiraCode Nerd Font";
          style = "Regular";
        };
        size = 12;
      };
      # window.padding = { x = 10; y = 10; };
      colors = {
        # Theme Dracula
        primary = {
          background = "0x282a36";
          foreground = "0xf8f8f2";
        };
        normal = {
          black = "0x000000"; red = "0xff5555"; green = "0x50fa7b";
          yellow = "0xf1fa8c"; blue = "0xbd93f9"; magenta = "0xff79c6";
          cyan = "0x8be9fd"; white = "0xbfbfbf";
        };
        bright = {
          black = "0x4d4d4d"; red = "0xff6e67"; green = "0x5af78e";
          yellow = "0xf4f99d"; blue = "0xcaa9fa"; magenta = "0xff92d0";
          cyan = "0x9aedfe"; white = "0xe6e6e6";
        };
      };
    };
  };
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = false;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
  };
}
