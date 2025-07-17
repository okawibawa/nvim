return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      picker = {
        enabled = true,
        backend = 'fzf',
        actions = {
          ['<C-v>'] = 'vsplit',
          ['<C-x>'] = 'split',
          ['<C-t>'] = 'tabedit',
        },
        use_devicons = true,
      },
      sources = {
        explorer = {
          win = {
            list = {
              keys = {
                ["h"] = "explorer_up",
                ["l"] = "confirm",
                ["<CR>"] = "confirm"
              }
            }
          }
        }
      },
      lazygit = {
        configure = true,
        config = {
          os = { editPreset = "nvim-remote" },
          gui = { nerdFontsVersion = "3" },
        },
        win = {
          style = "lazygit",
          width = 0.9,
          height = 0.9,
        },
      },
      input = {
        enabled = true,
        win = {
          relative = "editor",
          noautocmd = true,
          row = 2,
          col = nil,
          width = 60,
          height = 1,
          border = "rounded",
          title_pos = "left",
          style = "input",
        },
        icon = " ",
        icon_hl = "SnacksInputIcon",
        prompt = {
          enabled = true,
          prefix = " ",
        },
        expand = true,
      },
      indent = {
        enabled = true,
        char = "▎",
        only_current = false,
        only_scope = false,
        hl = {
          "SnacksIndent1",
          "SnacksIndent2",
          "SnacksIndent3",
          "SnacksIndent4",
          "SnacksIndent5",
          "SnacksIndent6",
          "SnacksIndent7",
          "SnacksIndent8",
        },
        animate = {
          enabled = true,
          duration = 75,
        },
        chunk = {
          enabled = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = "▶",
          },
          hl = "SnacksIndentChunk",
        },
        scope = {
          enabled = true,
          hl = "CursorLine",
          underline = false,
        },
        filter = function(buf)
          return vim.g.snacks_indent ~= false
              and vim.b[buf].snacks_indent ~= false
              and vim.bo[buf].buftype == ""
        end,
      },
      image = {
        enabled = true,

        formats = {
          "png", "jpg", "jpeg", "gif", "bmp", "webp", "tiff",
          "heic", "avif", "mp4", "mov", "avi", "mkv", "webm", "pdf"
        },

        force = false,

        doc = {
          enabled = true,
          inline = true,
          float = true,
          max_width = 80,
          max_height = 40,
          conceal = function(lang, type)
            return type == "math"
          end,
        },

        img_dirs = {
          "img", "images", "assets", "static", "public",
          "media", "attachments", "screenshots"
        },

        wo = {
          wrap = false,
          number = false,
          relativenumber = false,
          cursorcolumn = false,
          signcolumn = "no",
          foldcolumn = "0",
          list = false,
          spell = false,
          statuscolumn = "",
        },

        cache = vim.fn.stdpath("cache") .. "/snacks/image",

        debug = {
          request = false,
          convert = false,
          placement = false,
        },

        env = {
        },

        icons = {
          math = "󰪚 ",
          chart = "󰄧 ",
          image = " ",
        },

        convert = {
          notify = true,

          mermaid = function()
            local theme = vim.o.background == "light" and "neutral" or "dark"
            return {
              "-i", "{src}", "-o", "{file}",
              "-b", "transparent", "-t", theme, "-s", "{scale}"
            }
          end,

          magick = {
            default = { "{src}[0]", "-scale", "1920x1080>" },
            vector = { "-density", 192, "{src}[0]" },
            math = { "-density", 192, "{src}[0]", "-trim" },
            pdf = {
              "-density", 192, "{src}[0]",
              "-background", "white", "-alpha", "remove", "-trim"
            },
          },
        },

        math = {
          enabled = true,

          typst = {
            tpl = [[
						      #set page(width: auto, height: auto, margin: (x: 2pt, y: 2pt))
						      #show math.equation.where(block: false): set text(top-edge: "bounds", bottom-edge: "bounds")
						      #set text(size: 12pt, fill: rgb("${color}"))
						      ${header}
						      ${content}]]
          },

          latex = {
            font_size = "Large",
            packages = { "amsmath", "amssymb", "amsfonts", "amscd", "mathtools" },
            tpl = [[
						      \documentclass[preview,border=0pt,varwidth,12pt]{standalone}
						      \usepackage{${packages}}
						      \begin{document}
						      ${header}
						      { \${font_size} \selectfont
							\color[HTML]{${color}}
						      ${content}}
						      \end{document}]]
          },
        },

        resolve = function(file, src)
          if not vim.startswith(src, "/") and not vim.startswith(src, "http") then
            local dir = vim.fn.fnamemodify(file, ":h")
            return vim.fn.resolve(dir .. "/" .. src)
          end
          return src
        end,
      },
      statuscolumn = {
        enabled = true,

        left = { "mark", "sign" },
        right = { "git", "fold" },

        folds = {
          open = true,
          git_hl = true,
        },

        git = {
          patterns = { "GitSign", "MiniDiffSign", "Gitsigns" },
        },

        signs = {
          disabled = {},
        },

        marks = {
          enabled = true,
        },
      },
    },
    keys = {
      -- Picker keys
      { "<leader>ff", function() Snacks.picker.files() end,        desc = "Find Files" },
      { "<leader>fg", function() Snacks.picker.grep() end,         desc = "Grep" },
      { "<leader>fG", function() Snacks.picker.grep_buffers() end, desc = "Grep" },
      { "<leader>fb", function() Snacks.picker.buffers() end,      desc = "Buffers" },
      { "<leader>fe", function() Snacks.picker.explorer() end,     desc = "Explorer" },
      { "<leader>fs", function() Snacks.picker.smart() end,        desc = "Explorer" },

      -- Lazygit keys
      { "<leader>gg", function() Snacks.lazygit() end,             desc = "Lazygit" },
      { "<leader>gl", function() Snacks.lazygit.log() end,         desc = "Lazygit Log" },
      { "<leader>gf", function() Snacks.lazygit.log_file() end,    desc = "Lazygit Current File" },

      -- Indent keys
      { "<leader>id", function() Snacks.indent.disable() end,      desc = "Disable Indent Guides" },
      { "<leader>ie", function() Snacks.indent.enable() end,       desc = "Enable Indent Guides" },
    },
    init = function()
      vim.api.nvim_create_autocmd("ColorScheme", {
        callback = function()
          -- Catppuccin Mocha Palette (selected relevant colors)
          local catppuccin_mocha = {
            rosewater = "#f5e0dc",
            flamingo  = "#f2cdcd",
            pink      = "#f5c2e7",
            mauve     = "#cba6f7",
            red       = "#f38ba8",
            maroon    = "#eba0ac",
            peach     = "#fab387",
            yellow    = "#f9e2af",
            green     = "#a6e3a1",
            teal      = "#94e2d5",
            sky       = "#89dceb",
            sapphire  = "#74c7ce",
            blue      = "#89b4fa",
            lavender  = "#b4befe",
            text      = "#cdd6f4",
            subtext1  = "#bac2de",
            subtext0  = "#a6adc8",
            overlay2  = "#9399b2",
            overlay1  = "#7f849c",
            overlay0  = "#6c7086",
            surface2  = "#585b70",
            surface1  = "#45475a",
            surface0  = "#313244",
            base      = "#1e1e2e",
            mantle    = "#181825",
            crust     = "#11111b",
          }

          local indent_dot_color = catppuccin_mocha
              .overlay0
          local chunk_color = catppuccin_mocha.lavender

          for i = 1, 8 do
            vim.api.nvim_set_hl(0, "SnacksIndent" .. i, { fg = indent_dot_color })
          end

          vim.api.nvim_set_hl(0, "SnacksIndentChunk", { fg = chunk_color, bold = false })
        end,
      })

      vim.schedule(function()
        vim.cmd("doautocmd ColorScheme")
      end)
    end,
  },
}
