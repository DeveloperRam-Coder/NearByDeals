# Local Offer App – Frontend (Flutter)

## Overview
A mobile application built with Flutter to connect local sellers and buyers for time-limited offers. The app provides real-time discovery, filtering, and direct communication between users.

## Key Features
- **Authentication**: Email/phone signup & login for buyers and sellers.
- **Role Selection**: Buyer or Seller onboarding.
- **Home Feed (Buyer)**: List of live offers sorted by time and proximity, with filters and search.
- **Offer Details**: Images, description, price, map, contact, and feedback.
- **Create/Edit Offer (Seller)**: Form with validation, image picker, map picker, date-picker.
- **Seller Dashboard**: Manage offers, view stats and feedback.
- **Profile & Settings**: Edit info, manage notifications, logout.
- **In-app Messaging/Contact**: Chat or call vendor.
- **Feedback & Ratings**: Buyers rate and comment, sellers respond.

## Main Screens
- Onboarding & Auth
- Home (Buyer)
- Offer Details
- Create Offer (Seller)
- Seller Dashboard
- Profile & Settings

## Tech Stack
- **Flutter** (Dart)
- **Google Maps SDK** / Mapbox
- **Firebase Cloud Messaging** (Push Notifications)
- **JWT** for authentication
- **REST API** integration
- **Cloud Storage** for images

## Navigation Flow
1. Onboarding → Role Selection → Auth
2. Buyer: Home → Offer Details → Contact/Feedback
3. Seller: Dashboard → Create/Edit Offer → View Feedback

## Future Enhancements
- In-app payments
- Real-time chat
- Analytics dashboard
- Admin portal

---
*See backend and database docs for API and data model details.*
