# Local Offer App – Database

## Overview
Database schema for the Local Offer App, supporting geo-queries, user roles, offers, images, and feedback.

## Main Entities
### User
- UserID (PK)
- Name
- Role (Buyer/Seller)
- Email
- Phone
- ProfilePic
- Location (GeoPoint)

### Offer
- OfferID (PK)
- SellerID (FK → User)
- Title
- Description
- Price
- Discount
- StartDate
- EndDate
- Location (GeoPoint)
- Category
- CreatedAt

### Image
- ImageID (PK)
- OfferID (FK → Offer)
- URL

### Feedback
- FeedbackID (PK)
- OfferID (FK → Offer)
- BuyerID (FK → User)
- Rating (1–5)
- Comment
- CreatedAt

## Tech Stack
- **PostgreSQL** (with PostGIS) or **MongoDB** (with GeoJSON)
- **Cloud Storage** for images

## Geo-Query Example
- Find offers within X km of (lat, lng):
  - PostgreSQL: `ST_DWithin(location, ST_MakePoint(lng, lat)::geography, radius_meters)`
  - MongoDB: `{ location: { $near: { $geometry: { type: "Point", coordinates: [lng, lat] }, $maxDistance: radius_meters } } }`

## Future Enhancements
- Add order/payment tables
- Analytics tables for seller stats
- Moderation logs

---
*See backend and frontend docs for API and usage details.*
