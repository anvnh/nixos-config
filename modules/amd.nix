{ config, pkgs, ... }:
{
  hardware.enableRedistributableFirmware = true;

  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # needed for Steam / some 32-bit games
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      libva
      libvdpau-va-gl
    ];
    extraPackages32 = with pkgs.pkgsi686Linux; [
      mesa
      vulkan-loader
    ];
  };
}
