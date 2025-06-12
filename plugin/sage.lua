-- sage.nvim - Plugin entry point
-- This file is automatically loaded by Neovim

-- Prevent loading the plugin multiple times
if vim.g.loaded_sage_nvim then
  return
end
vim.g.loaded_sage_nvim = 1

-- Create user command for manual setup (if needed)
vim.api.nvim_create_user_command('SageSetup', function()
  require('sage').setup()
end, {
  desc = 'Set up sage.nvim plugin'
})

-- Auto-setup with default config if lazy.nvim calls setup
-- This ensures the plugin works out of the box with config = true
local augroup = vim.api.nvim_create_augroup('SageNvim', { clear = true })
vim.api.nvim_create_autocmd('User', {
  group = augroup,
  pattern = 'LazyLoad',
  callback = function(args)
    if args.data == 'sage.nvim' then
      -- Plugin was loaded by lazy.nvim, but setup wasn't called
      -- This happens when user uses config = true
      vim.schedule(function()
        if not package.loaded['sage'] then
          return
        end
        -- Check if setup was already called by checking if keymaps exist
        local existing_maps = vim.api.nvim_get_keymap('n')
        local has_sage_maps = false
        for _, map in ipairs(existing_maps) do
          if map.desc and string.find(map.desc, 'Sage:') then
            has_sage_maps = true
            break
          end
        end
        if not has_sage_maps then
          require('sage').setup()
        end
      end)
    end
  end,
})