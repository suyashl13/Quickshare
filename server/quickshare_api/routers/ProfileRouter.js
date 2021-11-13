const profileRouter = require('express').Router()
const User = require('../models/UserModel')
const bcrypt = require('bcrypt')
const passport = require('passport')
const { profileUpload } = require('../config/file_upload_configs/MulterConfig')
const Beneficiary = require('../models/BeneficiaryModel')
const TransactionModel = require('../models/TransactionModel')
const { SENDGRID_API_KEY } = require('../config/settings')
const fs = require('fs')
const sgMail = require('@sendgrid/mail')

sgMail.setApiKey(process.env.SENDGRID_API_KEY || SENDGRID_API_KEY)

profileRouter.post('/', (req, res) => {
    profileUpload(req, res, (next) => {
        var profileData = req.body
        profileData.is_verified = false

        if (req.file) { profileData.profile_photo = 'profiles/' + req.file.filename } else { profileData.profile_photo = null }

        const newUser = new User({ ...profileData })
        bcrypt.hash(req.body.password, 10, (err, hash) => {
            if (err) {
                console.log(err)
                return res.status(400).json({ err: "Something went wrong..." })
            } else {
                newUser.password = hash;
                newUser
                    .save()
                    .then(usr => {
                        return res
                            .status(200)
                            .json(usr);
                    }).catch(err => {
                        if (err.code === 11000) {
                            return res.status(400).json({
                                err: 'An another user with this ' + Object.keys(err.keyValue) + ' already exists.'
                            })
                        } else
                            return res
                                .status(400)
                                .json({ err: err.message })
                    })
            }
        })
    })
})


profileRouter.post('/:uid', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (req.body.password) {
        delete req.body.password;
    }
    if (req.user._id != req.params.uid) {
        return res.status(401).json({ err: 'Unauthorized' });
    }
    profileUpload(req, res, (err) => {
        if (req.user.profile_photo) {
            fs.unlink(`./public/${req.user.profile_photo}`, (err) => { if (err) { console.log("COULD NOT DELETE : " + req.user.profile_photo) } })
            User.findOneAndUpdate({ username: req.user.username }, { ...req.body, profile_photo: 'profiles/' + req.file.filename }).then(e => {
                return res.json(e);
            }).catch((err) => {
                return res.status(500).json({ err: err });
            })
        }
    })
})

profileRouter.get('/', passport.authenticate("jwt", { session: false }), (req, res) => {

    Beneficiary.find({ user: req.user })
        .populate({ path: 'beneficiary', select: ['username', 'name', 'profile_photo'] })
        .then(benf => {
            TransactionModel.find({ $or: [{ sender: req.user._id }, { reciever: req.user._id }] })
                .populate({ path: 'reciever', select: ['username', 'name', 'profile_photo'] })
                .populate({ path: 'sender', select: ['username', 'name', 'profile_photo'] })
                .then(transactions => {
                    delete req.user.password
                    return res.json({
                        user: req.user,
                        beneficiaries: benf,
                        transactions: transactions
                    })
                }).catch(err => {
                    return res.status(500).json({ err: err.message })
                })
        }).catch(err => {
            return res.status(500).json({ err: err.message });
        })
})

module.exports = profileRouter