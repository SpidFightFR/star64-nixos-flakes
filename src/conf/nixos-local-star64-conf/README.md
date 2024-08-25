# Configuration file for the SBC

## This config Enables remote-building from the star64 to your nixos vm.

### Installation steps:

1. Follow the steps in [The remote builder part](../nixos-remote-builder).
2. Then put the nix file into [the nix-cfgs folder](../../../nix-cfgs)
3. Uncomment the import in [the config file](../../../configuration.nix)
4. Rebuild nixos.
5. generate a ssh-key for your root user and transfer the public key on the `<remotebuilder-user>` of your remote builder install

### Quirks

- From now on, your nixos install on the star64 will require your remote builder to be powered on.
- If you want to update your nixos install without your remote builder, just run your nix command with `--builders ''`
