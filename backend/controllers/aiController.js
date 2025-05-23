/**
 * @fileoverview Controller for sending queries to the Gemini API
 * @description This file contains the controller function for sending queries to the Gemini API and saving the response to the database.
 */
import GeminiResponse from '../models/GeminiResponse.js';
import Advice from '../models/Advice.js';
import { GoogleGenAI } from "@google/genai";

/**
 * @function sendQuery
 * @description Sends a query to the Gemini API and saves the response to the database.
 * @param {Object} req - The request object containing the query and other parameters.
 * @param {Object} res - The response object to send the result back to the client.
 */
export const sendQuery = async (req, res) => {
    const { query, date, sender, sender_email, fileData } = req.body;

    if (!query || !date || !sender || !sender_email) {
        console.log('Validation failed. Missing fields:');
        if (!query) console.log('query is missing');
        if (!date) console.log('date is missing');
        if (!sender) console.log('sender is missing');
        if (!sender_email) console.log('sender_email is missing');
        return res.status(400).json({ error: 'Missing required fields' });
    }
    try {
        const API_KEY = process.env.GEMINI_API_KEY;
        const ai = new GoogleGenAI({vertexai: false, apiKey: API_KEY});
        const response = await ai.models.generateContent({ 
            model: 'gemini-2.0-flash',
            contents: query 
        });

        const textContent = response.candidates[0].content;
        const newResponse = new GeminiResponse({
            query,
            response: textContent,
            model: response.modelVersion,
            date,
            sender,
            sender_email: sender_email,
        });

        await newResponse.save();
        res.status(200).json({
            message: 'Response saved successfully',
            generatedContent: response.candidates[0].content,
        });
    } catch (error) {
        console.error('Error saving response to database:', error);
        res.status(500).json({ error: 'Error saving response to database' });
    }
};

/**
 * @function getGeminiResponses
 * @description Fetches all responses from the database and sends them back to the client.
 * @param {Object} req - The request object.
 * @param {Object} res - The response object to send the result back to the client.
 */
export const getGeminiResponses = async (req, res) => {
    try {
        const responses = await GeminiResponse.find().sort({ date: -1 });
        res.status(200).json(responses);
    } catch (error) {
        console.error('Error fetching responses:', error);
        res.status(500).json({ error: 'Error fetching responses' });
    }
};

/**
 * @function getGeminiResponseById
 * @description Fetches a specific response by ID from the database and sends it back to the client.
 * @param {Object} req - The request object containing the ID of the response to fetch.
 * @param {Object} res - The response object to send the result back to the client.
 */
export const generateEncouragement = async (req, res) => {
    try {
        const API_KEY = process.env.GEMINI_API_KEY;
        const ai = new GoogleGenAI({ vertexai: false, apiKey: API_KEY });

        // Generate content using the Gemini API
        const response = await ai.models.generateContent({
            model: 'gemini-2.0-flash',
            contents: "Generate a motivational quote for a physical therapist to send to a patient."
        });

        const textContent = response.candidates[0].content;

        // Save the generated encouragement to the database
        const encouragementResponse = new Advice({
            query: "Generate a motivational quote for a physical therapist to send to a patient. Respond with only the quote and nothing else.",
            response: textContent,
            model: response.modelVersion,
            date: new Date(),
        });
        await encouragementResponse.save();

        // Send the response back to the client
        res.status(200).json({
            message: 'Encouragement fetched successfully',
            generatedContent: textContent,
        });
    } catch (error) {
        console.error('Error fetching encouragement:', error);
        res.status(500).json({ error: 'Error fetching encouragement' });
    }
};

/**
 * @function getGeminiResponseById
 * @description Fetches a specific response by ID from the database and sends it back to the client.
 * @param {Object} req - The request object containing the ID of the response to fetch.
 * @param {Object} res - The response object to send the result back to the client.
 */
export const getEncouragement = async (req, res) => {
    try {
        const count = await Advice.countDocuments();
        const randomIndex = Math.floor(Math.random() * count);
        const randomAdvice = await Advice.findOne().skip(randomIndex);
        if (randomAdvice && randomAdvice.response && randomQuote.response.parts) {
            res.join(randomAdvice);
        } else {
            res.status(404).json({ error: "No parts found in the response" });
        }
    } catch (error) {
        console.error('Error fetching encouragement:', error);
    }
}