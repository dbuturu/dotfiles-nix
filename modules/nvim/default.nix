
{ pkgs, lib, config, nvim, ... }:

with lib;
let cfg = config.modules.nvim;

in {
  options.modules.nvim = { enable = mkEnableOption "neovim configuration"; };

  config = mkIf cfg.enable {
    # Enable the nixvim home-manager module
    programs.nixvim = {
      enable = true;

      # Import the base configuration from khanelivim
      imports = [ khanelivim.nixvimModules.khanelivim ];

      # Your custom overrides and extensions
      # Disable specific plugins
      plugins.yazi.enable = false;

      # Override plugin settings
      plugins.lualine.settings.options.theme = "gruvbox";

      # Add custom Lua configuration
      extraConfigLua = ''vim.opt.relativenumber = false'';
    };
  };
}
    };
}
