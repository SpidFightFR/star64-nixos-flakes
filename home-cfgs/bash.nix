{ config, pkgs, ... }:
{
    programs.bash = {
        enable = true;
        enableCompletion = true;
        bashrcExtra = builtins.readFile ./bashrc;
    };
}
