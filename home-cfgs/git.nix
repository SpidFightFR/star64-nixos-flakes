{ config, lib, pkgs, ... }:
{
    programs.gitMinimal = {
        enable = true;
        userName = "<username>";
        userEmail = "<email>";
    };
}
