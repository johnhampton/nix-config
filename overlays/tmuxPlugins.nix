{ inputs }: (final: prev: {

  tmuxPlugins = prev.tmuxPlugins // {
    sessionist = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "sessionist";
      rtpFilePath = "sessionist.tmux";
      version = "unstable-2023-05-02";
      src = final.fetchFromGitHub {
        owner = "tmux-plugins";
        repo = "tmux-sessionist";
        rev = "a315c423328d9bdf5cf796435ce7075fa5e1bffb";
        sha256 = "sha256-iC8NvuLujTXw4yZBaenHJ+2uM+HA9aW5b2rQTA8e69s=";
      };
      patches = [ ./sessionist-pr35.patch ];
    };
    resurrect = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "resurrect";
      rtpFilePath = "resurrect.tmux";
      src = inputs.tmux-resurrect;
      version = inputs.tmux-resurrect.shortRev;
      postInstall = ''
        rm -rf $out/share/tmux-plugins/resurrect/tests
        rm -f $out/share/tmux-plugins/resurrect/run_tests
      '';
    };
    continuum = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "continuum";
      rtpFilePath = "continuum.tmux";
      src = inputs.tmux-continuum;
      version = inputs.tmux-continuum.shortRev;
    };
    prefix-highlight = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "prefix-highlight";
      rtpFilePath = "prefix_highlight.tmux";
      src = inputs.tmux-prefix-highlight;
      version = inputs.tmux-prefix-highlight.shortRev;
    };
    extrakto = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "extrakto";
      rtpFilePath = "extrakto.tmux";
      src = inputs.tmux-extrakto;
      version = inputs.tmux-extrakto.shortRev;
    };
  };
})
