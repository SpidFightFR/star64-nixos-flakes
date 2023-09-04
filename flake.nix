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

      nixosConfigurations.star64 = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nixos-hardware; };
        modules = [ nixosModules.star64 ];
      };
      nixosConfigurations.star64-8gb = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit nixos-hardware; };
        modules = [ nixosModules.star64 nixosModules."8gb-patch" ];
      };

      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = nixosConfigurations.star64.config.system.build.sdImage;
        sd-image-8gb = nixosConfigurations.star64-8gb.config.system.build.sdImage;
        sd-image-cross = (nixpkgs.lib.nixosSystem {
          specialArgs = { inherit nixos-hardware; };
          modules = [
            nixosModules.star64
            { nixpkgs.buildPlatform = system; }
          ];
        }).config.system.build.sdImage;
        sd-image-cross-8gb = (nixpkgs.lib.nixosSystem {
          specialArgs = { inherit nixos-hardware; };
          modules = [
            nixosModules.star64
            { nixpkgs.buildPlatform = system; }
            nixosModules."8gb-patch"
          ];
        }).config.system.build.sdImage;
      });
    };
}
