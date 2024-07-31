{ config, lib, pkgs, ... }:
{
    home.packages = with pkgs; [
    fastfetch
    wget
    curl
    ffmpeg
    yt-dlp
    htop
    tree
    ];
}
