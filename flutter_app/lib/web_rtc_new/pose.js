/**
 * @fileoverview: This file sets up the Express server, connects to MongoDB, and defines the API routes.
 * It uses the dotenv package to load environment variables, cors for cross-origin resource sharing,
 * and mongoose for MongoDB object modeling.
 * @description: The server listens on a specified port and handles incoming requests to various routes.
 * The routes include authentication, messages, users, AI responses, and chat rooms.
 */

import { localVideo, remoteVideo, localCanvas, remoteCanvas } from './elements.js';

/**
 * Starts the local camera and initializes the pose detection.
 * @returns {Promise<void>}
 */
export function startLocalPose() {
  console.log('Starting local pose...');

  localPose = new Pose({
    locateFile: f => `https://cdn.jsdelivr.net/npm/@mediapipe/pose/${f}`
  });
  localPose.setOptions({
    modelComplexity: 1,
    smoothLandmarks: true,
    minDetectionConfidence: 0.5,
    minTrackingConfidence: 0.5
  });
  localPose.onResults(r => drawResults(r, localCanvas));

  localCamera = new Camera(localVideo, {
    onFrame: async () => await localPose.send({ image: localVideo }),
    width: 480, height: 360
  });
  localCamera.start();
}

/**
 * Starts the remote pose detection.
 * @returns {Promise<void>}
 */
export function startRemotePose() {
 console.log('Starting remote pose...');

  remoteVideo.onloadedmetadata = () => {
    console.log('Remote video metadata loaded');

    remoteCanvas.width  = remoteVideo.videoWidth;
    remoteCanvas.height = remoteVideo.videoHeight;
  };

  remotePose = new Pose({
    locateFile: f => `https://cdn.jsdelivr.net/npm/@mediapipe/pose/${f}`
  });
  remotePose.setOptions({
    modelComplexity: 1,
    smoothLandmarks: true,
    minDetectionConfidence: 0.5,
    minTrackingConfidence: 0.5
  });
  remotePose.onResults(r => drawResults(r, remoteCanvas));

  remoteCamera = new Camera(remoteVideo, {
    onFrame: async () => await remotePose.send({ image: remoteVideo }),
    width: 480, height: 360
  });
  remoteCamera.start();

  console.log('Remote pose started');
}

/**
 * Draws the results of the pose detection on the canvas.
 * @param {Object} results - The results from the pose detection.
 * @param {*} results 
 * @param {*} canvas 
 */
export function drawResults(results, canvas) {
  const ctx = canvas.getContext('2d');
  ctx.save();
  ctx.clearRect(0, 0, canvas.width, canvas.height);
  ctx.drawImage(results.image, 0, 0, canvas.width, canvas.height);
  if (results.poseLandmarks) {
    drawConnectors(ctx, results.poseLandmarks, Pose.POSE_CONNECTIONS, {
      color: '#00FF00', lineWidth: 2
    });
    drawLandmarks(ctx, results.poseLandmarks, {
      color: '#FF0000', lineWidth: 1, radius: 3
    });
  }
  ctx.restore();
}