import mongoose from 'mongoose';
/**
 * Advice Schema
 * This schema defines the structure of the Advice document in MongoDB.
 * It includes fields for query, response, model, and date.
 */
const AdviceSchema = new mongoose.Schema({
    query: { type: String, required: true },
    response: { type: Object, required: true },
    model: { type: String },
    date: { type: Date, required: true },
});

export default mongoose.model('Advice', AdviceSchema);