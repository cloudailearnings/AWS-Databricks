
CREATE DATABASE IF NOT EXISTS stock_db;
USE stock_db;

CREATE TABLE stock_prices (
    id INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    symbol VARCHAR(10),
    open_price DECIMAL(10,2),
    close_price DECIMAL(10,2),
    high_price DECIMAL(10,2),
    low_price DECIMAL(10,2),
    volume BIGINT,
    daily_return DECIMAL(10,2),
    trend VARCHAR(10)
);

CREATE INDEX idx_symbol_date ON stock_prices(symbol, date);
