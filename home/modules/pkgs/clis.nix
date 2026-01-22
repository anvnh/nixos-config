{pkgs, inputs, ...}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    zsh-powerlevel10k
    tmux

    krabby                      # Pokemon
    # fastfetch                     # System info

    ninja
    pkgs-unstable.geminicommit    # Gemini commit
    tree
    usbutils
    ranger                        # CLI file manager
    cmus                          # Music player
    eza                           # ls replacement
    bat                           # cat replacement
    zoxide                        # cd replacement
    ripgrep                       # grep replacement
    fd                            # find replacement
    fzf                           # Fuzzy finder
    jq                            # JSON processor
    btop                          # Resource monitor
    dua                           # Disk usage analyzer (better du)
    duf                           # Disk usage/free utility (better df)
    tldr                          # Simplified man pages
    pay-respects                  # Command correction (fun)
    openssl
    lsof                          # System diagnostic tool
    # xclip                       # Clipboard for X11
    wl-clipboard                  # Clipboard for Wayland

    appimage-run
    scrcpy                        # Android mirroring
    qrencode                      # Generate QR code

    # Agent
    pkgs-unstable.gemini-cli
    pkgs-unstable.codex
    # pkgs-unstable.github-copilot-cli

    onedrive
    whitesur-kde
  ];
}
