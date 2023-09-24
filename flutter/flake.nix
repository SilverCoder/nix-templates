{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    android.url = "github:tadfisher/android-nixpkgs";
  };

  outputs = { self, nixpkgs, flake-utils, android, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            (final: prev: {
              inherit (self.packages.${final.system}) android-sdk;
            })
          ];
          pkgs = import nixpkgs {
            inherit overlays system;

            config = {
              allowUnfree = true;
              android_sdk.accept_license = true;
            };
          };
        in
        {
          packages = {
            android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
              build-tools-33-0-1
              cmdline-tools-latest
              patcher-v4
              platforms-android-33
              platform-tools

            ]);
          };

          devShells.default = with pkgs; mkShell rec {
            androidDeps = [
              android-sdk
              gradle
              jdk17
            ];

            flutterDeps = [
              flutter
            ];

            packages = androidDeps ++ flutterDeps;

            ANDROID_HOME = "${android-sdk}/share/android-sdk";
            ANDROID_SDK_ROOT = "${ANDROID_HOME}";
            JAVA_HOME = jdk17.home;
            GRADLE_OPTS = "-Dorg.gradle.project.android.aapt2FromMavenOverride=${android-sdk}/share/android-sdk/build-tools/33.0.2/aapt2";
            CHROME_EXECUTABLE = "${google-chrome}/bin/google-chrome-stable";

            NIX_LD_LIBRARY_PATH = lib.makeLibraryPath ([
              stdenv.cc.cc.lib
            ]);
            NIX_LD = "${pkgs.stdenv.cc.libc_bin}/bin/ld.so";
            LD_LIBRARY_PATH = NIX_LD_LIBRARY_PATH;
          };
        });
}
