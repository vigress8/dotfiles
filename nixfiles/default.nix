let
  self = {
    pins = import ./npins;
    pkgs = import self.pins.nixpkgs {
      config = { };
      overlays = [ (_: prev: { neovim' = prev.wrapNeovim prev.neovim-unwrapped self.editors.neovim; }) ];
    };
    inherit (self.pkgs) lib;
    editors.neovim = import ./editors/neovim self;
    shells = {
      haskell = import ./shells/haskell self;
      ocaml = import ./shells/ocaml self;
    };
    v = import ./users/v self;
  };
in
self
