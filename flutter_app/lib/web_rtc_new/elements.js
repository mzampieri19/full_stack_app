/**
 * @fileoverview: This file sets up the Express server, connects to MongoDB, and defines the API routes.
 * It uses the dotenv package to load environment variables, cors for cross-origin resource sharing,
 * and mongoose for MongoDB object modeling.
 * @description: The server listens on a specified port and handles incoming requests to various routes.
 * The routes include authentication, messages, users, AI responses, and chat rooms.
 */

export const elements = {
  localVideo:      document.getElementById('localVideo'),
  remoteVideo:     document.getElementById('remoteVideo'),
  localCanvas:     document.getElementById('localCanvas'),
  remoteCanvas:    document.getElementById('remoteCanvas'),
  localContainer:  document.getElementById('localContainer'),
  remoteContainer: document.getElementById('remoteContainer'),
  createRoomBtn:   document.getElementById('createRoom'),
  joinRoomBtn:     document.getElementById('joinRoom'),
  roomIdInput:     document.getElementById('roomIdInput'),
  currentRoomEl:   document.getElementById('currentRoom'),
  togglePose:      document.getElementById('togglePose'),
};