# Neovim 配置优化指南

## 📊 配置分析总结

### ✅ 做得好的地方

1. **模块化结构清晰** - 使用了良好的文件组织结构（`lua/plugins/`, `lua/configs/`）
2. **现代插件管理** - 使用 lazy.nvim 管理插件，这是目前最好的选择之一
3. **优秀的插件选择**：
   - `blink.cmp` - 高性能的补全引擎
   - `fzf-lua` - 快速的模糊查找
   - `nvim-treesitter` - 现代化的语法高亮和代码分析
   - `avante.nvim` - AI 辅助编程
4. **基础配置完善** - 基本的编辑器选项和键位映射都有

---

## 🔧 优化建议

### 1. 性能优化

#### 1.1 启用 termguicolors
**文件**: `lua/options.lua`

**当前状态**: 被注释掉了
```lua
-- vim.opt.termguicolors = true
```

**建议**: 取消注释以获得更好的颜色显示
```lua
vim.opt.termguicolors = true  -- 启用 24-bit RGB 颜色
```

#### 1.2 添加大文件优化
**文件**: `lua/options.lua`

**建议添加**:
```lua
-- 性能优化
vim.opt.updatetime = 250        -- 更快的 CursorHold 触发时间
vim.opt.timeoutlen = 300        -- 更快的键位序列超时
vim.opt.lazyredraw = false      -- 不要在宏执行时重绘（nvim 默认 false，保持即可）

-- 大文件优化
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function()
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > 1024 * 1024 then -- 1MB
      vim.opt_local.syntax = "off"
      vim.opt_local.swapfile = false
      vim.opt_local.undofile = false
    end
  end,
})
```

---

### 2. 编辑器功能增强

#### 2.1 持久化撤销和文件管理
**文件**: `lua/options.lua`

**建议添加**:
```lua
-- 持久化撤销
vim.opt.undofile = true         -- 保存撤销历史到文件
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"  -- 撤销文件目录

-- 备份和交换文件
vim.opt.backup = false          -- 不创建备份文件
vim.opt.writebackup = false     -- 编辑时不创建备份
vim.opt.swapfile = false        -- 不使用交换文件

-- 滚动优化
vim.opt.scrolloff = 8           -- 光标上下保留 8 行
vim.opt.sidescrolloff = 8       -- 光标左右保留 8 列

-- 命令行
vim.opt.cmdheight = 1           -- 命令行高度
vim.opt.showcmd = true          -- 显示命令

-- 更好的补全体验
vim.opt.pumheight = 10          -- 补全菜单最大高度

-- 折叠
vim.opt.foldlevel = 99          -- 默认不折叠
vim.opt.foldlevelstart = 99     -- 打开文件时不折叠

-- 分割窗口
vim.opt.fillchars = {
  foldopen = "",
  foldclose = "",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
```

#### 2.2 更好的搜索和替换体验
**文件**: `lua/options.lua`

**当前已有**: `incsearch`, `hlsearch`, `ignorecase`, `smartcase`

**建议添加**:
```lua
vim.opt.inccommand = "split"    -- 实时预览替换效果
```

---

### 3. LSP 配置优化

#### 3.1 美化诊断和浮动窗口
**文件**: `lua/lsp.lua`

**建议添加**:
```lua
-- 自定义诊断符号
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " "
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

-- 诊断配置
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- 浮动窗口边框
local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end
```

#### 3.2 修复代码缩进问题
**文件**: `lua/lsp.lua`

**当前代码** 混用了 tab 和空格，建议统一：
```lua
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function (args)
        local keymap = vim.keymap
        local lsp = vim.lsp
        local bufopts = { noremap = true, silent = true }

        keymap.set("n", "gr", lsp.buf.references, bufopts)
        keymap.set("n", "gd", lsp.buf.definition, bufopts)
        keymap.set("n", "<space>rn", lsp.buf.rename, bufopts)
        keymap.set("n", "K", lsp.buf.hover, bufopts)
        keymap.set("n", "<space>f", function()
            vim.lsp.buf.format({ async = true })
        end, bufopts)
    end
})
```

#### 3.3 添加更多 LSP 键位映射
**文件**: `lua/lsp.lua`

**建议添加**:
```lua
keymap.set("n", "gD", lsp.buf.declaration, bufopts)
keymap.set("n", "gi", lsp.buf.implementation, bufopts)
keymap.set("n", "gt", lsp.buf.type_definition, bufopts)
keymap.set("n", "<space>ca", lsp.buf.code_action, bufopts)
keymap.set("n", "<space>d", vim.diagnostic.open_float, bufopts)
keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
```

---

### 4. 键位映射增强

#### 4.1 添加常用快捷键
**文件**: `lua/keymaps.lua`

**建议添加**:
```lua
-----------------
-- Normal mode --
-----------------

-- 快速保存和退出
vim.keymap.set('n', '<leader>w', ':w<CR>', opts)
vim.keymap.set('n', '<leader>q', ':q<CR>', opts)
vim.keymap.set('n', '<leader>x', ':x<CR>', opts)

-- Buffer 管理
vim.keymap.set('n', '<leader>bd', ':bd<CR>', opts)
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)

-- 清除搜索高亮
vim.keymap.set('n', '<Esc>', ':noh<CR>', opts)

-- 更好的行移动（处理自动换行）
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- 保持光标居中
vim.keymap.set('n', '<C-d>', '<C-d>zz', opts)
vim.keymap.set('n', '<C-u>', '<C-u>zz', opts)
vim.keymap.set('n', 'n', 'nzzzv', opts)
vim.keymap.set('n', 'N', 'Nzzzv', opts)

-- 快速替换当前单词
vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], opts)

-----------------
-- Insert mode --
-----------------

-- 快速退出插入模式
vim.keymap.set('i', 'jk', '<Esc>', opts)
vim.keymap.set('i', 'kj', '<Esc>', opts)

-----------------
-- Visual mode --
-----------------

-- 粘贴时不覆盖寄存器
vim.keymap.set('x', '<leader>p', [["_dP]], opts)

-- 复制到系统剪贴板
vim.keymap.set({'n', 'v'}, '<leader>y', [["+y]], opts)
vim.keymap.set('n', '<leader>Y', [["+Y]], opts)

-- 删除到黑洞寄存器
vim.keymap.set({'n', 'v'}, '<leader>d', [["_d]], opts)
```

