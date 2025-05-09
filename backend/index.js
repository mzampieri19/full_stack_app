/**
 * This is a simple Node.js application that uses AWS Cognito for user authentication and MongoDB for user data storage.
 * It provides endpoints for user sign-up, log in, and confirmation.
 * The application uses Express.js for the server, Mongoose for MongoDB interaction, and AWS SDK for Cognito.
 */

// Import required modules
const express = require('express');
const AWS = require('aws-sdk');
const mongoose = require('mongoose');
const cors = require('cors');
const crypto = require('crypto');

const User = require('./models/User'); // MongoDB User model
const Message = require('./models/Message'); // MongoDB Message model

// Load environment variables from .env file
require('dotenv').config({ path: '/Users/michelangelozampieri/Desktop/full_stack_app/flutter_app/assets/.env' });

// Initialize Express app
const app = express();
app.use(express.json());
app.use(cors());

// Middleware to log requests
app.use((req, res, next) => {
  console.log(`${req.method} ${req.url}`);
  next();
});

// AWS Cognito configuration
const cognito = new AWS.CognitoIdentityServiceProvider({
  region: process.env.COGNITO_REGION,
});

// MongoDB connection
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
}).then(() => console.log('MongoDB connected'))
  .catch(err => console.error('MongoDB connection error:', err));

/**
 * User Sign-Up Endpoint
 * This endpoint allows users to sign up by providing a username, password, and email.
 * It generates a SECRET_HASH using the username, client ID, and client secret, and sends a sign-up request to AWS Cognito.
 */
