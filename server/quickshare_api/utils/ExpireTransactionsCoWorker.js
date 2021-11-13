const fs = require('fs')
const Transaction = require('../models/TransactionModel')

function expireAndDeleteTransactions() {
    console.log("Worker Started...")
    Transaction.find().then((fileTransactions) => {
        fileTransactions.forEach((transaction, index) => {
            if (!transaction.is_expired) {
                const timeNow = Date.now()
                const fileUploadDate = new Date(transaction.createdAt).getTime();

                if ((timeNow - fileUploadDate) > (60 * 60 * 24 * 1000)) {
                    fs.unlink(`./public/${transaction.file_path}`, (err) => {
                        if (err) {
                            console.log(err)
                            console.log("Unable to delete file : " + transaction.file_path)
                        } else {
                            console.log('Deleted : ' + transaction.file_path);
                        }
                        Transaction.updateOne({ _id: transaction._id }, {
                            is_expired: true,
                            status: 'Expired',
                            file_path: '',
                        }).then(e => { })
                    })
                }
            }
        })
    }).catch(err => { console.log(err) })
}

module.exports = expireAndDeleteTransactions