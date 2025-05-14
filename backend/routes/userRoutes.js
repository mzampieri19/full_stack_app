/**
 * @fileoverview Routes for users
 * @description This file defines the routes for user-related operations, including fetching all users and getting a specific user by username.
 */

console.log('Loading userRoutes...');
import express from 'express'
import { getAllUsers, getUserByUsername } from '../controllers/userController.js'; // Ensure the .js extension is included
const router = express.Router();

router.get('/', getAllUsers);

router.get('/:username', getUserByUsername);

export default router;
