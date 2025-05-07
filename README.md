# Full Stack App

## Author Michelangelo Zampieri

This is a full-stack application that provides user authentication, messaging functionality, and captcha verification. The backend is built with Node.js, Express, MongoDB, and AWS Cognito, while the frontend is developed using Flutter.

---

## Features

### Backend
- **User Authentication**: Sign-up, login, logout, and user management using AWS Cognito.
- **Messaging System**: Users can send and view messages stored in MongoDB.
- **Captcha Verification**: Captcha generation and verification to prevent bots.
- **RESTful API**: Exposes endpoints for user and message management.

### Frontend
- **Flutter App**: A cross-platform mobile app for user interaction.
- **User Interface**: Includes login, sign-up, captcha verification, and messaging screens.

---

## Installation

### Prerequisites
- Backend: Node.js, MongoDB, AWS Cognito
- Frontend: Flutter SDK

### Backend Setup

1. Navigate to backend
`cd backend`

2. Install dependencies 
`npm install`

3. Create a .env file in the backend directory with the following variables:
`MONGO_URI=mongodb://localhost:27017/full_stack_app`
`COGNITO_REGION=your-cognito-region`
`COGNITO_CLIENT_ID=your-client-id`
`COGNITO_CLIENT_SECRET=your-client-secret`
`COGNITO_USER_POOL_ID=your-user-pool-id`

4. Start the server
`node index.js`

### Frontend Setup
1. Navigate to Flutter app directory
`cd flutter_app`

2. Install dependencies
`flutter pub get`

3. Run the app
`flutter run`
