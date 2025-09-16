CREATE DATABASE clases_particulares_db;

-- Conectarse a la base
-- \c clases_db;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY,
    dni INT UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(50)
);

CREATE TABLE estudiante (
    id_estudiante INT PRIMARY KEY REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    nivel_academico VARCHAR(20) NOT NULL,
    edad INT
);

CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY REFERENCES usuarios(id_usuario) ON DELETE CASCADE,
    telefono INT UNIQUE,
    años_experiencia INT,
    tarifa INT NOT NULL, -- (podría ser un float tmb)
    dni INT UNIQUE NOT NULL
);

CREATE TABLE grupo (
    id_grupo INT PRIMARY KEY,
    nombre VARCHAR(50)
);

CREATE TABLE estudiantePerteneceGrupo (
    id_estudiante INT,
    id_grupo INT,

    PRIMARY KEY (id_estudiante, id_grupo),
    
    FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
    FOREIGN KEY (id_grupo) REFERENCES grupo(id_grupo) ON DELETE CASCADE
);

CREATE TABLE materia (
    id_materia INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nivel VARCHAR(20)
);

CREATE TABLE profesorEnseñaMateria (
    id_profesor INT
    id_materia INT

    PRIMARY KEY (id_profesor, id_materia),
    
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor) ON DELETE CASCADE,
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia) ON DELETE CASCADE
);

CREATE TABLE disponibilidad (
);

CREATE TABLE profesorTieneDisponibilidad (
);

CREATE TABLE clase (
);

CREATE TABLE inscripcion (
);

CREATE TABLE pago (
);

CREATE TABLE reseña (
);
