# Remote builder configuration

## This configuration allows for a NixOS machine (prefer a dedicated VM, if possible) to build packages for your Star64.

### Installation steps:

1. Append the changes from the local [configuration.nix](./configuration.nix) to the remote builder true config.
2. Add the [remote builder configuration](./nix-cfgs/builder.nix) to your remote builder true config.
3. Rebuild the NixOS configuration of your Remote Builder machine
