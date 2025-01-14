{ ... }:
{
  programs.nixvim = {
    autoGroups.terraform = {
      clear = true;
    };

    autoCmd = [{
      event = "FileType";
      group = "terraform";
      pattern = [ "terraform" "hcl" ];
      callback = {
        __raw = ''
          function(ev)
            vim.bo[ev.buf].commentstring = "# %s"
          end
        '';
      };
    }];
  };

}
