{ config
, pkgs
, modulesPath
, ...
}@attrs:

# If used without a flake we can't declare nixos-hardware in the inputs
# or the configuration will fail to evaulate.
let nixos-hardware = attrs.nixos-hardware or
      (builtins.fetchGit { url = "https://github.com/nixos/nixos-hardware"; });
in

{
  imports = [
    "${nixos-hardware}/pine64/star64/sd-image.nix"
    # Set the nixos channel to the nixpkgs the image was built with,
    # to minimize rebuilds.
    "${modulesPath}/installer/cd-dvd/channel.nix"
    #./nix-cfgs/builder.nix
  ];

  system.stateVersion = "24.05";

  nixpkgs.hostPlatform = "riscv64-linux";

  time.timeZone = "Europe/Paris";

  # Uncomment on the 8GB model
  hardware.deviceTree.overlays = [{
    name = "8GB-patch";
    dtsFile = "${nixos-hardware}/pine64/star64/star64-8GB.dts";
  }];

  networking.useDHCP = true;
  networking.wireless.enable = true;
  networking.wireless.userControlled.enable = true;
  services.openssh.enable = true;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

#   users.users.<user> = {
#     isNormalUser = true;
#     extraGroups = [ "wheel" ];
#   };
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
      home-manager

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



### HOME MANAGER PART
    # Configure home-manager
    home-manager = {
        backupFileExtension = "hm-bak";
        useGlobalPkgs = true;

        config =
            { config, lib, pkgs, ... }:
            {
            # Read the changelog before changing this value
            home.stateVersion = "24.05";

            # insert home-manager config
            imports = [
                ./home-cfgs/bash.nix
                ./home-cfgs/home-mgr.nix
                ./home-cfgs/user-pkgs.nix
                ./home-cfgs/nvim.nix
                ./home-cfgs/git.com
            ];
        };
    };
}
