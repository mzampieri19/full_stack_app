# Full Stack Sandbox App

## Author: Michelangelo Zampieri

This is a full-stack application featuring real-time video chat with pose tracking, user authentication, messaging, and captcha verification. The backend is built with Node.js, Express, MongoDB, and AWS Cognito, with optional Firebase for signaling. The frontend is a cross-platform Flutter app supporting video calls, pose overlays, and messaging.

-----------------

## Features

# Backend

1. User Authentication

Sign-up, login, logout, and user management using AWS Cognito.
Secure password storage and JWT-based session management.
Middleware for protected routes and user role management.

2. Messaging System

Users can send, receive, and view messages.
Messages are stored in MongoDB with timestamps and user references.
RESTful endpoints for sending, retrieving, and deleting messages.

3. Captcha Verification

Captcha generation and verification to prevent automated bot signups/logins.
REST endpoints for captcha image generation and validation.

4. Video Room Signaling

REST API and/or Firebase Realtime Database for WebRTC signaling.
Endpoints for creating/joining rooms, exchanging SDP offers/answers, and ICE candidates.
In-memory or database-backed room management.

5. AI Integration

Endpoints for AI-powered responses (e.g., using Gemini or other AI models).
Route for generating and retrieving AI responses.
User Management

Organized RESTful routes: /api/auth, /api/messages, /api/users, /api/rooms, /api/geminiresponses.
CORS enabled for cross-origin requests from the Flutter frontend.

------------

# Frontend

1. Authentication UI

Login and sign-up screens with validation.
Captcha verification integrated into authentication flow.
Password reset and user profile management.

2. Messaging UI

Real-time chat interface for sending and receiving messages.
Message history display with timestamps and sender info.
Support for multiple chat rooms or direct messages.

3. Video Call with Pose Tracking

Join or create video rooms for real-time video chat.
Local and remote video streams displayed side by side or stacked.
Pose detection overlay on local video using ML Kit (Flutter Web) or camera plugin (mobile).
Copyable Room ID for easy sharing and joining.

4. Room Management

UI for creating and joining rooms.
Display of current Room ID with copy-to-clipboard functionality.
Feedback for room creation/joining success or errors.

5. AI Features

UI for interacting with AI-powered endpoints (e.g., chatbots, pose feedback).
Display of AI-generated responses.

6. Responsive Design

Works on mobile, tablet, and web.
Adaptive layouts for different screen sizes.

7. Error Handling and Feedback

User-friendly error messages for authentication, messaging, and video features.
Snackbars and dialogs for feedback on actions (e.g., room joined, message sent).
Installation

----------

# Prerequisites

Backend: Node.js, MongoDB, AWS Cognito (and optionally Firebase)
Frontend: Flutter SDK

# Backend Setup

Navigate to backend: `cd backend`

Install dependencies: `npm install`

Create a .env file in the backend directory with the following variables: 
`MONGO_URI=mongodb://localhost:27017/full_stack_app`
`COGNITO_REGION=your-cognito-region `
`COGNITO_CLIENT_ID=your-client-id `
`COGNITO_CLIENT_SECRET=your-client-secret `
`COGNITO_USER_POOL_ID=your-user-pool-id (Optional for Firebase signaling:) `
`FIREBASE_API_KEY=... `
`FIREBASE_AUTH_DOMAIN=... `
`FIREBASE_DATABASE_URL=... `
`FIREBASE_PROJECT_ID=... `
`FIREBASE_STORAGE_BUCKET=... `
`FIREBASE_MESSAGING_SENDER_ID=... `
`FIREBASE_APP_ID=... `
`FIREBASE_MEASUREMENT_ID=...`

Start the server: `node app.js`

# Frontend Setup

Navigate to Flutter app directory: `cd flutter_app`

Install dependencies: `flutter pub get`

Create a .env file in the Flutter app directory with your Firebase config if using Firebase signaling.

Run the app: `flutter run`

For more details on each feature, see the code and comments in the respective backend and frontend directories.