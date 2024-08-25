{ config, lib, pkgs, ... }:
{
  security.doas.enable = true;
  security.sudo.enable = false;
  security.doas.extraRules = [{
    users = ["<user>"];
    # Optional, retains environment variables while running commands
    # e.g. retains your NIX_PATH when applying your config
    keepEnv = true;
    persist = true;  # Optional, only require password verification a single time
  }

  {
    users = ["<user>"];
    cmd = "poweroff";
    #cmd = ["poweroff" "reboot"];
    noPass = true;
  }
  ];

  environment.systemPackages = with pkgs; [
    #Hacky way to set a sudo - doas alias
    (pkgs.writeScriptBin "sudo" ''exec doas "$@"'')
  ];
}
