# Bumps the mermaid bundle vendored inside markdown-preview.nvim.
#
# The plugin ships a prebuilt mermaid at app/_static/mermaid.min.js (v10). We
# swap in a newer 11.x UMD build — it still assigns globalThis.mermaid, so the
# preview app's mermaid.initialize/init/parse calls keep working.
#
# Applied to nixvim's OWN pkgs (see flake.nix): nixvim imports its own nixpkgs
# and does not inherit the flake's overlays. This is kept separate from
# overlays/vimPlugins.nix so nixvim only gets THIS override — folding in the
# whole vimPlugins overlay would also pull the CopilotChat pin, which nixvim's
# copilot-chat module rejects.
{ inputs }: (final: prev: {
  vimPlugins = prev.vimPlugins.extend (vfinal: vprev: {
    "markdown-preview-nvim" = vprev.markdown-preview-nvim.overrideAttrs (old: {
      mermaidJs = final.fetchurl {
        url = "https://cdn.jsdelivr.net/npm/mermaid@11.16.0/dist/mermaid.min.js";
        hash = "sha256-dNfEbavKMowilHM5EKiqHtDDdFF3bo1Sldo4ordY+5s=";
      };
      postInstall = (old.postInstall or "") + ''
        install -m 0644 "$mermaidJs" "$out/app/_static/mermaid.min.js"
      '';
    });
  });
})
