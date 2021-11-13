const express = require('express')
const app = express()
const mongoose = require('mongoose')
const { mongoUrl, PORT } = require('./config/settings')
const baseRouter = require('./routers/baseRouter')
const passport = require('passport')
const morgan = require('morgan')
const expireAndDeleteTransactions = require('./utils/ExpireTransactionsCoWorker')

// Middlewares
app.use(express.urlencoded({ extended: false }))
app.use(express.json());

app.use(express.static('public'))
app.use(morgan(':method :url :status :res[content-length] - :response-time ms'))

mongoose.connect(mongoUrl)
    .then(() => console.log("Connected to database Successfully."))
    .catch(err => console.log("DB ERR " + err))


app.use(passport.initialize())
require('./config/PassportConfig')(passport)


// Routers
app.use('/api/v1', baseRouter)


setInterval(expireAndDeleteTransactions, 150000);

app.listen(PORT, () => { console.log("Server listenening on PORT : " + PORT) })