{
  description = "Octofriend development and runtime environment for NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
        nodejs = pkgs.nodejs_22;
      in {
        packages.default = pkgs.buildNpmPackage {
          pname = "octofriend";
          version = "0.0.53";
          src = ./.;

          inherit nodejs;
          npmDepsHash = "sha256-j4rAACBQbfDT7qLW4Po9MdRSV1yRwOd7WXTXgWeP4Mg=";

          nativeBuildInputs = with pkgs; [
            nodejs
            python3
            pkg-config
          ];

          buildInputs = with pkgs; [
            sqlite
          ];

          npmBuildScript = "build";
          doCheck = false;

          meta = with pkgs.lib; {
            description = "Small, helpful, zero-telemetry coding assistant";
            homepage = "https://github.com/synthetic-lab/octofriend";
            license = licenses.mit;
            mainProgram = "octofriend";
            platforms = platforms.linux ++ platforms.darwin;
          };
        };

        apps.default = flake-utils.lib.mkApp {
          drv = self.packages.${system}.default;
        };

        defaultPackage = self.packages.${system}.default;
        defaultApp = self.apps.${system}.default;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            nodejs
            python3
            pkg-config
            gcc
            gnumake
            sqlite
          ];

          shellHook = ''
            export npm_config_build_from_source=true
            echo "Octofriend Nix shell ready."
            echo "Run: npm ci && npm run build"
          '';
        };
      });
}
