{ config, lib, pkgs, ... }:

{
	#enables the nix command and flakes feature
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	# Backup etc files instead of failing to activate generation if a file already exists in /etc
	environment.etcBackupExtension = ".bak";
}
