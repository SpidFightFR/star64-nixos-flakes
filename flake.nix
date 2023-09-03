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
    in {
      packages = forAllSupportedSystems (system: rec {
        default = sd-image;
        sd-image = (import "${nixpkgs}/nixos" {
          configuration =
            { config, pkgs, ... }: {
              imports = [
                "${nixos-hardware}/pine64/star64/sd-image.nix"
              ];

              system.stateVersion = "23.05";
              networking.useDHCP = true;
              services.openssh.enable = true;

              users.users.nixos = {
                isNormalUser = true;
                extraGroups = [ "wheel" ];
              };
              security.sudo.wheelNeedsPassword = false;
              users.users.nixos.initialPassword = "nixos";

              environment.systemPackages = with pkgs; [
                git
                htop
                tmux
              ];
            };
          inherit system;
        }).config.system.build.sdImage;
      });
    };
}
