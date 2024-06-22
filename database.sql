create database VACUU_Triggers;
use VACUU_Triggers;
-- drop database VACUU_Triggers;
CREATE TABLE empresarios (
  id_empresario int not null primary key auto_increment,
  nombre_empresario varchar(45) not null,
  correo varchar(45) not null unique,
  user_name varchar(10) not null unique,
  contraseña_empresario varchar(45) not null,
  telefono_empresario varchar(15) not null
  );
  
  create table categorias (
  id_categoria int not null auto_increment primary key,
  nombre_categoria varchar(20) not null,
  descripcion varchar(150) not null
  );
  
  create table establecimientos(
  id_establecimiento int not null auto_increment primary key,
  nombre_local varchar(45) not null,
  calle_numero varchar(45) not null,
  colonia varchar(45) not null,
  codigo_postal varchar(45) not null,
  telefono_local varchar(45) not null,
  fk_categoria int not null,
  fk_empresario int not null,
  foreign key(fk_categoria) references categorias(id_categoria),
  foreign key(fk_empresario) references empresarios(id_empresario)
  );
  
create table cupones(
id_cupon int not null auto_increment primary key,
codigo varchar(7) not null,
descripcion_cupon varchar(100),
fecha_inicio date,
fecha_vencimiento date,
descuento_mxn int,
cantidad int,
fk_establecimiento int not null,
descuento_anterior int,
foreign key(fk_establecimiento) references establecimientos(id_establecimiento)
);

create table usuarios(
id_usuario int not null auto_increment primary key,
username varchar(40) not null unique,
correo_electronico varchar(40) not null unique,
contraseña_usuario varchar(30) not null
);

create table usuario_cupon(
  id_usuario_cupon varchar(8) primary key not null,
  fk_usuario int,
  fk_cupon int,
  fecha_registro date,
  foreign key (fk_usuario) references usuarios (id_usuario),
  foreign key (fk_cupon) references cupones (id_cupon)

);
create unique index idx_unique_code on usuario_cupon(id_usuario_cupon);

create table alerta(
	id_alerta int auto_increment primary key,
    descripcionAlerta varchar(150),
    fechaAlerta date);
    
CREATE TABLE registro_cambios_descuento (
  id_registro INT AUTO_INCREMENT PRIMARY KEY,
  id_cupon INT,
  descuento_anterior INT,
  descuento_nuevo INT,
  fecha_cambio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (id_cupon) REFERENCES cupones(id_cupon)
);



/* -------------------------------------------------------------------------------------------------------------------------------------  
												Procedimientos aleatorios
 -------------------------------------------------------------------------------------------------------------------------------------  */
DELIMITER $$

DELIMITER $$

CREATE PROCEDURE randomCode(OUT coupon_code VARCHAR(8))
BEGIN
    DECLARE codeString VARCHAR(8); 
    DECLARE counter INT DEFAULT 0;
    DECLARE charLett VARCHAR(62) DEFAULT 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    DECLARE charSetLength INT DEFAULT 62;
    DECLARE isOn BOOLEAN DEFAULT TRUE;
    DECLARE attemptCounter INT DEFAULT 0;
    DECLARE maxAttempts INT DEFAULT 1000;

    WHILE isOn DO
        SET codeString = '';
        SET counter = 0;
        
        WHILE counter < 7 DO
            SET codeString = CONCAT(codeString, SUBSTRING(charLett, FLOOR(RAND() * charSetLength) + 1, 1));
            IF counter = 2 THEN
                SET codeString = CONCAT(codeString, '-');
            END IF;
            SET counter = counter + 1;
        END WHILE;

        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
            BEGIN
                SET attemptCounter = attemptCounter + 1;
                IF attemptCounter >= maxAttempts THEN
                    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Failed to generate unique coupon code after maximum attempts';
                END IF;
            END;

            IF NOT EXISTS (SELECT 1 FROM usuario_cupon WHERE id_usuario_cupon = codeString) THEN
                SET coupon_code = codeString;
                SET isOn = FALSE;
            END IF;
        END;
    END WHILE;
END $$

DELIMITER ;





delimiter $$
CREATE PROCEDURE randomUser(OUT randomUser INT)
BEGIN
    DECLARE randID INT;

    SELECT id_usuario INTO randID FROM usuarios ORDER BY RAND() LIMIT 1;
    SET randomUser = randID;
END$$

DELIMITER ;



/* Este procedimiento retorna un cupon aleatorio el cual no ha sido asignado a ningun usuario todavía */
delimiter $$

