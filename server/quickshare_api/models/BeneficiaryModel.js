const mongoose = require('mongoose')

const BeneficiarySchema = new mongoose.Schema({
    user: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    },
    beneficiary: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
    }
}, { timestamps: true })

module.exports = Beneficiary = mongoose.model('beneficiary', BeneficiarySchema)
