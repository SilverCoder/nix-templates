{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, flake-utils, rust-overlay, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [ (import rust-overlay) ];
          pkgs = import nixpkgs {
            inherit overlays system;

            config.allowUnfree = true;
          };

          rust = with pkgs; rust-bin.stable.latest.default.override {
            extensions = [ "rust-analyzer" "rust-src" "rustfmt" ];
            targets = [
              "x86_64-unknown-linux-gnu"
              "wasm32-unknown-unknown"
            ];
          };

          libraries = with pkgs; [
            alsa-lib
            alsa-plugins
            libxkbcommon
            udev
            vulkan-loader
            xorg.libX11
            xorg.libXcursor
            xorg.libXi
            xorg.libXrandr
          ];
        in
        {
          devShells.default = with pkgs; mkShell {
            packages = with pkgs; [
              pkg-config
              rust
              trunk
            ] ++ libraries;

            ALSA_PLUGIN_DIR = "${pkgs.alsa-plugins}/lib/alsa-lib";
            LD_LIBRARY_PATH = lib.makeLibraryPath libraries;
          };
        });
}
