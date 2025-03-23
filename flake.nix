{
  description = "NixOS configurations for Proxmox VMs for a homelab";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-generators, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      
      # Helper function to create system with the proxmox format
      mkSystem = { hostname, modules ? [] }: nixos-generators.nixosGenerate {
        inherit system;
        format = "proxmox";
        modules = modules ++ [
          ./modules/common.nix
          {
            networking.hostName = hostname;
            proxmox.qemuConf.name = hostname;
          }
        ];
      };
    in {
      nixosConfigurations = {
        base = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ 
            ./machines/base.nix 
            ./modules/common.nix
            nixos-generators.nixosModules.proxmox
            {
              networking.hostName = "base-vm";
              proxmox.qemuConf.name = "base-vm";
            }
          ];
        };

        smarthome = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [             
            ./machines/base.nix 
            ./machines/smarthome.nix
            ./modules/common.nix
            ./modules/docker/default.nix
            ./modules/docker/smarthome.nix
            nixos-generators.nixosModules.proxmox
            {
              networking.hostName = "smarthome";
              proxmox.qemuConf.name = "smarthome";
            }
          ];
        };
      };

      packages.${system} = {
        base-proxmox = mkSystem {
          hostname = "base-vm";
          modules = [ ./machines/base.nix ];
        };
        
        smarthome-proxmox = mkSystem {
          hostname = "smarthome";
          modules = [ 
            ./machines/base.nix 
            ./machines/smarthome.nix
          ];
        };
      };
    };
}
