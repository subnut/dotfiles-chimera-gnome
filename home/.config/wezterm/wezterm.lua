local wez = require 'wezterm'
local cfg = {}

local colorschemes = {
  onehalf = {'OneHalfLight',  'OneHalfDark'},
  iceberg = {'iceberg-light', 'iceberg-dark'},
}

local colorscheme = colorschemes.iceberg
if wez.gui.get_appearance():find 'Light'
  then cfg.color_scheme = colorscheme[1]
  else cfg.color_scheme = colorscheme[2]
end
cfg.force_reverse_video_cursor = false

cfg.enable_scroll_bar = true
cfg.use_fancy_tab_bar = false
cfg.tab_bar_at_bottom = true
cfg.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
cfg.integrated_title_buttons = { "Close" }
cfg.hide_tab_bar_if_only_one_tab = true
cfg.hide_mouse_cursor_when_typing = false

cfg.window_padding = {
  left = 2,
  right = 2,
  top = 0,
  bottom = 0,
}

cfg.term = "wezterm"
cfg.set_environment_variables = {
  TERMINFO_DIRS = "/home/chimera/.local/share/terminfo"
}

-- cfg.font_size = 14.5
-- cfg.cell_width = 0.85
-- cfg.font = wez.font{
--   family = 'Monaspace Neon',
--   harfbuzz_features = {"dlig", "calt"}
-- }

-- cfg.font_size = 15
-- cfg.cell_width = 0.85
-- cfg.line_height = 0.9
-- cfg.font = wez.font{
--   family = "IBM Plex Mono",
--   harfbuzz_features = {"ss06"} -- #
-- }

-- cfg.font_size = 14
-- cfg.font = wez.font{
--   family = 'Recursive Mono Casual Static',
--   harfbuzz_features = {"dlig"}
-- }

-- cfg.font_size = 17
-- cfg.cell_width = 0.85
-- cfg.line_height = 1.05
-- cfg.font = wez.font'Dank Mono'

-- cfg.font_size = 15
-- cfg.cell_width = 0.9
-- cfg.line_height = 0.9
-- cfg.font = wez.font{
--   family = "Iosevka SS15 Extended",
--   harfbuzz_features = {"dlig"}
-- }

cfg.font_size = 14
cfg.cell_width = 0.9
cfg.harfbuzz_features = {'calt', 'dlig'}
cfg.font_rules = {
  { italic = false, intensity = 'Normal',
    font = wez.font'Monaspace Neon',
  },
  { italic = true, intensity = 'Normal',
    font = wez.font'Monaspace Radon',
  },
  { italic = false, intensity = 'Bold',
    font = wez.font {
      family = 'Monaspace Neon',
      weight = 'Bold',
    },
  },
  { italic = true, intensity = 'Bold',
    font = wez.font {
      family = 'Monaspace Radon',
      weight = 'Bold',
    },
  },
}

return cfg
-- vim: et ts=2 sts=2 sw=2
