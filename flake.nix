{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
  };

  outputs = { nixpkgs, ... }: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
    };
    lib = nixpkgs.lib;
  in rec {
    devShell.${system} = pkgs.mkShell {
      buildInputs = with pkgs; [
        rsync
        zstd
      ];
    };

    nixosConfigurations.rpi2 = lib.nixosSystem {
      system = "armv7l-linux";

      modules = [
        {
          imports = [
            # https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-armv7l-multiplatform-installer.nix"
          ];

          services.openssh = {
            enable = true;
            permitRootLogin = "yes";
          };
          users.extraUsers.root.initialPassword = lib.mkForce "test123";
        }
      ];
    };

    nixosConfigurations.rpi4 = lib.nixosSystem {
      system = "aarch64-linux";

      modules = [
        {
          imports = [
            # https://nixos.wiki/wiki/NixOS_on_ARM#Build_your_own_image
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
          ];

          services.openssh = {
            enable = true;
            permitRootLogin = "yes";
          };
          users.extraUsers.root.initialPassword = lib.mkForce "test123";

          # https://github.com/NixOS/nixpkgs/issues/135828
          hardware.deviceTree.overlays = [
            {
              # https://github.com/NixOS/nixpkgs/issues/135828#issuecomment-918359063
              name = "issuecomment-918359063";
              dtsText = ''
              // SPDX-License-Identifier: GPL-2.0
              /dts-v1/;
              /plugin/;
              / {
                compatible = "brcm,bcm2711";
                fragment@1 {
                  target = <&emmc2bus>;
                  __overlay__ {
                    dma-ranges = <0x00 0x00 0x00 0x00 0xfc000000>;
                  };
                };
              };
              '';
            }
          ];
        }
      ];
    };


    images = {
      rpi2 = nixosConfigurations.rpi2.config.system.build.sdImage;
      rpi4 = nixosConfigurations.rpi4.config.system.build.sdImage;
    };
  };
}
