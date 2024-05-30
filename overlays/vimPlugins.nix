{ inputs }: (final: prev: {
  vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
    "telescope-hoogle-nvim" = final.vimUtils.buildVimPlugin {
      pname = "telescope-hoogle.nvim";
      version = inputs.telescope-hoogle-nvim.lastModifiedDate;
      src = inputs.telescope-hoogle-nvim;
    };

    "focus-nvim" = final.vimUtils.buildVimPlugin {
      pname = "focus-nvim";
      version = inputs.focus-nvim.lastModifiedDate;
      src = inputs.focus-nvim;
      patches = [ ./focus-nvim.patch ];
    };

    "ChatGPT-nvim" = vprev.ChatGPT-nvim.overrideAttrs (old: {
      patches = old.patches or [ ] ++ [ ./ChatGPT-nvim.patch ];
    });

		"haskell-tools-nvim" = vprev.haskell-tools-nvim.overrideAttrs(old: {
			patches = old.patches or [ ] ++ [ ./haskell-tools.patch ];
		});
  });
})

