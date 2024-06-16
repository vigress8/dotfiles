{
  description = "Home Manager configuration of v";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
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
        ];

        extraSpecialArgs = {
          inherit inputs system;
        };
      };
    };
}
