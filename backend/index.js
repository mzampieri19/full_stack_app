/**
 * @fileoverview Index file for the backend server
 * @description This file serves as the entry point for the backend server. It imports the necessary modules, connects to the database, and starts the server.
 */

const app = require('./app'); // Import the Express app
const connectDB = require('./config/db'); // Import the database connection function
const { PORT } = require('./config/env'); // Import environment variables

connectDB(); // Establish MongoDB connection
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));