/**
 * @fileoverview Index file for the backend server
 * @description This file serves as the entry point for the backend server. It imports the necessary modules, connects to the database, and starts the server.
 */

import app from './app.js'; // Ensure the .js extension is included
import dotenv from 'dotenv';
import connectDB from './config/db.js'; // Import the database connection function

connectDB(); // Establish MongoDB connection
app.listen(PORT, '0.0.0.0', () => console.log(`Server running on port ${PORT}`));