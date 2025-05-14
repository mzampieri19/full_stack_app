/**
 * @fileoverview Controller for sending queries to the Gemini API
 * @description This file contains the controller function for sending queries to the Gemini API and saving the response to the database.
 */
import GeminiResponse from '../models/GeminiResponse.js';
import { GoogleGenAI } from "@google/genai";

export const sendQuery = async (req, res) => {
    const { query, date, sender, email, fileData } = req.body;

    if (!query || !date || !sender || !email) {
        return res.status(400).json({ error: 'Missing required fields' });
    }

    try {
        const API_KEY = process.env.GEMINI_API_KEY;
        const ai = new GoogleGenAI({ apiKey: API_KEY });
        const response = await ai.generateContent({ prompt: query });

        const newResponse = new GeminiResponse({
            query,
            response: JSON.stringify(response),
            model: response.modelVersion,
            date,
            sender,
            sender_email: email,
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

export const getGeminiResponses = async (req, res) => {
    try {
        const responses = await GeminiResponse.find().sort({ date: -1 });
        res.status(200).json(responses);
    } catch (error) {
        console.error('Error fetching responses:', error);
        res.status(500).json({ error: 'Error fetching responses' });
    }
};
