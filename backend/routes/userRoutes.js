/**
 * @fileoverview Routes for users
 * @description This file defines the routes for user-related operations, including fetching all users and getting a specific user by username.
 */

console.log('Loading userRoutes...');
const express = require('express');
const { getAllUsers, getUserByUsername } = require('../controllers/userController');

const router = express.Router();

router.get('/', getAllUsers);

router.get('/:username', getUserByUsername);

module.exports = router;