return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
      code = {
        sign = false,
        width = "block",
        right_pad = 1,
      },
      heading = {
        sign = true,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " }, -- 使用漂亮的 Nerd Font 图标代替 #
      },
      checkbox = {
        enabled = true,
      },
    },
    ft = { "markdown", "norg", "rmd", "org" }, -- 对这些文件类型生效
    config = function(_, opts)
      require("render-markdown").setup(opts)
      -- 设置快捷键来切换渲染开关 (Leader + um)
      vim.keymap.set("n", "<Leader>um", require("render-markdown").toggle, { desc = "Toggle Markdown Render" })
    end,
  },
}
