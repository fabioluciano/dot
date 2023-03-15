local wezterm = require 'wezterm'

return {
  automatically_reload_config = true,
  hide_mouse_cursor_when_typing = true,
  font = wezterm.font('CaskaydiaCove Nerd Font Mono'),
  font_size = 15.0,
  window_background_opacity = 1.0,
  line_height = 1.2,
  default_prog = { '/usr/bin/tmuxp', 'load', '~/.tmuxp.yml' },
  enable_tab_bar = false,
  color_scheme = "tokyonight",
  window_padding = {
    left = 0,
    right = 0,
    top = 0,
    bottom = 0,
  },
}
