let
  self = {
    pins = import ./npins;
    pkgs = import self.pins.nixpkgs {
      config = { };
      overlays = [
        (_: prev: {
          neovim' = prev.wrapNeovim prev.neovim-unwrapped self.editors.neovim;
        })
      ];
    };
    inherit (self.pkgs) lib;
    editors.neovim = import ./editors/neovim self;
    shells = {
      hm = self.pkgs.mkShellNoCC {
        name = "home-manager-shell";
        packages = [ (import self.pins.home-manager { inherit (self) pkgs; }).home-manager ];
        NIX_PATH = builtins.concatStringsSep ":" (self.lib.mapAttrsToList (k: v: "${k}=${v}") self.pins);
      };
      haskell = import ./shells/haskell self;
      ocaml = import ./shells/ocaml self;
    };
    v = import ./users/v self;
  };
in
self
