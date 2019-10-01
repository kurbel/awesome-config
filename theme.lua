---------------------------
-- Default awesome theme --
---------------------------

-- ~/.config/awesome/rc.lua

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local gears = require('gears')
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local config_path = gfs.get_configuration_dir()

local theme = {}

theme.font_nerd_small = "Ubuntu Nerd Font 9"
theme.font_nerd       = "Ubuntu Nerd Font 12"
theme.font_nerd_big   = "Ubuntu Nerd Font 15"

theme.font_small    = "Ubuntu 6"
theme.font          = "Ubuntu 9" -- "ABeeZee 8"--"FreeSans 8.7"
theme.titlebars_enabled = true
theme.rofi_theme    = config_path .. "configs/rofi_drun.rasi"

-- Client
theme.border_width  = dpi(0)
theme.useless_gap   = dpi(3)
theme.border_normal = "#eeeeee"
theme.border_focus  = "#000000"
theme.border_marked = "#91231c"

-- Titlebar
theme.titlebar_bg_normal = "#2c2c2cff"
theme.titlebar_bg_focus  = "#1c1c24ff"
theme.titlebar_fg_normal = "#9f9f9fff"
theme.titlebar_icon_bg   = "#ff3a3aff"
theme.titlebar_button_bg = "#383838ff"

-- Wibar
theme.wibar_bg = "#1c1c24ff"

-- Tag list
theme.taglist_bg_focus = "#ff2a2aff"
theme.taglist_bg_occupied = "#ba524aff" -- "#370909ff"
theme.taglist_bg_empty = "#383838ff"
theme.taglist_font = theme.font_nerd

-- Task list
theme.tasklist_bg_focus = "#ff2a2aff"
theme.tasklist_bg_normal = "#383838ff"
theme.tasklist_bg_urgent = "#d35f8dff"
theme.tasklist_bg_minimize = "#a41010ff"
theme.tasklist_shape = gears.shape.powerline
theme.tasklist_spacing = -12

-- System tray
theme.bg_systray = "#383838ff"

-- Menu
theme.menu_submenu = ">"
theme.menu_bg_normal= "#38383888"
theme.menu_bg_focus = "#ff2a2a88"
theme.menu_height = dpi(16)
theme.menu_width  = dpi(120)

--Prompt Box
theme.prompt_bg = "#1c1c24ff"

theme.status_bar_bg = "#383838ff"

-- Default 
theme.bg_normal     = "#1c1c24ff"
theme.bg_focus      = "#ff2a2aff"
theme.bg_urgent     = "#ff3d3dbb"
theme.bg_minimize   = "#3261a899"
theme.bg_systray    = theme.bg_normal
theme.hotkeys_bg = "#000000ee"

theme.fg_normal     = "#cccccc"
theme.fg_focus      = "#ffffff"
theme.fg_urgent     = "#ffffff"
theme.fg_minimize   = "#ffffff"




-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the image to load
theme.titlebar_close_button_normal = config_path.."icons/closing.svg"
theme.titlebar_close_button_focus  = config_path.."icons/closing.svg"

theme.titlebar_minimize_button_normal = themes_path.."default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path.."default/titlebar/minimize_focus.png"

theme.titlebar_ontop_button_normal_inactive = themes_path.."default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path.."default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active = themes_path.."default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active  = themes_path.."default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = config_path.."icons/sticky_inactive.svg"
theme.titlebar_sticky_button_focus_inactive  = config_path.."icons/sticky_inactive.svg"
theme.titlebar_sticky_button_normal_active   = config_path.."icons/sticky_active.svg"
theme.titlebar_sticky_button_focus_active    = config_path.."icons/sticky_active.svg"

theme.titlebar_floating_button_normal_inactive = config_path.."icons/floating_inactive.svg"
theme.titlebar_floating_button_focus_inactive  = config_path.."icons/floating_inactive.svg"
theme.titlebar_floating_button_normal_active   = config_path.."icons/floating_active.svg" 
theme.titlebar_floating_button_focus_active    = config_path.."icons/floating_active.svg" 

theme.titlebar_maximized_button_normal_inactive = themes_path.."default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path.."default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active = themes_path.."default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active  = themes_path.."default/titlebar/maximized_focus_active.png"

theme.wallpaper =  "~/Pictures/41212.jpg" -- config_path .. "wallpapers/RedDroptop.png"


-- You can use your own layout icons like this:
theme.layout_fairh = themes_path.."default/layouts/fairhw.png"
theme.layout_fairv = themes_path.."default/layouts/fairvw.png"
theme.layout_floating  = themes_path.."default/layouts/floatingw.png"
theme.layout_magnifier = themes_path.."default/layouts/magnifierw.png"
theme.layout_max = themes_path.."default/layouts/maxw.png"
theme.layout_fullscreen = themes_path.."default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path.."default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path.."default/layouts/tileleftw.png"
theme.layout_tile = themes_path.."default/layouts/tilew.png"
theme.layout_tiletop = themes_path.."default/layouts/tiletopw.png"
theme.layout_spiral  = themes_path.."default/layouts/spiralw.png"
theme.layout_dwindle = themes_path.."default/layouts/dwindlew.png"
theme.layout_cornernw = themes_path.."default/layouts/cornernww.png"
theme.layout_cornerne = themes_path.."default/layouts/cornernew.png"
theme.layout_cornersw = themes_path.."default/layouts/cornersww.png"
theme.layout_cornerse = themes_path.."default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_focus, theme.fg_focus
)

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
