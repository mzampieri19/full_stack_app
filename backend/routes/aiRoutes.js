/**
 * @fileoverview Routes for sending queries to the Gemini API
 * @description This file defines the routes for sending queries to the Gemini API and saving the response to the database.
 */

const express = require('express');
const router = express.Router();
const aiController = require('../controllers/aiController');

console.log('AI routes initialized');

// Define the POST / route for /gemini
router.post('/', (req, res, next) => {
  console.log('POST /gemini route hit');
  next();
}, aiController.sendQuery);

module.exports = router;