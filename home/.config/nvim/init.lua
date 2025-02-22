-- Установка кодировки
vim.opt.encoding = "utf-8"

-- Включение подсветки синтаксиса
vim.cmd('syntax on')

-- Включение нумерации строк
vim.opt.number = true

-- Включение относительной нумерации строк
-- vim.opt.relativenumber = true

-- Включение автоматического отступа
vim.opt.autoindent = true

-- Включение отображения табов и пробелов
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·' }

-- Настройка табуляции (например, 4 пробела вместо таба)
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Включение поиска с подсветкой
vim.opt.hlsearch = true

-- Включение инкрементального поиска
vim.opt.incsearch = true

-- Включение мыши
vim.opt.mouse = 'a'

-- Включение переноса строк
vim.opt.wrap = true

-- Включение сохранения истории команд
vim.opt.history = 1000

-- Включение автодополнения
vim.opt.completeopt = 'menuone,noselect'

-- Задаёт фон терминала
vim.opt.termguicolors = true  -- Включает поддержку true colors
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })






-- Установка packer.nvim, если он еще не установлен
local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd 'packadd packer.nvim'
end

-- Настройка плагинов с помощью packer.nvim
require('packer').startup(function(use)
  -- Плагин для отображения изменений в файлах
  use 'lewis6991/gitsigns.nvim'

  -- Гит
  use {
    'kdheepak/lazygit.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
  }

  -- Плагин для подсветки синтаксиса
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate'
  }

  -- Дополнительные плагины для treesitter
  use 'nvim-treesitter/nvim-treesitter-context'  -- Показ контекста
  use 'nvim-treesitter/nvim-treesitter-textobjects' -- Текстовые объекты

  -- Тема для текста
  use 'folke/tokyonight.nvim'

  -- Автоматически закрывает скобки, кавычки и теги
  use 'windwp/nvim-autopairs'

  -- Улучшение работы с цветами
  use 'norcalli/nvim-colorizer.lua'

  -- Красивое стартовое меню для Neovim с быстрым доступом к недавним файлам
  use 'mhinz/vim-startify'


  
  -- Автодополнение
  use 'hrsh7th/nvim-cmp'         -- Менеджер автодополнения
  use 'hrsh7th/cmp-buffer'       -- Автодополнение из буфера
  use 'hrsh7th/cmp-path'         -- Автодополнение путей
  use 'hrsh7th/cmp-nvim-lsp'     -- Автодополнение из LSP
  use 'hrsh7th/cmp-nvim-lua'     -- Автодополнение для Lua (опционально)
  use 'saadparwaiz1/cmp_luasnip' -- Интеграция с snippets
  use 'L3MON4D3/LuaSnip'         -- Плагин для snippets

  -- LSP (Language Server Protocol)
  use 'neovim/nvim-lspconfig'    -- Настройка LSP

  -- Дерево директорий
  use {
    'nvim-tree/nvim-tree.lua',
    requires = { 'nvim-tree/nvim-web-devicons' }, -- Иконки (опционально)
  }

  -- Строка состояния
  use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }, -- Иконки (опционально)
  }

  -- Вкладки (табы)
  use {
    'romgrk/barbar.nvim',
    requires = { 'nvim-tree/nvim-web-devicons' }, -- Иконки (опционально)
  }
end)

-- Настройка lazygit
vim.api.nvim_set_keymap('n', 'gg', ':LazyGit<CR>', { noremap = true, silent = true })

-- Настройка nvim-treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "python", "javascript", "bash", "json", "yaml", "html", "css", "markdown" },
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
  },
}

-- Настройка цветовой схемы
require('tokyonight').setup({
  style = 'night', -- Варианты: 'night', 'storm', 'day', 'moon'
  transparent = true, -- Включаем прозрачный фон
  styles = {
    comments = { italic = true }, -- Курсив для комментариев
    keywords = { bold = true },   -- Жирный шрифт для ключевых слов
  },
})

-- Применение цветовой схемы
vim.cmd('colorscheme tokyonight')

