/**
 * @fileoverview: This file sets up the Express server, connects to MongoDB, and defines the API routes.
 * It uses the dotenv package to load environment variables, cors for cross-origin resource sharing,
 * and mongoose for MongoDB object modeling.
 * @description: The server listens on a specified port and handles incoming requests to various routes.
 * The routes include authentication, messages, users, AI responses, and chat rooms.
 */

import { initializeApp } from 'firebase/app';
import { getDatabase } from 'firebase/database';

const firebaseConfig = {
    apiKey: process.env.FIREBASE_API_KEY,
    authDomain: process.env.FIREBASE_AUTH_DOMAIN,
    projectId: process.env.FIREBASE_PROJECT_ID,
    storageBucket: process.env.FIREBASE_STORAGE_BUCKET,
    messagingSenderId: process.env.FIREBASE_MESSAGING_SENDER_ID,
    appId: process.env.FIREBASE_APP_ID,
    measurementId: process.env.FIREBASE_MEASUREMENT_ID
}

const app = initializeApp(firebaseConfig);
export const database = getDatabase(app);