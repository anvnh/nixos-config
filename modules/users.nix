{pkgs, ...}:
{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.anvnh = {
    isNormalUser = true;
    description = "anvnh";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      # kdePackages.kate
    ];
    shell = pkgs.zsh;
  };
}
