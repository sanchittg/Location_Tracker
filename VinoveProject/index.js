const express = require('express');
const app = express();
const cors = require('cors')

let corsOptions = {
    origin: (origin, callback) => {
        callback(null, true);
    }
}



app.use(express.json()); //middleware to parse json
app.use(cors(corsOptions));

require("dotenv").config();
const PORT = process.env.PORT || 4000;

app.use(express.json());

const userRoutes = require('./routes/routes');


app.use('/api/v1', userRoutes);

app.listen(3000, () => {
    console.log("Server started successfully at port 3000");
});

const dbConnect = require("./config/database");
dbConnect();

