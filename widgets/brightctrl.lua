#!/usr/local/bin/lua

local maxb_file = "/sys/class/backlight/intel_backlight/max_brightness"
local b_file = "/sys/class/backlight/intel_backlight/brightness"

-- {{{ Read/Write Function
local max_buf = nil
local function get_max()
    if max_buf ~= nil then return max_buf end
    local file, msg = io.open(maxb_file,"r")
    if not file then error(msg) end

    local value = file:read("n")
    if not value then error("Failed to read content of " .. maxb_file) end
    file:close()

    max_buf = value
    return value
end

local function get_brightness()
    local file, msg = io.open(b_file,"r")
    if not file then error(msg) end

    local value = file:read("n")
    if not value then error("Faile to read content of " .. b_file) end
    file:close()

    return value
end

local function set_brightness(value)
    if type(value) ~= "number" then
        error("Target variable is not a number")
    end
    if value > get_max() then 
        error("Target brightness " .. value .. " over maximum")
    end

    local file, msg = io.open(b_file,"w")
    if not file then error(msg) end

    file:write(tostring(value))
    file:flush()
    file:close()
end

-- }}}

---{{{ Control function

local function get_percent(value) return value / get_max() * 100 end
local function percent_to_raw(percent) return (get_max() / 100) * percent end
local function set_percent(percent)
    local level = math.floor(percent_to_raw(math.max(math.min(100,percent),0.5)))
    set_brightness(level)
    return level
end
local function inc_percent(percent) set_percent(get_percent(get_brightness()) + percent) end
local function dec_percent(percent) set_percent(get_percent(get_brightness()) - percent) end

-- }}}

local P = {
    get_max = get_max,
    get_brightness = get_brightness,
    set_brightness = set_brightness,
    percent_to_raw = percent_to_raw,
    get_percent = get_percent,
    set_percent = set_percent,
    inc_percent = inc_percent,
    dec_percent = dec_percent,
}

if ... ~= nil then
    _G[...] = P
else
    bright = P
end

return P
