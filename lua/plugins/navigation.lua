return {
  {
    'ggandor/leap.nvim',
    lazy = true,
    keys = {
      { 's', mode = { 'n', 'x', 'o' }, function() require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() } }) end, desc = 'Leap forward' },
      { 'S', mode = { 'n', 'x', 'o' }, function() require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() }, backward = true }) end, desc = 'Leap backward' },
      { 'gs', mode = { 'x', 'o' }, function() require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() } }) end, desc = 'Leap (operator)' },
      { 'gS', mode = { 'x', 'o' }, function() require('leap').leap({ target_windows = { vim.api.nvim_get_current_win() }, backward = true }) end, desc = 'Leap backward (operator)' },
    },
    config = function()
      require('leap').setup({
        case_sensitive = false,
        substitute_chars = {},
        highlight_unlabeled = true,
        max_phase_one_targets = 10,
      })
    end
  },
}
