-- TODO: Implement style
-- TODO: Export operating function, and setup the key binding
local wibox = require('wibox')
local gears = require('gears')
local awful = require('awful')
local command = require('awful.spawn').easy_async_with_shell

   -- 婢0 當靜音
   -- 婢0 當音量為 0
   -- 奄xx 當音量在 1~ 30 
   -- 奔xx 當音量在31~ 60
   -- 墳xx 當音量在61~100


local IconRule = {
    { "mute", " ", "#a6a6a6ff" },
    { 0,      " ", "#00ff00ff" },
    { 30,     " ", "#00ff00ff" },
    { 60,     " ", "#00ff00ff" },
    {100,     " ", "#00ff00ff" },
}

local VolumeManager = {}
local VolumeWidget  = {}

-- VolumeManager {{{
-- VolumeManager controls sound utility on this window system

function VolumeManager:init()

    -- test if amixer is installed
    command("amixer", function(stdout, stderr, exitreason, exitcode)
        if exitcode ~= 0 then
            local failure = function()
                error("Failed to execute amixer. Please ensure it is installed correctly." .. stderr) 
            end
        end
    end)
end

function VolumeManager:amixer(operation, value, callback) 
    if     operation == "set"    then operation = ""
    elseif operation == "offset" then operation = (value > 0 and "+" or "-")
    end

    command("amixer sset Master " .. math.abs(value) .. "%" .. operation,
        function(stdout, stderr, exitreason, exitcode) 
            if exitcode == 0 then
                if callback then callback() end
            else
                error("Failed to execute amixer." .. stderr)
            end
        end
    )
end

function VolumeManager:volumeAdd(value)

    if val == 0 then return end
    
    self:amixer("offset", value)
    self:triggerListener()
end

function VolumeManager:getVolume(callback)
    command("amixer sget Master", function(stdout) 
        result = string.match(stdout, "[0-9]*%%")
        result = string.gsub(result, "%%", "")
        callback(tonumber(result))
    end)
end

function VolumeManager:mute(set)
    -- Yes, that is a callback hell :(
    if set then 
        self:getVolume(function(vol) 
            self:amixer("set", 0, function()
                self.originalVolume = vol 
                self.muted = true 
                self:triggerListener()
            end)
        end)
    else
        self:amixer("set", self.originalVolume, function()
            self.originalVolume = nil
            self.muted = false
            self:triggerListener()
        end)
    end
end

function VolumeManager:toggleMute()
    self:mute(not self.muted)
end

function VolumeManager:triggerListener()
    self:getVolume(function(volume)
        for _, callback in pairs(self.callbacks) do
            callback({
                volume = volume,
                muted  = self.muted,
            })
        end
    end)
end

function VolumeManager:addListener(callback)
    if self.callbacks == nil then self.callbacks = {} end
    self.callbacks[callback] = callback
end

function VolumeManager:removeListener(callback)
    if self.callbacks then
        self.callbacks[callback] = nil
    end
end

-- }}}

VolumeManager:init()

-- VolumeWidget {{{

function VolumeWidget:create()
    local widget = wibox.widget.textbox()

    widget:buttons(
        gears.table.join(
            awful.button({}, 1, function() VolumeManager:toggleMute() end),
            awful.button({}, 4, function() VolumeManager:volumeAdd( 3) end),
            awful.button({}, 5, function() VolumeManager:volumeAdd(-3) end)
        )
    )

    VolumeManager:addListener(function(args) 
        local volume = args.volume
        local muted  = args.muted

        for _, rule in pairs(IconRule) do
            local level, icon, color
            level, icon, color = table.unpack(rule)
            if type(level) == 'string' and (level == "mute" and muted) then
                widget.markup = "<span foreground=\"" .. color .. "\">" ..
                                    " " .. icon .. " Mute" ..
                                   "</span>"

                break
            elseif type(level) == 'number' and volume <= level then
                widget.markup = "<span foreground=\"" .. color .. "\">" ..
                                    " " .. icon .. " " .. volume ..
                                   "</span>"
                break
            end
        end
    end)

    VolumeManager:triggerListener()

    return { 
        { widget = widget },
        { widget = wibox.container.margin, right= 5 },
        layout = wibox.layout.fixed.horizontal,
    }
end

function VolumeWidget:update(args)
end

-- }}}

return setmetatable(VolumeWidget,{ __call = VolumeWidget.create })