---

### 5. 插件配置优化

#### 5.1 修复 blink.cmp 拼写错误
**文件**: `lua/plugins/blink.cmp.lua`

**第 64 行**: `matchh` 应该改为 `match`
```lua
-- 修改前
-- The keyword should only matchh against the text before
-- 修改后
-- The keyword should only match against the text before
```

#### 5.2 优化 Treesitter 配置
**文件**: `lua/configs/nvim-treesitter.lua`

**建议**: 启用大文件禁用高亮的功能
```lua
highlight = {
    enable = true,
    disable = {},
    -- 大文件禁用高亮
    disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
            return true
        end
    end,
    additional_vim_regex_highlighting = false,
},
```

#### 5.3 添加更多有用的插件
**建议考虑添加的插件**:

1. **自动保存** - `okuuva/auto-save.nvim`
2. **会话管理** - `folke/persistence.nvim`
3. **代码注释** - `numToStr/Comment.nvim`
4. **代码格式化** - `stevearc/conform.nvim` (如果需要更强大的格式化)
5. **Git 增强** - `NeogitOrg/neogit` (如果需要更完整的 Git 集成)

---

### 6. 额外优化建议

#### 6.1 添加自动命令组
**文件**: 新建 `lua/autocmds.lua`

**建议内容**:
```lua
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- 高亮复制的文本
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- 打开文件时恢复光标位置
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- 保存时自动创建目录
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})

-- 关闭某些文件类型时按 q 退出
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "qf",
    "checkhealth",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})
```

**然后在** `init.lua` **中添加**:
```lua
require('autocmds')
```

#### 6.2 添加自定义命令
**文件**: 新建 `lua/commands.lua`

**建议内容**:
```lua
local command = vim.api.nvim_create_user_command

-- 格式化 JSON
command("FormatJson", function()
  vim.cmd("%!jq .")
end, {})

-- 删除尾随空格
command("TrimWhitespace", function()
  local save = vim.fn.winsaveview()
  vim.cmd([[keeppatterns %s/\s\+$//e]])
  vim.fn.winrestview(save)
end, {})

-- 复制当前文件路径
command("CopyPath", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, {})

-- 复制当前文件的相对路径
command("CopyRelPath", function()
  local path = vim.fn.expand("%:.")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, {})
```

**然后在** `init.lua` **中添加**:
```lua
require('commands')
```

---

## 📝 实施优先级

### 🔴 高优先级（立即实施）
1. ✅ 启用 `termguicolors`
2. ✅ 修复 `blink.cmp.lua` 拼写错误
3. ✅ 修复 `lsp.lua` 缩进问题
4. ✅ 添加持久化撤销 (`undofile`)
5. ✅ 添加 LSP 诊断美化

### 🟡 中优先级（建议实施）
1. ⚡ 添加大文件优化
2. ⚡ 添加常用键位映射
3. ⚡ 添加自动命令（高亮复制、恢复光标等）
4. ⚡ 添加更多 LSP 键位映射
5. ⚡ 优化滚动体验 (`scrolloff`)

### 🟢 低优先级（可选）
1. 💡 添加自定义命令
2. 💡 添加更多插件
3. 💡 优化 Treesitter 大文件处理

---

## 🚀 快速实施方案

如果你想快速应用这些优化，可以按照以下步骤：

1. **备份当前配置**:
   ```bash
   cd ~/.config
   cp -r nvim nvim.backup
   ```

2. **应用高优先级优化**:
   - 编辑 `lua/options.lua` 启用 termguicolors 和添加基础优化
   - 编辑 `lua/lsp.lua` 修复缩进和添加诊断美化
   - 编辑 `lua/plugins/blink.cmp.lua` 修复拼写错误

3. **测试配置**:
   ```bash
   nvim
   ```
   检查是否有错误，使用 `:checkhealth` 检查健康状态

4. **逐步添加中优先级优化**:
   - 先添加键位映射
   - 再添加自动命令
   - 最后添加其他优化

---

## 📚 参考资源

- [Neovim 官方文档](https://neovim.io/doc/)
- [lazy.nvim](https://github.com/folke/lazy.nvim)
- [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim) - 优秀的配置参考
- [LazyVim](https://github.com/LazyVim/LazyVim) - 另一个优秀的配置参考

---

## ❓ 常见问题

**Q: 这些优化会影响启动速度吗？**
A: 不会。大部分优化都是功能增强，不会显著影响启动速度。懒加载配置反而会提升性能。

**Q: 需要重新安装插件吗？**
A: 不需要。这些优化主要是配置调整，现有插件可以继续使用。

**Q: 如何回滚这些更改？**
A: 建议先备份配置，如果有问题可以直接恢复备份。

**Q: 我可以只应用部分优化吗？**
A: 当然可以！按照优先级选择性应用即可。

---

**最后更新**: 2025-12-02

