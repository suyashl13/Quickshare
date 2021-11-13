const mongoose = require('mongoose')

const TransactionSchema = new mongoose.Schema({
    file_path: {
        type: String,
        required: true,
    },
    title: {
        type: String,
        required: true,
    },
    description: {
        type: String,
    },
    sender: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
        required: true
    },
    reciever: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "user",
        required: true
    },
    is_rejected: {
        type: Boolean,
        default: false
    },
    is_expired: {
        type: Boolean,
        default: false
    },
    status: {
        type: String,
    }
}, { timestamps: true })

module.exports = Transaction = mongoose.model('transaction', TransactionSchema)