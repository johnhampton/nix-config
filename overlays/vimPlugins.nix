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

    # We temporarily need this. Remove at a later date.
    "nvim-tree-lua" = vprev.nvim-tree-lua.overrideAttrs (finalAttrs: prevAttrs: {
      src = final.fetchFromGitHub {
        owner = "nvim-tree";
        repo = "nvim-tree.lua";
        rev = "a38f9a55a4b55b0aa18af7abfde2c17a30959bdf";
        sha256 = "sha256-YC+/+u1UD4eOf0SXTRTmAQe3M9hjAVbTUv0gqkrXGSc=";
      };
    });
  });
})

