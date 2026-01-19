return {
  "nvim-neo-tree/neo-tree.nvim",
  keys = {
    { "<leader>fe", false },
    { "<leader>fE", false },
    { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (Root Dir)", remap = true },
    { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
  },
  opts = {
    source_selector = { winbar = false, statusline = false },
    filesystem = {
      bind_to_cwd = false,
      follow_current_file = { enabled = true },
    },
    window = {
      position = "left",
      width = 30,
      mappings = {
        ["<space>"] = "none",
        ["O"] = "system_open",
      },
    },
    commands = {
      system_open = function(state)
        local node = state.tree:get_node()
        vim.fn.jobstart({ "open", node:get_id() }, { detach = true })
      end,
    },
    event_handlers = {
      {
        event = "file_opened",
        handler = function() require("neo-tree.command").execute({ action = "close" }) end,
      },
    },
  },
}
