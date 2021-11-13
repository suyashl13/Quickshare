const beneficiaryRouter = require('express').Router()
const passport = require('passport');
const Beneficiary = require('../models/BeneficiaryModel');
const User = require('../models/UserModel');


beneficiaryRouter.get('/', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (!req.user.is_verified) { return res.status(400).json({ err: 'User not verified.' }) }
    Beneficiary.find({ user: req.user })
        .populate({ path: 'beneficiary', select: ['username', 'name', 'profile_photo'] })
        .then(benf => res.json({ beneficiaries: benf }))
        .catch(err => res.json({ err: err.message }))
});

beneficiaryRouter.get('/:username', passport.authenticate('jwt', { session: false }),
    (req, res) => {
        const { username: search_usr } = req.params

        User.find({ username: { $regex: search_usr } })
            .select(['-password', '-updatedAt'])
            .then(usr => {
                const response = usr.map(val => {
                    delete val.password
                    return val
                })
                return res.json(response)
            }).catch(err => res.json({ err: err.message }))
    }
)

beneficiaryRouter.post('/', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (!req.user.is_verified) { return res.status(400).json({ err: 'User not verified.' }) }

    User.findOne({ username: req.body.username })
        .select(['-password', '-updatedAt'])
        .then(usr => {
            if (!usr) {
                return res.status(404).json({ err: "No user found with associated username." })
            } else {
                Beneficiary.findOne({
                    user: req.user._id,
                    beneficiary: usr._id
                }).then(benfEvent => {
                    if (benfEvent) {
                        return res.status(400).json({ err: 'Beneficiary already exsists.' })
                    } else {
                        if (!usr.is_verified) {
                            return res.status(400).json({ err: 'Beneficiary is not verified.' });
                        }
                        new Beneficiary({
                            user: req.user._id,
                            beneficiary: usr._id
                        })
                            .save()
                            .then(e => {
                                e.beneficiary = usr
                                return res.json(e)
                            }).catch(err => res.json({ err: err.message }))
                    }
                }).catch(err => res.json({ err: err.message }))
            }
        }).catch(err => res.json({ err: err.message }))
})

module.exports = beneficiaryRouter