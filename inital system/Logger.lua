-- Logger.lua
-- Receives and logs data from Detector

local component = require("component")
local event = require("event")
local fs = require("filesystem")
local serialization = require("serialization")
local modem = component.modem
local logFilePath = "/home/entity_log.txt"

-- Open communication port
local port = 123
modem.open(port)

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
    file:write(string.format(
    "[%s] Entity: %s\n  Location: (%.2f, %.2f, %.2f)\n  Relative Offset: (dx=%.2f, dy=%.2f, dz=%.2f)\n  Distance: %.2f blocks\n  Facing: %s\n\n",
    data.time, data.name,
    data.absoluteX, data.absoluteY, data.absoluteZ,
    data.dx, data.dy, data.dz,
    data.distance,
    data.facing
    ))
    file:close()
    end
end

-- Listen for modem_message events
print("Logger started. Listening for entity data...")
while true do
    local _, _, from, recvPort, _, message = event.pull("modem_message")
    print("Received data from:", from, "on port:", recvPort)
    local status, data = pcall(serialization.unserialize, message)
    if status and data and type(data) == "table" then
        logEntity(data)
        print("Logged entity:", data.name)
    else
        print("Invalid data received")
    end
end
