
CREATE DATABASE IF NOT EXISTS disaster_db;
USE disaster_db;

CREATE TABLE disaster_events (
    event_id INT PRIMARY KEY,
    disaster_type VARCHAR(50),
    region VARCHAR(50),
    event_date DATE,
    severity VARCHAR(20)
);

CREATE TABLE regions (
    region_id INT PRIMARY KEY,
    region VARCHAR(50),
    population BIGINT,
    area_sq_km INT
);

CREATE TABLE impact_assessment (
    impact_id INT PRIMARY KEY,
    event_id INT,
    affected_people INT,
    economic_loss_musd DECIMAL(10,2),
    FOREIGN KEY (event_id) REFERENCES disaster_events(event_id)
);
