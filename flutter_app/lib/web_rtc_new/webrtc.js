/**
 * @fileoverview: This file sets up the Express server, connects to MongoDB, and defines the API routes.
 * It uses the dotenv package to load environment variables, cors for cross-origin resource sharing,
 * and mongoose for MongoDB object modeling.
 * @description: The server listens on a specified port and handles incoming requests to various routes.
 * The routes include authentication, messages, users, AI responses, and chat rooms.
 */

import { database } from './fb.js';
import { startLocalPose, startRemotePose } from './pose.js';

const rtcConfig = { iceServers: [{ urls: 'stun:stun.l.google.com:19302' }] };
let localStream, remoteStream, peerConnection;
let callerCiQueue = [], calleeCiQueue = [];
let remotePoseStarted = false;

/**
 * Starts the local camera and initializes the pose detection.
 * @returns {Promise<void>}
 */
export async function startLocalCamera() {
  localStream = await navigator.mediaDevices.getUserMedia({ video: true, audio: true });
  elements.localVideo.srcObject = localStream;
  elements.localVideo.onloadedmetadata = () => {
    elements.localCanvas.width  = elements.localVideo.videoWidth;
    elements.localCanvas.height = elements.localVideo.videoHeight;
  };
  startLocalPose();
  elements.togglePose.addEventListener('change', () => {
    elements.localCanvas.style.display = elements.togglePose.checked ? 'block' : 'none';
  });
}

/**
 * Initializes the peer connection and sets up event handlers.
 */
function initConnection() {
  peerConnection = new RTCPeerConnection(rtcConfig);
  remoteStream = new MediaStream();
  elements.remoteVideo.srcObject = remoteStream;
  localStream.getTracks().forEach(t => peerConnection.addTrack(t, localStream));
  peerConnection.ontrack = ev => {
    ev.streams[0].getTracks().forEach(t => remoteStream.addTrack(t));
    elements.remoteContainer.style.display = 'inline-block';
    if (!remotePoseStarted) {
      startRemotePose();
      remotePoseStarted = true;
    }
  };
}

/**
 * Creates a new room and sets up the signaling process.
 * @returns {Promise<void>}
 */
export async function createRoom() {
  if (!localStream) await startLocalCamera();
  initConnection();
  const roomRef = database.ref('rooms').push();
  const roomId  = roomRef.key;
  elements.currentRoomEl.textContent = roomId;
  peerConnection.onicecandidate = e => {
    if (e.candidate) roomRef.child('callerCandidates').push(e.candidate.toJSON());
  };
  const offer = await peerConnection.createOffer();
  await peerConnection.setLocalDescription(offer);
  await roomRef.child('offer').set({ type: offer.type, sdp: offer.sdp });
  roomRef.child('answer').on('value', snap => {
    const ans = snap.val();
    if (ans && !peerConnection.currentRemoteDescription) {
      peerConnection.setRemoteDescription(ans).then(() => drainQueue(callerCiQueue));
    }
  });
  roomRef.child('calleeCandidates').on('child_added', snap => {
    const cand = snap.val();
    if (peerConnection.remoteDescription) {
      peerConnection.addIceCandidate(cand);
    } else {
      callerCiQueue.push(cand);
    }
  });
}

/**
 * Joins an existing room and sets up the signaling process.
 * @returns {Promise<void>}
 */
export async function joinRoom() {
  const roomId = elements.roomIdInput.value.trim();
  if (!roomId) return alert('Enter Room ID');
  const roomRef = database.ref(`rooms/${roomId}`);
  const roomSnap = await roomRef.once('value');
  if (!roomSnap.exists()) return alert('Room not found');
  if (!localStream) await startLocalCamera();
  initConnection();
  elements.currentRoomEl.textContent = roomId;
  peerConnection.onicecandidate = e => {
    if (e.candidate) roomRef.child('calleeCandidates').push(e.candidate.toJSON());
  };
  roomRef.child('callerCandidates').on('child_added', snap => {
    const cand = snap.val();
    if (peerConnection.remoteDescription) {
      peerConnection.addIceCandidate(cand);
    } else {
      calleeCiQueue.push(cand);
    }
  });
  const offer = roomSnap.child('offer').val();
  await peerConnection.setRemoteDescription(offer);
  const answer = await peerConnection.createAnswer();
  await peerConnection.setLocalDescription(answer);
  await roomRef.child('answer').set({ type: answer.type, sdp: answer.sdp });
  drainQueue(calleeCiQueue);
}

/**
 * Drains the ICE candidate queue and adds candidates to the peer connection.
 * @param {Array} queue - The queue of ICE candidates.
 */
function drainQueue(queue) {
  queue.forEach(c => peerConnection.addIceCandidate(c));
  queue.length = 0;
}