CREATE PROCEDURE randomCupon(OUT randomCouponID VARCHAR(8))
BEGIN
   
	if 1 < (select count(*) from cupones where fecha_vencimiento > now()) then
    
		SELECT id_usuario_cupon INTO randomCouponID FROM usuario_cupon where fk_usuario is null ORDER BY RAND() LIMIT 1;
    
    end if;
    
END $$

DELIMITER ;


/* -------------------------------------------------------------------------------------------------------------------------------------  
												Triggers de asignación
 -------------------------------------------------------------------------------------------------------------------------------------  */


delimiter $$

CREATE TRIGGER assignCoupon
AFTER INSERT
ON cupones
FOR EACH ROW
BEGIN
    DECLARE codigoGenerado VARCHAR(8);
	DECLARE counter int default 0;
    
    while counter < new.cantidad do
    
		CALL randomCode(codigoGenerado);
        if not exists (select id_usuario_cupon from usuario_cupon where id_usuario_cupon = codigoGenerado) then 
			INSERT INTO usuario_cupon (id_usuario_cupon, fk_cupon, fecha_registro)
				VALUES (codigoGenerado, new.id_cupon, NOW());
			set counter = counter +1;
		end if;
			end while;
END$$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER assignCouponNewUser
AFTER INSERT ON usuarios
FOR EACH ROW 
BEGIN
    DECLARE cuponAleatorio VARCHAR(8);
    DECLARE counter INT DEFAULT 0;
    DECLARE cuponID INT;
    DECLARE noCupones BOOLEAN DEFAULT FALSE;

    WHILE counter < 3 AND noCupones = FALSE DO
        SELECT id_usuario_cupon INTO cuponAleatorio
        FROM usuario_cupon
        WHERE fk_usuario IS NULL
        LIMIT 1;

        IF cuponAleatorio IS NOT NULL THEN
            UPDATE usuario_cupon
            SET fk_usuario = NEW.id_usuario, 
                fecha_registro = NOW()
            WHERE id_usuario_cupon = cuponAleatorio;

        SET counter = counter + 1;
        ELSE
            SET noCupones = TRUE;
            SET counter = 3;
        END IF;

    END WHILE;

    IF noCupones = TRUE THEN
        INSERT INTO alerta (descripcionAlerta)
        VALUES ('No hay suficientes codigos para usuarios, hace falta vender más');
    END IF;
END $$

DELIMITER ;


DELIMITER $$
CREATE TRIGGER registrarCambioDescuento
AFTER UPDATE ON cupones
FOR EACH ROW
BEGIN
  IF NEW.descuento_mxn <> OLD.descuento_mxn THEN
    INSERT INTO registro_cambios_descuento (id_cupon, descuento_anterior, descuento_nuevo)
    VALUES (NEW.id_cupon, OLD.descuento_mxn, NEW.descuento_mxn);
    
  END IF;
END$$
DELIMITER ;




/* -------------------------------------------------------------------------------------------------------------------------------------  
												Inserción de datos de prueba
 -------------------------------------------------------------------------------------------------------------------------------------*/


INSERT INTO categorias(nombre_categoria, descripcion)
VALUES
('Cafeterías', 'Cafés locales en el centro de Chihuahua'),
('Bares', 'Bares locales en el centro de Chihuahua'),
('Restaurantes', 'Restaurantes locales en el centro de Chihuahua'),
('Tiendas de Ropa', 'Tiendas de ropa locales en el centro de Chihuahua'),
('Joyería', 'Joyerías locales en el centro de Chihuahua');

INSERT INTO empresarios (nombre_empresario, correo, user_name, contraseña_empresario, telefono_empresario)
VALUES
('Juan Pérez', 'juan.perez@example.com', 'juanp', 'pass1234', '6123456780'),
('María López', 'maria.lopez@example.com', 'marial', 'pass1234', '6123456781'),
('Carlos García', 'carlos.garcia@example.com', 'carlosg', 'pass1234', '6123456782'),
('Ana Rodríguez', 'ana.rodriguez@example.com', 'anar', 'pass1234', '6123456783'),
('Roberto Martínez', 'roberto.martinez@example.com', 'robertom', 'pass1234', '6123456784'),
('Lucía Hernández', 'lucia.hernandez@example.com', 'luciah', 'pass1234', '6123456785'),
('Miguel Fernández', 'miguel.fernandez@example.com', 'miguelf', 'pass1234', '6123456786'),
('Elena González', 'elena.gonzalez@example.com', 'elenag', 'pass1234', '6123456787'),
('José Ramírez', 'jose.ramirez@example.com', 'joser', 'pass1234', '6123456788'),
('Laura Sánchez', 'laura.sanchez@example.com', 'lauras', 'pass1234', '6123456789'),
('David Torres', 'david.torres@example.com', 'davidt', 'pass1234', '6123456790'),
('Sofía Flores', 'sofia.flores@example.com', 'sofiaf', 'pass1234', '6123456791'),
('Alberto Ruiz', 'alberto.ruiz@example.com', 'albertor', 'pass1234', '6123456792'),
('Natalia Díaz', 'natalia.diaz@example.com', 'nataliad', 'pass1234', '6123456793'),
('Pedro Morales', 'pedro.morales@example.com', 'pedrom', 'pass1234', '6123456794');



