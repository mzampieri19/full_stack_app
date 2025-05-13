/**
 * @fileoverview Routes for sending queries to the Gemini API
 * @description This file defines the routes for sending queries to the Gemini API and saving the response to the database.
 */

const express = require('express');
const multer = require('multer');
const { sendQuery } = require('../controllers/aiController');

const router = express.Router();
const upload = multer({ dest: 'uploads/' });

router.post('/gemini/', upload.single('file'), sendQuery);

module.exports = router;