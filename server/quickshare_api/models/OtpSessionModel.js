const { Schema, model } = require("mongoose");


const OtpSessionSchema = new Schema({
    user: {
        type: Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    otp: {
        type: String,
        maxlength: 6,
        required: true,
    },
}, { timestamps: true });

module.exports = OtpSession = model('otp_session', OtpSessionSchema)