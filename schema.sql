CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(120) UNIQUE NOT NULL,
    password_hash VARCHAR(128) NOT NULL,
    role VARCHAR(20) DEFAULT 'client' -- 'client' or 'official'
);

CREATE TABLE products (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100) NOT NULL,
    description TEXT,
    image_url VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE likes_saves (
    user_id INTEGER,
    product_id INTEGER,
    action_type VARCHAR(10), -- 'like' or 'save'
    PRIMARY KEY (user_id, product_id, action_type),
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);

CREATE TABLE follows (
    follower_id INTEGER,
    following_id INTEGER, -- Only Official Nextbuy account IDs
    PRIMARY KEY (follower_id, following_id)
);
```

---
