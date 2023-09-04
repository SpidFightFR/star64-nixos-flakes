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
          system = null; # Modular system/platform
          configuration =
            { config, pkgs, modulesPath, ... }: {
              imports = [
                "${nixos-hardware}/pine64/star64/sd-image.nix"
                # Set the nixos channel to the nixpkgs the image was built with,
                # to minimize rebuilds.
                "${modulesPath}/installer/cd-dvd/channel.nix"
              ];

              system.stateVersion = "23.05";

              nixpkgs.hostPlatform = "riscv64-linux";

              networking.useDHCP = true;
              networking.wireless.enable = true;
              networking.wireless.userControlled.enable = true;
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

              # Provide a bunch of build dependencies to minimize rebuilds.
              # Alternatively, sdImage.storePaths will not tie the packages to the system, allowing GC.
              system.extraDependencies = with pkgs; builtins.concatMap (x: x.all) [
                autoconf
                automake
                bash
                binutils
                bison
                busybox
                cargo
                clang
                cmake
                config.boot.kernelPackages.kernel
                curl
                dtc
                elfutils
                flex
                gcc
                glibc
                glibcLocales
                jq
                llvm
                meson
                ninja
                pkg-config
                python3
                rustc
                stdenv
                stdenv.cc
                stdenvNoCC
                unzip
                util-linux
                zip
                zlib
              ];
            };
        }).config.system.build.sdImage;
      });
    };
}
