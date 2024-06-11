
create database VACUU;
use VACUU;

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
codigo varchar(6) not null,
descripcion_cupon varchar(100),
fecha_inicio date,
fecha_vencimiento date,
descuento_mxn float,
fk_establecimiento int not null,
foreign key(fk_establecimiento) references establecimientos(id_establecimiento)
);

create table usuarios(
id_usuario int not null auto_increment primary key,
username varchar(40) not null unique,
correo_electronico varchar(40) not null unique,
contraseña_usuario varchar(30) not null
);

create table usuario_cupon(
  id_usuario_cupon int not null auto_increment primary key,
  fk_usuario int not null,
  fk_cupon int not null,
  fecha_uso date,
  foreign key (fk_usuario) references usuarios (id_usuario),
  foreign key (fk_cupon) references cupones (id_cupon)

);

/* INSERTAR DATOS  */


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


INSERT INTO usuarios (username, correo_electronico, contraseña_usuario)
VALUES
('usuario1', 'usuario1@example.com', 'password1'),
('usuario2', 'usuario2@example.com', 'password2'),
('usuario3', 'usuario3@example.com', 'password3'),
('usuario4', 'usuario4@example.com', 'password4'),
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

INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP001', 'Descuento de 50 MXN en Café Vallejo', '2024-06-11', '2024-06-21', 50, 1),
('CUP002', 'Descuento de 70 MXN en Café Tin Tan', '2024-06-11', '2024-07-01', 70, 2),
('CUP003', 'Descuento de 100 MXN en Café Kaldi', '2024-06-11', '2024-06-15', 100, 3),
('CUP004', 'Descuento de 40 MXN en Café Punta del Cielo', '2024-06-11', '2024-07-11', 40, 4),
('CUP005', 'Descuento de 60 MXN en Café La Antigua Paz', '2024-06-11', '2024-06-13', 60, 5),
('CUP006', 'Descuento de 80 MXN en Gloria Jeans Coffee', '2024-05-11', '2024-06-04', 80, 6),
('CUP007', 'Descuento de 90 MXN en Café Colibrí', '2024-04-11', '2024-06-21', 90, 7),
('CUP008', 'Descuento de 35 MXN en Café DVolada', '2024-06-11', '2024-07-13', 35, 8),
('CUP009', 'Descuento de 50 MXN en Café Versalles', '2024-06-20', '2024-07-11', 50, 9),
('CUP010', 'Descuento de 100 MXN en Café Divine', '2024-06-01', '2024-08-12', 100,10),
('CUP011', 'Descuento de 60 MXN en El Rincón del Café', '2024-06-11', '2024-06-21', 60, 11),
('CUP012', 'Descuento de 30 MXN en Café Imperial', '2024-06-11', '2024-07-11', 30, 12),
('CUP013', 'Descuento de 90 MXN en La Nonna', '2024-06-11', '2024-07-11', 90, 13);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP014', 'Descuento de 120 MXN en Café Tía Rosa', '2024-06-11', '2024-07-11', 120, 14),
('CUP015', 'Descuento de 150 MXN en Colonia Café', '2024-06-11', '2024-07-11', 150, 15),
('CUP016', 'Descuento de 30 MXN en Bar San Luis', '2024-06-11', '2024-06-21', 30, 16),
('CUP017', 'Descuento de 70 MXN en La Cervecería', '2024-06-11', '2024-07-01', 70, 17),
('CUP018', 'Descuento de 100 MXN en Bar el Rincón Feliz', '2024-06-11', '2024-06-15', 100, 18),
('CUP019', 'Descuento de 40 MXN en Patio Centenario', '2024-06-11', '2024-07-11', 40, 19),
('CUP020', 'Descuento de 60 MXN en Rocket Bar', '2024-06-11', '2024-06-13', 60, 20),
('CUP021', 'Descuento de 80 MXN en La Terraza de Urlarte', '2024-05-11', '2024-06-04', 80, 21),
('CUP022', 'Descuento de 90 MXN en Jarrita Tapatía', '2024-04-11', '2024-06-21', 90, 22),
('CUP023', 'Descuento de 35 MXN en La Antigua Paz Bar', '2024-06-11', '2024-07-13', 35, 23),
('CUP024', 'Descuento de 50 MXN en Bar Alaska', '2024-06-20', '2024-07-11', 50, 24);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP025', 'Descuento de 100 MXN en El Aljibe Bar', '2024-06-01', '2024-08-12', 100, 25);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP026', 'Descuento de 135 MXN en Esquina del Rock', '2024-06-11', '2024-06-25', 135, 26);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP027', 'Descuento de 40 MXN en El Desván', '2024-06-11', '2024-07-05', 40, 27);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP028', 'Descuento de 90 MXN en Bar La Oficina', '2024-06-11', '2024-06-20', 90, 28);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP029', 'Descuento de 75 MXN en Bar Dublin', '2024-06-11', '2024-07-01', 75, 29),
('CUP030', 'Descuento de 50 MXN en Bar Hamburgueses', '2024-06-11', '2024-06-30', 50, 30);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP031', 'Descuento de 60 MXN en La Casona', '2024-06-11', '2024-06-20', 60, 31),
('CUP032', 'Descuento de 120 MXN en La Casa de los Milagros', '2024-06-11', '2024-07-01', 120, 32),
('CUP033', 'Descuento de 50 MXN en Il Fornaio', '2024-06-11', '2024-06-25', 50, 33),
('CUP034', 'Descuento de 90 MXN en Pollo Feliz Centro', '2024-06-11', '2024-07-05', 90, 34),
('CUP035', 'Descuento de 70 MXN en Mesón de Catedral', '2024-06-11', '2024-06-20', 70, 35),
('CUP036', 'Descuento de 75 MXN en El Hojaldre', '2024-06-11', '2024-07-01', 75, 36),
('CUP037', 'Descuento de 40 MXN en El Retablo', '2024-06-11', '2024-06-30', 40, 37),
('CUP038', 'Descuento de 85 MXN en El Sabor de Oaxaca', '2024-06-11', '2024-07-20', 85, 38),
('CUP039', 'Descuento de 55 MXN en Comedor Familiar', '2024-06-11', '2024-06-25', 55, 39);
INSERT INTO cupones (codigo, descripcion_cupon, fecha_inicio, fecha_vencimiento, descuento_mxn, fk_establecimiento)
VALUES
('CUP040', 'Descuento de 60 MXN en Taquería La Suriana', '2024-06-11', '2024-07-01', 60, 40),
('CUP041', 'Descuento de 130 MXN en La Sierra', '2024-06-11', '2024-06-30', 130, 41),
('CUP042', 'Descuento de 45 MXN en La Huasteca', '2024-06-11', '2024-07-15', 45, 42),
('CUP043', 'Descuento de 95 MXN en La Mansión', '2024-06-11', '2024-06-30', 95, 43),
('CUP044', 'Descuento de 40 MXN en El Príncipe', '2024-06-11', '2024-07-01', 40, 44),
('CUP045', 'Descuento de 60 MXN en La Callejera', '2024-06-11', '2024-07-10', 60, 45),
('CUP046', 'Descuento de 75 MXN en Moda México', '2024-06-11', '2024-06-20', 75, 46),
('CUP047', 'Descuento de 100 MXN en Boutique Dulce María', '2024-06-11', '2024-07-01', 100, 47),
('CUP048', 'Descuento de 50 MXN en Ropa Mi Sueño', '2024-06-11', '2024-06-25', 50, 48),
('CUP049', 'Descuento de 90 MXN en Recicla Moda', '2024-06-11', '2024-07-05', 90, 49),
('CUP050', 'Descuento de 60 MXN en Boutique Belinda', '2024-06-11', '2024-07-01', 60, 50),
('CUP051', 'Descuento de 70 MXN en Diseños Bárbara', '2024-06-11', '2024-06-20', 70, 51),
('CUP052', 'Descuento de 85 MXN en Indigo Boutique', '2024-06-11', '2024-07-01', 85, 52),
('CUP053', 'Descuento de 55 MXN en Ocasiones Boutique', '2024-06-11', '2024-06-25', 55, 53),
('CUP054', 'Descuento de 45 MXN en Elegance Chihuahua', '2024-06-11', '2024-07-10', 45, 54),
('CUP055', 'Descuento de 95 MXN en Fashion Kiut', '2024-06-11', '2024-06-30', 95, 55),
('CUP056', 'Descuento de 90 MXN en Moda y Estilo', '2024-06-11', '2024-07-01', 90, 56),
('CUP057', 'Descuento de 80 MXN en La Gran Ropa', '2024-06-11', '2024-06-20', 80, 57),
('CUP058', 'Descuento de 30 MXN en Boutique Abril', '2024-06-11', '2024-07-01', 30, 58),
('CUP059', 'Descuento de 60 MXN en Lady Boutique', '2024-06-11', '2024-06-25', 60, 59),
('CUP060', 'Descuento de 70 MXN en Casual Store', '2024-06-11', '2024-07-15', 70, 60),
('CUP076', 'Descuento de 60 MXN en Café Vallejo', '2024-07-01', '2024-07-31', 60, 1),
('CUP077', 'Descuento de 45 MXN en Café Tin Tan', '2024-07-01', '2024-07-31', 45, 2),
('CUP078', 'Descuento de 80 MXN en Café Kaldi', '2024-07-01', '2024-07-31', 80, 3),
('CUP079', 'Descuento de 50 MXN en Café Punta del Cielo', '2024-07-01', '2024-07-31', 50, 4),
('CUP080', 'Descuento de 100 MXN en Café La Antigua Paz', '2024-07-01', '2024-07-31', 100, 5),
('CUP081', 'Descuento de 70 MXN en Gloria Jeans Coffee', '2024-07-01', '2024-07-31', 70, 6),
('CUP082', 'Descuento de 40 MXN en Café Colibrí', '2024-07-01', '2024-07-31', 40, 7),
('CUP083', 'Descuento de 110 MXN en Café DVolada', '2024-07-01', '2024-07-31', 110, 8),
('CUP084', 'Descuento de 90 MXN en Café Versalles', '2024-07-01', '2024-07-31', 90, 9),
('CUP085', 'Descuento de 65 MXN en Café Divine', '2024-07-01', '2024-07-31', 65, 10),
('CUP086', 'Descuento de 50 MXN en El Rincón del Café', '2024-07-01', '2024-07-31', 50, 11),
('CUP087', 'Descuento de 120 MXN en Café Imperial', '2024-07-01', '2024-07-31', 120, 12),
('CUP088', 'Descuento de 55 MXN en La Nonna', '2024-07-01', '2024-07-31', 55, 13),
('CUP089', 'Descuento de 90 MXN en Café Tía Rosa', '2024-07-01', '2024-07-31', 90, 14),
('CUP090', 'Descuento de 75 MXN en Colonia Café', '2024-07-01', '2024-07-31', 75, 15),
('CUP091', 'Descuento de 60 MXN en Bar San Luis', '2024-07-01', '2024-07-31', 60, 16),
('CUP092', 'Descuento de 45 MXN en La Cervecería', '2024-07-01', '2024-07-31', 45, 17),
('CUP093', 'Descuento de 80 MXN en Bar el Rincón Feliz', '2024-07-01', '2024-07-31', 80, 18),
('CUP094', 'Descuento de 50 MXN en Patio Centenario', '2024-07-01', '2024-07-31', 50, 19),
('CUP095', 'Descuento de 100 MXN en Rocket Bar', '2024-07-01', '2024-07-31', 100, 20),
('CUP096', 'Descuento de 70 MXN en La Terraza de Urlarte', '2024-07-01', '2024-07-31', 70, 21),
('CUP097', 'Descuento de 40 MXN en Jarrita Tapatía', '2024-07-01', '2024-07-31', 40, 22),
('CUP098', 'Descuento de 110 MXN en La Antigua Paz Bar', '2024-07-01', '2024-07-31', 110, 23),
('CUP099', 'Descuento de 90 MXN en Bar Alaska', '2024-07-01', '2024-07-31', 90, 24),
('CUP100', 'Descuento de 65 MXN en El Aljibe Bar', '2024-07-01', '2024-07-31', 65, 25),
('CUP101', 'Descuento de 50 MXN en Esquina del Rock', '2024-07-01', '2024-07-31', 50, 26),
('CUP102', 'Descuento de 120 MXN en El Desván', '2024-07-01', '2024-07-31', 120, 27),
('CUP103', 'Descuento de 55 MXN en Bar La Oficina', '2024-07-01', '2024-07-31', 55, 28),
('CUP104', 'Descuento de 90 MXN en Bar Dublin', '2024-07-01', '2024-07-31', 90, 29),
('CUP105', 'Descuento de 75 MXN en Bar Hamburgueses', '2024-07-01', '2024-07-31', 75, 30),
('CUP106', 'Descuento de 60 MXN en La Casona', '2024-07-01', '2024-07-31', 60, 31),
('CUP107', 'Descuento de 130 MXN en La Casa de los Milagros', '2024-07-01', '2024-07-31', 130, 32),
('CUP108', 'Descuento de 85 MXN en Il Fornaio', '2024-07-01', '2024-07-31', 85, 33),
('CUP109', 'Descuento de 55 MXN en Pollo Feliz Centro', '2024-07-01', '2024-07-31', 55, 34),
('CUP110', 'Descuento de 105 MXN en Mesón de Catedral', '2024-07-01', '2024-07-31', 105, 35),
('CUP111', 'Descuento de 75 MXN en El Hojaldre', '2024-07-01', '2024-07-31', 75, 36),
('CUP112', 'Descuento de 50 MXN en El Retablo', '2024-07-01', '2024-07-31', 50, 37),
('CUP113', 'Descuento de 135 MXN en El Sabor de Oaxaca', '2024-07-01', '2024-07-31', 135, 38),
('CUP114', 'Descuento de 110 MXN en Comedor Familiar', '2024-07-01', '2024-07-31', 110, 39),
('CUP115', 'Descuento de 65 MXN en Taquería La Suriana', '2024-07-01', '2024-07-31', 65, 40),
('CUP116', 'Descuento de 120 MXN en La Sierra', '2024-07-01', '2024-07-31', 120, 41),
('CUP117', 'Descuento de 60 MXN en La Huasteca', '2024-07-01', '2024-07-31', 60, 42),
('CUP118', 'Descuento de 95 MXN en La Mansión', '2024-07-01', '2024-07-31', 95, 43),
('CUP119', 'Descuento de 55 MXN en El Príncipe', '2024-07-01', '2024-07-31', 55, 44),
('CUP120', 'Descuento de 100 MXN en La Callejera', '2024-07-01', '2024-07-31', 100, 45),
('CUP121', 'Descuento de 70 MXN en Moda México', '2024-07-01', '2024-07-31', 70, 46),
('CUP122', 'Descuento de 55 MXN en Boutique Dulce María', '2024-07-01', '2024-07-31', 55, 47),
('CUP123', 'Descuento de 90 MXN en Ropa Mi Sueño', '2024-07-01', '2024-07-31', 90, 48),
('CUP124', 'Descuento de 45 MXN en Recicla Moda', '2024-07-01', '2024-07-31', 45, 49),
('CUP125', 'Descuento de 100 MXN en Boutique Belinda', '2024-07-01', '2024-07-31', 100, 50),
('CUP126', 'Descuento de 110 MXN en Diseños Bárbara', '2024-07-01', '2024-07-31', 110, 51),
('CUP127', 'Descuento de 55 MXN en Indigo Boutique', '2024-07-01', '2024-07-31', 55, 52),
('CUP128', 'Descuento de 70 MXN en Ocasiones Boutique', '2024-07-01', '2024-07-31', 70, 53),
('CUP129', 'Descuento de 50 MXN en Elegance Chihuahua', '2024-07-01', '2024-07-31', 50, 54),
('CUP130', 'Descuento de 125 MXN en Fashion Kiut', '2024-07-01', '2024-07-31', 125, 55),
('CUP131', 'Descuento de 60 MXN en Moda y Estilo', '2024-07-01', '2024-07-31', 60, 56),
('CUP132', 'Descuento de 95 MXN en La Gran Ropa', '2024-07-01', '2024-07-31', 95, 57),
('CUP133', 'Descuento de 40 MXN en Boutique Abril', '2024-07-01', '2024-07-31', 40, 58),
('CUP134', 'Descuento de 75 MXN en Lady Boutique', '2024-07-01', '2024-07-31', 75, 59),
('CUP135', 'Descuento de 90 MXN en Casual Store', '2024-07-01', '2024-07-31', 90, 60);


