{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/amd.nix
      ./modules/boot.nix
      ./modules/audio.nix
      ./modules/desktop-enviroment.nix
      ./modules/locale.nix
      ./modules/input-method.nix
      ./modules/fonts.nix
      ./modules/networking.nix
      ./modules/nixpkgs.nix
      ./modules/packages.nix
      ./modules/programs.nix
      ./modules/users.nix
      ./modules/misc.nix
      ./modules/battery.nix
      ./modules/docker.nix
    ];

  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11";
}
