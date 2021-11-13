const generateRandomOtp = () => Math.random().toString().split('.')[1].substr(0, 5);

module.exports = { generateRandomOtp }