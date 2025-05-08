Goals
    Create a system to detect and log entities found near the base witch the system is located.
    It must detect where coordinates wise and what face (N,E,W,S) they are on.

Requirements
    A way to detect when and where (Cords, Face, Time)
    A way to log said data 
    A way to display said data

Optionals
    Ignore movement if a player is on a whitelist (authorized list and unauthorized list)
    Raise an alarm if a unauthorized player enters a given area
    Log keycard uses at doors
    Clock in and clock out system

Notes

    For entity detector block
        known to open computers as "os_entdetector"
        has 4 functions:
            getLoc() : returns the global position of the detector block (X, Y ,Z)
            greet() : prints something
            scanEntities(a,b,c,d) : Pushes a table with all entities in the scanning radius. Has 4(?) inputs, a, witch is related to the distance the scan will go, b, witch is a boolean that dictates weather coordinates are global or relative to the scan block, and d and c, idk what they do yet
            scanPlayers(a,b,c,d) : Same as entities but only scans players and not entities
            default of b is false for both scanPlayers and scanEntities