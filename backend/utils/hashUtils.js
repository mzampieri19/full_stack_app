/**
 * @fileoverview Utility functions for generating a secret hash
 * @description This file contains utility functions for generating a secret hash using HMAC SHA256.
 */

const crypto = require('crypto');

/**
 * Generates a secret hash using HMAC SHA256.
 * @param {string} username - The username of the user.
 * @param {string} clientId - The client ID of the application.
 * @param {string} clientSecret - The client secret of the application.
 * @returns {string} - The generated secret hash in base64 format.
 */
const generateSecretHash = (username, clientId, clientSecret) => {
  const message = username + clientId;
  const hmac = crypto.createHmac('SHA256', clientSecret);
  hmac.update(message);
  return hmac.digest('base64');
};

module.exports = { generateSecretHash };