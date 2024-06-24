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

    # TODO: Remove this once version 2024-05-31 is released
    "CopilotChat-nvim" = vprev.CopilotChat-nvim.overrideAttrs (old: {
      src = final.fetchFromGitHub {
        owner = "CopilotC-Nvim";
        repo = "CopilotChat.nvim";
        sha256 = "sha256-bdGql7WBn4yk44rd+6fK3CwBZNOZOlatnKjJLoyHBDY=";
        rev = "82923efe22b604cf9c0cad0bb2a74aa9247755ab";
      };
      version = "2024-05-31";
    });
  });
})

