-- Detector.lua
-- Scans for entities and sends data to Logger

local component = require("component")
local event = require("event")
local serialization = require("serialization")
local modem = component.modem
local detector = component.os_entdetector
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
    local entities = detector.scanEntities()
    for _, e in ipairs(entities) do
        if e.name then -- likely a player
            local time = os.date("%Y-%m-%d %H:%M:%S")
            local detectorX = detector.getX() or 0
            local detectorZ = detector.getZ() or 0
            local dx = e.x - detectorX
            local dz = e.z - detectorZ
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
    event.pull(2) -- Delay between scans
end
