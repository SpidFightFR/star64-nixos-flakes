{ config, lib, pkgs, ... }:
{
    home.packages = with pkgs; [
    fastfetch
    wget
    curl
    htop
    tree
    ];
}
