CREATE DATABASE clases_particulares_db;

-- Conectarse a la base
-- \c clases_db;

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
);

CREATE TABLE profesorTieneDisponibilidad (
);

CREATE TABLE Clase (
  id_clase INT PRIMARY KEY,

  duracion_en_horas FLOAT,
  modalidad VARCHAR(50),
  estado VARCHAR(50),
  id_profesor INT NOT NULL,

  FOREIGN KEY (id_profesor) REFERENCES Profesor(id_profesor)
);


CREATE TABLE Inscripcion (
  id_estudiante INT,
  id_clase INT,

  estado_inscripcion VARCHAR(50), -- xq esto?
  fecha_inscripcion TIMESTAMP, -- idem

  PRIMARY KEY (id_estudiante, id_clase),

  FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante) ON DELETE CASCADE,
  FOREIGN KEY (id_clase) REFERENCES Clase(id_clase) ON DELETE CASCADE
);


CREATE TABLE Pago (
  id_pago SERIAL PRIMARY KEY,
  numero_recibo VARCHAR(100) UNIQUE,

  id_clase INTEGER NOT NULL,
  metodo VARCHAR(50),
  estado_pago VARCHAR(50),
  monto NUMERIC(10,2),

  FOREIGN KEY (id_clase) REFERENCES Clase(id_clase) ON DELETE CASCADE
);


CREATE TABLE Reseña (
  id_reseña SERIAL PRIMARY KEY,
  id_estudiante INTEGER NOT NULL,
  id_profesor INTEGER NOT NULL,

  puntaje SMALLINT,
  comentario TEXT,
  fecha TIMESTAMP DEFAULT now(),


  FOREIGN KEY (id_estudiante) REFERENCES Estudiante(id_estudiante) ON DELETE CASCADE,
  FOREIGN KEY (id_profesor) REFERENCES Profesor(id_usuario) ON DELETE CASCADE
);

