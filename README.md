# nixos-star64

**NixOS images for the Pine64 STAR64 SBC**

## Acknowledgements
### This repo is based on
- [fgaz' work](https://git.sr.ht/~fgaz/nixos-star64)
- [Old](https://nixos.wiki/wiki/Main_Page) and [New](https://wiki.nixos.org/wiki/NixOS_Wiki) NixOS wikis. (Careful, the later has instructions for unstable mostly).
- Many thanks to [@CORAAL](https://github.com/CORAAL) , without whom this project wouldn't have been possible.
- The [Gaming Linux FR](https://discord.gg/CYVj2Uzg) community, especially the side dedicated to the "immutable distros" branch.


## Goals of this repo
Understand how nixos works in general, with flakes, and make it work on the Star64 from Pine64.

> Please be advised: <br>
> I'm still new to NixOS, and i'm actively learning about both nix, flakes, and NixOS. <br>
> Mistakes, corrections on the go, and other things like that are to be expected. <br>
> This repo itself is an attempt at understanding fgaz' work with limited knowledge on the subject and pure reverse-engineering. <br>
> Thank you for your understanding.


# Things to consider first
1. You first need to know if you have the 8Gb variant or the 4Gb one. As the process varies depending on that.
1. Every package included in your config (alongside subpackages) will be compiled from source, since we lack binary caches.
1. You will need to enable the experimental features for both the `nix` command and the `flake` features. I made the required changes in the SBC install, thanks to the [env.nix](./nix-cfgs/env.nix) for your convenience. But on a native nix install, you'll still need need to enable them manually on the builder machine.

# This repo's content
## Included NixOS modules:
- `star64` - This module takes the file `./configuration.nix` within the flake (considering your work directory is the flake directory itself).
- `8gb-patch` - This module adds [the patch 8Gb](https://github.com/NixOS/nixos-hardware/blob/master/pine64/star64/star64-8GB.dts) for the 8Gb variant of the SBC, the said patch unlocks the 4 gigabytes left of your ram for usage - it isn't the case by default.
- `copyConfiguration` - This modules creates the folder `/etc/nixos/` and puts `./configuration.nix` inside.

## Included configurations
### For maintaining the system:
- `.#star64` - This config applies the `star64` module and `copyConfiguration`, in order to maintain an existing installation of nixos (`nixos-rebuild --flake .#star64`).
- `.#star64-8gb` - This config does the same but applies the `8gb-patch`. This config is thus used to maintain an existing 8Gb install (`nixos-rebuild --flake .#star64-8gb`)
>N.B: Do note that the 4Gb config is compatible with 8Gb models, but you will be limited with 4Gb of ram while usage.

### Creating SD images:
#### On native `riscv64-linux` hardware (unlikely)
<b>You probably do not have any powerful enough hardware to compile a whole system from scratch, and the absolute max 20W of power this SBC can draw would take you weeks at best to achieve that.</b>
- `.#sd-image` - This config, also the default one, `.#` - allows you to create the base system (config `.#star64`), then converts the result system into a `.img` file, meant to be burned into a SD card (with `dd` for example), this is based on the methods of NixOS (ref: [github:nixos/nixpkgs/nixos/modules/system/build.sdImage](https://github.com/NixOS/nixpkgs/blob/20eb4bcca8cd31297f2ed23d3cc5eb5543e871e9/nixos/modules/installer/sd-card/sd-image.nix#L173).
- `.#sd-image-8gb` - This config does the same, executing `.#star64-8gb` then converting it into a `.img` file.

>Now, as said above, you WON'T use that, except if you have a beefy, native `riscv64-linux` machine with nix installed. As a consequence, we rely on the 2 next configs that enable crossbuilding.

#### On any other hardware (non-native - crossbuilding)
> Check the list of `supportedSystems` in [flake.nix](./flake.nix) before heading in. Just to make sure your system is compatible.
- `.#sd-image-cross` - This config does the same thing as `.#sd-image`, however, it enables crossbuilding capabilities for all `supportedSystems`.
- `.#sd-image-cross-8gb` - This config does the same as `.#sd-image-8gb`, however this one enables crossbuilding, such as `.#sd-image-cross`.


# Alright that's cool, What should I do ?
## "I don't know what I'm doing I need help."

### First, identify your needs.

#### 1) I need to initialize my system, making a working system on an SD Card for my star64.

Alright, well except if you live in the year 2077 and Arasaka gave you the first riscv64 SOC with 48 logical cores, you won't get anywhere. <br>
**Forget about `nix build .#sd-image` and `nix build .#sd-image-8gb`.**

You need to use a beefy machine, to compile in a reasonable time. I used to do that with a 12 logical cores (you can check by running `nproc`), withing 10 minutes more or less.<br>
The said machine will surely have a cpu architecture like x86_64 or aarch64 or something. <br>
Two options then:

- You have a Star64 SBC with 4Gb of Ram: run `nix build .#sd-image-cross` - it will create a `.img` file in your flake folder, burn it on a SD card using something like `dd`. after that, install the card in your SBC and boot.
OR
- You have a Star64 SBC with 8Gb of Ram: run `nix build .#sd-image-cross-8gb` and same thing here: `.img` image, burn it on an sd card and boom, working nixos.

#### 2) I need to maintain an existing install, from my SBC install itself
- Star64 4Gb: run `nixos-rebuild switch/test --flake .#star64` within the flake folder, on your SBC install.
OU
- Star64 8Gb: run `nixos-rebuild switch/test --flake .#star64-8gb`, still within the flake folder on your SBC install.

> Note: If by mistake you burned the 4Gb version on the SD Card, you don't need to destroy the install. <br>
> Just run `nixos-rebuild switch/test --flake .#star64-8gb` from the flake to apply the 8gb-patch while keeping what you already did.

#### 3) Update ?
- Just run `nix flake update`, add the `flake.lock` file to your git repo and re-run the correct command in case 2.

## License

The code, like [nixos-hardware](https://github.com/NixOS/nixos-hardware) from which it's taken, is released under CC0-1.0.
Licenses of the composing packages apply to the prebuilt images.
