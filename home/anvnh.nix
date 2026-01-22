{ config, pkgs, inputs, lib, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [
    ./modules/pkgs/clis.nix
    ./modules/pkgs/editors-ides.nix
    ./modules/pkgs/browsers.nix
    ./modules/pkgs/lsp.nix
    ./modules/pkgs/dev.nix
    ./modules/pkgs/gui.nix
    ./modules/pkgs/terminal.nix
  ];

  # home.packages = with pkgs; [
  # ];

  home.username = "anvnh";
  home.homeDirectory = "/home/anvnh";
  home.stateVersion = "25.11";

  home.activation.kwinInputMethod = lib.hm.dag.entryAfter ["writeBoundary"] ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 \
      --file kwinrc \
      --group Wayland \
      --key InputMethod \
      org.fcitx.Fcitx5.desktop
  '';

  home.activation.writeWakapiCfg = lib.hm.dag.entryAfter ["writeBoundary"] ''
umask 077
cat > "$HOME/.wakatime.cfg" <<EOF
[settings]
api_url = $(cat /run/secrets/wakapi_api_url)
api_key = $(cat /run/secrets/wakapi_api_key)
EOF
  '';

  home.file.".config/.gitcommit".source = ../config/gitcommit; # gitcommit config

  home.activation.kwinButtonsMacos = ''
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnLeft XIA
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kwinrc --group org.kde.kdecoration2 --key ButtonsOnRight ""
  '';

  programs.home-manager.enable = true; # home-manager switch

  # Enable CLI programs
  programs = {
    kitty = {
      enable = true;
      settings = {
        font_size = 15;
        window_padding_width = 0;
        window_padding_height = 0;
        # background_opacity = "1.0";
        confirm_os_window_close = 0;
      };
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    gh = {
      enable = true;
    };

    git = {
      enable = true;
      settings = {
        user = {
          name = "anvnh";
          email = "73346280+anvnh@users.noreply.github.com";
        };
        push.autoSetupRemote = "true";
        commit.template = "~/.config/.gitcommit";
      };
    };

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

    tmux = {
      enable = true;
      keyMode = "vi";
      clock24 = true;
      prefix = "C-a";
      terminal = "tmux-256color";

      plugins = with pkgs.tmuxPlugins; [
        sensible
        vim-tmux-navigator
        yank
        # catppuccin
        # resurrect
        # continuum
      ];
      extraConfig = ''
set -g mouse on
set -g @continuum-restore 'on'
set-option -g status-position top

set -as terminal-features 'xterm-256color:RGB'
set -as terminal-features 'alacritty:RGB'
set -as terminal-features 'tmux-256color:RGB'

unbind C-b
set -g prefix C-a
bind C-a send-prefix

set -gq allow-passthrough on
set -g visual-activity off

set-option -sa terminal-overrides ",xterm*:Tc"

bind -n C-M-h previous-window
bind -n C-M-l next-window

bind-key -T copy-mode-vi v send-keys -X begin-selection
bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

bind '"' split-window -v -c "#{pane_current_path}"
bind % split-window -h -c "#{pane_current_path}"

# === THEME === #
set-option -g status-style fg=white,bg=colour234

# active window
set-window-option -g window-status-current-style fg=colour231,bg=default

# inactive windows
set-window-option -g window-status-style fg=colour244,bg=default
      '';
    };

    zsh = {
      enable = true;

      enableCompletion = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;

      initContent = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        [[ -r ~/.p10k.zsh ]] && source ~/.p10k.zsh
        bindkey -v
        bindkey "^?" backward-delete-char
        bindkey "^H" backward-delete-char
        bindkey -M viins "^W" backward-kill-word
        bindkey -M viins "^?" backward-delete-char
        bindkey -M viins "^H" backward-delete-char
        bindkey -r "^E"
        bindkey "^E" autosuggest-accept
        bindkey '^P' up-line-or-history
        bindkey '^N' down-line-or-history
        bindkey '^A' beginning-of-line

        # fastfetch
        krabby random --no-title -s --padding-left 10
        if [[ -z "$TMUX" ]]; then
           tmux attach || tmux new-session
        fi
      '';

      shellAliases = {
        nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos && exec zsh";
        ncg = "sudo nix-collect-garbage -d";
        sn = "shutdown now";
        rb = "reboot";
        ls = "eza --color=always --long --git --no-filesize --icons=always";
        cd = "z";
        ".." = "cd ..";
        "..." = "cd ../..";
        "?" = "pay-respects";

        glg = "log --oneline --graph --all --decorate";
        gst = "git status";
        gco = "git checkout -b";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gpl = "git pull";

        bat60  = "sudo systemctl start battery-limit@60.service";
        bat80  = "sudo systemctl start battery-limit@80.service";
        bat100 = "sudo systemctl start battery-limit@100.service";
      };
    };
    spicetify = {
      enable = true;
      enabledExtensions = with spicePkgs.extensions; [
        adblockify
        hidePodcasts
        shuffle
      ];
      theme = spicePkgs.themes.catppuccin;
      colorScheme = "mocha";
    };
  };
}
