const authRouter = require('express').Router()
const bcrypt = require('bcrypt')
const jsonwt = require('jsonwebtoken')
const { secret_key, SENDGRID_API_KEY } = require('../config/settings')
const passport = require('passport')
const sgMail = require('@sendgrid/mail')
const OtpSession = require('../models/OtpSessionModel')
const { generateRandomOtp } = require('../utils/Utils')
const User = require('../models/UserModel')


sgMail.setApiKey(process.env.SENDGRID_API_KEY || SENDGRID_API_KEY)


authRouter.post('/login', (req, res) => {
    const { email, password } = req.body
    User.findOne({ email: email })
        .then((usr) => {
            if (usr) {
                bcrypt.compare(password, usr.password, (err, result) => {
                    if (err) { console.log(err); return res.status(400).json({ err: err.message }); }
                    if (result) {
                        jsonwt.sign(
                            { id: usr._id, username: usr.username }, secret_key, { expiresIn: 3600 }, (err, token) => {
                                if (err) { console.log(err); return res.status(400).json({ err: err.message }); } else
                                    return res.json({
                                        user: usr,
                                        token: "Bearer " + token
                                    })
                            })
                    } else {
                        return res.status(404).json({ err: "Incorrect password." })
                    }
                })
            } else { return res.status(400).json({ err: 'User not found' }) }
        }).catch(e => res.status(400).json({ err: e.message }))
})

authRouter.get('/generateOTPSession', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (req.user.is_verified)
        return res.status(400).json({ err: 'User already verified' })

    OtpSession.deleteMany({ user: req.user }).then(() => { });
    const otp = generateRandomOtp()
    new OtpSession({
        user: req.user._id,
        otp: otp
    }).save()
        .then(() => {
            const msg = {
                to: req.user.email,
                from: 'admin@hiresuyash.com',
                subject: 'OTP for Quickshare App',
                text: 'Here is your OTP',
                html: `Your OTP for Quickshare App is <strong>${otp}</strong>.`,
            }
            sgMail.send(msg).then(() => {
                return res.send({ msg: "Successfully sent OTP to " + req.user.email })
            }).catch((err) => {
                console.log(err)
                return res.status(500).send({ err: "Unable to send OTP to " + + req.user.email })
            })
        })
        .catch(err => {
            console.log(err)
            return res.status(500).send({ err: "Unable to send OTP to " + + req.user.email })
        })
})


authRouter.post('/verifyAccount', passport.authenticate('jwt', { session: false }), (req, res) => {
    if (req.user.is_verified)
        return res.status(400).json({ err: 'User already verified' })

    const { otp } = req.body;
    OtpSession.findOne({ otp: otp }).then((otpSession) => {
        if (!otpSession) {
            return res.status(400).json({ err: "Invalid OTP." })
        } else {
            if (otpSession.user._id.toString() == req.user._id.toString()) {
                User.findOneAndUpdate({ username: req.user.username }, { is_verified: true })
                    .then(() => res.json({
                        msg: 'User verified successfully.'
                    }))
                    .catch((_) => {
                        res.status(500).json({
                            err: 'Unable to verify user.'
                        })
                    })
                OtpSession.findByIdAndDelete(otpSession._id).then(() => { });
            } else {
                return res.status(400).json({ err: "Trying to validate invalid user" })
            }
        }
    }).catch(err => {
        console.error(err);
        res.status(500).json({ err: 'User verified successfully.' })
    })
})

module.exports = authRouter