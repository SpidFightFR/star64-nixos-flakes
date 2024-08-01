{ config, lib, pkgs, ... }:
{
    programs.git = {
        packages = pkgs.gitMinimal;
        enable = true;
        userName = "<username>";
        userEmail = "<email>";
    };
}
