return {
  "yetone/avante.nvim",
  event = "VeryLazy",
  lazy = false,
  opts = {
    -- 1. 指定默认 Provider
    provider = "openai",
    -- auto_suggestions_provider = "copilot",
    
    -- 2. 所有模型配置必须放在 'providers' 表中 (不再是 vendors)
    providers = {
      -- DeepSeek 配置 (覆盖内置的 openai)
      openai = {
        endpoint = "https://api.deepseek.com/v1",
        model = "deepseek-chat",
        timeout = 30000,
        -- 参数必须放在 extra_request_body 中，否则报错
        extra_request_body = {
          temperature = 0,
          max_tokens = 4096,
        },
      },
      
      -- Gemini 配置 (作为自定义 provider)
      gemini = {
        __inherited_from = "openai",
        endpoint = "https://generativelanguage.googleapis.com/v1beta/openai",
        model = "gemini-1.5-pro",
        timeout = 30000,
        api_key_name = "GEMINI_API_KEY",
        extra_request_body = {
          temperature = 0,
          max_tokens = 8192,
        },
      },
    },
    
    behaviour = {
      auto_suggestions = false,
    },
  },
  dependencies = {
    "stevearc/dressing.nvim",
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "hrsh7th/nvim-cmp",
    "nvim-tree/nvim-web-devicons",
    {
      "zbirenbaum/copilot.lua",
      opts = { 
        suggestion = { 
          enabled = true, 
          auto_trigger = true, 
          keymap = { accept = "<M-l>" } 
        } 
      },
    },
    { "MeanderingProgrammer/render-markdown.nvim", opts = { file_types = { "markdown", "Avante" } } },
  },
}
