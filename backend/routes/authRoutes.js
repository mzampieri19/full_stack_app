/**
 * @fileoverview Routes for authentication
 * @description This file defines the routes for user authentication, specifically the signup route.
 */

console.log('Loading authRoutes...');
const express = require('express');
console.log('Express module loaded');
const { signup, confirm_signup, login } = require('../controllers/authController');
console.log('Auth controller loaded');

const router = express.Router();

router.post('/signup', signup);
router.post('/confirm', confirm_signup);
router.post('/login', login);

module.exports = router;