INSERT INTO usuario_cupon (fk_usuario, fk_cupon, fecha_uso)
VALUES
(1, 1, '2024-06-12'),
(2, 2, '2024-06-13'),
(3, 3, '2024-06-14'),
(4, 4, '2024-06-15'),
(5, 5, '2024-06-16'),
(6, 6, '2024-06-17'),
(7, 7, '2024-06-18'),
(8, 8, '2024-06-19'),
(9, 9, '2024-06-20'),
(10, 10, '2024-06-21'),
(11, 11, '2024-06-22'),
(12, 12, '2024-06-23'),
(13, 13, '2024-06-24'),
(14, 14, '2024-06-25'),
(15, 15, '2024-06-26'),
(1, 16, '2024-06-27'),
(2, 17, '2024-06-28'),
(3, 18, '2024-06-29'),
(4, 19, '2024-06-30'),
(5, 20, '2024-07-01'),
(6, 21, '2024-07-02'),
(7, 22, '2024-07-03'),
(8, 23, '2024-07-04'),
(9, 24, '2024-07-05'),
(10, 25, '2024-07-06'),
(11, 26, '2024-07-07'),
(12, 27, '2024-07-08'),
(13, 28, '2024-07-09'),
(14, 29, '2024-07-10'),
(15, 30, '2024-07-11'),
(1, 31, '2024-07-12'),
(2, 32, '2024-07-13'),
(3, 33, '2024-07-14'),
(4, 34, '2024-07-15'),
(5, 35, '2024-07-16'),
(6, 36, '2024-07-17'),
(7, 37, '2024-07-18'),
(8, 38, '2024-07-19'),
(9, 39, '2024-07-20'),
(10, 40, '2024-07-21'),
(11, 41, '2024-07-22'),
(12, 42, '2024-07-23'),
(13, 43, '2024-07-24'),
(14, 44, '2024-07-25'),
(15, 45, '2024-07-26'),
(1, 46, '2024-07-27'),
(2, 47, '2024-07-28'),
(3, 48, '2024-07-29'),
(4, 49, '2024-07-30'),
(5, 50, '2024-07-31'),
(6, 51, '2024-08-01'),
(7, 52, '2024-08-02'),
(8, 53, '2024-08-03'),
(9, 54, '2024-08-04'),
(10, 55, '2024-08-05'),
(11, 56, '2024-08-06'),
(12, 57, '2024-08-07'),
(13, 58, '2024-08-08'),
(14, 59, '2024-08-09'),
(15, 60, '2024-08-10'),
(1, 76, '2024-08-11'),
(2, 77, '2024-08-12'),
(3, 78, '2024-08-13'),
(4, 79, '2024-08-14'),
(5, 80, '2024-08-15'),
(6, 81, '2024-08-16'),
(7, 82, '2024-08-17'),
(8, 83, '2024-08-18'),
(9, 84, '2024-08-19'),
(10, 85, '2024-08-20'),
(11, 86, '2024-08-21'),
(12, 87, '2024-08-22'),
(13, 88, '2024-08-23'),
(14, 89, '2024-08-24'),
(15, 90, '2024-08-25');


