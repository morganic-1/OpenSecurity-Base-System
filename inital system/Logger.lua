-- Logger.lua
-- Receives and logs data from Detector

local event = require("event")
local fs = require("filesystem")
local serialization = require("serialization")
local logFilePath = "/home/entity_log.txt"

-- Ensure the log file exists
if not fs.exists(logFilePath) then
    local file = io.open(logFilePath, "w")
    file:write("[Entity Log Initialized]\n")
    file:close()
end

-- Append a log entry
local function logEntity(data)
    local file = io.open(logFilePath, "a")
    if file then
    file:write(string.format("[%s] Entity: %s at (%d, %d, %d) facing %s\n",
        data.time, data.name, data.x, data.y, data.z, data.facing))
    file:close()
    end
end

-- Listen for modem_message events
print("Logger started. Listening for entity data...")
while true do
    local _, _, _, _, _, message = event.pull("modem_message")
    local status, data = pcall(serialization.unserialize, message)
    if status and data and type(data) == "table" then
        logEntity(data)
        print("Logged entity:", data.name)
    else
        print("Invalid data received")
    end
end