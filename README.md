# Indigo Parking
Indigo Parking is a script that saves players cars in the database and respawns them when the server restarts.

## Documentation
Will be included in the next commit

## Supported frameworks

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [esx](https://github.com/esx-framework/esx_core)

## Dependencies

- [oxmysql](https://github.com/overextended/oxmysql)
- [ox_lib](https://github.com/overextended/ox_lib)

## Features

- Player vehicles are automatically saved to the database
- If a player disconnects (for whatever reason), their vehicle's position is saved
- When the server restarts, the vehicle positions are restored
- Only the server communicates directly with the database; the client (player) sends their vehicle data to the server during certain events
- For performance reasons, the database is not updated constantly; the server stores the vehicle data and updates the database at regular intervals

## What information is stored?

- The vehicle's location
- The vehicle's license plate number
- The owner (identifier on ESX / CitizenID on QB-Core)
- The vehicle model
- The fuel level
- The vehicle configuration (e.g., primary and secondary colors, dirt, tires, extras, and much more)

For a list of all configurations that are saved, please refer to the [ox_lib](https://overextended.dev/docs/ox_lib/VehicleProperties/Client#vehicle-properties) documentation
