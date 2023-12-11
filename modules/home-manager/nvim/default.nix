{ lib, config, pkgs, inputs, system, ... }:
with lib;
let 
  cfg = config.modules.nvim;
  /*catppuccin-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "catppuccin-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "catppuccin";
      repo = "nvim";
      rev = "73587f9c454da81679202f1668c30fea6cdafd5e";
      sha256 = "sha256-UrHoESRYwALPo6LFFocEIM0CZa740tjxjvmYES7O5Rw=";
    };
  };*/
in {
  imports = [
    inputs.nixvim.homeManagerModules.${system}.nixvim
  ];
  options.modules.nvim = { 
    enable = mkOption {
      default = false;
      description = "Enable the nvim text editor";
      type = types.bool;
    };
    makeDefaultEditor = mkOption {
      default = false;
      description = "Set nvim to be the default text editor";
      type = types.bool;
    };
  };
  
  config = mkIf cfg.enable {

    programs.nixvim = {
      enable = true;
      defaultEditor = true;
    };
    
    # home.packages = [
    #   inputs.nixvim.legacyPackages.${system}.make { 
    #     config = {
    #       gopls.enable = true;
    #     };
    #   }
    # ];


/*
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      package = 

      plugins = with pkgs.vimPlugins; [
        vim-nix
        # Dependency for a number of other packages
        plenary-nvim
        {
          plugin = catppuccin-nvim;
        }
        {
          plugin = vim-fugitive;
        }
        {
          plugin = vim-rhubarb;
        }
        {
          plugin = vim-sleuth;
        }
        {
          plugin = nvim-lspconfig;
        }
        {
          plugin = fidget-nvim;
        }
        {
          plugin = neodev-nvim;
        }
        {
          plugin = nvim-cmp;
        }
        {
          plugin = which-key-nvim;
        }
        {
          plugin = gitsigns-nvim;
        }
        {
          plugin = lualine-nvim;
        }
        {
          plugin = indent-blankline-nvim;
        }
        {
          plugin = comment-nvim;
        }
        {
          plugin = telescope-nvim;
        }
        {
          plugin = telescope-fzf-native-nvim;
        }
        {
          plugin = nvim-treesitter.withPlugins (p: [ p.javascript p.c p.json p.go p.c-sharp p.typescript p.rust p.bash p.html p.css p.jsdoc p.lua p.svelte ] );
        }
        {
          plugin = nvim-treesitter-textobjects;
        }
        {
          plugin = cmp-nvim-lsp;
        }
        {
          plugin = luasnip;
        }
        {
          plugin = harpoon;
        }
        {
          plugin = nvim-dap;
        }
        {
          plugin = nvim-dap-ui;
        }
      ];
    };

    # Language servers
    home.packages = with pkgs; [
      # Lua
      sumneko-lua-language-server
      # Rust
#      rust-analyzer rustup
      # Typescript
      nodePackages.typescript-language-server
      # Nix
      nil
      # Svelte
      nodePackages.svelte-language-server # vimPlugins.nvim-treesitter-parsers.svelte
      # For .NET
      omnisharp-roslyn
    ];

    home.file."nvim" = {
      # Makes this a symlink that lives outside the nix store. This way I can make updates to it without requiring a nix switch to see the changes
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/modules/home-manager/nvim/config";
      target = ".config/nvim";
      recursive = true;
    };
*/
    home.sessionVariables = mkIf cfg.makeDefaultEditor {
      EDITOR = "nvim";
    };
  };
}
