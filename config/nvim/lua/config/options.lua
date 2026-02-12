vim.opt.spell = false
vim.opt.concealcursor = "nc" -- 浏览时保持渲染，不显示原始 Markdown 符号
vim.opt.mouse = "a" -- 开启所有模式下的鼠标支持
vim.opt.mousemoveevent = true -- 允许鼠标移动事件 (某些终端需要)
vim.opt.clipboard = "unnamedplus" -- 让 Vim 和系统剪贴板互通
vim.opt.autoread = true -- 开启 autoread 选项
-- 2. 只要回到窗口或切换文件，就强制触发磁盘检查
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold" }, {
  pattern = "*",
  command = "checktime",
})