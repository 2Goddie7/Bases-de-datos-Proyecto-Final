CREATE DATABASE PROYECTO_FINAL;
USE PROYECTO_FINAL;

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

-- Establecer claves foraneas con restricciones de integridad
-- Tabla Vuelos (Relaciona con Aeropuertos y Avion)
ALTER TABLE Vuelos 
ADD CONSTRAINT fk_vuelo_origen FOREIGN KEY (origen_id) REFERENCES Aeropuertos(aeropuerto_id) 
ON UPDATE CASCADE ON DELETE RESTRICT;
-- ON UPDATE CASCADE: Si cambia el ID de un aeropuerto o avión, se actualiza en Vuelos.

ALTER TABLE Vuelos 
ADD CONSTRAINT fk_vuelo_destino FOREIGN KEY (destino_id) REFERENCES Aeropuertos(aeropuerto_id) 
ON UPDATE CASCADE ON DELETE RESTRICT;
-- ON DELETE RESTRICT: No se puede eliminar un aeropuerto si hay vuelos asociados.

ALTER TABLE Vuelos 
ADD CONSTRAINT fk_vuelo_avion FOREIGN KEY (avion_id) REFERENCES Avion(avion_id) 
ON UPDATE CASCADE ON DELETE SET NULL;
-- ON DELETE SET NULL: Si se elimina un avión, los vuelos quedan con NULL en avion_id en vez de borrarlos.

-- Tabla Reservas (Relaciona con Clientes y Vuelos)
ALTER TABLE Reservas 
ADD CONSTRAINT fk_reserva_cliente FOREIGN KEY (cliente_id) REFERENCES Clientes(cliente_id) 
ON UPDATE CASCADE ON DELETE CASCADE;
-- ON DELETE CASCADE: Si se elimina un cliente, también se eliminan sus reservas.

ALTER TABLE Reservas 
ADD CONSTRAINT fk_reserva_vuelo FOREIGN KEY (vuelo_id) REFERENCES Vuelos(vuelo_id) 
ON UPDATE CASCADE ON DELETE RESTRICT;
-- ON DELETE RESTRICT: No se puede eliminar un vuelo si tiene reservas activas.

 -- Tabla Pagos (Relaciona con Reservas)
ALTER TABLE Pagos 
ADD CONSTRAINT fk_pago_reserva FOREIGN KEY (reserva_id) REFERENCES Reservas(reserva_id) 
ON UPDATE CASCADE ON DELETE CASCADE;
-- ON DELETE CASCADE: Si se cancela una reserva, también se eliminan sus pagos.



