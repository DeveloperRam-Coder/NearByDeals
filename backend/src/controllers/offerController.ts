import { Request, Response } from 'express';
import pool from '../config/database';

interface AuthRequest extends Request {
  user?: any;
}

export const createOffer = async (req: AuthRequest, res: Response) => {
  try {
    const { title, description, price, discount, startDate, endDate, location, category } = req.body;
    const sellerId = req.user.id;

    const result = await pool.query(
      `INSERT INTO offers 
       (seller_id, title, description, price, discount, start_date, end_date, location, category)
       VALUES ($1, $2, $3, $4, $5, $6, $7, ST_SetSRID(ST_MakePoint($8, $9), 4326), $10)
       RETURNING *`,
      [sellerId, title, description, price, discount, startDate, endDate, 
       location.longitude, location.latitude, category]
    );

    res.status(201).json(result.rows[0]);
  } catch (error) {
    console.error('Create offer error:', error);
    res.status(500).json({ message: 'Error creating offer' });
  }
};

export const getNearbyOffers = async (req: Request, res: Response) => {
  try {
    const { lat, lng, radius, category } = req.query;
    
    let query = `
      SELECT 
        o.*,
        u.name as seller_name,
        ST_X(o.location::geometry) as longitude,
        ST_Y(o.location::geometry) as latitude,
        ST_Distance(
          o.location, 
          ST_SetSRID(ST_MakePoint($1, $2), 4326)
        ) as distance
      FROM offers o
      JOIN users u ON o.seller_id = u.user_id
      WHERE o.end_date > NOW()
    `;

    const params: any[] = [lng, lat];
    
    if (radius) {
      query += ` AND ST_DWithin(
        o.location,
        ST_SetSRID(ST_MakePoint($1, $2), 4326),
        $${params.length + 1}
      )`;
      params.push(Number(radius) * 1000); // Convert km to meters
    }

    if (category) {
      query += ` AND o.category = $${params.length + 1}`;
      params.push(category);
    }

    query += ' ORDER BY distance ASC';

    const result = await pool.query(query, params);
    res.json(result.rows);
  } catch (error) {
    console.error('Get nearby offers error:', error);
    res.status(500).json({ message: 'Error fetching offers' });
  }
};

export const getOfferById = async (req: Request, res: Response) => {
  try {
    const { id } = req.params;

    const result = await pool.query(
      `SELECT 
        o.*,
        u.name as seller_name,
        ST_X(o.location::geometry) as longitude,
        ST_Y(o.location::geometry) as latitude
       FROM offers o
       JOIN users u ON o.seller_id = u.user_id
       WHERE o.offer_id = $1`,
      [id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Offer not found' });
    }

    // Get images for the offer
    const imagesResult = await pool.query(
      'SELECT * FROM images WHERE offer_id = $1',
      [id]
    );

    // Get feedback for the offer
    const feedbackResult = await pool.query(
      `SELECT f.*, u.name as buyer_name
       FROM feedback f
       JOIN users u ON f.buyer_id = u.user_id
       WHERE f.offer_id = $1`,
      [id]
    );

    const offer = {
      ...result.rows[0],
      images: imagesResult.rows,
      feedback: feedbackResult.rows
    };

    res.json(offer);
  } catch (error) {
    console.error('Get offer error:', error);
    res.status(500).json({ message: 'Error fetching offer' });
  }
};

export const updateOffer = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const sellerId = req.user.id;
    const { title, description, price, discount, startDate, endDate, location, category } = req.body;

    // Check if offer exists and belongs to seller
    const offerExists = await pool.query(
      'SELECT * FROM offers WHERE offer_id = $1 AND seller_id = $2',
      [id, sellerId]
    );

    if (offerExists.rows.length === 0) {
      return res.status(404).json({ message: 'Offer not found or unauthorized' });
    }

    const result = await pool.query(
      `UPDATE offers 
       SET title = COALESCE($1, title),
           description = COALESCE($2, description),
           price = COALESCE($3, price),
           discount = COALESCE($4, discount),
           start_date = COALESCE($5, start_date),
           end_date = COALESCE($6, end_date),
           location = CASE 
             WHEN $7 IS NOT NULL AND $8 IS NOT NULL 
             THEN ST_SetSRID(ST_MakePoint($7, $8), 4326)
             ELSE location
           END,
           category = COALESCE($9, category)
       WHERE offer_id = $10 AND seller_id = $11
       RETURNING *`,
      [title, description, price, discount, startDate, endDate, 
       location?.longitude, location?.latitude, category, id, sellerId]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Update offer error:', error);
    res.status(500).json({ message: 'Error updating offer' });
  }
};

export const deleteOffer = async (req: AuthRequest, res: Response) => {
  try {
    const { id } = req.params;
    const sellerId = req.user.id;

    const result = await pool.query(
      'DELETE FROM offers WHERE offer_id = $1 AND seller_id = $2 RETURNING *',
      [id, sellerId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'Offer not found or unauthorized' });
    }

    res.json({ message: 'Offer deleted successfully' });
  } catch (error) {
    console.error('Delete offer error:', error);
    res.status(500).json({ message: 'Error deleting offer' });
  }
};
