-- Detector.lua
-- Scans for entities and sends data to Logger

local component = require("component")
local event = require("event")
local serialization = require("serialization")
local modem = component.modem
local detector = component.os_entdetector

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

local scanX, scanY, scanZ = detector.getLoc()

while true do
    print("Scanning for entities...")
    local scan = detector.scanPlayers(64)
    for i, entity in ipairs(scan) do
        print("Scanned entity:", entity.name)
        entity = scan[i]
        local absoluteX, absoluteY, absoluteZ = entity.x, entity.y, entity.z
        local dx, dy, dz = absoluteX - scanX, absoluteY - scanY, absoluteZ - scanZ
        local distance = math.sqrt(dx^2 + dy^2 + dz^2)
        local facing = getFacing(dx, dz)

        local data = {
            time = os.date("%Y-%m-%d %H:%M:%S"),
            name = entity.name,
            absoluteX = absoluteX,
            absoluteY = absoluteY,
            absoluteZ = absoluteZ,
            dx = dx,
            dy = dy,
            dz = dz,
            distance = distance,
            facing = facing
        }

        local message = serialization.serialize(data)
        modem.broadcast(port, message)
        print("Sent data to Logger")
    end
    os.sleep(2) -- Sleep for a second before the next scan
end