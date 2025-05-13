/**
 * @fileoverview Controller for sending queries to the Gemini API
 * @description This file contains the controller function for sending queries to the Gemini API and saving the response to the database.
 */
const GeminiResponse = require('../models/GeminiResponse');
const fs = require('fs');
const path = require('path');

/**
 * Send a query to the Gemini API and save the response to the database
 * @param {*} req 
 * @param {*} res 
 * @returns {Promise<void>}
 */
exports.sendQuery = async (req, res) => {
    const { query, date, sender, email, fileData} = req.body;
    debugPrint('Received request body:', req.body);
    if (!query || !date || !sender || !email) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    const API_KEY = process.env.GEMINI_API_KEY;
    const ai = new GoogleGenAI({ apiKey: API_KEY });
    console.log('GoogleGenAI initialized');

    try {
        const response = await ai.models.generateContent({
            model: "gemini-2.0-flash",
            contents: "Explain how AI works in a few words",
        });
        console.log(response.text);

        const geminiResponse = new GeminiResponse({
            response: response.data,
            query: query,
            model: 'Gemini',
            date: date,
            sender: sender,
            sender_email: email,
            fileData: fileData ? fs.readFileSync(fileData) : null, // Read file data if provided
        });

        await geminiResponse.save();
        console.log('Response saved to database:', geminiResponse);
        res.status(200).json({ message: 'Response saved to database', response: geminiResponse });

        return response.data;
    } catch (error) {
        console.error('Error sending query to Gemini API:', error);
        return res.status(500).json({ error: 'Error sending query to Gemini API' });
    }
};