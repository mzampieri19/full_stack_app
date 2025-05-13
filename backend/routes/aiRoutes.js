/**
 * @fileoverview Routes for sending queries to the Gemini API
 * @description This file defines the routes for sending queries to the Gemini API and saving the response to the database.
 */

const express = require('express');
const { sendQuery } = require('../controllers/aiController');

const router = express.Router();

router.post('gemini', sendQuery);

module.exports = router;