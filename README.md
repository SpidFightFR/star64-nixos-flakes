# Acknowledgements
## This repo is based on
- [fgaz' work](https://git.sr.ht/~fgaz/nixos-star64)
- [zhaofengli's binary cache](https://github.com/zhaofengli/nixos-riscv64)

# nixos-star64

**NixOS images for the Pine64 STAR64 SBC**

## goal of this repo
Deal with the lack of raw power to compile software from sources. Repo modified as a mean for me to try and enable distributed builds.

## "Ayo i'm new to nixos, how do i use that on my star64 :("
We're on the same boat, according to my tests, you need to do this:

1. Clone the repo (duh)
```
git clone https://github.com/SpidFightFR/star64-nixos-flakes.git
```

2. Identify your board model (either Star64-4Gb or Star64-8Gb)
> If you still wander, it's written on a sticker glued to your board, either '4G' or '8G'

3. navigate into the repo and identify the configuration
```
cd ./star64-nixos-flakes && nix flake show . --extra-experimental-features nix-command --extra-experimental-features flakes
```

4. [OPTIONAL] - Load up / edit `./configuration.nix` to your liking
> Do what you need :)

5. Ready Set Go !
```
sudo nixos-rebuild test --flake .#star64
```
> replace `.#star64` with `.#star64-8gb` to switch the config and so use the 8Gb patch provided by fgaz.

## License

The code, like [nixos-hardware](https://github.com/NixOS/nixos-hardware) from which it's taken, is released under CC0-1.0.
Licenses of the composing packages apply to the prebuilt images.
