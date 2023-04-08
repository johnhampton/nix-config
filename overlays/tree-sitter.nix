{ inputs }:
let
  src = inputs.treesitter-just;
  version = "0.0.0+rev=${inputs.treesitter-just.shortRev}";
in
(final: prev: {
  tree-sitter-grammars = prev.tree-sitter-grammars // {
    tree-sitter-just = final.tree-sitter.buildGrammar {
      inherit src version;
      language = "just";
    };
  };

  vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
    "tree-sitter-just" = final.vimUtils.buildVimPluginFrom2Nix {
      inherit src version;
      pname = "tree-sitter-just";
    };
  });
})
