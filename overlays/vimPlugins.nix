{ inputs }: (final: prev: {
  vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
    "telescope-hoogle-nvim" = final.vimUtils.buildVimPluginFrom2Nix {
      pname = "telescope-hoogle.nvim";
      version = inputs.telescope-hoogle-nvim.lastModifiedDate;
      src = inputs.telescope-hoogle-nvim;
    };

    "focus-nvim" = final.vimUtils.buildVimPluginFrom2Nix {
      pname = "focus-nvim";
      version = inputs.focus-nvim.lastModifiedDate;
      src = inputs.focus-nvim;
    };
  });
})

