CREATE DATABASE clases_particulares_db;

-- Conectarse a la base
-- \c clases_particulares_db;

CREATE TABLE usuarios (
    id_usuario INT PRIMARY KEY,

    dni INT UNIQUE NOT NULL,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(50) UNIQUE NOT NULL,
    contraseña VARCHAR(50) NOT NULL
);

CREATE TABLE estudiante (
    id_estudiante INT PRIMARY KEY,

    nivel_academico VARCHAR(20) NOT NULL,
    edad INT,

    FOREIGN KEY (id_estudiante) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
);

CREATE TABLE profesor (
    id_profesor INT PRIMARY KEY,

    telefono INT UNIQUE,
    años_experiencia INT,
    tarifa INT NOT NULL, -- (podría ser un float tmb)

    FOREIGN KEY (id_profesor) REFERENCES usuarios(id_usuario) ON DELETE CASCADE
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
    nivel VARCHAR(20) -- ver esto del nivel
);

CREATE TABLE profesorEnseñaMateria (
    id_profesor INT
    id_materia INT

    PRIMARY KEY (id_profesor, id_materia),
    
    FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor) ON DELETE CASCADE,
    FOREIGN KEY (id_materia) REFERENCES materia(id_materia) ON DELETE CASCADE
);

CREATE TABLE disponibilidad (
  dia_semana VARCHAR(20),
  horario_inicio TIME(0),
  horario_fin TIME(0),

  PRIMARY KEY (dia_semana, horario_inicio, horario_fin)
);

CREATE TABLE profesorTieneDisponibilidad (
  id_profesor INT,
  dia_semana VARCHAR(20),
  horario_inicio TIME(0),
  horario_fin TIME(0),

  PRIMARY KEY (id_profesor, dia_semana, horario_inicio, horario_fin),

  FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor) ON DELETE CASCADE,
  FOREIGN KEY (dia_semana, horario_inicio, horario_fin) REFERENCES disponibilidad(dia_semana, horario_inicio, horario_fin) ON DELETE CASCADE
);

CREATE TABLE clase (
  id_clase INT PRIMARY KEY,

  duracion_en_horas FLOAT,
  fecha_y_hora TIMESTAMP(0), -- esto hay que agregarlo en el diagrama y en las tablas
  modalidad VARCHAR(50),
  estado VARCHAR(50),
  id_profesor INT NOT NULL,

  FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor)
);

CREATE TABLE inscripcion (
  id_estudiante INT,
  id_clase INT,

  PRIMARY KEY (id_estudiante, id_clase),

  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
  FOREIGN KEY (id_clase) REFERENCES clase(id_clase) ON DELETE CASCADE
);

CREATE TABLE Pago (
  id_pago PRIMARY KEY,

  numero_recibo VARCHAR(30) UNIQUE,
  id_clase INTEGER NOT NULL,
  metodo VARCHAR(30),
  estado_pago VARCHAR(30),
  monto FLOAT, -- preguntar como se hace con los atributos derivados

  FOREIGN KEY (id_clase) REFERENCES clase(id_clase) ON DELETE CASCADE
);

CREATE TABLE Reseña (
  -- id_reseña PRIMARY KEY,
  id_estudiante INT NOT NULL,
  id_profesor INT NOT NULL,

  puntaje INT,
  comentario VARCHAR(300),
  fecha TIMESTAMP(0),

  PRIMARY KEY (id_estudiante, id_profesor),

  FOREIGN KEY (id_estudiante) REFERENCES estudiante(id_estudiante) ON DELETE CASCADE,
  FOREIGN KEY (id_profesor) REFERENCES profesor(id_profesor) ON DELETE CASCADE
);

