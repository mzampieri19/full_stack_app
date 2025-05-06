const mongoose = require('mongoose');

/**
 * User Schema
 * This schema defines the structure of the User document in MongoDB.
 * It includes fields for username, password, email, AWS Cognito UserSub, and the date the user was created.
 */
const userSchema = new mongoose.Schema({
  username: { type: String, required: true, unique: true },
  password: { type: String, required: true }, 
  email: { type: String, required: true, unique: true },
  cognitoSub: { type: String, required: true }, // AWS Cognito UserSub
  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model('User', userSchema);