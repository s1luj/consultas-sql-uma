--AGRUPACIONES

-- max ->maximo
-- min -> minimo
-- count -> cuantos registros hay

select departamento,round (avg(creditos),2) media --round redondea a X decimales (2 en este caso)
from asignaturas
group by departamento;

select departamento,d.nombre,round (avg(creditos),2) media, round(max(creditos),2) maximo --round redondea a X decimales (2 en este caso)
from asignaturas a join departamentos d on (a.departamento=d.codigo)
group by departamento, d.nombre; -- hay que agrupar por todos los que no sean resumenes

select departamento,d.nombre,round (avg(creditos),2) media, round(max(creditos),2) maximo --round redondea a X decimales (2 en este caso)
from asignaturas a join departamentos d on (a.departamento=d.codigo)
group by departamento, d.nombre; -- hay que agrupar por todos los que no sean resumenes
having avg(a.creditos)>6 --condicion a aplicar  en un resumen se pone en havin (en where no)



select min(apellido1) "Menor apellido", p.departamento, d.nombre
from profesores p join departamentos d on (p.departamento = d.codigo)
group by p.departamento, d.nombre;

/* orden de ejecucion de la sentencia select
5-select
1-from
2-where
3-group by
4-having
6-order by
*/

-- ROWNUM
select rownum, nombre
from profesores
where apellido2 is not null and rownum <=5; -- da los 5 primeros de la lista

select rownum, nombre
from profesores
where apellido2 is not null and rownum >2; -- no da nada, porque el rownum hace referencia a la posicion del resultado, siempre tiene que haber un 1

------ ANIDAMIENTO AVANZADO
select *
from asignaturas
where rownum<=3 and creditos is not null -- no sale bien, porque yo quiero las tres primeras una vez ordenadas(tiene que ver con los ordenes de ejecucion)
order by creditos desc;

select *
from (select *
    from asignaturas
    where creditos is not null
    order by creditos desc
    )
where rownum <=3; -- así si funciona (usando ANIDAMIENTO AVANZADO)

--------------------

select asig.*
from asignaturas asig
where (25, asig.codigo) in (
    select count(distinct alumno), asignatura
    from matricular
    group by asignatura
    );
    
select asig.*
from asignaturas asig
where 25 <= (select count (distinct alumno)
            from matricular
            where asig.codigo =asignatura);
            
select asig.*
from asignaturas asig
where codigo in (
    select asignatura
    from matricular
    group by asignatura
    having count (distinct alumno)>=25
    ); -- da igual esta o la anterior, pero el profesor prefiere esta
    

select asig.*, numero
from asignaturas asig join (
    select count (distinct alumno) as numero, asignatura
    from matricular
    group by asignatura
    ) on (asig.codigo = asignatura)
where numero >=25;


-- Ejercicio 3 de las diapositivas DMLIV (hecho en clase):
select a.dni, a.apellido1, a.apellido2, a.nombre, a.email, trunc(months_between(sysdate,a.fecha_nacimiento)/12) "Edad"
from alumnos a join matricular m on (m.alumno=a.dni)
where m.asignatura in (
            select asignatura
            from (
                select count (distinct alumno) as numero, asignatura
                from matricular
                group by asignatura
                order by numero desc
                )
            where rownum < 2 
            )
;