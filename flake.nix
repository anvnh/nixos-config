{
      description = "Command Center";

      inputs = {
            # nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
            nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
            nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
            spicetify-nix.url = "github:Gerg-L/spicetify-nix";

            home-manager = {
                  # url = "github:nix-community/home-manager";
                  url = "github:nix-community/home-manager/release-25.11";
                  inputs.nixpkgs.follows = "nixpkgs";
            };
      };

      outputs = { self, nixpkgs, home-manager, ... }@inputs: {
            nixosConfigurations.vnhantyn = nixpkgs.lib.nixosSystem {
                  system = "x86_64-linux";
                  specialArgs = { inherit inputs; }; # Makes inputs available to other files
                  modules = [
                        ./configuration.nix

                        home-manager.nixosModules.home-manager
                        {
                              home-manager.useGlobalPkgs = true;
                              home-manager.useUserPackages = true;
                              home-manager.backupFileExtension = "backup";
                              home-manager.extraSpecialArgs = { inherit inputs; };
                              home-manager.users.vnhantyn = import ./home.nix;
                        }
                  ];
            };
      };
}
