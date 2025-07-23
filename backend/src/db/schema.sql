CREATE EXTENSION IF NOT EXISTS postgis;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role VARCHAR(10) CHECK (role IN ('Buyer', 'Seller')) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    profile_pic VARCHAR(255),
    password_hash VARCHAR(255) NOT NULL,
    location GEOGRAPHY(POINT) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE offers (
    offer_id SERIAL PRIMARY KEY,
    seller_id INTEGER REFERENCES users(user_id),
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    discount DECIMAL(5,2),
    start_date TIMESTAMP WITH TIME ZONE NOT NULL,
    end_date TIMESTAMP WITH TIME ZONE NOT NULL,
    location GEOGRAPHY(POINT) NOT NULL,
    category VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE images (
    image_id SERIAL PRIMARY KEY,
    offer_id INTEGER REFERENCES offers(offer_id),
    url VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE feedback (
    feedback_id SERIAL PRIMARY KEY,
    offer_id INTEGER REFERENCES offers(offer_id),
    buyer_id INTEGER REFERENCES users(user_id),
    rating INTEGER CHECK (rating >= 1 AND rating <= 5) NOT NULL,
    comment TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Indexes for better query performance
CREATE INDEX idx_offers_location ON offers USING GIST (location);
CREATE INDEX idx_users_location ON users USING GIST (location);
CREATE INDEX idx_offers_category ON offers(category);
CREATE INDEX idx_offers_seller ON offers(seller_id);
CREATE INDEX idx_feedback_offer ON feedback(offer_id);
CREATE INDEX idx_images_offer ON images(offer_id);
