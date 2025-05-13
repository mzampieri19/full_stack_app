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
exports.sendQuery = async (req , res) => {
    const {query, date, sender, sender_email} = req.body;
    const file = req.file;
    // emsures that the request body contains all required fields
    if ((!query || !date || !sender || !sender_email) && !file) {
        debugPrint('Missing required fields in request body');
        return res.status(400).json({ error: 'Please provide all required fields' });
    }
    // Try to generate a response using the Gemini API
    try {
        let fileData = null;
        if (file) {
          fileData = fs.readFileSync(file.path); // Read file content
          fs.unlinkSync(file.path); // Delete file after reading
        }    
        // Import the Gemini API client
        client = genai.Client(api_key=process.env.GEMINI_API_KEY);
        // Generate a response using the Gemini API
        response = client.models.generate_content(
                    model="gemini-2.0-flash", 
                    contents=`Based on the following patient report, please provide a at home patient care report: ${query}`
                );  res.status(200).json({ response: response });
        // Save the response to the database
        const geminiRes = new GeminiResponse({
            response,
            query,
            model,
            date,
            sender,
            sender_email,
            fileData
        });
        await geminiRes.save();
        res.status(200).json({ message: 'Response saved successfully', geminiRes });
    } catch (error) {
        console.error('Error generating response:', error);
        res.status(500).json({ error: 'Failed to generate response' });
    }
}