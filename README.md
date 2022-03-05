# NixOS builds for Raspberry Pi

Here's a simple flake to build a basic NixOS image for the Raspberry Pi 2 and 4.


## Build Instructions

Either

`nix build github:PhilTaken/rpi-image-flake#images.rpi4` (or images.rpi2, whatever you want to build)

or

1. Clone the repo
1. Apply your changes
1. `nix build .#images.rpi4`

The output will be under `result/sd-image/nixos-sd-image-$(version).$(date).$(hash)-aarch64-linux.img.zst`.
To obtain the unpacked image file, just copy it somewhere and unpack with `unzstd`:

1. `cp result/sd-image/nixos-sd-image-21.05.20220115.0fd9ee1-aarch64-linux.img.zst .`
1. `unzstd nixos-sd-image-21.05.20220115.0fd9ee1-aarch64-linux.img.zst`

## Install/Flash instructions

As with any image for the Raspberry Pi, just burn the file onto a sd card with your tool of choice.
I use `dd` but theres plenty of tools out there.

`dd if=nixos-sd-image-21.05.20220115.0fd9ee1-aarch64-linux.img of=/dev/sdcard bs=4M status=progress`
