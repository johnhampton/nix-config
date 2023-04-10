{ pkgs, ... }: {
  programs.neovim.plugins = [
    { plugin = pkgs.vimPlugins.vim-kitty-navigator; optional = true; }
    { plugin = pkgs.vimPlugins.vim-tmux-navigator; optional = true; }
  ];

  programs.neovim.extraLuaConfig = ''
    local function isempty(s)
      return s == nil or s == '''
    end

    if isempty(vim.env.KITTY_WINDOW_ID) or not isempty(vim.env.TMUX) then
      vim.cmd "packadd vim-tmux-navigator"
    else 
      vim.cmd "packadd vim-kitty-navigator"
    end
  '';

}
