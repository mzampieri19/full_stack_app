/**
 * @fileoverview Routes for messages
 * @description This file defines the routes for message-related operations, including fetching messages between two users and posting a new message.
 */

const express = require('express');
const { getMessagesBetweenUsers, postMessage } = require('../controllers/messageController');

const router = express.Router();

router.get('/:user1/:user2', getMessagesBetweenUsers);
router.post('/', postMessage);

module.exports = router;