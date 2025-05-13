/**
 * @fileoverview The main application file
 * @description This file sets up the Express application, middleware, and routes.
 * It imports the necessary modules, configures middleware for JSON parsing and CORS, and defines routes for authentication, messages, and users.
 * The application is exported for use in the server file.
 */

const express = require('express');
const cors = require('cors');
const axios = require('axios');
const dotenv = require('dotenv');
const authRoutes = require('./routes/authRoutes');
const messageRoutes = require('./routes/messageRoutes');
const userRoutes = require('./routes/userRoutes');
const aiRoutes = require('./routes/aiRoutes');

const app = express();

app.use(express.json());
app.use(cors());

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// Routes
app.use('/auth', authRoutes);
app.use('/messages', messageRoutes);
app.use('/users', userRoutes);
app.use('/gemini', aiRoutes);

module.exports = app;