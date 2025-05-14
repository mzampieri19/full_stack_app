console.log('Message model loaded');
import mongoose from "mongoose";
console.log('Mongoose module loaded');

/**
 * Message Schema
 * This schema defines the structure of the Message document in MongoDB.
 * It includes fields for username, message content, and the date the message was created.
 */
const messageSchema = new mongoose.Schema({
  sender: { type: String, required: true },
  receiver: { type: String, required: true },
  sender_email: { type: String, required: true },
  reciever_email: { type: String, required: true },
  message: { type: String, required: true },
  date: { type: Date, required: true },
});

export default mongoose.model('Message', messageSchema);