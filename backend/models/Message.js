const mongoose = require('mongoose');

/**
 * Message Schema
 * This schema defines the structure of the Message document in MongoDB.
 * It includes fields for username, message content, and the date the message was created.
 */
const messageSchema = new mongoose.Schema({
  username: { type: String, required: true },
  message: { type: String, required: true },
  date: { type: Date, required: true },
});

module.exports = mongoose.model('Message', messageSchema);