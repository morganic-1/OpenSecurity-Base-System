-- Detector.lua
-- Scans for entities and sends data to Logger

local component = require("component")
local event = require("event")
local serialization = require("serialization")
local modem = component.modem
local detector = component.entity_detector
local sides = require("sides")

-- Open a port for communication
local port = 123
modem.open(port)

-- Helper to determine direction based on relative position
local function getFacing(dx, dz)
    if math.abs(dx) > math.abs(dz) then
        return dx > 0 and "East" or "West"
    else
        return dz > 0 and "South" or "North"
    end
end

print("Detector started. Scanning...")

while true do
    local entities = detector.scanEntities(16, 4, 16)
    for _, e in ipairs(entities) do
    if e.name then -- likely a player
        local time = os.date("%Y-%m-%d %H:%M:%S")
        local dx = e.x - detector.getX()
        local dz = e.z - detector.getZ()
        local data = {
                name = e.name,
                x = math.floor(e.x),
                y = math.floor(e.y),
                z = math.floor(e.z),
                facing = getFacing(dx, dz),
                time = time
            }
            local message = serialization.serialize(data)
            modem.broadcast(port, message)
        end
    end
    os.sleep(2) -- Delay between scans
end
