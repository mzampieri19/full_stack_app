/**
 * @fileoverview MongoDB connection configuration
 * @description This file establishes a connection to the MongoDB database using Mongoose.
 * It imports the Mongoose library and the MongoDB URI from the environment variables.
 * The connection is established using the `connectDB` function, which is exported for use in other parts of the application.
 */

import mongoose from 'mongoose'
import {MONGO_URI} from '../config/env.js';

const connectDB = async () => {
  try {
    await mongoose.connect(MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    });
    console.log('MongoDB connected');
  } catch (err) {
    console.error('MongoDB connection error:', err);
    process.exit(1);
  }
};

export default connectDB;