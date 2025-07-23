import express from 'express';
import { auth, requireRole } from '../middleware/auth';
import {
  createOffer,
  getNearbyOffers,
  getOfferById,
  updateOffer,
  deleteOffer
} from '../controllers/offerController';

const router = express.Router();

// Public routes
router.get('/', getNearbyOffers);
router.get('/:id', getOfferById);

// Protected routes (sellers only)
router.post('/', auth, requireRole('Seller'), createOffer);
router.put('/:id', auth, requireRole('Seller'), updateOffer);
router.delete('/:id', auth, requireRole('Seller'), deleteOffer);

export default router;