-- Indices
/*
-- Se crea un indice para el nombre de usuarios, para así, poder encontrar más rapido buscando usuarios unicos,
tambien se creará una similar para establecimientos.

*/
create index usr_idx on usuarios (username);
create index correo_idx on usuarios (correo_electronico);

create index empr_idx on empresarios (user_name);
create index emprCorreo_idx on empresarios (correo);

create index establecimiento_idx on establecimientos (nombre_local);

create index cupones_idx on cupones (codigo);

/*
Funciones de agregado
*/

/*
1.- Cupones activos
*/
select codigo, (select nombre_local from establecimientos where id_establecimiento = fk_establecimiento) as establecimiento, fecha_vencimiento
from cupones where fecha_vencimiento > '2024-06-10';

/*
2.- Cupones usados
En este consulta puede parecer un simple 'select * from usuario_cupon', pero se está haciendo uso de una subquery para enlazar directamente un cupon usado con un username
*/
select (select codigo from cupones where id_cupon = fk_cupon) as codigo_cupon, (select username from usuarios where id_usuario = fk_usuario) as User, fecha_uso
from usuario_cupon;

/*
1.- ¿Cuantos establecimientos tenemos?
*/
select count(id_establecimiento)as Cant_establecimientos from establecimientos;

/*
2.- ¿Cuantos establecimientos de cada categoria tenemos?
*/
select (select nombre_categoria from categorias where id_categoria = fk_categoria) as categoria, count(id_establecimiento)as Cant_establecimientos 
from establecimientos
group by fk_categoria;

