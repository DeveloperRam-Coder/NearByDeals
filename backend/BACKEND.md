# Local Offer App – Backend

## Overview
A Node.js + Express backend providing RESTful APIs for the Local Offer App. Handles authentication, offer management, feedback, image uploads, and geolocation queries.

## Core API Endpoints
### Auth
- `POST /api/auth/signup` — Register user
- `POST /api/auth/login` — Obtain JWT token

### Offers
- `GET /api/offers?lat=&lng=&radius=&filters...` — List nearby offers
- `POST /api/offers` — Create new offer (seller)
- `GET /api/offers/{id}` — Offer details
- `PUT /api/offers/{id}` — Update offer
- `DELETE /api/offers/{id}` — Remove offer

### Feedback
- `POST /api/offers/{id}/feedback` — Submit rating & comment
- `GET /api/offers/{id}/feedback` — List feedback

### Images
- `POST /api/offers/{id}/images` — Upload images

## Tech Stack
- **Node.js + Express**
- **JWT** for authentication
- **Cloud Storage** (S3/Firebase Storage) for images
- **Geo-queries** (PostgreSQL/PostGIS or MongoDB)
- **CI/CD**: GitHub Actions
- **Hosting**: AWS Elastic Beanstalk / Heroku

## Security & Performance
- HTTPS for all endpoints
- Input validation & sanitization
- Rate limiting & JWT verification
- Fast geo-queries for nearby offers

## Future Enhancements
- Microservices for scalability
- Real-time chat API
- Admin moderation endpoints

---
*See frontend and database docs for integration and data model details.*
