{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
in
{
  imports =
    [
      # ../../modules/neovim
    ];

  nix = {
    package = pkgs.lix;
    nixPath = lib.mapAttrsToList (n: v: "${n}=flake:${v}") flakeInputs;
    registry = builtins.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
  };

  home.username = "v";
  home.homeDirectory = "/home/v";
  home.stateVersion = "23.11";
  home.packages = with pkgs; [
    cached-nix-shell
    nh
    nixd
    nixfmt-rfc-style
    pre-commit
    rlwrap
    shellcheck
    shfmt
    yadm
    yt-dlp
  ];

  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  home.shellAliases = {
    g = "git";
    "..." = "cd ../..";
    "...." = "cd ../../..";
  };

  programs = {
    home-manager.enable = true;
    bat = {
      enable = true;
      config.map-syntax = [ "*.pacscript:Bash" ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza = {
      enable = true;
      icons = "auto";
    };
    fd.enable = true;
    fish = {
      enable = true;
      plugins = [
        {
          name = "foreign-env";
          src = inputs.foreign-env.outPath;
        }
      ];
      shellInit = ''
	umask u=rwx,go=
      '';
    };
    gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
    git = {
      enable = true;
      delta = {
        enable = true;
        options.navigate = true;
      };
      extraConfig = {
        core = {
          untrackedCache = true;
          fsmonitor = true;
          compression = 9;
        };
        alias.clone-empty = "clone --filter=tree:0 --no-checkout --no-tags --depth=1 --sparse --shallow-submodules";
        checkout.workers = 0;
        feature.manyFiles = true;
        fetch.prune = true;
        http = {
          maxRequestBuffer = 1048576000;
          postBuffer = 1048576000;
        };
        init.defaultBranch = "main";
        maintenance.gc.schedule = "daily";
        merge.conflictStyle = "diff3";
        pack.writeReverseIndex = true;
        push.autoSetupRemote = true;
        rerere.enable = true;
	user = {
	  email = "150687949+vigress8@users.noreply.github.com";
          name = "vigress8";
          signingKey = "AADBA9ABA5EDBDE3";
	};
      };
      includes = [
        { path = "alias"; }
      ];
    };
    neovim.enable = true;
    nix-index.enable = true;
    nix-index-database.comma.enable = true;
    oh-my-posh = {
      enable = true;
      settings = lib.importJSON "${pkgs.oh-my-posh}/share/oh-my-posh/themes/catppuccin_latte.omp.json";
    };
    ripgrep.enable = true;
  };
}
