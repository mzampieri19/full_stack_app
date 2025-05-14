import mongoose from 'mongoose';
/**
 * GeminiResponse Schema
 * This schema defines the structure of the GeminiResponse document in MongoDB.
 * It includes fields for response, query, model, date, sender, and sender_email.
 */
const GeminiResponseSchema = new mongoose.Schema({
    query: { type: String, required: true },
    response: { type: String, required: true },
    model: { type: String },
    date: { type: String, required: true },
    sender: { type: String, required: true },
    sender_email: { type: String, required: true },
});

export default mongoose.model('GeminiResponse', GeminiResponseSchema);