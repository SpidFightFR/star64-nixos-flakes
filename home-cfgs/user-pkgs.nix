{ config, lib, pkgs, ... }:
{
    home.packages = with pkgs; [
    ncurses
    openssh
    fastfetch
    wget
    curl
    ffmpeg
    yt-dlp
    htop
    tree
    ];
}
