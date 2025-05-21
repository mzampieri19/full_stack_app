import express from 'express';
import {
  createRoom,
  saveOffer,
  getOffer,
  saveAnswer,
  getAnswer,
  addCandidate,
  getCandidates,
} from '../controllers/roomController.js';

const router = express.Router();

router.post('/', createRoom);
router.post('/rooms', createRoom);
router.post('/:roomId/offer', saveOffer);
router.get('/:roomId/offer', getOffer);
router.post('/:roomId/answer', saveAnswer);
router.get('/:roomId/answer', getAnswer);
router.post('/:roomId/candidate', addCandidate);
router.get('/:roomId/candidates', getCandidates);

export default router;