# nixos-star64

**NixOS images for the Pine64 STAR64 SBC**

## Building/downloading

You can build an image by running `nix build`.
Prebuilt images are available at [this page](https://git.sr.ht/~fgaz/nixos-star64/refs).
Click on the latest version, then download the `.img.zst` file on the left.

## Flashing

The image is compressed with zstd, so you have to unpack it first.
For example, in a single command:

```sh
zstdcat nixos-sd-image-23.11pre-git-riscv64-linux-pine64-star64.img.zst | dd bs=1M status=progress of=/dev/target_device
```

where `target_device` is the device you want to flash.

## First steps

On first boot the root partition will automatically extend to the entire drive, so expect to wait a bit.
DHCP, sshd, and serial console are enabled. The default user and password are both `nixos`.
The GPU does not work yet, so there will be no HDMI output.

The image is configured for 4GB of RAM. If you have 8GB, follow the instructions
[here](https://github.com/NixOS/nixos-hardware/tree/master/pine64/star64#8gb-memory).

## License

The code, like [https://github.com/NixOS/nixos-hardware] from which it's taken, is released under CC0-1.0.
Licenses of the composing packages apply to the prebuilt images.
