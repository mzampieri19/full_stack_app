/**
 * @fileoverview Controller for messages
 * @description This file contains the logic for handling message-related requests.
 * It includes functions for retrieving messages between two users and posting a new message.
 * The functions interact with the Message model to perform database operations.
 * The controller handles errors and sends appropriate JSON responses to the client.
 */
console.log('Loading messageController...');
const Message = require('../models/Message');
console.log('Message model loaded');

/**
 * Get messages between two users
 * @param {Object} req - The request object containing user IDs
 * @param {Object} res - The response object to send the response
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the message retrieval process fails
 */
exports.getMessagesBetweenUsers = async (req, res) => {
  const { user1, user2 } = req.params;

  try {
    const messages = await Message.find({
      $or: [
        { sender: user1, receiver: user2 },
        { sender: user2, receiver: user1 },
      ],
    }).sort({ date: -1 });

    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Post a new message
 * @param {Object} req - The request object containing message data
 * @param {Object} res - The response object to send the response
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the message posting process fails
 */
exports.postMessage = async (req, res) => {
  const { sender, receiver, sender_email, reciever_email, message, date } = req.body;

  if (!sender || !receiver || !sender_email || !reciever_email || !message || !date) {
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    const newMessage = new Message({ sender, receiver, sender_email, reciever_email, message, date });
    await newMessage.save();
    res.status(201).json({ message: 'Message sent successfully' });
  } catch (error) {
    console.error('Error saving message:', error);
    res.status(500).json({ error: 'Failed to send message' });
  }
};