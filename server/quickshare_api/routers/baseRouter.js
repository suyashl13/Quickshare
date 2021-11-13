const baseRouter = require('express').Router()
const authRouter = require('./AuthRouter')
const beneficiaryRouter = require('./BeneficiaryRouter')
const profileRouter = require('./ProfileRouter')
const transactionRouter = require('./TransactionRouter')

baseRouter.use('/auth', authRouter)
baseRouter.use('/beneficiary', beneficiaryRouter)
baseRouter.use('/profile', profileRouter)
baseRouter.use('/transactions', transactionRouter)

module.exports = baseRouter