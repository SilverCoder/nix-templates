{ pkgs }:
{
  packages = {
    rust-sdk = with pkgs; rust-bin.stable.latest.default.override {
      extensions = [ "rust-analyzer" "rust-src" "rustfmt" ];
      targets = [
        "x86_64-unknown-linux-gnu"
        "aarch64-linux-android"
        "armv7-linux-androideabi"
        "i686-linux-android"
        "x86_64-linux-android"
        "wasm32-unknown-unknown"
      ];
    };
  };
}
