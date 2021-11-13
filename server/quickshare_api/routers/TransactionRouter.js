const transactionRouter = require('express').Router()
const passport = require('passport')
const { transactionUpload } = require('../config/file_upload_configs/MulterConfig')
const Transaction = require('../models/TransactionModel')
const User = require('../models/UserModel')

transactionRouter.get('/', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (!req.user.is_verified) { return res.status(400).json({ err: 'User not verified.' }) }
    Transaction.find({ user: req.user._id })
        .populate('sender', ['username', 'name', 'profile_photo'])
        .populate('reciever', ['username', 'name', 'profile_photo'])
        .then(e => {
            return res.json(e)
        }).catch(err => {
            res.status(500).json({ err: err.message });
        })
})

transactionRouter.post('/', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (!req.user.is_verified) { return res.status(400).json({ err: 'User not verified.' }) }
    transactionUpload(req, res, (err) => {
        if (err) {
            return res.status(500).json({ err: err.message });
        } else {
            User.findOne({ username: req.body.receiver }).then((rcvr) => {
                if (!rcvr) {
                    return res.status(400).json({ err: 'Invalid reciver username.' });
                } else {

                    if (req.user._id.toString() == rcvr._id.toString()) {
                        return res.status(400).json({ err: '' });
                    }

                    new Transaction({
                        file_path: `transactions/${req.file.filename}`,
                        sender: req.user._id,
                        reciever: rcvr._id,
                        description: req.body.description,
                        title: req.body.title,
                        status: 'Available'
                    })
                        .save()
                        .then((e) => {
                            return res.json(e);
                        }).catch((err) => {
                            return res.status(400).json({ err: err.message })
                        })
                }
            }).catch((err) => {
                console.log(err)
                return res.status(400).json({ err: err.message })
            })
        }
    });
})

module.exports = transactionRouter
