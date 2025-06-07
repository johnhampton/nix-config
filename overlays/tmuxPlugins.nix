{ inputs }: (final: prev: {

  tmuxPlugins = prev.tmuxPlugins // {
    t-smart-tmux-session-manager = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "t-smart-tmux-session-manager";
      rtpFilePath = "t-smart-tmux-session-manager.tmux";
      src = inputs.t-smart-tmux-session-manager;
      version = inputs.t-smart-tmux-session-manager.shortRev;
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
  };
})
