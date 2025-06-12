# sage.nvim

A Neovim plugin that provides seamless integration with the [Sage SCM](https://github.com/sage-scm/sage) tool, offering intuitive keybindings and smart prompts for modern Git workflow management.

## Features

- **Clean, intuitive keybindings** using `<leader>S` prefix
- **Smart prompting** with sensible defaults and fallbacks
- **Progressive complexity** - simple commands for daily use, advanced options available
- **Full sage command coverage** including save, work, sync, share, and utilities
- **Which-key integration** for command discoverability

## Prerequisites

- [Sage SCM](https://github.com/sage-scm/sage) installed and available in your PATH
- Neovim 0.8+ (for `vim.keymap.set` support)

## Installation

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'sage-scm/sage.nvim',
  dependencies = {
    'folke/which-key.nvim', -- Optional but recommended for command discoverability
  },
  config = true, -- Use default configuration
  -- Or with custom configuration:
  -- opts = { leader = '<leader>G' } -- Use different leader key
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  'sage-scm/sage.nvim',
  requires = { 'folke/which-key.nvim' }, -- Optional
  config = function()
    require('sage').setup()
  end
}
```

## Default Keybindings

All keybindings use the `<leader>S` prefix by default.

### Core Operations (Daily Use)

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>Ss` | `sage save` | Save with optional message (prompts, uses quick save if empty) |
| `<leader>Sa` | `sage save --ai` | AI-assisted commit message |
| `<leader>Sw` | `sage work` | Work on branch (prompts for name, uses fuzzy search if empty) |
| `<leader>Sr` | `sage work --root` | Switch to root branch |

### Advanced Save Operations

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>SP` | `sage save --all --push` | Save all changes and push |
| `<leader>Se` | `sage save --empty` | Create empty commit |
| `<leader>SA` | `sage save --amend` | Amend previous commit |
| `<leader>Sp` | `sage save --paths` | Save specific paths (prompts for paths) |

### PR/Share Workflow

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>SH` | `sage share` | Create or update pull request |
| `<leader>Sd` | `sage share --draft` | Create draft pull request |
| `<leader>Sg` | `sage share --ready` | Mark pull request as ready |

### Sync Operations

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>Sy` | `sage sync` | Sync (restack and push) |
| `<leader>SC` | `sage sync --continue` | Continue sync after resolving conflicts |
| `<leader>SB` | `sage sync --abort` | Abort current sync operation |

### Utilities

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>Sl` | `sage list` | List branches |
| `<leader>Sc` | `sage clean` | Clean merged branches |
| `<leader>SD` | `sage dash` | Open repository dashboard |

### Recovery & Maintenance

| Key | Command | Description |
|-----|---------|-------------|
| `<leader>Su` | `sage undo` | Undo last sage operation |
| `<leader>Sh` | `sage history` | Show sage operation history |
| `<leader>Sm` | `sage resolve` | Launch merge conflict resolution tool |
| `<leader>Sx` | `sage doctor` | Run sage health check |

## Configuration

```lua
require('sage').setup({
  -- Change the leader key prefix (default: '<leader>S')
  leader = '<leader>G',
  
  -- Enable which-key integration (default: true if which-key is available)
  which_key = true,
  
  -- Custom keybindings (optional)
  keymaps = {
    save = '<leader>Ss',
    ai_save = '<leader>Sa',
    work = '<leader>Sw',
    -- ... etc
  }
})
```

## Usage Examples

### Smart Save Workflow

1. **Quick save**: `<leader>Ss` → Press Enter (uses `sage save`)
2. **Custom message**: `<leader>Ss` → Type message → Press Enter
3. **AI commit**: `<leader>Sa` (no prompt needed)

### Branch Management

1. **Create/switch branch**: `<leader>Sw` → Type branch name → Press Enter
2. **Fuzzy search branches**: `<leader>Sw` → Press Enter (empty input)
3. **Return to main**: `<leader>Sr`

### Complete Feature Workflow

```
1. <leader>Sw → "feature/new-ui" → Create branch
2. <leader>Ss → "Add header component" → Save with message  
3. <leader>Ss → "Update styles" → Save again
4. <leader>SH → Create PR
5. <leader>Sg → Mark ready for review
6. <leader>Sr → Return to main branch
```

## Why sage.nvim?

- **No complex menus** - Simple, predictable keybindings
- **Smart defaults** - Empty inputs trigger sensible fallbacks  
- **Muscle memory friendly** - Logical key groupings
- **Full feature coverage** - Access to all sage functionality
- **Non-intrusive** - Uses `<leader>S` prefix to avoid conflicts

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.