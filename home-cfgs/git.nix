{ config, lib, pkgs, ... }:
{
    programs.git = {
        enable = true;
        userName = "<username>";
        userEmail = "<email>";
    };
}
