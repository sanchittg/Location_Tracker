const Location = require("../Modules/location");

const haversineDistance = (lat1, lon1, lat2, lon2) => {
    const R = 6371e3; // Earth radius in meters
    const toRadians = (degrees) => (degrees * Math.PI) / 180;
    const latiOne = toRadians(lat1);
    const latiTwo = toRadians(lat2);
    const radiOne = toRadians(lat2 - lat1);
    const radiTwo = toRadians(lon2 - lon1);

    const a = Math.sin(radiOne / 2) ** 2 + Math.cos(latiOne) * Math.cos(latiTwo) * Math.sin(radiTwo / 2) ** 2;
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

    return R * c; // Distance in meters
};

exports.addLocation = async (req, res) => {
    const { userId, latitude, longitude, address } = req.body;

    try {
        const newLocation = await Location.create({
            userId,
            latitude,
            longitude,
            address,
        });
        res.status(201).json(newLocation);
    } catch (error) {
        res.status(500).json({ message: 'Error adding location', error });
    }
};

exports.getLocationByDateRange = async (req, res) => {
    const { userId } = req.params;
    const { startDate, endDate } = req.query;

    if (!startDate || !endDate) {
        return res.status(400).json({ message: 'Please provide both startDate and endDate.' });
    }

    try {
        // Fetch locations within the date range
        const locations = await Location.find({
            userId,
            timestamp: {
                $gte: new Date(startDate),
                $lte: new Date(endDate),
            },
        }).sort({ timestamp: 1 });

        if (!locations.length) {
            console.log("No locations found for the given date range.")
            return res.status(200).json([]);
        }

        // Filter locations where user stayed for 10+ minutes within a 20-meter radius
        const groupedLocations = [];
        let stayGroup = [];
        let startTime = null;

        for (let i = 0; i < locations.length; i++) {
            const currentLocation = locations[i];

            // If the stayGroup is empty, start a new group
            if (!stayGroup.length) {
                stayGroup.push(currentLocation);
                startTime = new Date(currentLocation.timestamp);
                continue;
            }

            // Calculate the distance between the last location in the group and the current location
            const lastLocation = stayGroup[stayGroup.length - 1];
            const distance = haversineDistance(
                lastLocation.latitude,
                lastLocation.longitude,
                currentLocation.latitude,
                currentLocation.longitude
            );

            // Check if the user stayed within a 20-meter radius
            if (distance <= 20) {
                stayGroup.push(currentLocation);
            } else {
                // Calculate the time difference between the first and last location in the group
                const endTime = new Date(lastLocation.timestamp);
                const duration = (endTime - startTime) / (1000 * 60); // Duration in minutes

                // If the user stayed for 10+ minutes, add the group to groupedLocations
                if (duration >= 10) {
                    groupedLocations.push({
                        startLocation: stayGroup[0],
                        endLocation: lastLocation,
                        duration: `${duration.toFixed(2)} minutes`,
                        locations: stayGroup,
                    });
                }

                // Reset the stayGroup and startTime for the next group
                stayGroup = [currentLocation];
                startTime = new Date(currentLocation.timestamp);
            }
        }

        // Check the last group after exiting the loop
        if (stayGroup.length > 1) {
            const lastLocation = stayGroup[stayGroup.length - 1];
            const endTime = new Date(lastLocation.timestamp);
            const duration = (endTime - startTime) / (1000 * 60);

            if (duration >= 10) {
                groupedLocations.push({
                    startLocation: stayGroup[0],
                    endLocation: lastLocation,
                    duration: `${duration.toFixed(2)} minutes`,
                    locations: stayGroup,
                });
            }
        }

        let result = []
        groupedLocations.forEach(item => {
            result.push({
                startLocation: item.startLocation,
                endLocation: item.endLocation,
                duration: item.duration
            })
        })
        res.status(200).json(result);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching location data', error });
    }
};