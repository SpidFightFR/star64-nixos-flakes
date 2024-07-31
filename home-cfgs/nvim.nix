{ config, pkgs, lib, ... }:
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    extraConfig = builtins.readFile ./neovim.conf;
  };
}
