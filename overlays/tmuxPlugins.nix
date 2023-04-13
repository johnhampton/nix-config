{ inputs }: (final: prev: {

  tmuxPlugins = prev.tmuxPlugins // {
    t-smart-tmux-session-manager = final.tmuxPlugins.mkTmuxPlugin {
      pluginName = "t-smart-tmux-session-manager";
      rtpFilePath = "t-smart-tmux-session-manager.tmux";
      src = inputs.t-smart-tmux-session-manager;
      version = inputs.t-smart-tmux-session-manager.shortRev;
    };
  };
})