-- Установка прозрачного фона для всех окон
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- Настройка nvim-cmp (автодополнение)
local cmp = require('cmp')

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- Используем LuaSnip для snippets
    end,
  },
  mapping = {
    ['<C-b>'] = cmp.mapping(cmp.mapping.scroll_docs(-4)), -- Прокрутка документации вверх
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4)),  -- Прокрутка документации вниз
    ['<C-Space>'] = cmp.mapping(cmp.mapping.complete()),  -- Открыть автодополнение
    ['<C-e>'] = cmp.mapping(cmp.mapping.abort()),         -- Закрыть автодополнение
    ['<CR>'] = cmp.mapping.confirm({ select = true }),    -- Подтвердить выбор
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' }, -- Источник для LSP
    { name = 'luasnip' },  -- Источник для snippets
    { name = 'buffer' },   -- Источник из текущего буфера
    { name = 'path' },     -- Источник для путей к файлам
  }),
})

-- Настройка LSP
local lspconfig = require('lspconfig')

-- Настройка LSP для C и C++ (clangd)
lspconfig.clangd.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Настройка LSP для Python (pyright)
lspconfig.pyright.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Настройка LSP для HTML (html)
lspconfig.html.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Настройка LSP для CSS (cssls)
lspconfig.cssls.setup({
  capabilities = require('cmp_nvim_lsp').default_capabilities(),
})

-- Настройка LuaSnip (snippets)
require('luasnip.loaders.from_vscode').lazy_load() -- Загрузка snippets из VSCode

-- Настройка nvim-tree.lua
require('nvim-tree').setup({
  view = {
    width = 30, -- Ширина дерева
    side = 'left', -- Расположение (left или right)
  },
  renderer = {
    highlight_opened_files = "all", -- Подсветка открытых файлов
    icons = {
      glyphs = {
        default = '', -- Иконка для файлов по умолчанию
        symlink = '', -- Иконка для символьных ссылок
        folder = {
          arrow_closed = '', -- Иконка закрытой папки
          arrow_open = '',   -- Иконка открытой папки
          default = '',      -- Иконка папки по умолчанию
          open = '',         -- Иконка открытой папки
          empty = '',        -- Иконка пустой папки
          empty_open = '',   -- Иконка открытой пустой папки
        },
      },
    },
  },
  actions = {
    open_file = {
      quit_on_open = true, -- Закрыть дерево после открытия файла
    },
  },
})

