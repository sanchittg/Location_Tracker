const express = require('express');
const router = express.Router();


const { getUser } = require("../controller/User_Controller");
const { getLocationByDateRange } = require("../controller/Location_Controller");
const { addLocation } = require("../controller/Location_Controller");

router.get('/users', getUser);
router.get('/locations/:userId/:date-range', getLocationByDateRange);
router.post('/locations', addLocation);
module.exports = router;