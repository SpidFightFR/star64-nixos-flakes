{ config, lib, pkgs, ... }:

{
  #Equivalent of /etc/environment
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # Backup etc files instead of failing to activate generation if a file already exists in /etc
  environment.etcBackupExtension = ".bak";

  #adds aliases to bins
  environment.packages = with pkgs; [
  (pkgs.writeScriptBin "ff" ''exec fastfetch --logo android "$@"'')
  ];
}
