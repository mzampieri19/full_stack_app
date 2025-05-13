/**
 * @fileoverview Routes for messages
 * @description This file defines the routes for message-related operations, including fetching messages between two users and posting a new message.
 */

console.log('Loading messageRoutes...');
const express = require('express');
console.log('Express module loaded');
const { getMessagesBetweenUsers, postMessage } = require('../controllers/messageController');
console.log('Message controller loaded');

const router = express.Router();
console.log('Router initialized');

router.get('/:user1/:user2', getMessagesBetweenUsers);
router.post('/', postMessage);
console.log('Routes defined');
module.exports = router;
console.log('Message routes module exported');