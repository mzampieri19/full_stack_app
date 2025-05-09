/**
 * @fileoverview Controller for users
 * @description This file contains the logic for handling user-related requests.
 * It includes functions for retrieving all users and a specific user by username.
 * The functions interact with the User model to perform database operations.
 * The controller handles errors and sends appropriate JSON responses to the client.
 */

const User = require('../models/User');

/**
 * Get all users
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the user retrieval process fails
 */
exports.getAllUsers = async (req, res) => {
  try {
    const users = await User.find({}, { password: 0 }); // Exclude the password field
    res.status(200).json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: 'Failed to fetch users' });
  }
};

/**
 * Get user by username
 * @param {Object} req - The request object containing the username
 * @param {Object} res - The response object
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the user retrieval process fails
 */
exports.getUserByUsername = async (req, res) => {
  const { username } = req.params;

  try {
    const user = await User.findOne({ username }, { password: 0 }); // Exclude the password field
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }
    res.status(200).json(user);
  } catch (error) {
    console.error('Error fetching user:', error);
    res.status(500).json({ error: 'Failed to fetch user' });
  }
};