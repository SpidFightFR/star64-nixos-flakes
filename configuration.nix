{ config
, pkgs
, modulesPath
, nixos-hardware ? builtins.fetchgit { url = "https://github.com/nixos/nixos-hardware"; }
, ...
}:

{
  imports = [
    "${nixos-hardware}/pine64/star64/sd-image.nix"
    # Set the nixos channel to the nixpkgs the image was built with,
    # to minimize rebuilds.
    "${modulesPath}/installer/cd-dvd/channel.nix"
  ];

  system.stateVersion = "23.05";

  nixpkgs.hostPlatform = "riscv64-linux";

  # Uncomment on the 8GB model
  #hardware.deviceTree.overlays = [{
  #  name = "8GB-patch";
  #  dtsFile = "${nixos-hardware}/pine64/star64/star64-8GB.dts";
  #}];

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
    gitMinimal
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
}
