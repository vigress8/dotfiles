{
  description = "Home Manager configuration of v";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vc-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      formatter = pkgs.nixfmt-rfc-style;
    in
    {
      formatter.${system} = formatter;
      homeConfigurations."v" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./home.nix
          { home.packages = [ formatter ]; }
          {
            nix.registry = {
              nixpkgs.flake = nixpkgs;
              home-manager.flake = home-manager;
            };
            home.sessionVariables.NIX_PATH = "home-manager=flake:home-manager:nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
          }
        ];

        extraSpecialArgs = {
          inherit inputs system;
        };
      };
    };
}
