/**
 * @fileoverview Controller for user authentication
 * @description This file contains the controller functions for user authentication, including sign-up and sign-in.
 * It imports the necessary modules, including the AWS SDK for Cognito, the User model, and utility functions for hashing.
 * The controller functions handle the sign-up and sign-in processes, including generating secret hashes for Cognito and saving user data to MongoDB.
 * The functions also handle error responses and send appropriate JSON responses to the client.
 */

const cognito = require('../config/aws');
console.log('Cognito SDK loaded');
const User = require('../models/User');
console.log('User model loaded');
const { generateSecretHash } = require('../utils/hashUtils');
const { COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET } = require('../config/env');

/**
 * Sign-up controller function
 * @param {Object} req - The request object containing user data
 * @param {Object} res - The response object to send the response
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the sign-up process fails
 */
exports.signup = async (req, res) => {
  const { username, password, email } = req.body;

  try {
    const secretHash = generateSecretHash(username, COGNITO_CLIENT_ID, COGNITO_CLIENT_SECRET);

    const params = {
      ClientId: COGNITO_CLIENT_ID,
      Username: username,
      Password: password,
      UserAttributes: [
        { Name: 'email', Value: email },
        { Name: 'preferred_username', Value: username },
      ],
      SecretHash: secretHash,
    };

    const cognitoResponse = await cognito.signUp(params).promise();

    const user = new User({
      username,
      password,
      email,
      cognitoSub: cognitoResponse.UserSub,
    });

    await user.save();

    res.status(200).json({ message: 'User signed up and stored in MongoDB', user });
  } catch (error) {
    console.error('Error during sign-up:', error);
    res.status(500).json({ error: error.message });
  }
};

/**
 * Sign-in controller function
 * @param {Object} req - The request object containing user credentials
 * @param {Object} res - The response object to send the response
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the sign-in process fails
 */
exports.confirm_signup = async (req, res) => {
    const { username, confirmationCode } = req.body;
  
    if (!username || !confirmationCode) {
      return res.status(400).json({ error: 'Username and confirmation code are required' });
    }
  
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
  };

/**
 * Sign-in controller function
 * @param {Object} req - The request object containing user credentials
 * @param {Object} res - The response object to send the response
 * @returns {Promise<void>} - A promise that resolves when the response is sent
 * @throws {Error} - Throws an error if the sign-in process fails
 */
exports.login = async (req, res) => {
    const { username, password } = req.body;
  
    if (!username || !password) {
      return res.status(400).json({ error: 'Username and password are required' });
    }
  
    try {
      // Generate the SECRET_HASH
      const secretHash = generateSecretHash(
        username,
        process.env.COGNITO_CLIENT_ID,
        process.env.COGNITO_CLIENT_SECRET
      );
  
      // Log in the user with AWS Cognito
      const params = {
        AuthFlow: 'ADMIN_NO_SRP_AUTH',
        ClientId: process.env.COGNITO_CLIENT_ID,
        UserPoolId: process.env.COGNITO_USER_POOL_ID,
        AuthParameters: {
          USERNAME: username,
          PASSWORD: password,
          SECRET_HASH: secretHash,
        },
      };
  
      const cognitoResponse = await cognito.adminInitiateAuth(params).promise();
  
      res.status(200).json({ message: 'User logged in successfully', cognitoResponse });
    } catch (error) {
      console.error('Error during login:', error);
      res.status(500).json({ error: error.message });
    }
}