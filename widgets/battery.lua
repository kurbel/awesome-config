-- For those people has UPS, this widget doesn't support it QQ.
--
-- Implement feature: turn battery notification into a configuable property

local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local naughty = require('naughty')
local beautiful = require('beautiful')

local timer = gears.timer 
-- Each icon rule is make up by two to three value
-- condition: the statify condition that trigger this rule, can be a number or string "full"
-- text icon: the icon itself
-- type : "Mains" for external power 
local IconRule = {
    {   9, "  "  , "#ff4230ff"},
    {  19, "  "  , "#ff6666ff"},
    {  29, "  "  , "#ff8a5cff"},
    {  39, "  "  , "#ff863bff"},
    {  49, "  "  , "#ffc13bff"},
    {  59, "  "  , "#ffd83bff"},
    {  69, "  "  , "#deff3bff"}, 
    {  79, "  "  , "#93ff3bff"}, 
    {"full", " " ,"#55ff3bff","Mains" },
    { 100, "  "  , "#55ff3bff"},
}
local powerWarningRule = {
    { 
        id = 1,
        level = 5,
        title = "Message from your operating system",
        content = "Hey, serious.\nThis is your last warning." 
    },{ 
        id = 2,
        level = 10,
        title = "Message from your operating system",
        content = "I calculate stuff for you.\n" ..
                  "I run all these programs for you.\n"..
                  "I even deal with your crazy shitty code.\n"..
                  "And this is how you pay me?\n"..
                  "Huh?\n"..
                  "Give me power or we are done."
    },{ 
        id = 3,
        level = 20,
        title = "Message from your operating system",
        content = "我們需要更多高能瓦斯",
    },
}

local PowerWidget = {}
local PowerWatch  = {}

local POWERSUPPLE_DIR = "/sys/class/power_supply/"

-- Power Watch {{{

-- Setup query timer for PowerWatch, also this object will trigger 
-- fisrt shot of query
function PowerWatch:init()
    self.power = { Battery = {}, UPS = {}, Mains = {}, USB = {}, }
    self.powertable = setmetatable({}, {
        __index = self.power,
        __newindex = function(table, key, value)
                        error("Power status table is readonly")
                    end,
        __metatable = false,
    })

    -- Open each power supply driver
    local drivers = io.popen('ls '..POWERSUPPLE_DIR)
    for line in drivers:lines() do

        -- Indicate type
        local power_type = io.open(POWERSUPPLE_DIR..line.."/type"):read('*a')
        power_type, _ = string.gsub(power_type, '\n', '')
        print("Find", power_type, line)

        -- Put dir name to corresponding power supply category
        table.insert(self.power[power_type], {name = line})
    end

    -- Setup timer and call it immediately
    self:changeInternval(10)
end

-- Change power query interval
function PowerWatch:changeInternval(interval)
    if self.updateTimer ~= nil then 
        self.updateTimer:stop()
    end

    self.updateTimer = timer {
        timeout = interval,
        call_now = false,
        autostart = true,
        callback = function() PowerWatch.update(PowerWatch) end
    }
end

-- Update Current Power status and battery usage
function PowerWatch:update()
    if self.power == nil then self.power = {} end

    -- Test if main power is on
    for _,power in pairs(self.power.Mains) do
        local powerOnline = io.open(POWERSUPPLE_DIR..power.name.."/online"):read(1) 
        self.mainOnline = powerOnline == "1"
    end

    -- Retrieve capacity of each battery
    for _,power in pairs(self.power.Battery) do 
        local powerCapacity = io.open(POWERSUPPLE_DIR..power.name.."/capacity"):read('*a')
        power.capacity = tonumber(powerCapacity)
    end

    -- Callback
    if self.listenerCallbacks then
        print("Handle", #self.listenerCallbacks,"callback")
        for _,callback in pairs(self.listenerCallbacks) do
            callback(self.mainOnline, self.powertable)
        end
    end
end

-- Regist event callback, once power status is updated
-- callback function getting trigger.
function PowerWatch:addListener(callback)
    if self.listenerCallbacks == nil then
        self.listenerCallbacks = {}
    end
    print("Add listener", callback)

    self.listenerCallbacks[callback] = callback
end
function PowerWatch:removeListener(callback)
    if self.listenerCallbacks == nil then
        return
    end

    self.listenerCallbacks[callback] = nil
end
-- }}}

-- Power Widget {{{

function PowerWidget:notify(args)
    self.alert = self.alert or {}

    if self.alert[args.id] == nil then
        self.alert[args.id] = naughty.notify({
            title = args.title,
            text = args.content,
            preset = naughty.config.presets.critical,
            timeout = 0,
        })
    end
end

function PowerWidget:clearAlerts()
    -- remove every alert.
    for index, alert in pairs(self.alert) do
        if alert then 
            naughty.destroy(alert, naughty.notificationClosedReason.dismissedByCommand)
            self.alert[index] = nil
        end
    end
end

function PowerWidget:create(args)

    local widget = wibox.widget.textbox()

    -- Registe Power watch event
    PowerWatch:addListener(function(mainOnline, power)
        local capacity = power.Battery[1].capacity
        
        -- Update icon
        for _, rule in ipairs(IconRule) do
            condition, icon, fcolor, ptype = table.unpack(rule)
            if type(condition) == "number" and capacity <= condition then 
                widget.markup = "<span foreground=\"".. fcolor .."\">"..
                                    icon .. " " .. capacity .. 
                                "</span>"
                break
            -- TODO: Implement External Power
            elseif type(condition) == "string" and condition == "full" and capacity == 100 and mainOnline then
                widget.markup = "<span foreground=\"".. fcolor .."\">"..
                                    icon .. " Full" ..
                                "</span>"
                break
            end
        end

        -- Remove alert naughty when notification has been closed

        -- alert user when running out of power 
        if mainOnline == false then
            local r1 = powerWarningRule[1]
            local r2 = powerWarningRule[2]
            local r3 = powerWarningRule[3]
            if capacity <= r1.level then
                self:notify(r1)
            elseif capacity <= r2.level then
                self:notify(r2)
            elseif capacity <= r3.level then
                self:notify(r3)
            else 
                if self.alert then self:clearAlerts() end
            end
        else
            if self.alert then self:clearAlerts() end
        end
    end)

    PowerWatch:update()

    return {
        { widget = widget },
        { widget = wibox.container.margin, right = 5 },
        layout = wibox.layout.fixed.horizontal,
    }
end


-- }}}

PowerWatch:init()

return setmetatable(PowerWidget, {
    __call = PowerWidget.create 
})
