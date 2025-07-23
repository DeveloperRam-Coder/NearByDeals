import { Request, Response } from 'express';
import pool from '../config/database';

interface AuthRequest extends Request {
  user?: any;
}

export const getProfile = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user.id;
    const result = await pool.query(
      `SELECT user_id, name, email, role, phone, 
       ST_X(location::geometry) as longitude,
       ST_Y(location::geometry) as latitude
       FROM users WHERE user_id = $1`,
      [userId]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ message: 'User not found' });
    }

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Get profile error:', error);
    res.status(500).json({ message: 'Error fetching profile' });
  }
};

export const updateProfile = async (req: AuthRequest, res: Response) => {
  try {
    const userId = req.user.id;
    const { name, phone, location } = req.body;

    const result = await pool.query(
      `UPDATE users 
       SET name = COALESCE($1, name),
           phone = COALESCE($2, phone),
           location = CASE 
             WHEN $3 IS NOT NULL AND $4 IS NOT NULL 
             THEN ST_SetSRID(ST_MakePoint($3, $4), 4326)
             ELSE location
           END
       WHERE user_id = $5
       RETURNING user_id, name, email, role, phone,
       ST_X(location::geometry) as longitude,
       ST_Y(location::geometry) as latitude`,
      [name, phone, location?.longitude, location?.latitude, userId]
    );

    res.json(result.rows[0]);
  } catch (error) {
    console.error('Update profile error:', error);
    res.status(500).json({ message: 'Error updating profile' });
  }
};
