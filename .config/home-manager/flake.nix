{
  description = "Home Manager configuration of v";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    homeConfigurations."v" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home.nix
        nixvim.homeManagerModules.nixvim
        {
          nix.registry = {
            nixpkgs.flake = nixpkgs;
            home-manager.flake = home-manager;
          };
          home.sessionVariables.NIX_PATH = "home-manager=flake:home-manager:nixpkgs=flake:nixpkgs$\{NIX_PATH:+:$NIX_PATH}";
        }
      ];

      extraSpecialArgs = {inherit inputs;};
    };
  };
}
