{pkgs, inputs, ...}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
  {
  home.packages = with pkgs; [
    solaar                          # Logitech management
    vlc
    libreoffice
    obsidian
    ticktick
    onedrive
    signal-desktop
    ente-auth
    anki
    joplin-desktop
    telegram-desktop
    drawio

    # Scientific Research
    zotero
  ];
}
