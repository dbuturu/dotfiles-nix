{
    description = "NixOS configuration";

    # All inputs for the system
    inputs = {
        nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
        hyprland.url = "github:hyprwm/Hyprland";

        home-manager = {
            url = "github:nix-community/home-manager";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        hyprland-plugins = {
            url = "github:hyprwm/hyprland-plugins";
            inputs.hyprland.follows = "hyprland";
        };

        nur = {
            url = "github:nix-community/NUR";
            inputs.nixpkgs.follows = "nixpkgs";
        };

        xremaps-flake.url = "github:xremap/nix-flake";
        
    };

    # All outputs for the system (configs)
    outputs = { home-manager, nixpkgs, nur, ... }@inputs: 
        let
            system = "x86_64-linux"; #current system
            pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
            lib = nixpkgs.lib;

            # This lets us reuse the code to "create" a system
            # Credits go to sioodmy on this one!
            # https://github.com/sioodmy/dotfiles/blob/main/flake.nix
            mkSystem = pkgs: system: hostname:
                pkgs.lib.nixosSystem {
                    system = system;
                    modules = [
                        { networking.hostName = hostname; }
                        ./hosts/yourComputer/hardware-configuration.nix
                        # General configuration (users, networking, sound, etc)
                        ./modules/system/configuration.nix
                        # Hardware config (bootloader, kernel modules, filesystems, etc)
                        # DO NOT USE MY HARDWARE CONFIG!! USE YOUR OWN!!
                        # (./. + "/hosts/${hostname}/hardware-configuration.nix")
                        home-manager.nixosModules.home-manager
                        {
                            home-manager = {
                                useUserPackages = true;
                                useGlobalPkgs = true;
                                extraSpecialArgs = { inherit inputs; };
                                # Home manager config (configures programs like firefox, zsh, eww, etc)
                                users.dbuturu = (./. + "/hosts/${hostname}/user.nix");
                                backupFileExtension = "backup";
                            };
                            nixpkgs.overlays = [
                                # Add nur overlay for Firefox addons
                                # nur.overlay
                                (import ./overlays)
                            ];
                        }
                    ];
                    specialArgs = { inherit inputs; };
                };

        in {
            nixosConfigurations = {
                # Now, defining a new system is can be done in one line
                #                                      Architecture   Hostname
                # laptop = mkSystem inputs.nixpkgs     "x86_64-linux" "laptop";
                # desktop = mkSystem inputs.nixpkgs    "x86_64-linux" "desktop";
                # laptop-hp = mkSystem inputs.nixpkgs  "x86_64-linux" "laptop-hp";
                # nouvelle = mkSystem inputs.nixpkgs   "x86_64-linux" "nouvelle";
                yourComputer = mkSystem inputs.nixpkgs "x86_64-linux" "yourComputer";
            };
    };
}
