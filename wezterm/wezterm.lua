local wezterm = require 'wezterm'

return {
  color_scheme = "Dracula",
  window_frame = {
    font = wezterm.font 'JetBrains Mono',
  },
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
  initial_cols = 180,
  initial_rows = 50,
  hide_tab_bar_if_only_one_tab = true
}