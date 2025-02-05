CREATE DATABASE PROYECTO_FINAL;
USE PROYECTO_FINAL;

-- CREACION DE TABLAS CON SUS RELACIONES
CREATE TABLE Clientes (
    cliente_id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(20),
    documento_identidad VARBINARY(255) NOT NULL -- Cifrado con AES_ENCRYPT
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
);

CREATE TABLE Pagos (
    pago_id INT AUTO_INCREMENT PRIMARY KEY,
    reserva_id INT,
    monto DECIMAL(10,2) NOT NULL,
    metodo_pago ENUM('tarjeta', 'efectivo', 'transferencia') NOT NULL,
    estado ENUM('completado', 'pendiente', 'fallido') NOT NULL,
    fecha_pago TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    numero_tarjeta VARBINARY(255) NOT NULL, -- Cifrado con AES_ENCRYPT
    FOREIGN KEY (reserva_id) REFERENCES Reservas(reserva_id)
);

-- Tabla Clientes
INSERT INTO Clientes (nombre, email, telefono, documento_identidad)
VALUES 
('Juan Pérez', 'juan.perez@example.com', '123456789', AES_ENCRYPT('12345678', 'clave')),
('María Gómez', 'maria.gomez@example.com', '987654321', AES_ENCRYPT('87654321', 'clave'));

-- Tabla Aeropuertos
INSERT INTO Aeropuertos (nombre, ciudad, pais)
VALUES 
('Aeropuerto Internacional', 'Ciudad A', 'País A'),
('Aeropuerto Nacional', 'Ciudad B', 'País B');

-- Tabla Avion
INSERT INTO Avion (modelo, capacidad, aerolinea)
VALUES 
('Boeing 737', 180, 'Aerolínea A'),
('Airbus A320', 160, 'Aerolínea B');

-- Tabla Vuelos
INSERT INTO Vuelos (origen_id, destino_id, fecha_salida, fecha_llegada, avion_id)
VALUES 
(1, 2, '2024-12-01 08:00:00', '2024-12-01 12:00:00', 1),
(2, 1, '2024-12-02 15:00:00', '2024-12-02 19:00:00', 2);

-- Tabla Reservas
INSERT INTO Reservas (cliente_id, vuelo_id, estado)
VALUES 
(1, 1, 'confirmada'),
(2, 2, 'pendiente');

-- Tabla Pagos
INSERT INTO Pagos (reserva_id, monto, metodo_pago, estado, numero_tarjeta)
VALUES 
(1, 150.00, 'tarjeta', 'completado', AES_ENCRYPT('4111111111111111', 'clave')),
(2, 200.00, 'transferencia', 'pendiente', AES_ENCRYPT('4222222222222222', 'clave'));

-- Verificación de los datos descifrados
SELECT 
    nombre, 
    CAST(AES_DECRYPT(documento_identidad, 'clave') AS CHAR) AS documento_descifrado
FROM Clientes;

-- Visualizar los datos encriptados
select * from clientes;

-- Verificación de los datos descifrados
SELECT 
    reserva_id, 
    estado, 
    CAST(AES_DECRYPT(numero_tarjeta, 'clave') AS CHAR) AS tarjeta_descifrada
FROM Pagos;

-- Visualizar los datos encriptados
select * from pagos;
