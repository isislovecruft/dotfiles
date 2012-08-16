-------------------------------
--  "Zenburn" awesome theme  --
--    By Adrian C. (anrxc)   --
-------------------------------

-- Alternative icon sets and widget icons:
--  * http://awesome.naquadah.org/wiki/Nice_Icons

-- {{{ Main
theme = {}
theme.dir = "/home/isis/\.config/awesome/themes/isis/"
theme.wallpaper_cmd = { "awsetbg /home/isis/\.config/awesome/themes/isis/default_background\.png" }
-- }}}

-- {{{ Styles
theme.font      = "sans 10"

-- {{{ Colors
theme.fg_normal = "#aaaaaa"
theme.fg_focus  = "#ffffff"
theme.fg_urgent = "#ffffff"
theme.bg_normal = "#222222"
theme.bg_focus  = "#0B0B0B"
theme.bg_urgent = "#aef4ba"
-- }}}

-- {{{ Borders
-- XXX fucking hell fucking lua
theme.border_width  = "1"
theme.border_normal = "#222222"
theme.border_focus  = "#222222"
theme.border_marked = "#aef4ba"
-- }}}

-- {{{ Titlebars
theme.titlebar_bg_focus  = "#3F3F3F"
theme.titlebar_bg_normal = "#3F3F3F"
-- }}}

-- There are other variable sets
-- overriding the default one when
-- defined, the sets are:
-- [taglist|tasklist]_[bg|fg]_[focus|urgent]
-- titlebar_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- Example:
--theme.taglist_bg_focus = "#CC9393"
-- }}}

-- {{{ Widgets
-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
theme.fg_widget                 = "#FFFFFF"
theme.fg_widget_value           = "#FFFFFF"
theme.fg_widget_value_important = "#FFFFFF"
theme.fg_widget_clock           = "#FFFFFF"
theme.fg_center_widget          = "#FFFFFF"
theme.fg_end_widget             = "#1A1A1A"
theme.bg_widget                 = "#222222"
theme.border_widget             = "#444444"
-- }}}

theme.info = theme.dir .. "icons/info.png"
theme.pacman = theme.dir .. "icons/pacman.png"

-- {{{ Mouse finder
theme.mouse_finder_color = "#CC9393"
-- mouse_finder_[timeout|animate_timeout|radius|factor]
-- }}}

-- {{{ Menu
-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_height = "15"
theme.menu_width  = "150"
-- }}}

-- {{{ Icons
-- {{{ Taglist
theme.taglist_squares_sel   = theme.dir .. "taglist/squarefz.png"
theme.taglist_squares_unsel = theme.dir .. "taglist/squarez.png"
--theme.taglist_squares_resize = "false"
-- }}}

-- {{{ Misc
theme.awesome_icon           = theme.dir .. "icons/awesome-icon.png"
theme.menu_submenu_icon      = theme.dir .. "icons/submenu.png"
theme.tasklist_floating_icon = theme.dir .. "tasklist/floatingw.png"
-- }}}

-- {{{ Layout
theme.layout_tile       = theme.dir .. "layouts/tile.png"
theme.layout_tileleft   = theme.dir .. "layouts/tileleft.png"
theme.layout_tilebottom = theme.dir .. "layouts/tilebottom.png"
theme.layout_tiletop    = theme.dir .. "layouts/tiletop.png"
theme.layout_fairv      = theme.dir .. "layouts/fairv.png"
theme.layout_fairh      = theme.dir .. "layouts/fairh.png"
theme.layout_spiral     = theme.dir .. "layouts/spiral.png"
theme.layout_dwindle    = theme.dir .. "layouts/dwindle.png"
theme.layout_max        = theme.dir .. "layouts/max.png"
theme.layout_fullscreen = theme.dir .. "layouts/fullscreen.png"
theme.layout_magnifier  = theme.dir .. "layouts/magnifier.png"
theme.layout_floating   = theme.dir .. "layouts/floating.png"
-- }}}

-- {{{ Titlebar
theme.titlebar_close_button_focus  = theme.dir .. "titlebar/close_focus.png"
theme.titlebar_close_button_normal = theme.dir .. "titlebar/close_normal.png"

theme.titlebar_ontop_button_focus_active  = theme.dir .. "titlebar/ontop_focus_active.png"
theme.titlebar_ontop_button_normal_active = theme.dir .. "titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_inactive  = theme.dir .. "titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_inactive = theme.dir .. "titlebar/ontop_normal_inactive.png"

theme.titlebar_sticky_button_focus_active  = theme.dir .. "titlebar/sticky_focus_active.png"
theme.titlebar_sticky_button_normal_active = theme.dir .. "titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_inactive  = theme.dir .. "titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_inactive = theme.dir .. "titlebar/sticky_normal_inactive.png"

theme.titlebar_floating_button_focus_active  = theme.dir .. "titlebar/floating_focus_active.png"
theme.titlebar_floating_button_normal_active = theme.dir .. "titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_inactive  = theme.dir .. "titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_inactive = "/usr/share/awesome/themes/zenburn/titlebar/floating_normal_inactive.png"

theme.titlebar_maximized_button_focus_active  = theme.dir .. "titlebar/maximized_focus_active.png"
theme.titlebar_maximized_button_normal_active = theme.dir .. "titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_inactive  = theme.dir .. "titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_inactive = theme.dir .. "titlebar/maximized_normal_inactive.png"
-- }}}
-- }}}

return theme
