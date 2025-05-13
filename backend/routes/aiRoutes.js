const express = require('express');
const { sendQuery } = require('../controllers/aiController');

const router = express.Router();

router.post('gemini', sendQuery);

module.exports = router;