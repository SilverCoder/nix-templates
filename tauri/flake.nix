{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    android.url = "github:tadfisher/android-nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, android, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            (import rust-overlay)
            (final: prev: {
              inherit (self.packages.${final.system}) android-sdk rust-sdk;
            })
          ];

          pkgs = import nixpkgs {
            inherit overlays system;

            config.allowUnfree = true;
            android_sdk.accept_license = true;
          };

          android-module = import ./nix/android.nix { inherit system pkgs android; };
          rust-module = import ./nix/rust.nix { inherit pkgs; };
        in
        {
          packages = (android-module.packages // rust-module.packages);

          devShells =
            let
              dev = import ./nix/dev.nix { inherit pkgs android-module rust-module; };
            in
            {
              default = dev.shells.default;
            };
        });
}