app.post('/signup', async (req, res) => {
  const { username, password, email } = req.body;

  try {
    // Generate the SECRET_HASH
    const secretHash = generateSecretHash(
      username,
      process.env.COGNITO_CLIENT_ID,
      process.env.COGNITO_CLIENT_SECRET
    );

    // Sign up the user with AWS Cognito
    const params = {
      ClientId: process.env.COGNITO_CLIENT_ID,
      Username: username,
      Password: password,
      UserAttributes: [
        { Name: 'email', Value: email },
        { Name: 'preferred_username', Value: username },
      ],
      SecretHash: secretHash, // Include the SECRET_HASH
    };

    const cognitoResponse = await cognito.signUp(params).promise();

    // Store the user in MongoDB
    const user = new User({
      username,
      password,
      email,
      cognitoSub: cognitoResponse.UserSub, // Store Cognito UserSub for reference
    });

    await user.save();

    res.status(200).json({ message: 'User signed up and stored in MongoDB', user });
  } catch (error) {
    console.error('Error during sign-up:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * User Confirmation Endpoint
 * This endpoint allows users to confirm their sign-up by providing a username and confirmation code.
 */
app.post('/confirm', async (req, res) => {
  const { username, confirmationCode } = req.body;

  try {
    // Generate the SECRET_HASH
    const secretHash = generateSecretHash(
      username,
      process.env.COGNITO_CLIENT_ID,
      process.env.COGNITO_CLIENT_SECRET
    );

    // Confirm the user with AWS Cognito
    const params = {
      ClientId: process.env.COGNITO_CLIENT_ID,
      Username: username,
      ConfirmationCode: confirmationCode,
      SecretHash: secretHash,
    };

    const cognitoResponse = await cognito.confirmSignUp(params).promise();

    res.status(200).json({ message: 'User confirmed successfully', cognitoResponse });
  } catch (error) {
    console.error('Error during confirmation:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * User Login Endpoint
 * This endpoint allows users to log in by providing a username and password.
 * It generates a SECRET_HASH and sends a login request to AWS Cognito.
 */
app.post('/login', async (req, res) => {
  const { username, password } = req.body;

  try {
    // Generate the SECRET_HASH
    const secretHash = generateSecretHash(
      username,
      process.env.COGNITO_CLIENT_ID, // Client ID
      process.env.COGNITO_CLIENT_SECRET // Client Secret
    );

    // Log in the user with AWS Cognito
    const params = {
      AuthFlow: 'ADMIN_NO_SRP_AUTH',
      ClientId: process.env.COGNITO_CLIENT_ID, // Client ID
      UserPoolId: process.env.COGNITO_USER_POOL_ID, // User Pool ID
      AuthParameters: {
        USERNAME: username,
        PASSWORD: password,
        SECRET_HASH: secretHash,
      },
    };

    // Debug logs
    console.log('Login Params:', params);

    const cognitoResponse = await cognito.adminInitiateAuth(params).promise();

    res.status(200).json({ message: 'User logged in successfully', cognitoResponse });
  } catch (error) {
    console.error('Error during login:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Function to generate the SECRET_HASH
 * This function generates a HMAC SHA256 hash using the username, client ID, and client secret.
 * It is used to authenticate requests to AWS Cognito.
 * @param {*} username 
 * @param {*} clientId 
 * @param {*} ClientSecret 
 * @returns 
 */
function generateSecretHash(username, clientId, ClientSecret) {
  const message = username + clientId;
  const hmac = crypto.createHmac('SHA256', ClientSecret);
  hmac.update(message);
  return hmac.digest('base64');
}

/**
 * User Logout Endpoint
 * This endpoint allows users to log out by providing a username.
 * It generates a SECRET_HASH and sends a logout request to AWS Cognito.
 */
app.post('/logout', async (req, res) => {
  const { username } = req.body;

  try {
    // Log out the user with AWS Cognito
    const params = {
      UserPoolId: process.env.COGNITO_USER_POOL_ID,
      Username: username,
    };

    await cognito.adminUserGlobalSignOut(params).promise();

    res.status(200).json({ message: 'User logged out successfully' });
  } catch (error) {
    console.error('Error during logout:', error);
    res.status(500).json({ error: error.message });
  }
}
);

/**
 * Get All Users Endpoint
 * This endpoint retrieves all users from the MongoDB database, excluding the password field.
 */
app.get('/users', async (req, res) => {
  try {
    const users = await User.find({}, { password: 0 }); // Exclude password field
    res.status(200).json(users);
  } catch (error) {
    console.error('Error fetching users:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Get User Info Endpoint
 * This endpoint retrieves information for a specific user by username.
 */
app.get('/users/:username', async (req, res) => {
  const { username } = req.params;

  try {
    const user = await User.findOne({ username });
    if (!user) {
      return res.status(404).json({ error: 'User not found' });
    }

    res.status(200).json({
      username: user.username,
      email: user.email,
    });
  } catch (error) {
    console.error('Error fetching user details:', error);
    res.status(500).json({ error: 'Failed to fetch user details' });
  }
});


/**
 * Message Posting Endpoint
 * This endpoint allows users to post messages by providing a username, message, and date.
 * It stores the message in MongoDB.
 */
app.post('/messages', async (req, res) => {
  const { sender, receiver, sender_email, reciever_email, message, date } = req.body;

  console.log('Incoming request body:', req.body); // Log the request body for debugging

  // Validate the request body
  if (!sender || !receiver || !sender_email || !reciever_email || !message || !date) {
    console.error('Validation failed:', req.body);
    return res.status(400).json({ error: 'All fields are required' });
  }

  try {
    const newMessage = new Message({ sender, receiver, sender_email, reciever_email, message, date });
    await newMessage.save();
    console.log('Message saved successfully:', newMessage); // Log the saved message
    res.status(201).json({ message: 'Message sent successfully' });
  } catch (error) {
    console.error('Error saving message:', error); // Log the error
    res.status(500).json({ error: 'Failed to send message' });
  }
});

/**
 * Get All Messages Endpoint
 * This endpoint retrieves all messages from the MongoDB database.
 */
app.get('/messages', async (req, res) => {
  try {
    const messages = await Message.find().sort({ date: -1 }); // Sort messages by date in descending order
    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching messages:', error);
    res.status(500).json({ error: error.message });
  }
}
);

/**
 * Get User Messages Endpoint
 * This endpoint retrieves all messages for a specific user by username.
 */
app.get('/messages/:username', async (req, res) => {
  const { username } = req.params;

  try {
    const messages = await Message
      .find({ username })
      .sort({ date: -1 }); // Sort messages by date in descending order
    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching user messages:', error);
    res.status(500).json({ error: error.message });
  }
});

/**
 * Get Messages Between Two Users Endpoint
 * This endpoint retrieves all messages between two users by their usernames.
 */
app.get('/messages/:user1/:user2', async (req, res) => {
  const { user1, user2 } = req.params;

  try {
    const messages = await Message.find({ // Find messages between two users
      // Use $or to find messages where either user1 is the sender and user2 is the receiver, or vice versa
      $or: [
        { sender: user1, receiver: user2 }, // Messages sent from user1 to user2
        { sender: user2, receiver: user1 }, // Messages sent from user2 to user1
      ],
    }).sort({ date: -1 }); // Sort messages by date in descending order

    res.status(200).json(messages);
  } catch (error) {
    console.error('Error fetching user messages:', error);
    res.status(500).json({ error: error.message });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => console.log(`Server running on port ${PORT}`));


// /**
//  * @fileoverview Index file for the backend server
//  * @description This file serves as the entry point for the backend server. It imports the necessary modules, connects to the database, and starts the server.
//  */

// const app = require('./app'); // Import the Express app
// const connectDB = require('./config/db'); // Import the database connection function
// const { PORT } = require('./config/env'); // Import environment variables

// connectDB(); // Establish MongoDB connection
// app.listen(PORT, () => console.log(`Server running on port ${PORT}`));