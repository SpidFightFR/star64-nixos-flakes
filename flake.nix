{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  inputs.nixos-hardware.url = "github:nixos/nixos-hardware";


  outputs = { self, nixpkgs, nixos-hardware, ... }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "riscv64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSupportedSystems = nixpkgs.lib.genAttrs supportedSystems;
    in rec {
      nixosModules.star64 = ./configuration.nix;
      nixosModules."8gb-patch" = {
        hardware.deviceTree.overlays = [{
          name = "8GB-patch";
          dtsFile = "${nixos-hardware}/pine64/star64/star64-8GB.dts";
        }];
      };
      # Copies ./configuration.nix to /etc/nixos
      nixosModules.copyConfiguration = {
        sdImage.populateRootCommands = ''
          mkdir -p ./files/etc/nixos
          cp ${./configuration.nix} ./files/etc/nixos/configuration.nix
        '';
      };

      nixosConfigurations.star64 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nixos-hardware; };
        modules = [ nixosModules.star64 nixosModules.copyConfiguration ];
      };
      nixosConfigurations.star64-8gb = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nixos-hardware; };
        modules = [ nixosModules.star64 nixosModules.copyConfiguration nixosModules."8gb-patch" ];
      };

      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = nixosConfigurations.star64.config.system.build.sdImage;
        sd-image-8gb = nixosConfigurations.star64-8gb.config.system.build.sdImage;
        sd-image-cross = (nixpkgs.lib.nixosSystem {
          specialArgs = { inherit nixos-hardware; };
          modules = [
            nixosModules.star64
            nixosModules.copyConfiguration
            { nixpkgs.buildPlatform = system; }
          ];
        }).config.system.build.sdImage;
        sd-image-cross-8gb = (nixpkgs.lib.nixosSystem {
          specialArgs = { inherit nixos-hardware; };
          modules = [
            nixosModules.star64
            nixosModules.copyConfiguration
            { nixpkgs.buildPlatform = system; }
            nixosModules."8gb-patch"
          ];
        }).config.system.build.sdImage;
      });
    };
}
