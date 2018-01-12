 -- Subconsultas
 
-- Listar el nombre de las asignaturas que tienen más créditos que la asignatura llamada ‘Bases de Datos’ 
select Nombre
from asignaturas
where creditos > (select creditos from asignaturas
                 where upper(Nombre)='BASES DE DATOS');
                 
-- Consultas anidaddas (correlacionales)
-- AL FINAL DE LA PAGINA

-- ALL, ANY 
select Nombre
from asignaturas
where creditos > all (select creditos from asignaturas -- es un y, para las dos asignaturas. > ALL maximo en este caso
                 where upper(Nombre) like 'E%');
                 
select Nombre
from asignaturas
where creditos > any (select creditos from asignaturas -- algun. minimo en este caso
                 where upper(Nombre) like 'E%');
                 
/*Listar el nombre de las asignaturas que tienen mas créditos que 
ALGUNA DE
las asignaturas de segundo curso.*/
SELECT Nombre
FROM Asignaturas
WHERE 
creditos
> ANY (SELECT 
creditos
FROM Asignaturas
WHERE curso = 2 ) ;

/*Listar el nombre de las asignaturas que tienen mas créditos que 
TODAS
las 
asignaturas de segundo curso*/

SELECT Nombre
FROM Asignaturas
WHERE 
creditos
> ALL (SELECT 
creditos
FROM Asignaturas
WHERE curso = 2 ) ;

-- IN /EXISTS
select *
from matricular
where calificacion in ('SB', 'MH'); -- not in para lo contrario

/*Mostrar el código y el nombre de las asignaturas que imparte el profesor manuel enciso*/

---------------------------------------------------------------------------------------
-- * nombre y apellidos de profesores qu e impartieron clase en el curso 15/16
--primera forma con in (esta se piensa mejor)
select nombre,apellido1,apellido2
from profesores
where id IN
(select profesor
from impartir
where curso = '15/16')
order by apellido1,apellido2;

-- otra forma(con join)
select nombre,apellido1, apellido2
from profesores p join impartir i on (p.id=i.profesor)
where i.curso='15/16'
order by apellido1, apellido2;
--------------------------------------------------------------------------------------

-- Consultas correlacionadas --tienen alto coste computacional
select *
from asignaturas asig1
where creditos>=all (select creditos
                     from asignaturas asig2
                     where asig2.curso=asig1.curso)
ORDER BY curso, creditos;
------------------------------------------------------------------------
-- operador exists (esta relacionado con las consultas correlacionadas)
------------------------------------------------------------------------

-- *ejemplo: profesores que no han impartido clase en el curso 15/16
select *
from profesores prof1
where not exists(
    select *
    from impartir imp
    where imp.profesor=prof1.id and curso = '15/16'
);

select id from profesores
minus -- para hacer un minus lo que salga de los selec deben ser compatibles
select profesor from impartir where curso ='15/16';

select *
from profesores
where id in (
    select id from profesores
    minus
    select profesor --..........
);



-- mostrar el código de los alumnosque reciven clase del profesor de código C-34-TU-00
SELECT Alumno "CodigoAlumno"
FROM Matricular 
WHERE (Asignatura, Grupo, Curso) IN (
    SELECT Asignatura, Grupo, Curso
    FROM Impartir
    WHERE Profesor = 'C-34-TU-00'
);

-- mostrar el nombre de los alumnosque reciven clase del profesor de código C-34-TU-00
SELECT nombre, apellido1, apellido2, Alumno "CodigoAlumno"
FROM Matricular join alumnos on (DNI= alumno)
WHERE (Asignatura, Grupo, Curso) IN (
    SELECT Asignatura, Grupo, Curso
    FROM Impartir
    WHERE Profesor = 'C-34-TU-00'
); 


----------------------------------------------------------------
-- CONSULTAS NEGATIVAS
----------------------------------------------------------------


-- Ejercicio 4. mostrar las parejas de profesores que no tienen ningún alumno en común
select p1.nombre, p1.apellido1, p2.nombre, p2.apellido
from profesores p1, profesores p2
where p1.id>p2.id and not exists(
        select alumno from matricular where (Asignatura,grupmcurso) in
            (select asignatura,grupo,curso from impartir where profesor =p1.id)
            --....................
);

-- Profesor mas viejo
--select min(fecha_nacimiento) from profesores;
select *
from profesores
where fecha_nacimiento=(select min(fecha_nacimiento) from profesores);

--Profesor mas joven
select *
from profesores
where fecha_nacimiento=(select max(fecha_nacimiento) from profesores);

-- media de los creditos
select avg(creditos)
from asignaturas;

--mediana de los creditos
select median(creditos)
from asignaturas;

-- cuantas asignaturas hay??
select count(nombre)
from asignaturas;

-- suma de todos los creditos conocidos de todas las asignaturas
select sum(creditos)
from asignaturas;

-- columna generada automaticamente(los numeritos de la izquierda)
select rownum, nombre,creditos
from asignaturas;

-- dame las cinco primeras asignaturas
select rownum, nombre, creditos
from asignaturas
where rownum <=5;

--direccion de memoria abstracta en disco duro donde se encuentra cada dato
select rowid, nombre, creditos
from asignaturas;

--



--grupos (más a fondo en la siguiente clase)
select curso, max(creditos) -- hace falta una operacion que machaque todos los datos y las convierta a uno solo, como max, avg, median, etc...
from asignaturas
group by curso;

select *
from asignaturas
where (curso, creditos) in (
        select curso, max(creditos)
        from asignaturas
        group by curso
);