-- Настройка прозрачного фона для nvim-tree.lua
vim.api.nvim_set_hl(0, 'NvimTreeNormal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeEndOfBuffer', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NvimTreeVertSplit', { bg = 'none' })

-- Горячие клавиши для nvim-tree.lua
vim.api.nvim_set_keymap('n', 'ee', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Настройка lualine.nvim
require('lualine').setup({
  options = {
    theme = 'tokyonight', -- Используем тему tokyonight
    component_separators = { left = '', right = '' },
    section_separators = { left = '', right = '' },
  },
  sections = {
    lualine_a = { 'mode' }, -- Текущий режим Vim
    lualine_b = { 'branch', 'diff', 'diagnostics' }, -- Ветка Git, изменения и диагностика
    lualine_c = { { 'filename', path = 1 } }, -- Имя файла и путь
    lualine_x = { 'encoding', 'fileformat', 'filetype' }, -- Кодировка, формат файла и тип
    lualine_y = { 'progress' }, -- Прогресс (строка:столбец)
    lualine_z = { 'location' }, -- Текущее положение курсора
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { 'filename', path = 1 } }, -- Имя файла и путь для неактивных окон
    lualine_x = { 'location' },
    lualine_y = {},
    lualine_z = {},
  },
})

-- Настройка barbar.nvim
require('barbar').setup({
  animation = true, -- Включить анимацию
  auto_hide = false, -- Автоматически скрывать вкладки, если их меньше двух
  tabpages = true, -- Показывать вкладки для всех табов
  icons = {
    button = '', -- Иконка для кнопки закрытия вкладки
    inactive = { separator = { left = '▎', right = '' } }, -- Стиль неактивных вкладок
    separator = { left = '▎', right = '' }, -- Разделитель между вкладками
  },
})

-- Настройка прозрачного фона для barbar.nvim
vim.api.nvim_set_hl(0, 'BufferCurrent', { bg = 'none' }) -- Активная вкладка
vim.api.nvim_set_hl(0, 'BufferCurrentIndex', { bg = 'none' }) -- Индекс активной вкладки
vim.api.nvim_set_hl(0, 'BufferCurrentMod', { bg = 'none' }) -- Активная вкладка с изменениями
vim.api.nvim_set_hl(0, 'BufferCurrentSign', { bg = 'none' }) -- Значок активной вкладки
vim.api.nvim_set_hl(0, 'BufferCurrentTarget', { bg = 'none' }) -- Цель активной вкладки
-- vim.api.nvim_set_hl(0, 'BufferVisible', { bg = 'none' }) -- Видимые вкладки
-- vim.api.nvim_set_hl(0, 'BufferVisibleIndex', { bg = 'none' }) -- Индекс видимых вкладок
-- vim.api.nvim_set_hl(0, 'BufferVisibleMod', { bg = 'none' }) -- Видимые вкладки с изменениями
-- vim.api.nvim_set_hl(0, 'BufferVisibleSign', { bg = 'none' }) -- Значок видимых вкладок
-- vim.api.nvim_set_hl(0, 'BufferVisibleTarget', { bg = 'none' }) -- Цель видимых вкладок
-- vim.api.nvim_set_hl(0, 'BufferInactive', { bg = 'none' }) -- Неактивные вкладки
-- vim.api.nvim_set_hl(0, 'BufferInactiveIndex', { bg = 'none' }) -- Индекс неактивных вкладок
-- vim.api.nvim_set_hl(0, 'BufferInactiveMod', { bg = 'none' }) -- Неактивные вкладки с изменениями
-- vim.api.nvim_set_hl(0, 'BufferInactiveSign', { bg = 'none' }) -- Значок неактивных вкладок
-- vim.api.nvim_set_hl(0, 'BufferInactiveTarget', { bg = 'none' }) -- Цель неактивных вкладок

-- Горячие клавиши для barbar.nvim
vim.api.nvim_set_keymap('n', '<A-,>', ':BufferPrevious<CR>', { noremap = true, silent = true }) -- Перейти на предыдущую вкладку
vim.api.nvim_set_keymap('n', '<A-.>', ':BufferNext<CR>', { noremap = true, silent = true }) -- Перейти на следующую вкладку
vim.api.nvim_set_keymap('n', '<A-1>', ':BufferGoto 1<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 1
vim.api.nvim_set_keymap('n', '<A-2>', ':BufferGoto 2<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 2
vim.api.nvim_set_keymap('n', '<A-3>', ':BufferGoto 3<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 3
vim.api.nvim_set_keymap('n', '<A-4>', ':BufferGoto 4<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 4
vim.api.nvim_set_keymap('n', '<A-5>', ':BufferGoto 5<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 5
vim.api.nvim_set_keymap('n', '<A-6>', ':BufferGoto 6<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 6
vim.api.nvim_set_keymap('n', '<A-7>', ':BufferGoto 7<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 7
vim.api.nvim_set_keymap('n', '<A-8>', ':BufferGoto 8<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 8
vim.api.nvim_set_keymap('n', '<A-9>', ':BufferGoto 9<CR>', { noremap = true, silent = true }) -- Перейти на вкладку 9
vim.api.nvim_set_keymap('n', '<A-0>', ':BufferLast<CR>', { noremap = true, silent = true }) -- Перейти на последнюю вкладку
vim.api.nvim_set_keymap('n', '<A-c>', ':BufferClose<CR>', { noremap = true, silent = true }) -- Закрыть текущую вкладку


require('nvim-autopairs').setup()

require('colorizer').setup()



