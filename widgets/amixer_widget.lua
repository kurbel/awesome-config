#!/usr/local/bin/lua

local textbox = require("wibox.widget.textbox")
local widget_base = require("wibox.widget.base")
local gdebug = require("gears.debug")
local awful = require("awful")
local beautiful = require('beautiful')
local gears = require("gears")
local setmetatable = setmetatable
local widget = { mt = {} }

-- Initialization here
function widget.new()
  
    local textbox = textbox('  ')
    textbox.font = beautiful.font_nerd_small
    widget.textbox = textbox
    widget.muted = false
    widget.update_ui()
    widget.textbox:buttons(
        gears.table.join(
            awful.button({}, 1, widget.switch_mute),
            awful.button({}, 4, function(t) widget.add_volume("3%+") end),
            awful.button({}, 5, function(t) widget.add_volume("3%-") end)
        )
    )
    return textbox
end

-- func
function widget.update_ui()
    if widget.muted then
        widget.textbox:set_markup_silently("<span color='#923c45'>婢 </span>")
    else 
        awful.spawn.easy_async_with_shell("amixer sget Master", function(out) 
            out = string.match(out, '[0-9]*%%')
            widget.textbox:set_markup_silently(" : <span color='#22cc22'>" .. out .. "</span> ")
        end)
    end
end

function widget.switch_mute()
    widget.muted = not widget.muted
    if widget.muted then
        -- save current volume before mute
        awful.spawn.easy_async_with_shell("amixer sget Master", function(out) 
            widget.origin = string.match(out, '[0-9]*%%')
            awful.spawn.easy_async_with_shell("amixer sset Master 0%", function(out) end)
        end)
        widget.update_ui()
    else
        awful.spawn.easy_async_with_shell("amixer sset Master " .. widget.origin, widget.update_ui)
    end
end

function widget.add_volume(value)
    if widget.muted then return end
    awful.spawn.easy_async_with_shell("amixer sset Master " .. value, function(out)
        widget.update_ui()
    end)
    widget.update_ui()
end

-- signals

-- export amixer widget

local _instance = nil;

function widget.mt:__call(...)
    if _instance == nil then
        _instance = widget.new()
    end
    return _instance
end

return setmetatable(widget, widget.mt)