INSERT INTO establecimientos (nombre_local, calle_numero, colonia, codigo_postal, telefono_local, fk_categoria, fk_empresario)
VALUES
-- Cafeterías
('Café Vallejo', 'Calle 1 #123', 'Centro', '31000', '6123456795', 1, 1),
('Café Tin Tan', 'Calle 2 #234', 'Centro', '31000', '6123456796', 1, 2),
('Café Kaldi', 'Calle 3 #345', 'Centro', '31000', '6123456797', 1, 3),
('Café Punta del Cielo', 'Calle 4 #456', 'Centro', '31000', '6123456798', 1, 4),
('Café La Antigua Paz', 'Calle 5 #567', 'Centro', '31000', '6123456799', 1, 5),
('Gloria Jeans Coffee', 'Calle 6 #678', 'Centro', '31000', '6123456700', 1, 6),
('Café Colibrí', 'Calle 7 #789', 'Centro', '31000', '6123456701', 1, 7),
('Café DVolada', 'Calle 8 #890', 'Centro', '31000', '6123456702', 1, 8),
('Café Versalles', 'Calle 9 #147', 'Centro', '31000', '6123456703', 1, 9),
('Café Divine', 'Calle 10 #258', 'Centro', '31000', '6123456704', 1, 10),
('El Rincón del Café', 'Calle 11 #369', 'Centro', '31000', '6123456705', 1, 11),
('Café Imperial', 'Calle 12 #101', 'Centro', '31000', '6123456706', 1, 12),
('La Nonna', 'Calle 13 #202', 'Centro', '31000', '6123456707', 1, 13),
('Café Tía Rosa', 'Calle 14 #303', 'Centro', '31000', '6123456708', 1, 14),
('Colonia Café', 'Calle 15 #404', 'Centro', '31000', '6123456709', 1, 15),

-- Bares
('Bar San Luis', 'Calle 16 #505', 'Centro', '31000', '6123456710', 2, 1),
('La Cervecería', 'Calle 17 #606', 'Centro', '31000', '6123456711', 2, 2),
('Bar el Rincón Feliz', 'Calle 18 #707', 'Centro', '31000', '6123456712', 2, 3),
('Patio Centenario', 'Calle 19 #808', 'Centro', '31000', '6123456713', 2, 4),
('Rocket Bar', 'Calle 20 #909', 'Centro', '31000', '6123456714', 2, 5),
('La Terraza de Urlarte', 'Calle 21 #111', 'Centro', '31000', '6123456715', 2, 6),
('Jarrita Tapatía', 'Calle 22 #222', 'Centro', '31000', '6123456716', 2, 7),
('La Antigua Paz Bar', 'Calle 23 #333', 'Centro', '31000', '6123456717', 2, 8),
('Bar Alaska', 'Calle 24 #444', 'Centro', '31000', '6123456718', 2, 9),
('El Aljibe Bar', 'Calle 25 #555', 'Centro', '31000', '6123456719', 2, 10),
('Esquina del Rock', 'Calle 26 #666', 'Centro', '31000', '6123456720', 2, 11),
('El Desván', 'Calle 27 #777', 'Centro', '31000', '6123456721', 2, 12),
('Bar La Oficina', 'Calle 28 #888', 'Centro', '31000', '6123456722', 2, 13),
('Bar Dublin', 'Calle 29 #999', 'Centro', '31000', '6123456723', 2, 14),
('Bar Hamburgueses', 'Calle 30 #100', 'Centro', '31000', '6123456724', 2, 15),

