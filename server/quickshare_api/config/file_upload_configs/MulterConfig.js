const multer = require("multer")
const path = require('path')


const storage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './public/profiles')
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname))
    }
})

const transactionStorage = multer.diskStorage({
    destination: function (req, file, cb) {
        cb(null, './public/transactions')
    },
    filename: function (req, file, cb) {
        const uniqueSuffix = Date.now() + '-' + Math.round(Math.random() * 1E9)
        cb(null, file.fieldname + '-' + uniqueSuffix + path.extname(file.originalname))
    }
})

module.exports = {
    profileUpload: multer({ storage: storage }).single('profile_photo'),
    transactionUpload: multer({ storage: transactionStorage }).single('transaction_file'),
}
