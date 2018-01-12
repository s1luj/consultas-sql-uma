desc profesores;

select distinct p.nombre, p.apellido1, p.apellido2, i.asignatura
from profesores p, impartir i
where p.id = i.profesor and p.apellido1 like 'S%' or apellido2 like 'S%'
order by p.nombre, i.asignatura;



select distinct p.nombre, p.apellido1, p.apellido2, i.asignatura, a.nombre
from profesores p JOIN impartir i ON (p.id = i.profesor) JOIN asignaturas a ON (i.asignatura=a.codigo) -- JOIN se usa para establecer las relaciones entre las tablas
where p.apellido1 like 'S%' or apellido2 like 'S%'
order by p.nombre, i.asignatura;

desc impartir;
desc asignaturas;

select distinct p.nombre, p.apellido1, p.apellido2, a.nombre "Asignatura"
from profesores p JOIN impartir i ON (p.id = i.profesor) JOIN asignaturas a ON (i.asignatura=a.codigo)
where p.apellido1 like 'S%' or apellido2 like 'S%'
order by p.nombre;

desc profesores;

select p.nombre, p.apellido1, p.director_tesis, d.nombre "Nombre director" 
from profesores p join profesores d on (d.id = p.director_tesis); -- relacion reflexiva

select p.nombre, p.director_tesis, d.nombre "Nombre director" 
from profesores p left outer join profesores d on (d.id = p.director_tesis);

-- Consultas raras:
-- Parejas de profesores que estan en el mismo departamento:
select p1.nombre, p1.apellido1, p2.nombre, p2.apellido1, d.nombre
from profesores p1 join profesores p2 on (p1.departamento = p2.departamento and p1.id < p2.id) -- la ultima condicion es para que no se repitan
                    join departamentos d on (d.codigo = p1.departamento); 
                    
desc departamentos;

desc matricular;

-- No lo recomienda el profesor:
select alumno, profesor
from impartir natural join matricular
where curso = '15/16';

-- así mejor con un (joing using)
select alumno, profesor
from impartir join matricular using (asignatura, grupo , curso)
where curso = '15/16';


-- Ejercicios (trasparencias):
-- Ejercicio 1:
select al.nombre, mat.calificacion
from alumnos al join matricular mat on (al.dni = mat.alumno) join asignaturas asig on (mat.asignatura = asig.codigo)
where nvl(mat.calificacion, 'SP') != 'SP' and upper(asig.nombre)= 'BASES DE DATOS'; -- mat.calificacion is not null tambien vale

desc matricular;

