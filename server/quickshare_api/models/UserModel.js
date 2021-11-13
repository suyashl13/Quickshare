const mongoose = require('mongoose')

const UserSchema = new mongoose.Schema({
    name: {
        type: String,
    },
    username: {
        type: String,
        unique: true,
    },
    email: {
        type: String,
        unique: true,
    },
    password: {
        type: String,
        minlength: 6
    },
    profile_photo: {
        type: String
    },
    birth_year: {
        type: Number,
        required: true,
    },
    is_verified: {
        type: Boolean,
        default: false,
    },
}, { timestamps: true })

module.exports = User = mongoose.model('user', UserSchema);