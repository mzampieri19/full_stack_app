/**
 * @fileoverview Routes for authentication
 * @description This file defines the routes for user authentication, specifically the signup route.
 */

const express = require('express');
const { signup, confirm_signup } = require('../controllers/authController');

const router = express.Router();

router.post('/signup', signup);
router.post('/confirm', confirm_signup);

module.exports = router;