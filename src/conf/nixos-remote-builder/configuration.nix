{ config, pkgs, modulesPath, ...}:

{
	#Append the content of this config to your nixos builder machine
	#Accordingly to what you want in.
	#I organize sub-configs in the nix-cfgs dir.
	imports = [
		./nix-cfgs/builder.nix
	];

	users.users.<remotebuilder-user> = {
		isNormalUser = true;
	};

	nix.settings.trusted-users = [ "<remotebuilder-user>" ];
}

