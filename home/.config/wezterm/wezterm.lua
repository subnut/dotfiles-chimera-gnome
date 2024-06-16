local wez = require 'wezterm'
local cfg = {}

local colorschemes = {
  onehalf = {'OneHalfLight',  'OneHalfDark'},
  iceberg = {'iceberg-light', 'iceberg-dark'},
  gruvbox = {'GruvboxLight',  'GruvboxDarkHard'}
}

local colorscheme = colorschemes.iceberg
if wez.gui.get_appearance():find 'Light'
  then cfg.color_scheme = colorscheme[1]
  else cfg.color_scheme = colorscheme[2]
end
cfg.force_reverse_video_cursor = false

cfg.enable_scroll_bar = false
cfg.use_fancy_tab_bar = false
cfg.tab_bar_at_bottom = true
cfg.window_decorations = 'RESIZE|INTEGRATED_BUTTONS'
cfg.integrated_title_buttons = { "Close" }
cfg.hide_tab_bar_if_only_one_tab = true
cfg.hide_mouse_cursor_when_typing = false

cfg.window_padding = {
  left = 2,
  right = 2,
  top = 2,
  bottom = 2,
}

cfg.term = "wezterm"
cfg.set_environment_variables = {
  TERMINFO_DIRS = "/home/chimera/.local/share/terminfo"
}


local ffidx = 2 --[[

  1 - Monaspace Neon + Radon
  2 - MonoLisa Plus
  3 - IBM Plex Mono
  4 - Dank Mono
  5 - Victor Mono (DemiBold)
  6 - Recursive Mono (Casual)
  7 - Iosevka SS15 (extended)
  8 - Monaspace Neon

--]]
local fftbl =
{
  [2] =
  function()
    cfg.font_size = 14
    cfg.line_height = 0.95
    cfg.cell_width = 0.8
    cfg.font = wez.font{
      family = 'MonoLisa',
      harfbuzz_features = {"dlig", "calt"}
    }
  end,

  [3] =
  function()
    cfg.font_size = 15
    cfg.cell_width = 0.8
    cfg.line_height = 0.95
    cfg.font = wez.font{
      family = "IBM Plex Mono",
      harfbuzz_features = {"ss06"} -- #
    }
  end,

  [4] =
  function()
    cfg.font_size = 17
    cfg.cell_width = 0.85
    cfg.line_height = 1.1
    cfg.font = wez.font'Dank Mono'
  end,

  [5] =
  function()
    cfg.font_size = 14
    cfg.line_height = 0.9
    cfg.font = wez.font{
      family = "Victor Mono",
      weight = "DemiBold"
    }
  end,

  [6] =
  function()
    cfg.font_size = 14
    cfg.font = wez.font{
      family = 'Recursive Mono Casual Static',
      harfbuzz_features = {"dlig"}
    }
  end,

  [7] =
  function()
    cfg.font_size = 15
    cfg.cell_width = 0.9
    cfg.line_height = 0.9
    cfg.font = wez.font{
      family = "Iosevka SS15 Extended",
      harfbuzz_features = {"dlig"}
    }
  end,

  [8] =
  function()
    cfg.font_size = 14.5
    cfg.cell_width = 0.85
    cfg.font = wez.font{
      family = 'Monaspace Neon',
      harfbuzz_features = {"dlig", "calt"}
    }
  end,

  [1] =
  function()
    cfg.font_size = 14
    cfg.cell_width = 0.9
    cfg.harfbuzz_features = {'calt', 'dlig'}
    cfg.font_rules = {
      {
        intensity = 'Normal', italic = false,
        font = wez.font'Monaspace Neon',
      },
      {
        intensity = 'Normal', italic = true,
        font = wez.font'Monaspace Radon',
      },
      {
        intensity = 'Bold', italic = false,
        font = wez.font {
          family = 'Monaspace Neon',
          weight = 'Bold',
        }
      },
      {
        intensity = 'Bold', italic = true,
        font = wez.font {
          family = 'Monaspace Radon',
          weight = 'Bold',
        }
      },
    }
  end,
}
fftbl[ffidx]()


-- Maximize all displayed windows on startup
-- https://wezfurlong.org/wezterm/config/lua/gui-events/gui-attached.html
wez.on('gui-attached',
  function(domain)
    local workspace = wez.mux.get_active_workspace()
    for _, window in ipairs(wez.mux.all_windows()) do
      if window:get_workspace() == workspace then
        window:gui_window():maximize()
      end
    end
  end
)

-- vim: et ts=2 sts=2 sw=2
return cfg
