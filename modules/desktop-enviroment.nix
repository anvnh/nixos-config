{ config, pkgs, lib, ... }:
let # Script to tune KWin Wayland settings for low latency and uncapped FPS
  kwinTune = pkgs.writeShellScript "kwin-wayland-tune" ''
    set -eu
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kwinrc --group Compositing --key LatencyPolicy Low
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kwinrc --group Compositing --key MaxFPS 0
    ${pkgs.kdePackages.kconfig}/bin/kwriteconfig6 --file kwinrc --group Compositing --key RefreshRate 0
    ${pkgs.qt6.qttools}/bin/qdbus6 org.kde.KWin /KWin reconfigure >/dev/null 2>&1 || true
    '';
in
  {
  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        options = "ctrl:nocaps";
      };
    };
  };

  console.useXkbConfig = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
    configPackages = [ pkgs.kdePackages.plasma-desktop ];
    config = {
      common = {
        default = "kde";
        "org.freedesktop.impl.portal.Lockdown" = [ "none" ];
        "org.freedesktop.impl.portal.Secret" = [ "kde" ];
      };
    };
  };


  # Disable GTK xdg-desktop-portal service to avoid conflicts with KDE portal
  # systemd.user.services.xdg-desktop-portal-gtk = {
  #   enable = false;
  #   wantedBy = lib.mkForce [];
  # };

  # Remove Mesa VRAM limiting + overlays (Vulkan layers) ---
  # Disable specific Vulkan layers even if something tries to enable them.
  # environment.sessionVariables = {
  #   # Keep presentation stable on Wayland (reduces jitter for some Mesa/KWin combos)
  #   MESA_VK_WSI_PRESENT_MODE = "mailbox";
  #
  #   # Hard-disable common Mesa/Intel layers that can interfere / add overhead
  #   VK_LOADER_LAYERS_DISABLE =
  #     "VK_LAYER_MESA_vram_report_limit:"
  #     + "VK_LAYER_MESA_overlay:"
  #     + "VK_LAYER_MESA_screenshot:"
  #     + "VK_LAYER_INTEL_nullhw";
  # };

  # Force KWin to use stable Wayland compositing settings ---
  # Apply on each user login (Wayland session). Writes to kwinrc then asks KWin to reload.
  systemd.user.services.kwin-wayland-tune = {
    description = "KWin Wayland tuning";
    wantedBy = [ "graphical-session.target" ];
    after = [ "plasma-kwin_wayland.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = kwinTune;
    };
  };
}
