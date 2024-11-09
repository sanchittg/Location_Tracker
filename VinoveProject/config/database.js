// now in this file we will connect node.js with database

const mongoose = require('mongoose');

const dbConnect = () => {
    mongoose.connect(process.env.DATABASE_URL, {
        useNewUrlParser: true,
        useUnifiedTopology: true
    })
        .then(() => { console.log("Connection successfull") })
        .catch((error) => {
            console.log("Revieve an error");
            console.error(error.message);
            process.exit(1);
        });
}

module.exports = dbConnect;