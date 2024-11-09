// models/Location.js
const mongoose = require('mongoose');

const locationSchema = new mongoose.Schema({
    userId: {
        type: String,
        required: true,
    },
    _id: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        unique: true,
        auto: true
    },
    latitude: {
        type: Number,
        required: true,
    },
    longitude: {
        type: Number,
        required: true,
    },
    timestamp: {
        type: Date,
        default: Date.now,
    },
    address: {
        type: String
    }
});

const Location = mongoose.model('locations', locationSchema);
module.exports = Location
