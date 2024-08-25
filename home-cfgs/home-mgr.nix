{ config, pkgs, inputs, ... }:
{
	imports = [
		inputs.home-manager.nixosModules.home-manager
	];

### HOME MANAGER PART
    # Configure home-manager
    home-manager = {
        backupFileExtension = "hm-bak";
        useGlobalPkgs = true;

        users.<user> =
            { config, lib, pkgs, inputs, ... }:
            {
            # Read the changelog before changing this value
            home.stateVersion = "24.05";
            home.username = "<user>";
            home.homeDirectory = "/home/<user>";

            # insert home-manager config
            imports = [
                ./bash.nix
                ./user-pkgs.nix
                ./nvim.nix
                ./git.nix
            ];
        };
    };
}
