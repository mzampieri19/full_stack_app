/**
 * @fileoverview AWS SDK configuration for Cognito
 * @description This file sets up the AWS SDK for JavaScript with the Cognito Identity Service Provider.
 * It imports the AWS SDK and initializes the CognitoIdentityServiceProvider with the specified region.
 * The region is imported from the environment variables.
 */

console.log('Loading aws.js...');
const AWS = require('aws-sdk');
const { COGNITO_REGION } = require('./env');
console.log('AWS SDK loaded');

const cognito = new AWS.CognitoIdentityServiceProvider({
  region: COGNITO_REGION,
});

module.exports = cognito;