/**
 * @fileoverview Dotenv configuration
 * @description This file loads environment variables from a .env file into process.env.
 * It uses the dotenv package to read the .env file and populate the environment variables.
 * The path to the .env file is specified, and the variables are then exported for use in other parts of the application.
 */

require('dotenv').config({ path: '/Users/michelangelozampieri/Desktop/Imago/full_stack_app/flutter_app/assets/.env' });
console.log('MONGO_URI:', process.env.MONGO_URI); // Debug log

module.exports = {
  COGNITO_REGION: process.env.COGNITO_REGION,
  COGNITO_CLIENT_ID: process.env.COGNITO_CLIENT_ID,
  COGNITO_CLIENT_SECRET: process.env.COGNITO_CLIENT_SECRET,
  COGNITO_USER_POOL_ID: process.env.COGNITO_USER_POOL_ID,
  MONGO_URI: process.env.MONGO_URI,
  PORT: process.env.PORT || 3000,
};