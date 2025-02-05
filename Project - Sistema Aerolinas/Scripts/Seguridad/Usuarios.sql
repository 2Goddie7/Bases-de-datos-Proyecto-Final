-- Crear el usuario 'Administrador' 
CREATE USER 'administrador'@'localhost' IDENTIFIED BY '123456';
-- Otorgar todos los privilegios sobre la base de datos 'Proyecto_final'
GRANT ALL PRIVILEGES ON *.*  TO 'administrador'@'localhost';
-- Aplicar los cambios en los privilegios
FLUSH PRIVILEGES;


-- Crear el usuario 'Usuario'
CREATE USER 'usuario'@'localhost' IDENTIFIED BY '12345';
-- Otorgar todos los privilegios sobre la base de datos 'Proyecto_final'
GRANT SELECT, INSERT, UPDATE ON Proyecto_final.* TO 'usuario'@'localhost';
-- Aplicar los cambios en los privilegios
FLUSH PRIVILEGES;



-- Crear el usuario 'Auditor' 
CREATE USER 'auditor'@'localhost' IDENTIFIED BY '123';
-- Otorgar todos los privilegios sobre la base de datos 'Proyecto_final'
GRANT ALL PRIVILEGES ON Proyecto_final.* TO 'auditor'@'localhost';
-- Aplicar los cambios en los privilegios
FLUSH PRIVILEGES;
