const express = require('express');
console.log('Express module loaded');

const cors = require('cors');
console.log('CORS module loaded');

const dotenv = require('dotenv');
console.log('Dotenv module loaded');

const authRoutes = require('./routes/authRoutes');
console.log('Auth routes loaded');

const messageRoutes = require('./routes/messageRoutes');
console.log('Message routes loaded');

const userRoutes = require('./routes/userRoutes');
console.log('User routes loaded');

const aiRoutes = require('./routes/aiRoutes');
console.log('AI routes loaded');

const app = express();
console.log('Express app initialized');

app.use(express.json());
console.log('JSON middleware added');

app.use(cors());
console.log('CORS middleware added');

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// Routes
app.use('/auth', authRoutes);
console.log('Auth routes mounted');

app.use('/messages', messageRoutes);
console.log('Message routes mounted');

app.use('/users', userRoutes);
console.log('User routes mounted');

app.use('/gemini', aiRoutes);
console.log('AI routes mounted');

module.exports = app;
console.log('App module exported');