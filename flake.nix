{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    systems.url = "github:nix-systems/default";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };
    # This branch of helix fixes issues with deno lsp breaking on files with brackets in its path
    # Issue: https://github.com/helix-editor/helix/issues/11888
    # PR: https://github.com/helix-editor/helix/pull/11889
    helix.url = "github:helix-editor/helix/string-lsp-url";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      helix,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            deno
            helix.packages.${system}.default
            svelte-language-server
          ];
          shellHook = "deno i --frozen";
        };
      }
    );
}
