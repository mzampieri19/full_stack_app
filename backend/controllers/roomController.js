import { v4 as uuidv4 } from 'uuid';

// In-memory room storage (for demo only)
const rooms = {};

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

export const saveOffer = (req, res) => {
  const { roomId } = req.params;
  const { offer } = req.body;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  rooms[roomId].offer = offer;
  res.json({ success: true });
};

export const getOffer = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({ offer: rooms[roomId].offer });
};

export const saveAnswer = (req, res) => {
  const { roomId } = req.params;
  const { answer } = req.body;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  rooms[roomId].answer = answer;
  res.json({ success: true });
};

export const getAnswer = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({ answer: rooms[roomId].answer });
};

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

export const getCandidates = (req, res) => {
  const { roomId } = req.params;
  if (!rooms[roomId]) return res.status(404).json({ error: 'Room not found' });
  res.json({
    callerCandidates: rooms[roomId].callerCandidates,
    calleeCandidates: rooms[roomId].calleeCandidates,
  });
};