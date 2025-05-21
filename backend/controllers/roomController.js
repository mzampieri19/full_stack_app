/**
 * @fileoverview Controller for room management
 * @description This file contains the controller functions for creating rooms, saving offers, answers, and candidates.
 */
import { v4 as uuidv4 } from 'uuid';

// In-memory room storage (for demo only)
const rooms = {};

/**
 * Create a new room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const createRoom = (req, res) => {
  const roomId = uuidv4();
  rooms[roomId] = {
    offer: null,
    answer: null,
    callerCandidates: [],
    calleeCandidates: [],
  };
  res.json({ roomId });
};

/**
 * Get all rooms
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const saveOffer = (req, res) => {
  const { roomId } = req.params;
  const { offer } = req.body;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  rooms[roomId].offer = offer;
  res.json({ success: true });
};

/**
 * Get the offer for a room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const getOffer = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({ offer: rooms[roomId].offer });
};

/**
 * Save the answer for a room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const saveAnswer = (req, res) => {
  const { roomId } = req.params;
  const { answer } = req.body;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  rooms[roomId].answer = answer;
  res.json({ success: true });
};

/**
 * Get the answer for a room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const getAnswer = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({ answer: rooms[roomId].answer });
};

/**
 * Add a candidate to a room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const addCandidate = (req, res) => {
  const { roomId } = req.params;
  const { candidate, role } = req.body; // role: 'caller' or 'callee'
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  if (role === 'caller') {
    rooms[roomId].callerCandidates.push(candidate);
  } else {
    rooms[roomId].calleeCandidates.push(candidate);
  }
  res.json({ success: true });
};

/**
 * Get candidates for a room
 * @param {Object} req - The request object
 * @param {Object} res - The response object
 * @returns {void}
 */
export const getCandidates = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({
    callerCandidates: rooms[roomId].callerCandidates,
    calleeCandidates: rooms[roomId].calleeCandidates,
  });
};