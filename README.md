# nixos-star64

**NixOS images for the Pine64 STAR64 SBC**

## Building/downloading

You can build an image by running `nix build`.
If you are not building on a risc-v system, either enable emulation by adding
`riscv64-linux` to
[`boot.binfmt.emulatedSystems`](https://search.nixos.org/options?channel=unstable&show=boot.binfmt.emulatedSystems&query=boot.binfmt.emulatedSystems)
or cross-compile the image by running `nix build .#sd-image-cross` instead.
**Prebuilt native images are available for download at
[this page](https://git.sr.ht/~fgaz/nixos-star64/refs).**
Click on the latest version, then download the `.img.zst` file on the left.

## Flashing

The image is compressed with zstd, so you have to unpack it first.
For example, in a single command:

```sh
zstdcat nixos-sd-image.img.zst | dd bs=1M status=progress of=/dev/target_device
```

where `target_device` is the device you want to flash.

## First steps

On first boot the root partition will automatically extend to the entire drive, so expect to wait a bit.
DHCP, sshd, and serial console are enabled. The default user and password are both `nixos`.
The GPU does not work yet, so there will be no HDMI output.

The `nixos` root channel is set to the nixpkgs revision that was used to build
the image.
The image includes a bunch of build tools in the store, so if you use the
existing `nixos` channels for everything, you won't have to build too much stuff.

A default `configuration.nix` file matching the image is provided in `/etc/nixos`.
You can also use this flake's `nixosConfigurations.star64`

The image is configured for 4GB of RAM. If you have 8GB, either uncomment the
relevant section in `/etc/nixos/configuration.nix` and run nixos-rebuild,
or use one of the `-8gb` variants included in the flake.

## License

The code, like [nixos-hardware](https://github.com/NixOS/nixos-hardware) from which it's taken, is released under CC0-1.0.
Licenses of the composing packages apply to the prebuilt images.
