{ config, lib, pkgs, ... }:
{
	#I don't use nano, i don't need it.
	#Remove this line if you want nano
	programs.nano.enable = false;

	#System packages
	environment.systemPackages = with pkgs; [
	#Remember that you do need git at a systemWide level to use flakes with sudo
	#Otherwise you're softlock
	git
	wget
	curl
	home-manager
    ];
}
