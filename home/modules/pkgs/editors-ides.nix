{pkgs, inputs, ...}:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in
{
  home.packages = with pkgs; [
    neovide
    vscode
    antigravity
    # jetbrains.clion
    # pkgs-unstable.jetbrains.webstorm
  ];
}
