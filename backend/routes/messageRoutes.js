/**
 * @fileoverview Routes for messages
 * @description This file defines the routes for message-related operations, including fetching messages between two users and posting a new message.
 */

console.log('Loading messageRoutes...');
import express from 'express'
console.log('Express module loaded');
import { getMessagesBetweenUsers, postMessage } from '../controllers/messageController.js'; // Ensure the .js extension is included
console.log('Message controller loaded');

const router = express.Router();
console.log('Router initialized');

router.post('/', postMessage);
router.get('/:user1/:user2', getMessagesBetweenUsers);
console.log('Routes defined');

export default router;
console.log('Message routes module exported');