-- Restaurantes
('La Casona', 'Calle 31 #101', 'Centro', '31000', '6123456725', 3, 1),
('La Casa de los Milagros', 'Calle 32 #202', 'Centro', '31000', '6123456726', 3, 2),
('Il Fornaio', 'Calle 33 #303', 'Centro', '31000', '6123456727', 3, 3),
('Pollo Feliz Centro', 'Calle 34 #404', 'Centro', '31000', '6123456728', 3, 4),
('Mesón de Catedral', 'Calle 35 #505', 'Centro', '31000', '6123456729', 3, 5),
('El Hojaldre', 'Calle 36 #606', 'Centro', '31000', '6123456730', 3, 6),
('El Retablo', 'Calle 37 #707', 'Centro', '31000', '6123456731', 3, 7),
('El Sabor de Oaxaca', 'Calle 38 #808', 'Centro', '31000', '6123456732', 3, 8),
('Comedor Familiar', 'Calle 39 #909', 'Centro', '31000', '6123456733', 3, 9),
('Taquería La Suriana', 'Calle 40 #111', 'Centro', '31000', '6123456734', 3, 10),
('La Sierra', 'Calle 41 #222', 'Centro', '31000', '6123456735', 3, 11),
('La Huasteca', 'Calle 42 #333', 'Centro', '31000', '6123456736', 3, 12),
('La Mansión', 'Calle 43 #444', 'Centro', '31000', '6123456737', 3, 13),
('El Príncipe', 'Calle 44 #555', 'Centro', '31000', '6123456738', 3, 14),
('La Callejera', 'Calle 45 #666', 'Centro', '31000', '6123456739', 3, 15),

-- Tiendas de Ropa
('Moda México', 'Calle 46 #777', 'Centro', '31000', '6123456740', 4, 1),
('Boutique Dulce María', 'Calle 47 #888', 'Centro', '31000', '6123456741', 4, 2),
('Ropa Mi Sueño', 'Calle 48 #999', 'Centro', '31000', '6123456742', 4, 3),
('Recicla Moda', 'Calle 49 #100', 'Centro', '31000', '6123456743', 4, 4),
('Boutique Belinda', 'Calle 50 #101', 'Centro', '31000', '6123456744', 4, 5),
('Diseños Bárbara', 'Calle 51 #202', 'Centro', '31000', '6123456745', 4, 6),
('Indigo Boutique', 'Calle 52 #303', 'Centro', '31000', '6123456746', 4, 7),
('Ocasiones Boutique', 'Calle 53 #404', 'Centro', '31000', '6123456747', 4, 8),
('Elegance Chihuahua', 'Calle 54 #505', 'Centro', '31000', '6123456748', 4, 9),
('Fashion Kiut', 'Calle 55 #606', 'Centro', '31000', '6123456749', 4, 10),
('Moda y Estilo', 'Calle 56 #707', 'Centro', '31000', '6123456750', 4, 11),
('La Gran Ropa', 'Calle 57 #808', 'Centro', '31000', '6123456751', 4, 12),
('Boutique Abril', 'Calle 58 #909', 'Centro', '31000', '6123456752', 4, 13),
('Lady Boutique', 'Calle 59 #111', 'Centro', '31000', '6123456753', 4, 14),
('Casual Store', 'Calle 60 #222', 'Centro', '31000', '6123456754', 4, 15);


select * from usuarios;
select * from usuario_cupon;
INSERT INTO usuarios (username, correo_electronico, contraseña_usuario)
VALUES
('usuario1', 'usuario1@example.com', 'password1'),
('usuario2', 'usuario2@example.com', 'password2'),
('usuario3', 'usuario3@example.com', 'password3'),
('usuario4', 'usuario4@example.com', 'password4');



INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, cantidad, fk_establecimiento)
VALUES
('CUP001', 'Descuento de 50 MXN en Café Vallejo', '2024-06-11', '2024-06-21', 50, 10, 1),
('CUP002', 'Descuento de 70 MXN en Café Tin Tan', '2024-06-11', '2024-07-01', 70, 20, 2),
('CUP003', 'Descuento de 100 MXN en Café Kaldi', '2024-06-11', '2024-06-15', 100, 30, 3),
('CUP004', 'Descuento de 40 MXN en Café Punta del Cielo', '2024-06-11', '2024-07-11', 40, 40, 4),
('CUP005', 'Descuento de 60 MXN en Café La Antigua Paz', '2024-06-11', '2024-06-13', 60, 50, 5),
('CUP006', 'Descuento de 80 MXN en Gloria Jeans Coffee', '2024-05-11', '2024-06-04', 80, 10, 6),
('CUP007', 'Descuento de 90 MXN en Café Colibrí', '2024-04-11', '2024-06-21', 90, 20, 7),
('CUP008', 'Descuento de 35 MXN en Café DVolada', '2024-06-11', '2024-07-13', 35, 30, 8),
('CUP009', 'Descuento de 50 MXN en Café Versalles', '2024-06-20', '2024-07-11', 50, 40, 9),
('CUP010', 'Descuento de 100 MXN en Café Divine', '2024-06-01', '2024-08-12', 100, 50, 10),
('CUP011', 'Descuento de 60 MXN en El Rincón del Café', '2024-06-11', '2024-06-21', 60, 10, 11),
('CUP012', 'Descuento de 30 MXN en Café Imperial', '2024-06-11', '2024-07-11', 30, 20, 12),
('CUP013', 'Descuento de 90 MXN en La Nonna', '2024-06-11', '2024-07-11', 90, 30, 13),
('CUP014', 'Descuento de 120 MXN en Café Tía Rosa', '2024-06-11', '2024-07-11', 120, 40, 14),
('CUP015', 'Descuento de 150 MXN en Colonia Café', '2024-06-11', '2024-07-11', 150, 50, 15),
('CUP016', 'Descuento de 30 MXN en Bar San Luis', '2024-06-11', '2024-06-21', 30, 10, 16),
('CUP017', 'Descuento de 70 MXN en La Cervecería', '2024-06-11', '2024-07-01', 70, 20, 17),
('CUP018', 'Descuento de 100 MXN en Bar el Rincón Feliz', '2024-06-11', '2024-06-15', 100, 30, 18),
('CUP019', 'Descuento de 40 MXN en Patio Centenario', '2024-06-11', '2024-07-11', 40, 40, 19),
('CUP020', 'Descuento de 60 MXN en Rocket Bar', '2024-06-11', '2024-06-13', 60, 50, 20),
('CUP021', 'Descuento de 80 MXN en La Terraza de Urlarte', '2024-05-11', '2024-06-04', 80, 10, 21),
('CUP022', 'Descuento de 90 MXN en Jarrita Tapatía', '2024-04-11', '2024-06-21', 90, 20, 22),
('CUP023', 'Descuento de 35 MXN en La Antigua Paz Bar', '2024-06-11', '2024-07-13', 35, 30, 23),
('CUP024', 'Descuento de 50 MXN en Bar Alaska', '2024-06-20', '2024-07-11', 50, 40, 24),
('CUP025', 'Descuento de 100 MXN en El Aljibe Bar', '2024-06-01', '2024-08-12', 100, 50, 25),
('CUP026', 'Descuento de 135 MXN en Esquina del Rock', '2024-06-11', '2024-06-25', 135, 10, 26),
('CUP027', 'Descuento de 40 MXN en El Desván', '2024-06-11', '2024-07-05', 40, 20, 27),
('CUP028', 'Descuento de 90 MXN en Bar La Oficina', '2024-06-11', '2024-06-20', 90, 30, 28),
('CUP029', 'Descuento de 75 MXN en Bar Dublin', '2024-06-11', '2024-07-01', 75, 40, 29),
('CUP030', 'Descuento de 50 MXN en Bar Hamburgueses', '2024-06-11', '2024-06-30', 50, 50, 30),
('CUP031', 'Descuento de 60 MXN en La Casona', '2024-06-11', '2024-06-20', 60, 10, 31),
('CUP032', 'Descuento de 120 MXN en La Casa de los Milagros', '2024-06-11', '2024-07-01', 120, 20, 32),
('CUP033', 'Descuento de 50 MXN en Il Fornaio', '2024-06-11', '2024-06-25', 50, 30, 33),
('CUP034', 'Descuento de 90 MXN en Pollo Feliz Centro', '2024-06-11', '2024-07-05', 90, 40, 34),
('CUP035', 'Descuento de 70 MXN en Mesón de Catedral', '2024-06-11', '2024-06-20', 70, 50, 35),
('CUP036', 'Descuento de 75 MXN en El Hojaldre', '2024-06-11', '2024-07-01', 75, 10, 36),
('CUP037', 'Descuento de 40 MXN en El Retablo', '2024-06-11', '2024-06-30', 40, 20, 37),
('CUP038', 'Descuento de 85 MXN en El Sabor de Oaxaca', '2024-06-11', '2024-07-20', 85, 30, 38),
('CUP039', 'Descuento de 55 MXN en Comedor Familiar', '2024-06-11', '2024-06-25', 55, 40, 39),
('CUP040', 'Descuento de 60 MXN en Taquería La Suriana', '2024-06-11', '2024-07-01', 60, 50, 40),
('CUP041', 'Descuento de 130 MXN en La Sierra', '2024-06-11', '2024-06-30', 130, 10, 41),
('CUP042', 'Descuento de 45 MXN en La Huasteca', '2024-06-11', '2024-07-15', 45, 20, 42),
('CUP043', 'Descuento de 95 MXN en La Mansión', '2024-06-11', '2024-06-30', 95, 30, 43),
('CUP044', 'Descuento de 40 MXN en El Príncipe', '2024-06-11', '2024-07-01', 40, 40, 44),
('CUP045', 'Descuento de 60 MXN en La Callejera', '2024-06-11', '2024-07-10', 60, 50, 45),
('CUP046', 'Descuento de 75 MXN en Moda México', '2024-06-11', '2024-06-20', 75, 10, 46),
('CUP047', 'Descuento de 100 MXN en Boutique Dulce María', '2024-06-11', '2024-07-01', 100, 20, 47),
('CUP048', 'Descuento de 50 MXN en Ropa Mi Sueño', '2024-06-11', '2024-06-25', 50, 30, 48),
('CUP049', 'Descuento de 90 MXN en Recicla Moda', '2024-06-11', '2024-07-05', 90, 40, 49),
('CUP050', 'Descuento de 60 MXN en Boutique Belinda', '2024-06-11', '2024-07-01', 60, 50, 50),
('CUP051', 'Descuento de 70 MXN en Diseños Bárbara', '2024-06-11', '2024-06-20', 70, 10, 51),
('CUP052', 'Descuento de 85 MXN en Indigo Boutique', '2024-06-11', '2024-07-01', 85, 20, 52),
('CUP053', 'Descuento de 55 MXN en Ocasiones Boutique', '2024-06-11', '2024-06-25', 55, 30, 53),
('CUP054', 'Descuento de 45 MXN en Elegance Chihuahua', '2024-06-11', '2024-07-10', 45, 40, 54),
('CUP055', 'Descuento de 95 MXN en Fashion Kiut', '2024-06-11', '2024-06-30', 95, 50, 55),
('CUP056', 'Descuento de 90 MXN en Moda y Estilo', '2024-06-11', '2024-07-01', 90, 10, 56),
('CUP057', 'Descuento de 80 MXN en La Gran Ropa', '2024-06-11', '2024-06-20', 80, 20, 57),
('CUP058', 'Descuento de 30 MXN en Boutique Abril', '2024-06-11', '2024-07-01', 30, 30, 58),
('CUP059', 'Descuento de 60 MXN en Lady Boutique', '2024-06-11', '2024-06-25', 60, 40, 59),
('CUP060', 'Descuento de 70 MXN en Casual Store', '2024-06-11', '2024-07-15', 70, 50, 60),
('CUP076', 'Descuento de 60 MXN en Café Vallejo', '2024-07-01', '2024-07-31', 60, 10, 1),
('CUP077', 'Descuento de 45 MXN en Café Tin Tan', '2024-07-01', '2024-07-31', 45, 20, 2),
('CUP078', 'Descuento de 80 MXN en Café Kaldi', '2024-07-01', '2024-07-31', 80, 30, 3),
('CUP079', 'Descuento de 50 MXN en Café Punta del Cielo', '2024-07-01', '2024-07-31', 50, 40, 4),
('CUP080', 'Descuento de 100 MXN en Café La Antigua Paz', '2024-07-01', '2024-07-31', 100, 50, 5),
('CUP081', 'Descuento de 70 MXN en Gloria Jeans Coffee', '2024-07-01', '2024-07-31', 70, 10, 6),
('CUP082', 'Descuento de 40 MXN en Café Colibrí', '2024-07-01', '2024-07-31', 40, 20, 7),
('CUP083', 'Descuento de 110 MXN en Café DVolada', '2024-07-01', '2024-07-31', 110, 30, 8),
('CUP084', 'Descuento de 90 MXN en Café Versalles', '2024-07-01', '2024-07-31', 90, 40, 9),
('CUP085', 'Descuento de 65 MXN en Café Divine', '2024-07-01', '2024-07-31', 65, 50, 10),
('CUP086', 'Descuento de 50 MXN en El Rincón del Café', '2024-07-01', '2024-07-31', 50, 10, 11),
('CUP087', 'Descuento de 120 MXN en Café Imperial', '2024-07-01', '2024-07-31', 120, 20, 12),
('CUP088', 'Descuento de 55 MXN en La Nonna', '2024-07-01', '2024-07-31', 55, 30, 13),
('CUP089', 'Descuento de 90 MXN en Café Tía Rosa', '2024-07-01', '2024-07-31', 90, 40, 14),
('CUP090', 'Descuento de 75 MXN en Colonia Café', '2024-07-01', '2024-07-31', 75, 50, 15),
('CUP091', 'Descuento de 60 MXN en Bar San Luis', '2024-07-01', '2024-07-31', 60, 10, 16),
('CUP092', 'Descuento de 45 MXN en La Cervecería', '2024-07-01', '2024-07-31', 45, 20, 17),
('CUP093', 'Descuento de 80 MXN en Bar el Rincón Feliz', '2024-07-01', '2024-07-31', 80, 30, 18),
('CUP094', 'Descuento de 50 MXN en Patio Centenario', '2024-07-01', '2024-07-31', 50, 40, 19),
('CUP095', 'Descuento de 100 MXN en Rocket Bar', '2024-07-01', '2024-07-31', 100, 50, 20),
('CUP096', 'Descuento de 70 MXN en La Terraza de Urlarte', '2024-07-01', '2024-07-31', 70, 10, 21),
('CUP097', 'Descuento de 40 MXN en Jarrita Tapatía', '2024-07-01', '2024-07-31', 40, 20, 22),
('CUP098', 'Descuento de 110 MXN en La Antigua Paz Bar', '2024-07-01', '2024-07-31', 110, 30, 23),
('CUP099', 'Descuento de 90 MXN en Bar Alaska', '2024-07-01', '2024-07-31', 90, 40, 24),
('CUP100', 'Descuento de 65 MXN en El Aljibe Bar', '2024-07-01', '2024-07-31', 65, 50, 25),
('CUP101', 'Descuento de 50 MXN en Esquina del Rock', '2024-07-01', '2024-07-31', 50, 10, 26),
('CUP102', 'Descuento de 120 MXN en El Desván', '2024-07-01', '2024-07-31', 120, 20, 27),
('CUP103', 'Descuento de 55 MXN en Bar La Oficina', '2024-07-01', '2024-07-31', 55, 30, 28),
('CUP104', 'Descuento de 90 MXN en Bar Dublin', '2024-07-01', '2024-07-31', 90, 40, 29),
('CUP105', 'Descuento de 75 MXN en Bar Hamburgueses', '2024-07-01', '2024-07-31', 75, 50, 30),
('CUP106', 'Descuento de 60 MXN en La Casona', '2024-07-01', '2024-07-31', 60, 10, 31),
('CUP107', 'Descuento de 130 MXN en La Casa de los Milagros', '2024-07-01', '2024-07-31', 130, 20, 32),
('CUP108', 'Descuento de 85 MXN en Il Fornaio', '2024-07-01', '2024-07-31', 85, 30, 33),
('CUP109', 'Descuento de 55 MXN en Pollo Feliz Centro', '2024-07-01', '2024-07-31', 55, 40, 34),
('CUP110', 'Descuento de 105 MXN en Mesón de Catedral', '2024-07-01', '2024-07-31', 105, 50, 35),
('CUP111', 'Descuento de 75 MXN en El Hojaldre', '2024-07-01', '2024-07-31', 75, 10, 36),
('CUP112', 'Descuento de 50 MXN en El Retablo', '2024-07-01', '2024-07-31', 50, 20, 37),
('CUP113', 'Descuento de 135 MXN en El Sabor de Oaxaca', '2024-07-01', '2024-07-31', 135, 30, 38),
('CUP114', 'Descuento de 110 MXN en Comedor Familiar', '2024-07-01', '2024-07-31', 110, 40, 39),
('CUP115', 'Descuento de 65 MXN en Taquería La Suriana', '2024-07-01', '2024-07-31', 65, 50, 40),
('CUP116', 'Descuento de 120 MXN en La Sierra', '2024-07-01', '2024-07-31', 120, 10, 41),
('CUP117', 'Descuento de 60 MXN en La Huasteca', '2024-07-01', '2024-07-31', 60, 20, 42),
('CUP118', 'Descuento de 95 MXN en La Mansión', '2024-07-01', '2024-07-31', 95, 30, 43),
('CUP119', 'Descuento de 55 MXN en El Príncipe', '2024-07-01', '2024-07-31', 55, 40, 44),
('CUP120', 'Descuento de 100 MXN en La Callejera', '2024-07-01', '2024-07-31', 100, 50, 45),
('CUP121', 'Descuento de 70 MXN en Moda México', '2024-07-01', '2024-07-31', 70, 10, 46),
('CUP122', 'Descuento de 55 MXN en Boutique Dulce María', '2024-07-01', '2024-07-31', 55, 20, 47),
('CUP123', 'Descuento de 90 MXN en Ropa Mi Sueño', '2024-07-01', '2024-07-31', 90, 30, 48),
('CUP124', 'Descuento de 45 MXN en Recicla Moda', '2024-07-01', '2024-07-31', 45, 40, 49),
('CUP125', 'Descuento de 100 MXN en Boutique Belinda', '2024-07-01', '2024-07-31', 100, 50, 50),
('CUP126', 'Descuento de 110 MXN en Diseños Bárbara', '2024-07-01', '2024-07-31', 110, 10, 51),
('CUP127', 'Descuento de 55 MXN en Indigo Boutique', '2024-07-01', '2024-07-31', 55, 20, 52),
('CUP128', 'Descuento de 70 MXN en Ocasiones Boutique', '2024-07-01', '2024-07-31', 70, 30, 53),
('CUP129', 'Descuento de 50 MXN en Elegance Chihuahua', '2024-07-01', '2024-07-31', 50, 40, 54),
('CUP130', 'Descuento de 125 MXN en Fashion Kiut', '2024-07-01', '2024-07-31', 125, 50, 55),
('CUP131', 'Descuento de 60 MXN en Moda y Estilo', '2024-07-01', '2024-07-31', 60, 10, 56),
('CUP132', 'Descuento de 95 MXN en La Gran Ropa', '2024-07-01', '2024-07-31', 95, 20, 57),
('CUP133', 'Descuento de 40 MXN en Boutique Abril', '2024-07-01', '2024-07-31', 40, 30, 58),
('CUP134', 'Descuento de 75 MXN en Lady Boutique', '2024-07-01', '2024-07-31', 75, 40, 59),
('CUP135', 'Descuento de 90 MXN en Casual Store', '2024-07-01', '2024-07-31', 90, 50, 60);