/*
3.- ¿Cuantos establecimientos tiene cada empresario?
*/
select (select nombre_empresario from empresarios where id_empresario = fk_empresario) as Empresario, count(id_establecimiento) as Cant_establecimientos
from establecimientos
group by fk_empresario;

/*
4.- ¿Cuantos usuarios hay registrados?
*/
select count(id_usuario) Cant_users from usuarios;

/*
5.- ¿Cuantos cupones han usado cada usuario?
*/
select (select username from usuarios where id_usuario = fk_usuario) as User, count(fk_usuario) as Cupones_usados
from usuario_cupon
group by fk_usuario;

/*
5.- ¿Cuantos cupones no han sido usados?
*/
select count(id_cupon) as cuponesNoUsados
from cupones
where id_cupon not in (select fk_cupon from usuario_cupon);

/*
6.- ¿Cupon con mas tiempo de vigencia en el futuro?
falta refinar
*/

select (select nombre_local from establecimientos where id_establecimiento = fk_establecimiento) as Establecimiento, descripcion_cupon, max(fecha_vencimiento) as fechamayor
from cupones 
group by id_cupon order by fecha_vencimiento desc limit 1;

/*
7.- ¿Cupon con mas proximo a vencer en el futuro?
*/

select (select nombre_local from establecimientos where id_establecimiento = fk_establecimiento) as Establecimiento, descripcion_cupon, min(fecha_vencimiento) as fechamayor
from cupones where fecha_vencimiento > CURDATE()
group by id_cupon order by fecha_vencimiento asc limit 1;

