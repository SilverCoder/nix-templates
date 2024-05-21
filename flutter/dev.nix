{ pkgs, android-module, ... }:
with pkgs;
let
  packages = [
    android-sdk
    gradle
    jdk17
    rust-sdk

  ] ++ androidPackages ++ libraries;

  environment = {
    CHROME_EXECUTABLE = "${google-chrome}/bin/google-chrome-stable";

    PATH = "$HOME/.pub-cache/bin:$PATH";
  };

in
{
  shells = {
    default = (mkShell ({
      inherit packages;
    } // (lib.attrsets.mergeAttrsList [ android-module.environment environment ])));
  };
}
