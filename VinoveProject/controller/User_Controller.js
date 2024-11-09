const User = require("../Modules/user");

exports.getUser = async (req, res) => {
    try {
        console.log("--------------------")
        const users = await User.find();
        res.status(200).json(users);
    } catch (error) {
        res.status(500).json({ message: error.message });
    }
}