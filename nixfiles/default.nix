let
  self = {
    pins = import ./npins;
    pkgs = import self.pins.nixpkgs { };
    inherit (self.pkgs) lib;
    editors.neovim = import ./editors/neovim self;
    shells = {
      hm = self.pkgs.mkShellNoCC {
        packages = [ (import self.pins.home-manager { inherit (self) pkgs; }).home-manager ];
        NIX_PATH = builtins.concatStringsSep ":" (self.lib.mapAttrsToList (k: v: "${k}=${v}") self.pins);
      };
      haskell = import ./shells/haskell self;
      ocaml = import ./shells/ocaml self;
    };
    v = {
      imports = [ ./users/v ];
      _module.args = {
        inherit self;
      };
    };
  };
in
self
