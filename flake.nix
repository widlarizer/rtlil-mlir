{
  description = "Generic devshell setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "https://flakehub.com/f/edolstra/flake-compat/1.tar.gz";
  };
  outputs = { self, nixpkgs, flake-compat, flake-utils }@inputs:
    let
      overlay = import ./nix/overlay.nix;
    in
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          pkgs = import nixpkgs { overlays = [ overlay ]; inherit system; };
        in
        {
          # Help other use packages in this flake
          legacyPackages = pkgs;

          devShell = pkgs.mkShell { buildInputs = [
            pkgs.clang-yosys
            pkgs.circt
            pkgs.circt.llvm
          ]; };

          formatter = pkgs.nixpkgs-fmt;
        }) //
    {
      # Other system-independent attr
      inherit inputs;
      flake-compat = inputs.flake-compat;
      overlays.default = overlay;
    };
}