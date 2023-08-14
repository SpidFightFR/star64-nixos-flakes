# nixos-star64

**NixOS images for the Pine64 STAR64 SBC**

You can build an image by running `nix build`.
Prebuilt images are available at [this page](https://git.sr.ht/~fgaz/nixos-star64/refs).
Click on the latest version, then download the `.img.zst` file on the left.

The image is compressed with zstd, so you have to unpack it first.
For example, in a single command:

```sh
zstdcat nixos-sd-image-23.11pre-git-riscv64-linux-pine64-star64.img.zst | dd bs=1M status=progress of=/dev/target_device
```

where `target_device` is the device you want to flash.

## License

The code, like [https://github.com/NixOS/nixos-hardware] from which it's taken, is released under CC0-1.0.
Licenses of the composing packages apply to the prebuilt images.
