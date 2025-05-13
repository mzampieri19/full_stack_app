const mongoose = require('mongoose');

/**
 * GeminiResponse Schema
 * This schema defines the structure of the GeminiResponse document in MongoDB.
 * It includes fields for response, query, model, date, sender, and sender_email.
 */
const GeminiResponseSchema = new mongoose.Schema({
    response: { type: String, required: true },
    query: { type: String, required: true },
    model: { type: String, required: true },
    date: { type: Date, default: Date.now },
    sender: { type: String, required: true },
    sender_email: { type: String, required: true },
});

module.exports = mongoose.model('GeminiResponse', GeminiResponseSchema);