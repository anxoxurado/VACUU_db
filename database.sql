create database VACUU;
use VACUU;

CREATE TABLE empresario (
  id_empresario int not null primary key auto_increment,
  nombre_empresario varchar(45) not null,
  correo varchar(45) not null,
  user_name varchar(10) not null,
  contraseña_empresario varchar(45) not null,
  telefono varchar(15) not null
  );
  
  create table categoria (
  id_categoria int not null auto_increment primary key,
  nombre_categoria varchar(20) not null,
  descripcion varchar(150) not null
  );
  
  create table establecimiento(
  id_establecimiento int not null auto_increment primary key,
  nombre_local varchar(45) not null,
  calle_numero varchar(45) not null,
  colonia varchar(45) not null,
  codigo_postal varchar(45) not null,
  telefono_local varchar(45) not null,
  fk_categoria int not null,
  fk_empresario int not null,
  foreign key(fk_categoria) references categoria(id_categoria),
  foreign key(fk_empresario) references empresario(id_empresario)
  );
  
create table cupones(
id_cupones int not null auto_increment primary key,
codigo varchar(6) not null,
descripcion_cupon varchar(100),
fecha_inicio date,
fecha_vencimiento date,
fk_establecimiento int not null,
foreign key(fk_establecimiento) references establecimiento(id_establecimiento)
);

create table usuario(
id_usuario int not null auto_increment primary key,
username varchar(40) not null,
correo_electronico varchar(40) not null,
contraseña_usuario varchar(30) not null
);

create table usuario_cupon(
  id_usuario_cupon int not null auto_increment primary key,
  fk_usuario int not null,
  fk_cupon int not null,
  fecha_uso date
);

/* INSERTAR DATOS  */
