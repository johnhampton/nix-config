{ inputs }: final: prev:
let
  inherit (inputs) lsp-zero-nvim;
in
{
  vimPlugins = prev.vimPlugins.extend (vimFinal: vimPrev: {
    lsp-zero-nvim = vimPrev.lsp-zero-nvim.overrideAttrs (_: {
      src = lsp-zero-nvim;
      version = "v3.x-${lsp-zero-nvim.lastModifiedDate}";
    });
  });
}
