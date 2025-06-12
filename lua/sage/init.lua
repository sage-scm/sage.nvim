-- sage.nvim - Neovim integration for Sage SCM
-- Main plugin module

local M = {}

-- Default configuration
local default_config = {
  leader = '<leader>S',
  which_key = true, -- Enable which-key integration if available
  keymaps = {
    -- Core operations
    save = 's',
    ai_save = 'a',
    work = 'w',
    root = 'r',
    
    -- Advanced saves
    save_all_push = 'P',
    empty_commit = 'e',
    amend = 'A',
    save_paths = 'p',
    
    -- PR/Share workflow
    share = 'H',
    draft = 'd',
    ready = 'g',
    
    -- Sync operations
    sync = 'y',
    sync_continue = 'C',
    sync_abort = 'B',
    
    -- Utilities
    list = 'l',
    clean = 'c',
    dashboard = 'D',
    
    -- Recovery & maintenance
    undo = 'u',
    history = 'h',
    resolve = 'm',
    doctor = 'x',
  }
}

-- Plugin configuration
local config = {}

-- Check if sage command is available
local function check_sage_available()
  local handle = io.popen('which sage 2>/dev/null')
  if handle then
    local result = handle:read('*a')
    handle:close()
    return result ~= ''
  end
  return false
end

-- Set up keymaps
local function setup_keymaps()
  local map = vim.keymap.set
  local leader = config.leader
  local keys = config.keymaps
  
  -- Core save operations (most commonly used)
  map('n', leader .. keys.save, function()
    local message = vim.fn.input('Commit message (empty for quick save): ')
    if message ~= '' then
      vim.cmd('!sage save "' .. message .. '"')
    else
      vim.cmd('!sage save')
    end
  end, { desc = 'Sage: Save with optional message' })

  map('n', leader .. keys.ai_save, '<cmd>!sage save --ai<cr>', { desc = 'Sage: AI-assisted commit' })

  -- Branch operations (simple and intuitive)
  map('n', leader .. keys.work, function()
    local branch = vim.fn.input('Branch name (empty for fuzzy search): ')
    if branch ~= '' then
      vim.cmd('!sage work ' .. branch)
    else
      vim.cmd('!sage work --fuzzy')
    end
  end, { desc = 'Sage: Work on branch' })

  map('n', leader .. keys.root, '<cmd>!sage work --root<cr>', { desc = 'Sage: Switch to root branch' })

  -- Advanced save operations
  map('n', leader .. keys.save_all_push, '<cmd>!sage save --all --push<cr>', { desc = 'Sage: Save all & push' })
  map('n', leader .. keys.empty_commit, '<cmd>!sage save --empty<cr>', { desc = 'Sage: Empty commit' })
  map('n', leader .. keys.amend, '<cmd>!sage save --amend<cr>', { desc = 'Sage: Amend previous commit' })

  map('n', leader .. keys.save_paths, function()
    local paths = vim.fn.input('Paths to save (space-separated): ')
    if paths ~= '' then
      vim.cmd('!sage save --paths ' .. paths)
    end
  end, { desc = 'Sage: Save specific paths' })

  -- PR/Share operations
  map('n', leader .. keys.share, '<cmd>!sage share<cr>', { desc = 'Sage: Create/update PR' })
  map('n', leader .. keys.draft, '<cmd>!sage share --draft<cr>', { desc = 'Sage: Create draft PR' })
  map('n', leader .. keys.ready, '<cmd>!sage share --ready<cr>', { desc = 'Sage: Mark PR ready' })

  -- Sync operations
  map('n', leader .. keys.sync, '<cmd>!sage sync<cr>', { desc = 'Sage: Sync (restack & push)' })
  map('n', leader .. keys.sync_continue, '<cmd>!sage sync --continue<cr>', { desc = 'Sage: Continue sync' })
  map('n', leader .. keys.sync_abort, '<cmd>!sage sync --abort<cr>', { desc = 'Sage: Abort sync' })

  -- Quick utilities
  map('n', leader .. keys.list, '<cmd>!sage list<cr>', { desc = 'Sage: List branches' })
  map('n', leader .. keys.clean, '<cmd>!sage clean<cr>', { desc = 'Sage: Clean branches' })
  map('n', leader .. keys.dashboard, '<cmd>!sage dash<cr>', { desc = 'Sage: Repository dashboard' })

  -- Recovery operations
  map('n', leader .. keys.undo, '<cmd>!sage undo<cr>', { desc = 'Sage: Undo last action' })
  map('n', leader .. keys.history, '<cmd>!sage history<cr>', { desc = 'Sage: Show history' })
  map('n', leader .. keys.resolve, '<cmd>!sage resolve<cr>', { desc = 'Sage: Launch mergetool' })

  -- Health check
  map('n', leader .. keys.doctor, '<cmd>!sage doctor<cr>', { desc = 'Sage: Health check' })
end

-- Set up which-key integration
local function setup_which_key()
  if not config.which_key then
    return
  end
  
  local ok, wk = pcall(require, 'which-key')
  if not ok then
    return
  end
  
  local leader = config.leader
  local keys = config.keymaps
  
  wk.add({
    -- Sage CLI Integration
    { leader, group = "Sage (Git Workflow)" },
    -- Core operations (most used)
    { leader .. keys.save, desc = "Save with optional message" },
    { leader .. keys.ai_save, desc = "AI-assisted commit" },
    { leader .. keys.work, desc = "Work on branch" },
    { leader .. keys.root, desc = "Switch to root branch" },
    -- Advanced saves
    { leader .. keys.save_all_push, desc = "Save all & push" },
    { leader .. keys.empty_commit, desc = "Empty commit" },
    { leader .. keys.amend, desc = "Amend previous commit" },
    { leader .. keys.save_paths, desc = "Save specific paths" },
    -- PR/Share workflow
    { leader .. keys.share, desc = "Create/update PR" },
    { leader .. keys.draft, desc = "Create draft PR" },
    { leader .. keys.ready, desc = "Mark PR ready" },
    -- Sync operations
    { leader .. keys.sync, desc = "Sync (restack & push)" },
    { leader .. keys.sync_continue, desc = "Continue sync" },
    { leader .. keys.sync_abort, desc = "Abort sync" },
    -- Quick utilities
    { leader .. keys.list, desc = "List branches" },
    { leader .. keys.clean, desc = "Clean branches" },
    { leader .. keys.dashboard, desc = "Repository dashboard" },
    -- Recovery & maintenance
    { leader .. keys.undo, desc = "Undo last action" },
    { leader .. keys.history, desc = "Show history" },
    { leader .. keys.resolve, desc = "Launch mergetool" },
    { leader .. keys.doctor, desc = "Health check" },
  })
end

-- Main setup function
function M.setup(opts)
  -- Merge user config with defaults
  config = vim.tbl_deep_extend('force', default_config, opts or {})
  
  -- Check if sage is available
  if not check_sage_available() then
    vim.notify('sage.nvim: sage command not found in PATH. Please install Sage SCM.', vim.log.levels.WARN)
    return
  end
  
  -- Set up keymaps and which-key integration
  setup_keymaps()
  setup_which_key()
  
  vim.notify('sage.nvim: Plugin loaded successfully!', vim.log.levels.INFO)
end

return M