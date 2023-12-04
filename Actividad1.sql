use laboratorio_senati;

CREATE TABLE personas (
    id_persona INT PRIMARY KEY,
    nombre VARCHAR(50),
    apellido VARCHAR(50),
    fecha_nacimiento DATE,
    direccion VARCHAR(100),
    documento VARCHAR(20),
    correo VARCHAR(50)
);
CREATE TABLE alumnos (
    id_alumno INT PRIMARY KEY,
    id_persona INT,
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);
CREATE TABLE docentes (
    id_docente INT PRIMARY KEY,
    id_persona INT,
    tipo_contrato VARCHAR(50),
    FOREIGN KEY (id_persona) REFERENCES personas(id_persona)
);
CREATE TABLE cursos (
    id_curso INT PRIMARY KEY,
    id_docente INT,
    nombre_curso VARCHAR(50),
    descripcion TEXT,
    creditos INT,
    FOREIGN KEY (id_docente) REFERENCES docentes(id_docente)
);
CREATE TABLE periodo_academico (
    id_periodo INT PRIMARY KEY,
    nombre_periodo VARCHAR(50)
);

CREATE TABLE matriculas (
    id_matricula INT PRIMARY KEY,
    id_alumno INT,
    fecha_matricula DATE,
    estado_matricula VARCHAR(20),
    id_periodo INT,
    pago_total DECIMAL(10, 2),
    FOREIGN KEY (id_alumno) REFERENCES alumnos(id_alumno),
    FOREIGN KEY (id_periodo) REFERENCES periodo_academico(id_periodo)
);
CREATE TABLE matricula_detalle (
    id_matricula_detalle INT PRIMARY KEY,
    id_matricula INT,
    id_curso INT,
    precio_curso DECIMAL(10, 2),
    FOREIGN KEY (id_matricula) REFERENCES matriculas(id_matricula),
    FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
);
CREATE TABLE calificaciones (
    id_calificacion INT PRIMARY KEY,
    id_matricula_detalle INT,
    nota DECIMAL(5, 2),
    FOREIGN KEY (id_matricula_detalle) REFERENCES matricula_detalle(id_matricula_detalle)
);

-- Insertar registros en la tabla personas
INSERT INTO personas (id_persona, nombre, apellido, fecha_nacimiento, direccion, documento, correo)
VALUES
(1, 'Juan', 'Pérez', '1990-05-15', 'Calle 123', '12345678', 'juan.perez@email.com'),
(2, 'María', 'Gómez', '1985-08-22', 'Avenida XYZ', '87654321', 'maria.gomez@email.com'),
(3, 'Carlos', 'Rodríguez', '1992-03-10', 'Paseo ABC', '23456789', 'carlos.rodriguez@email.com'),
(4, 'Laura', 'Fernández', '1988-11-30', 'Ruta 456', '34567890', 'laura.fernandez@email.com'),
(5, 'Alejandro', 'Hernández', '1995-06-25', 'Carrera MNO', '45678901', 'alejandro.hernandez@email.com'),
(6, 'Ana', 'López', '1983-09-18', 'Callejón 789', '56789012', 'ana.lopez@email.com'),
(7, 'Pedro', 'Martínez', '1998-02-03', 'Avenida PQR', '67890123', 'pedro.martinez@email.com'),
(8, 'Sofía', 'Díaz', '1980-07-12', 'Circunvalación 321', '78901234', 'sofia.diaz@email.com'),
(9, 'Javier', 'García', '1993-04-20', 'Bulevar XYZ', '89012345', 'javier.garcia@email.com'),
(10, 'Marta', 'Sánchez', '1986-01-08', 'Ronda 654', '90123456', 'marta.sanchez@email.com'),
(11, 'Lucía', 'Ramírez', '1994-07-05', 'Avenida UVW', '01234567', 'lucia.ramirez@email.com'),
(12, 'Fernando', 'Torres', '1982-12-28', 'Calle 987', '23456789', 'fernando.torres@email.com'),
(13, 'Isabel', 'Gutiérrez', '1991-10-15', 'Paseo DEF', '34567890', 'isabel.gutierrez@email.com'),
(14, 'Raúl', 'Morales', '1987-05-22', 'Ruta 876', '45678901', 'raul.morales@email.com'),
(15, 'Elena', 'Ortega', '1996-03-17', 'Carrera JKL', '56789012', 'elena.ortega@email.com'),
(16, 'Roberto', 'Vega', '1984-08-10', 'Callejón 345', '67890123', 'roberto.vega@email.com'),
(17, 'Luisa', 'Navarro', '1999-01-25', 'Avenida GHI', '78901234', 'luisa.navarro@email.com'),
(18, 'Gabriel', 'Cruz', '1981-06-19', 'Circunvalación 678', '89012345', 'gabriel.cruz@email.com'),
(19, 'Natalia', 'Herrera', '1997-04-03', 'Bulevar NOP', '90123456', 'natalia.herrera@email.com'),
(20, 'Andrés', 'Mendoza', '1989-09-12', 'Ronda 123', '01234567', 'andres.mendoza@email.com');

INSERT INTO alumnos (id_alumno, id_persona)
SELECT TOP 5 p.id_persona, p.id_persona
FROM personas p
ORDER BY p.id_persona ASC;

select * from alumnos;  

---Alumnos----
create function fn_mostrar_name_alumnos(

@id_alumno int
)

returns nvarchar (200)

as
begin
 declare @nombre nvarchar (59);
 declare @apellido nvarchar (59);

 select @nombre = p.nombre, @apellido = p.apellido from personas as p
inner join alumnos as a
on p.id_persona = a.id_persona 
WHERE a.id_alumno =  @id_alumno;

return concat (UPPER(@nombre),',' ,@apellido);

END;

SELECT * FROM alumnos;
SELECT DBO. fn_mostrar_name_alumnos(5) as nombre_alumno;

----Profesores-----
create function fn_mostrar_name(

@id_docente int
)

returns nvarchar (255)

as
begin
 declare @nombre nvarchar (59);
 declare @apellido nvarchar (59);

 select @nombre = p.nombre, @apellido = p.apellido from personas as p
inner join docentes as d on p.id_persona = d.id_persona 
WHERE D.id_docente =  @id_docente;

return concat (UPPER(@nombre),',' ,@apellido);

END;

SELECT * FROM docentes;
SELECT DBO. fn_mostrar_name(15) as nombre_docente;
---Reporte Alumno---
SELECT
	p.nombre,
	p.apellido,
	p.fecha_nacimiento,
	p.direccion,
	p.correo,
	dbo.fn_mostrar_name_alumnos(a.id_alumno) as nombre_alumno
FROM personas as p
INNER JOIN alumnos as a  on a.id_persona = p.id_persona
;
---Reporte Docente---
SELECT
	p.nombre, 
	p.apellido, 
	p.fecha_nacimiento,
	p.direccion,
	p.correo,
	dbo.fn_mostrar_name(d.id_docente) as nombre_docente
FROM personas as p

INNER JOIN docentes as d on d.id_persona = p.id_persona;