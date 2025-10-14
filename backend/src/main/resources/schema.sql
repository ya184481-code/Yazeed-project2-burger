IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='ingredients' AND xtype='U')
BEGIN
    CREATE TABLE ingredients (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        name VARCHAR(100) NOT NULL UNIQUE,
        category VARCHAR(50) NOT NULL,
        price DECIMAL(10,2) NOT NULL CHECK (price > 0),
        description VARCHAR(500),
        image_url VARCHAR(255),
        is_available BIT NOT NULL DEFAULT 1,
        sort_order INT
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='cart_items' AND xtype='U')
BEGIN
    CREATE TABLE cart_items (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        session_id VARCHAR(255) NOT NULL,
        ingredient_id BIGINT NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(10,2),
        total_price DECIMAL(10,2),
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='burger_layers' AND xtype='U')
BEGIN
    CREATE TABLE burger_layers (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        cart_item_id BIGINT NOT NULL,
        ingredient_id BIGINT NOT NULL,
        layer_order INT NOT NULL CHECK (layer_order > 0),
        quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
        unit_price DECIMAL(10,2),
        FOREIGN KEY (cart_item_id) REFERENCES cart_items(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='orders' AND xtype='U')
BEGIN
    CREATE TABLE orders (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_number VARCHAR(50) NOT NULL UNIQUE,
        customer_name VARCHAR(100) NOT NULL,
        customer_email VARCHAR(100),
        customer_phone VARCHAR(20),
        total_amount DECIMAL(10,2) NOT NULL CHECK (total_amount > 0),
        status VARCHAR(20) NOT NULL DEFAULT 'PENDING',
        created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
        updated_at DATETIME
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='order_items' AND xtype='U')
BEGIN
    CREATE TABLE order_items (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_id BIGINT NOT NULL,
        ingredient_id BIGINT NOT NULL,
        quantity INT NOT NULL CHECK (quantity > 0),
        unit_price DECIMAL(10,2),
        total_price DECIMAL(10,2),
        FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
    );
END;

IF NOT EXISTS (SELECT * FROM sysobjects WHERE name='order_layers' AND xtype='U')
BEGIN
    CREATE TABLE order_layers (
        id BIGINT IDENTITY(1,1) PRIMARY KEY,
        order_item_id BIGINT NOT NULL,
        ingredient_id BIGINT NOT NULL,
        layer_order INT NOT NULL CHECK (layer_order > 0),
        quantity INT NOT NULL DEFAULT 1 CHECK (quantity > 0),
        unit_price DECIMAL(10,2),
        FOREIGN KEY (order_item_id) REFERENCES order_items(id) ON DELETE CASCADE,
        FOREIGN KEY (ingredient_id) REFERENCES ingredients(id)
    );
END;

-- Indexes
CREATE INDEX idx_ingredients_category ON ingredients(category);
CREATE INDEX idx_ingredients_available ON ingredients(is_available);
CREATE INDEX idx_cart_items_session ON cart_items(session_id);
CREATE INDEX idx_cart_items_ingredient ON cart_items(ingredient_id);
CREATE INDEX idx_orders_customer_email ON orders(customer_email);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_ingredient_id ON order_items(ingredient_id);
