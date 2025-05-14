/**
 * @fileoverview Routes for authentication
 * @description This file defines the routes for user authentication, specifically the signup route.
 */

console.log('Loading authRoutes...');
import express from 'express'
console.log('Express module loaded');
import { signup, confirm_signup, login } from '../controllers/authController.js'; // Ensure the .js extension is included
console.log('Auth controller loaded');

const router = express.Router();

router.post('/signup', signup);
router.post('/confirm', confirm_signup);
router.post('/login', login);

export default router;