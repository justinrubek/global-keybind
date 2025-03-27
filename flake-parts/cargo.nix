{inputs, ...}: {
  perSystem = {
    config,
    pkgs,
    system,
    inputs',
    self',
    ...
  }: let
    # packages required for building the rust packages
    extraPackages = [
      pkgs.pkg-config
      pkgs.xdotool
    ];
    withExtraPackages = base: base ++ extraPackages;

    craneLib = (inputs.crane.mkLib pkgs).overrideToolchain self'.packages.rust-toolchain;

    common-build-args = rec {
      src = inputs.nix-filter.lib {
        root = ../.;
        include = [
          "crates"
          "Cargo.toml"
          "Cargo.lock"
        ];
      };

      pname = "global-keybind";

      nativeBuildInputs = withExtraPackages [];
      LD_LIBRARY_PATH = pkgs.lib.makeLibraryPath nativeBuildInputs;
    };

    deps-only = craneLib.buildDepsOnly ({} // common-build-args);

    packages = {
      default = packages.global-keybind-cli;
      global-keybind-cli = craneLib.buildPackage ({
          pname = "global-keybind-cli";
          cargoArtifacts = deps-only;
          cargoExtraArgs = "--bin global-keybind-cli";
          meta.mainProgram = "global-keybind-cli";
        }
        // common-build-args);

      cargo-doc = craneLib.cargoDoc ({
          cargoArtifacts = deps-only;
        }
        // common-build-args);
    };

    checks = {
      clippy = craneLib.cargoClippy ({
          cargoArtifacts = deps-only;
          cargoClippyExtraArgs = "--all-features -- --deny warnings";
        }
        // common-build-args);

      rust-fmt = craneLib.cargoFmt ({
          inherit (common-build-args) src;
        }
        // common-build-args);

      rust-tests = craneLib.cargoNextest ({
          cargoArtifacts = deps-only;
          partitions = 1;
          partitionType = "count";
        }
        // common-build-args);
    };
  in rec {
    inherit packages checks;

    apps = {
      global-keybind-cli = {
        type = "app";
        program = pkgs.lib.getBin self'.packages.global-keybind-cli;
      };
      default = apps.global-keybind-cli;
    };

    legacyPackages = {
      cargoExtraPackages = extraPackages;
    };
  };
}
