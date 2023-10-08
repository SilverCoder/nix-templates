{
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlays = [
            (self: super: {
              nodejs = super.nodejs-18_x;
            })
          ];
          pkgs = import nixpkgs {
            inherit overlays system;

            config.allowUnfree = true;
          };
        in
        {
          devShells.default = with pkgs; mkShell {
            packages = with pkgs; [
              nodejs
              (pkgs.runCommand "corepack-enable" { } ''
                mkdir -p $out/bin
                ${nodejs}/bin/corepack enable --install-directory $out/bin
              '')
            ];
          };
        });
}
