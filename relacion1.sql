-- Referencia de sql: Buscar en google sql reference oracle

-- Control+intro(o el boton verde de arriba, sirve para ejecutar la setencia (en la que esta el cursor)
-- en el usuario docencia, vistas: estan las soluciones de los ejercicios (en la pestaña datos)

-- NVL (EXPRESION1, EXPRESION2) <= si expresion1 es null no da las expresion2
-- Por ejemplo: nvl(to_char (creditos), 'No definido') <= en vez de sacar null, saca un mensaje "No definido"

-- Lo suyo primero es poner un select * from "la tabla que sea". Ver lo que hay. Luego poner el elemento que condiciona en el select, para ver si fucnciona. cuando funcione pasarlo al where.


-- EJERCICIOS HECHOS POR EL PROFESOR
-- EJERCICIO 5 (siempre tiene que haber un select y un from) (lo de nvl no lo pide el ejercicio, pero se ha usado para explicar en clase)
select nombre, nvl(to_char(creditos),'No definido') "Creditos Totales", teoricos/creditos*100 "% teoricos", nvl(to_char(practicos/creditos*100),'No definido') "% practicos"
from asignaturas
where curso=1;

-- EJERCICIO 15
select *
from alumnos
where MONTHS_BETWEEN (fecha_prim_matricula, fecha_nacimiento)/12 < 18;

--EJERCICIO 16
select *                       --select to_char(fecha_prim_matricula, 'yyyy, month, day')
from alumnos
where lower(to_char(fecha_prim_matricula, 'day')) like 'lunes%'; -- lower pasa todo a minusculas, y upper va a mayusculas

-- EJERCICIOS HECHOS POR MI EN CLASE:
-- EJERCICIO 1:
select nombre, apellido1, apellido2
from profesores
where departamento = 1;

-- EJERCICIO 2:
select nombre, apellido1, apellido2
from profesores
where departamento != 3;

-- EJERCICIO 3:
select *
from profesores
where lower(email) like '%lcc.uma.es';

-- EJERCICIO 4:
select nombre, apellido1, apellido2
from alumnos
where email is null;

-- EJERCICIO 6:
select alumno, calificacion
from matricular
where asignatura = 112
order by alumno;

-- EJERCICIO 7:
select nombre, hombres + mujeres "Poblacion"
from MUNICIPIO;

-- USO DE FUNCIONES

-- EJERCICIO 8:
--select concat ('El/la alumno/a ', concat(nombre, ' no tiene correo'))
select 'El alumno ' || nombre || ' ' || apellido1 || ' ' || apellido2 ||' no tiene correo' -- Otra forma de concatenar (esta es mas rapida)
from alumnos
where email is null;

-- EJERCICIO 9:
select *
from profesores
where TO_DATE ('01/01/1990', 'DD/MM/YYYY')>ANTIGUEDAD;   -- LAS FECHAS MAYORES SON LAS MAS ANTIGUAS, LAS MENORES LAS MAS NUEVAS

-- EJERCICIO 10:
SELECT nombre, apellido1, apellido2
FROM PROFESORES
where months_between(sysdate,fecha_nacimiento)/12 <30;

-- EJERCICIO 11:
select upper(nombre), upper(apellido1), upper(apellido2), trunc(months_between(sysdate, antiguedad)/12/3) "Trienios"
from profesores
where trunc(months_between(sysdate, antiguedad)/12/3)>=3;

-- EJERCICIO 12:
select replace('BASES and ALMACENES') "upper(nombre)"
from asignaturas
where upper(nombre) like '%BASES DE DATOS%';