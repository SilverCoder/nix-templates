{ system, pkgs, android }:
{
  packages = {
    android-sdk = android.sdk.${system} (sdkPkgs: with sdkPkgs; [
      build-tools-30-0-3
      cmdline-tools-latest
      emulator
      ndk-bundle
      platforms-android-33
      platform-tools
    ]
    ++ pkgs.lib.optionals (system == "aarch64-darwin") [
      system-images-android-34-google-apis-playstore-arm64-v8a
      system-images-android-34-google-apis-arm64-v8a
    ]
    ++ pkgs.lib.optionals (system == "x86_64-darwin" || system == "x86_64-linux") [
      system-images-android-34-google-apis-playstore-x86-64
      system-images-android-34-google-apis-x86-64
    ]);
  } // pkgs.lib.optionalAttrs (system == "x86_64-linux") {
    android-studio = pkgs.androidStudioPackages.stable;
  };

  environment = rec {
    ANDROID_HOME = "${pkgs.android-sdk}/share/android-sdk";
    ANDROID_SDK_ROOT = "${ANDROID_HOME}";
    NDK_HOME = "${ANDROID_HOME}/ndk-bundle";
    JAVA_HOME = pkgs.jdk17.home;
  };
}
