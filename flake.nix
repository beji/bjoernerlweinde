{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, flake-utils, nixpkgs }:
    flake-utils.lib.eachDefaultSystem (system: {

      devShell =
        let
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        import ./shell.nix { inherit pkgs; };

    });


}
