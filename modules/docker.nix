{ config, pkgs, ... }:
{
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    # optional if you use IPv6 / custom daemon flags:
    # daemon.settings = { "ipv6" = true; };
  };

  # Docker Compose (CLI plugin)
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  # Allow your user to run docker without sudo
  users.users.anvnh.extraGroups = [ "docker" ];
}