/*
ORDENAMIENTO
*/

/*
Cupones ordenados por su fecha de inicio
*/
select id_cupon, fecha_inicio
from cupones
order by fecha_inicio asc;

/*
Establecimientos ordenados por categoria y orden alfabetico
*/
select nombre_local, (select nombre_categoria from categorias where id_categoria = fk_categoria) as categoria
from establecimientos
order by categoria, nombre_local;

/*
Establecimientos ordenados por dueño y orden alfabetico
*/
select  nombre_local, (select nombre_empresario from empresarios where id_empresario = fk_empresario) as empresario
from establecimientos
order by empresario, nombre_local;

/*  VISTAS   */  

-- Vista para cafeterias
create view lugares_cafeterias as select id_establecimiento, nombre_local, telefono_local from establecimientos where fk_categoria = 1;
select * from lugares_cafeterias;

-- Vista para bares
create view lugares_bares as select id_establecimiento, nombre_local, telefono_local from establecimientos where fk_categoria = 2;
select * from lugares_bares;


-- Vista para restaurantes
create view lugares_restaurantes as select id_establecimiento, nombre_local, telefono_local from establecimientos where fk_categoria = 3;
select * from lugares_restaurantes;

-- vista para tiendas de ropa
create view lugares_tiendas_ropa as select id_establecimiento, nombre_local, telefono_local from establecimientos where fk_categoria = 4;
select * from lugares_tiendas_ropa;

-- vista para joyerias
create view lugares_joyerias as select id_establecimiento, nombre_local, telefono_local from establecimientos where fk_categoria = 5;
select * from lugares_joyerias;


/* SUBCONSULTAS  */

-- cupones por dia de la semana, por local, dia de la semana, cupones por empresario, 
-- Usuarios po lugares a los que fueron utilizando los cupones que canjearon


-- cupones por dia de la semana, con su local
select c.id_cupon, e.id_establecimiento, e.nombre_local, c.fecha_inicio, c.fecha_vencimiento from cupones c, establecimientos e where c.fk_establecimiento = e.id_establecimiento;


-- cupones por dia de uso
select dayname(fecha_uso)as dia_semana, count(id_usuario_cupon)as cantidad_cupones from usuario_cupon group by dia_semana;

-- cupones por mes de inicio
select monthname(fecha_inicio) as mes_inicio, count(id_cupon) as cantidad_cupones from cupones group by mes_inicio;

select * from cupones;