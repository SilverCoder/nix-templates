{ pkgs, android-module, ... }:
with pkgs;
let
  androidPackages = [
    android-sdk
    gradle
    jdk17
  ];

  libraries = [
    librsvg
    openssl
    webkitgtk_4_1
  ];

  packages = [
    nodejs
    pkg-config
    rust-sdk
    (pkgs.runCommand "corepack-enable" { } ''
        mkdir -p $out/bin
      ${nodejs}/bin/corepack enable --install-directory $out/bin
    '')
  ] ++ androidPackages ++ libraries;

  environment = rec {
    NIX_LD_LIBRARY_PATH = lib.makeLibraryPath libraries;
    LD_LIBRARY_PATH = NIX_LD_LIBRARY_PATH;
  };
in
{
  shells = {
    default = (mkShell ({
      inherit packages;
    } // (lib.attrsets.mergeAttrsList [ android-module.environment environment ])));
  };
}
