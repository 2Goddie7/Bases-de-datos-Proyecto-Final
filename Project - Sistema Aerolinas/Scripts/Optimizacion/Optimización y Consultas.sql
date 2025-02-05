CREATE DATABASE PROYECTO_FINALs;
USE PROYECTO_FINALs;

-- CREACION DE TABLAS CON SUS RELACIONES
CREATE TABLE Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    documento_identidad VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Aeropuertos (
    aeropuerto_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL
);

CREATE TABLE Avion (
    avion_id INT AUTO_INCREMENT PRIMARY KEY,
    modelo VARCHAR(50) NOT NULL,
    capacidad INT NOT NULL,
    aerolinea VARCHAR(100) NOT NULL
);

CREATE TABLE Vuelos (
    vuelo_id INT AUTO_INCREMENT PRIMARY KEY,
    origen_id INT,
    destino_id INT,
    fecha_salida DATETIME NOT NULL,
    fecha_llegada DATETIME NOT NULL,
    avion_id INT,
    FOREIGN KEY (origen_id) REFERENCES Aeropuertos(aeropuerto_id),
    FOREIGN KEY (destino_id) REFERENCES Aeropuertos(aeropuerto_id),
    FOREIGN KEY (avion_id) REFERENCES Avion(avion_id)
);

CREATE TABLE Reservas (
    reserva_id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT,
    vuelo_id INT,
    fecha_reserva TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('confirmada', 'cancelada', 'pendiente') NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id),
    FOREIGN KEY (vuelo_id) REFERENCES Vuelos(vuelo_id)
)
PARTITION BY RANGE (YEAR(fecha_reserva)) (
    PARTITION p2023 VALUES LESS THAN (2023),
    PARTITION p2024 VALUES LESS THAN (2024),
    PARTITION p2025 VALUES LESS THAN (2025)
);

CREATE TABLE Pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('tarjeta', 'efectivo', 'transferencia') NOT NULL,
    estado ENUM('completado', 'pendiente', 'fallido') NOT NULL,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (reserva_id) REFERENCES Reservas(reserva_id)
);

-- Registros

-- Insertar algunos registros de ejemplo
INSERT INTO Clientes (nombre, email, telefono, documento_identidad) 
VALUES ('Juan Pérez', 'juanperez@example.com', '123456789', '12345678A'),
       ('María García', 'mariagarcia@example.com', '987654321', '87654321B');

INSERT INTO Aeropuertos (nombre, ciudad, pais) 
VALUES ('Aeropuerto Internacional El Dorado', 'Bogotá', 'Colombia'),
       ('Aeropuerto de la Ciudad de México', 'Ciudad de México', 'México');

INSERT INTO Avion (modelo, capacidad, aerolinea) 
VALUES ('Boeing 737', 150, 'Aerolínea XYZ'),
       ('Airbus A320', 180, 'Aerolínea ABC');

INSERT INTO Vuelos (origen_id, destino_id, fecha_salida, fecha_llegada, avion_id)
VALUES (1, 2, '2025-01-01 10:00:00', '2025-01-01 12:30:00', 1),
       (2, 1, '2025-02-01 14:00:00', '2025-02-01 16:30:00', 2);

INSERT INTO Reservas (cliente_id, vuelo_id, estado)
VALUES (1, 1, 'confirmada'),
       (2, 2, 'pendiente');

INSERT INTO Pagos (reserva_id, monto, metodo_pago, estado)
VALUES (1, 100.00, 'tarjeta', 'completado'),
       (2, 50.00, 'efectivo', 'pendiente');



-- 4. Optimización y Rendimiento de Consultas

-- CREAR INDICES 
-- Crear los índices para optimizar las consultas
CREATE INDEX idx_vuelo_id ON Reservas(vuelo_id);
CREATE INDEX idx_cliente_id ON Reservas(cliente_id);
CREATE INDEX idx_fecha_salida ON Vuelos(fecha_salida);


-- Optimizar consultas SQL.
EXPLAIN
SELECT 
    Reservas.reserva_id, 
    Vuelos.fecha_salida, 
    Clientes.nombre AS cliente, 
    Aeropuertos.nombre AS origen
FROM Reservas
JOIN Vuelos ON Reservas.vuelo_id = Vuelos.vuelo_id
JOIN Clientes ON Reservas.cliente_id = Clientes.cliente_id
JOIN Aeropuertos ON Vuelos.origen_id = Aeropuertos.aeropuerto_id
WHERE Clientes.cliente_id = 1;

-- EXPLAIN para verificar el plan de ejecución de la consulta anterior
EXPLAIN 
SELECT 
    Reservas.reserva_id, 
    Vuelos.fecha_salida, 
    Clientes.nombre AS cliente, 
    Aeropuertos.nombre AS origen
FROM Reservas
JOIN Vuelos ON Reservas.vuelo_id = Vuelos.vuelo_id
JOIN Clientes ON Reservas.cliente_id = Clientes.cliente_id
JOIN Aeropuertos ON Vuelos.origen_id = Aeropuertos.aeropuerto_id
WHERE Clientes.cliente_id = 1;

-- EXPLAIN con optimización de condición en la fecha de salida
EXPLAIN 
SELECT 
    Reservas.reserva_id, 
    Vuelos.fecha_salida, 
    Clientes.nombre AS cliente, 
    Aeropuertos.nombre AS origen
FROM Reservas
JOIN Vuelos ON Reservas.vuelo_id = Vuelos.vuelo_id
JOIN Clientes ON Reservas.cliente_id = Clientes.cliente_id
JOIN Aeropuertos ON Vuelos.origen_id = Aeropuertos.aeropuerto_id
WHERE Vuelos.fecha_salida > '2025-01-01';


-- 3 punto fue agregado en la tabla de reserva la cual tiene particios de busqueda
-- paa como años se van a partir en año 2023, 2024 y 2025 para una busqueda mas optimizada