INSERT INTO usuarios (username, correo_electronico, contraseña_usuario)
VALUES
('usuario5', 'usuario5@example.com', 'password5'),
('usuario6', 'usuario6@example.com', 'password6'),
('usuario7', 'usuario7@example.com', 'password7'),
('usuario8', 'usuario8@example.com', 'password8'),
('usuario9', 'usuario9@example.com', 'password9'),
('usuario10', 'usuario10@example.com', 'password10'),
('usuario11', 'usuario11@example.com', 'password11'),
('usuario12', 'usuario12@example.com', 'password12'),
('usuario13', 'usuario13@example.com', 'password13'),
('usuario14', 'usuario14@example.com', 'password14'),
('usuario15', 'usuario15@example.com', 'password15'),
('usuario16', 'usuario16@example.com', 'password16'),
('usuario17', 'usuario17@example.com', 'password17'),
('usuario18', 'usuario18@example.com', 'password18'),
('usuario19', 'usuario19@example.com', 'password19'),
('usuario20', 'usuario20@example.com', 'password20'),
('usuario21', 'usuario21@example.com', 'password21'),
('usuario22', 'usuario22@example.com', 'password22'),
('usuario23', 'usuario23@example.com', 'password23'),
('usuario24', 'usuario24@example.com', 'password24'),
('usuario25', 'usuario25@example.com', 'password25'),
('usuario26', 'usuario26@example.com', 'password26'),
('usuario27', 'usuario27@example.com', 'password27'),
('usuario28', 'usuario28@example.com', 'password28'),
('usuario29', 'usuario29@example.com', 'password29'),
('usuario30', 'usuario30@example.com', 'password30'); 

