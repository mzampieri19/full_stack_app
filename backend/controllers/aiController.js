

exports.sendQuery = async (req , res) => {
    const {query} req.body;
    client = genai.Client(api_key=process.env.GEMINI_API_KEY);

    if (!query) {
        return res.status(400).json({ error: 'Query is required' });
    }

    try {
        response = client.models.generate_content(
                    model="gemini-2.0-flash", 
                    contents=`Based on the following patient report, please provide a at home patient care report: ${query}`
                );  res.status(200).json({ response: response });
    } catch (error) {
        console.error('Error generating response:', error);
        res.status(500).json({ error: 'Failed to generate response' });
    }
}