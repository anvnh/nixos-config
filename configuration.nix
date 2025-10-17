{ config, pkgs, ... }:

{
      imports =
            [ # Include the results of the hardware scan.
                  ./hardware-configuration.nix
            ];

      # Bootloader.
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.grub.configurationLimit = 10; # Limit generation display in grub

      # Network
      networking.hostName = "nixos-nvhantyn"; # Define your hostname.
      # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

      # Default shell
      # users.defaultUserShell = pkgs.zsh;
      programs.zsh.enable = true;

      # Bluetooth
      hardware.bluetooth.enable = true;
      # services.blueman.enable = true;

      # TLP
      services.tlp = {
            enable = true;
            settings = {
                  START_CHARGE_THRESH_BAT0 = 60;
                  STOP_CHARGE_THRESH_BAT0 = 60;

                  # START_CHARGE_THRESH_BAT1 = 75;
                  # STOP_CHARGE_THRESH_BAT1 = 80;
            };
      };
      services.power-profiles-daemon.enable = false; # Disable default daemon

      # Configure network proxy if necessary
      # networking.proxy.default = "http://user:password@proxy:port/";
      # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

      # Enable networking
      networking.networkmanager.enable = true;

      # Set your time zone.
      time.timeZone = "Asia/Ho_Chi_Minh";

      # Select internationalisation properties.
      i18n.defaultLocale = "en_US.UTF-8";

      # Set input method
      i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5.addons = with pkgs; [
                  fcitx5-unikey
            ];
      };

      # Font
      fonts.packages = with pkgs; [
            nerd-fonts.fira-code
            nerd-fonts.jetbrains-mono
      ];

      i18n.extraLocaleSettings = {
            LC_ADDRESS = "en_US.UTF-8";
            LC_IDENTIFICATION = "en_US.UTF-8";
            LC_MEASUREMENT = "en_US.UTF-8";
            LC_MONETARY = "en_US.UTF-8";
            LC_NAME = "en_US.UTF-8";
            LC_NUMERIC = "en_US.UTF-8";
            LC_PAPER = "en_US.UTF-8";
            LC_TELEPHONE = "en_US.UTF-8";
            LC_TIME = "en_US.UTF-8";
      };

      # Enable the KDE Plasma Desktop Environment.
      services.displayManager.sddm.enable = true;
      services.desktopManager.plasma6.enable = true;

      programs.kdeconnect.enable = true;

      # Configure keymap
      services.xserver = {
            # Enable the X11 windowing system.
            enable = true;
            xkb = {
                  layout = "us";
                  options = "ctrl:nocaps";
            };
      };

      # Enable CUPS to print documents.
      services.printing.enable = true;

      # Enable sound with pipewire.
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
            enable = true;
            alsa.enable = true;
            alsa.support32Bit = true;
            pulse.enable = true;
            # If you want to use JACK applications, uncomment this
            #jack.enable = true;

            # use the example session manager (no others are packaged yet so this is enabled by default,
            # no need to redefine it in your config for now)
            #media-session.enable = true;
      };
      hardware.enableRedistributableFirmware = true;

      # Enable touchpad support (enabled default in most desktopManager).
      # services.xserver.libinput.enable = true;

      # Define a user account. Don't forget to set a password with ‘passwd’.
      users.users.vnhantyn = {
            isNormalUser = true;
            description = "vnhantyn";
            extraGroups = [ "networkmanager" "wheel" ];
            shell = pkgs.zsh;
            packages = with pkgs; [
                  kdePackages.kate
                  #  thunderbird
            ];
      };

      # Install firefox.
      programs.firefox.enable = true;

      # SDK
      programs.adb.enable = true;
      services.udev.packages = [ pkgs.android-udev-rules ];

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Enable flatpak
      services.flatpak.enable = true;

      # List packages installed in system profile. To search, run:
      # $ nix search wget
      environment.systemPackages = with pkgs; [
            vim
            wget
            # firefox
            git
            unzip
            htop
            wireplumber
            direnv
      ];
      programs.direnv.enable = true;
      programs.direnv.nix-direnv.enable = true;

      # Automatically clear garbages
      nix.gc = {
            automatic = true;
            dates = "weekly";
            options = "--delete-older-than 7d";
      };

      nix.settings.experimental-features = [ "nix-command" "flakes" ];

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
      networking.firewall.allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
      networking.firewall.allowedUDPPortRanges = [ { from = 1714; to = 1764; } ];
      # Or disable the firewall altogether.
      # networking.firewall.enable = false;

      # This value determines the NixOS release from which the default
      # settings for stateful data, like file locations and database versions
      # on your system were taken. It‘s perfectly fine and recommended to leave
      # this value at the release version of the first install of this system.
      # Before changing this value read the documentation for this option
      # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
      system.stateVersion = "25.05"; # Did you read the comment?
}
