const GeminiResponseSchema = new mongoose.Schema({
    response: { type: String, required: true },
    query: { type: String, required: true },
    model: { type: String, required: true },
    date: { type: Date, default: Date.now },
    sender: { type: String, required: true },
    sender_email: { type: String, required: true },
});

module.exports = mongoose.model('GeminiResponse', GeminiResponseSchema);