/* -------------------------------------------------------------------------------------------------------------------------------------  
												Pruebas
 -------------------------------------------------------------------------------------------------------------------------------------  */

select count(*) from usuario_cupon;

UPDATE cupones
SET descuento_mxn = CASE
    WHEN id_cupon = 23 THEN 50
    WHEN id_cupon = 45 THEN 120
    WHEN id_cupon = 12 THEN 40
    WHEN id_cupon = 8 THEN 45
    WHEN id_cupon = 37 THEN 60
    ELSE descuento_mxn
END,
descuento_anterior = descuento_mxn
WHERE id_cupon IN (23, 45, 12, 8, 37);

select * from registro_cambios_descuento;

-- drop database VACUU_Triggers;

-- DISPARADOR 3 auditoría de eliminación de datos sensibles
create table auditoria_datos_sensibles(
id_auditoria int primary key auto_increment,
accion varchar(45) not null,
usuario_administrador varchar(45) not null,
fecha_modificacion timestamp default current_timestamp,
id_empresario_borrado int not null,
nombre_empresario varchar(45) not null,
correo varchar(45) not null,
user_name varchar(10) not null unique,
contraseña_empresario varchar(45) not null,
telefono_empresario varchar(15) not null
);

drop table auditoria_datos_sensibles;

DELIMITER //
create trigger auditoria_de_eliminacion_de_datos_sensibles
after delete on empresarios
for each row
begin 
	insert into auditoria_datos_sensibles (accion, usuario_administrador, id_empresario_borrado, 
    nombre_empresario, correo, user_name, contraseña_empresario, telefono_empresario)
    values
			('DELETE', user(), old.id_empresario, old.nombre_empresario, old.correo, old.user_name, 
            old.contraseña_empresario, old.telefono_empresario);
            
end // 
DELIMITER ;

select * from auditoria_datos_sensibles;

SELECT * FROM EMPRESARIOS;

insert into empresarios(nombre_empresario, correo, user_name, contraseña_empresario, telefono_empresario)
values 	('Gerardo Perez', 'dbsdkbe@gmail.com', 'gerardito','bvfjebdjk','6145329859');

delete from empresarios where id_empresario = 16;
