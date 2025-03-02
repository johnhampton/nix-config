{ pkgs, lib, config, ... }:
let
  yamlFormat = pkgs.formats.yaml { };
in
{
  home.packages = with pkgs; [
    pandoc
  ];
  # This configuration enables Claude 3.7 Sonnet's "thinking tokens" feature
  # which allows the model to spend tokens on explicit thinking steps before
  # providing its final answer. The thinking is captured separately and can
  # be examined to understand the model's reasoning process.
  # The budget_tokens value (32000) controls how many tokens the model can use 
  # for thinking before providing its final response.
  home.file.".aider.model.settings.yml".source = yamlFormat.generate "aider-model-settings" [
    {
      name = "anthropic/claude-3-7-sonnet-20250219";
      edit_format = "diff";
      weak_model_name = "anthropic/claude-3-5-haiku-20241022";
      use_repo_map = true;
      examples_as_sys_msg = true;
      use_temperature = false;
      extra_params = {
        extra_headers = {
          anthropic-beta = "prompt-caching-2024-07-31,pdfs-2024-09-25,output-128k-2025-02-19";
        };
        max_tokens = 64000;
        thinking = {
          type = "enabled";
          budget_tokens = 32000;
        };
      };
      cache_control = true;
      editor_model_name = "anthropic/claude-3-7-sonnet-20250219";
      editor_edit_format = "editor-diff";
    }
  ];

  home.file.".aider.conf.yml".source = yamlFormat.generate "aider-conf" {
    model = "anthropic/claude-3-7-sonnet-20250219";
    vim = true;
  };
}
