{ config, pkgs, modulesPath, inputs, ... }:

# If used without a flake we can't declare nixos-hardware in the inputs
# or the configuration will fail to evaulate.
let
  #I changed the source of nixos-hardware because of a uboot problem
  #(https://github.com/NixOS/nixos-hardware/issues/1051#issuecomment-2308226974)
  #nixos-hardware = inputs.nixos-hardware;
  nixos-hardware = inputs.nixos-hardware-patched;
in

{
  imports = [
    "${nixos-hardware}/pine64/star64/sd-image.nix"
    # Set the nixos channel to the nixpkgs the image was built with,
    # to minimize rebuilds.
    "${modulesPath}/installer/cd-dvd/channel.nix"
    #The line below adds home-manager with full support to a specific user once created.
    #Please check the integrity of configs before changing that
    #./home-cfgs/home-mgr.nix
    ./nix-cfgs/sys-pkgs.nix
    #./nix-cfgs/builder.nix
    #./nix-cfgs/doas.nix
    ./nix-cfgs/builder.nix
  ];

  system.stateVersion = "24.05";

  nixpkgs.hostPlatform = "riscv64-linux";

  time.timeZone = "Europe/Paris";

  # Uncomment on the 8GB model
#   hardware.deviceTree.overlays = [{
#     name = "8GB-patch";
#     dtsFile = "${nixos-hardware}/pine64/star64/star64-8GB.dts";
#   }];

  networking.useDHCP = true;
  #I disabled wireless capabilities because i don't need them, enabled them if needed
  networking.wireless.enable = false;
  networking.wireless.userControlled.enable = false;
  services.openssh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

    #Uncomment and change <user> to your username to create your user. (please check ./home-cfgs ./nix-cfgs as well)
#   users.users.<user> = {
# 	isNormalUser = true;
# 	extraGroups = [ "wheel" ];
#   };

  #Security risk, remove these lines after creating your user on a production system
  security.sudo.wheelNeedsPassword = false;
  users.users.nixos.initialPassword = "nixos";


  # Provide a bunch of build dependencies to minimize rebuilds.
  # Alternatively, sdImage.storePaths will not tie the packages to the system, allowing GC.
  # system.includeBuildDependencies is another alternative, but results in a WAY bigger image.
  system.extraDependencies = with pkgs;
    # Include only in native builds.
    # Use normalized platforms from stdenv.
    lib.optionals (stdenv.buildPlatform == stdenv.hostPlatform)
    (builtins.concatMap (x: x.all) [
      #I use toybox instead of busybox, as it provides a tinier set of tools than busybox
      toybox

      autoconf
      automake
      binutils
      bison
      cargo
      clang
      cmake
      config.boot.kernelPackages.kernel
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
      openssl
      pkg-config
      python3
      rustc
      stdenv
      # Bootstrap stages. Yes, this is the right way to do it.
      stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv
      stdenv.cc
      stdenv.__bootPackages.stdenv.cc
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.cc
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.cc
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.cc
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.cc
      stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.__bootPackages.stdenv.cc
      stdenvNoCC
      unzip
      util-linux
      zip
      zlib
    ]);
}
