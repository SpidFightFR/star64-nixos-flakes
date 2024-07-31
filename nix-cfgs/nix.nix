{ config, lib, pkgs, ... }:

{
#Allows experimental flakes and nix features
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';
}
