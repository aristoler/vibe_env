-- Keymaps for Vibercoder
local map = vim.keymap.set

-- 1. 快速保存
map({ "n", "x", "i", "s" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save File" })

-- 2. 窗口微调 (Option + hjkl)
-- 显式使用 <M- 开头，这是 Meta (Alt/Option) 的标准写法
map("n", "<M-h>", "<cmd>vertical resize -2<cr>", { desc = "Decrease Window Width" })
map("n", "<M-l>", "<cmd>vertical resize +2<cr>", { desc = "Increase Window Width" })
map("n", "<M-k>", "<cmd>resize +2<cr>", { desc = "Increase Window Height" })
map("n", "<M-j>", "<cmd>resize -2<cr>", { desc = "Decrease Window Height" })

-- 3. AI Provider 切换菜单
map("n", "<leader>ap", function()
  local providers = { "openai", "gemini" }
  vim.ui.select(providers, {
    prompt = "🤖 Select AI Brain:",
    format_item = function(item)
      local icons = { openai = "🧠 DeepSeek", gemini = "✨ Gemini Pro" }
      return icons[item] or item
    end,
  }, function(choice)
    if choice then
      vim.cmd("AvanteSwitchProvider " .. choice)
      vim.notify("AI Engine switched to: " .. choice, vim.log.levels.INFO)
    end
  end)
end, { desc = "Switch AI Provider" })
