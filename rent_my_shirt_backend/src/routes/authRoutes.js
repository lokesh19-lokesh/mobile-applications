const express = require('express');
const { login, verifyOTP } = require('../controllers/authController');

const router = express.Router();

router.post('/login', login);
router.post('/verify', verifyOTP);

module.exports = router;
