/**
 * @fileoverview Routes for sending queries to the Gemini API
 * @description This file defines the routes for sending queries to the Gemini API and saving the response to the database.
 */

import express from 'express';
import { sendQuery, getGeminiResponses, generateEncouragement, getEncouragement } from '../controllers/aiController.js';

const router = express.Router();

router.post('/', sendQuery);
router.get('/', getGeminiResponses);
router.post('/generateEncouragement', generateEncouragement);
router.get('/encouragement', getEncouragement);
export default router;