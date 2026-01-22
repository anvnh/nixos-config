{...}:
{
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Encryption
  sops.defaultSopsFile = ../secrets/wakapi.yaml;
  sops.age.keyFile = "/etc/nixos/config/sops/age/keys.txt";
  sops.secrets.wakapi_api_url = { key = "api_url"; owner = "anvnh"; mode = "0400"; };
  sops.secrets.wakapi_api_key = { key = "api_key"; owner = "anvnh"; mode = "0400"; };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable Flatpak support.
  services.flatpak.enable = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
