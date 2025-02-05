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
       

-- 2. Seguridad, Auditoría y Control de Acceso

-- Habilitar auditoría y registrar eventos de base de datos.
-- Activar el log
SET GLOBAL general_log = 'ON';
-- Crear un archivo en log
SET GLOBAL general_log_file = 'C:/ProgramData/MySQL/MySQL Server 8.0/Data/general.log';
-- Visualizar si se encuentra activo y donde esta el arhivo
SHOW VARIABLES LIKE 'general_log%';

-- Registra los logs en la tabla `mysql.general_log`
SET GLOBAL log_output = 'TABLE';
-- Visualiza los usuarios que ingresaron 


