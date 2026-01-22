{pkgs, ...}:
{
  # List packages installed in system profile. To search, run: nix search wget
  environment.systemPackages = with pkgs; [
    git
    gh
    kdePackages.kdeconnect-kde
    quota
    # Encrypted
    sops
    age
  ];
}
