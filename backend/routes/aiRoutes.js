/**
 * @fileoverview Routes for sending queries to the Gemini API
 * @description This file defines the routes for sending queries to the Gemini API and saving the response to the database.
 */

import express from 'express';
import { sendQuery, getGeminiResponses } from '../controllers/aiController.js';

const router = express.Router();

// POST /geminiresponses/
router.post('/', sendQuery);

// GET /geminiresponses/
router.get('/', getGeminiResponses);

export default router;