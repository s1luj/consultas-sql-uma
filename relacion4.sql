select 'HOLA'
from dual;


select *
from (  select *
        from asignaturas
        where creditos is not null
        order by creditos desc)
where rownum <=2;

-- EJERCICIO 1: (hecho en clase)
/*select p1.nombre, p1.apellido1, p2.nombre, p2.apellido1, i1.asignatura, i2.asignatura
from profesores p1 join impartir i1 on (i1.profesor = p1.id), profesores p2 join impartir i2 on (p2.id=i2.profesor)
where i1.asignatura=i2.asignatura;*/ -- <- ESTA MAL

desc impartir;
desc profesores;

select p1.id, p2.id
from profesores p1 join profesores p2 on (p1.id>p2.id)
where not exists ( -- (A-B)U(B-A)
    select asignatura from impartir where profesor = p1.id -- A
    MINUS -- -
    select asignatura from impartir where profesor = p2.id -- B
UNION
    select asignatura from impartir where profesor = p2.id -- B
    minus -- -
    select asignatura from impartir where profesor = p1.id -- A
);

create view prueba as select * from profesores; -- aún no se puede hacer porque no han dado privilegios

-- EJERCICIO 2:
desc profesores;
desc impartir;

select
from alumnos a
where a.dni  in (
    select distinct m.alumno -- alumnos matriculados en alguna asignatura que no sea de matematica aplicada
    from matricular m join asignaturas a on (m.asignatura=a.codigo) join departamentos d on (d.codigo=a.departamento)
    where d.nombre != 'Matematica Aplicada'
    );
    
select distinct m.alumno
    from matricular m join asignaturas a on (m.asignatura=a.codigo) join departamentos d on (d.codigo=a.departamento)
    where d.nombre != 'Matematica Aplicada';
    ----------------------------------------------------------------------
    
-- EJERCICIO 3: !!!!!!!!!!!!!!!!!!!
desc matricular;
select * from matricular;

select a1.nombre, a1.apellido1, a2.nombre, a2.apellido2
from alumnos a1 join alumnos a2 on (a1.dni<a2.dni)
where all(select m1.asignatura, m1.grupo
        from matricular m1
        where m1.alumno=a1.dni) !=  all(select m2.asignatura, m2.grupo
                                    from matricular m2
                                    where m2.alumno=a2.dni);


--EJERCICIO 5: (HECHO EN CLASE)
select a.dni
from alumnos a join matricular m on (a.dni = m.ALUMNO)
where a.genero = 'MASC'
group by a.dni
having count(distinct asignatura) >=3;

-- create view alumnos_masc_3 as (la pedazo de consulta enterior); -- aún no se puede hacer porque no han dado privilegios
-- con las vistas metemos dentro consultas grandes, en plan macros

select *
from GALVEZ.ALUMNOS_MASC_3 a1 join GALVEZ.ALUMNOS_MASC_3 a2 on (a1.dni>a2.dni);

select alumno, profesor
from matricular join impartir using(asignatura,grupo,curso)
group by alumno, profesor
having count(*) >= 2; -- "EL EJERCICIO NO ESTÁ BIEN EXPLICADO, PASAMOS AL SIGUIENTE"

-- EJERCICIO 6: (hecho en clase)
select a.*, 0.5*practicos+1*teoricos "NCN"
from asignaturas a;

create view asignaturas2 as select a.*, 0.5*practicos+1*teoricos "NCN" from asignaturas a; -- aun no se puede hasta que den permisos(el profesor ha creado una igual publica

select * from galvez.asignaturas2;

select asig.ncn*count(distinct m.alumno) "CNTA"
from galvez.asignaturas2 asig join matricular m on (m.asignatura=asig.codigo);

select asignatura, count(*)
from matricular
group by asignatura;

select a.*, cuenta, ncn*cuenta "CNTA"
from galvez.asignaturas2 a left outer join (
                select asignatura, count(*) cuenta
                from matricular
                group by asignatura
        ) b on (a.codigo=b.asignatura);

create view asignaturas3 as ( -- crear una vista de la consulta anterior
            select a.*, cuenta, ncn*cuenta "CNTA"
            from galvez.asignaturas2 a left outer join (
                select asignatura, count(*) cuenta
                from matricular
                group by asignatura
        ) b on (a.codigo=b.asignatura)
);
        
        
select * from galvez.asignaturas3;        -- es la consulta anterior

select i.*, cnta*i.carga_creditos/a.creditos "CNTAP"
from impartir i join galvez.asignaturas3 a on (codigo = asignatura);

create view impartir2 as (
        select i.*, cnta*i.carga_creditos/a.creditos "CNTAP"
        from impartir i join galvez.asignaturas3 a on (codigo = asignatura);
);

select * from galvez.impartir2;

-- solucion:
select profesor, sum(CNTAP) -- por cada profesor sacamos su cntap
from galvez.impartir2
group by profesor; -- agrupamos por profesor

-- EJERCICIO 2: (hecho en clase) -- ejemplo de consulta que no caería en el exmanen, de larga que es.... pero viene muy bien para practicar
--mio
select distinct a.dni
from alumnos a join matricular m on (a.dni=m.alumno) join asignaturas asig on (m.asignatura=asig.codigo) join departamentos d on (asig.departamento=d.codigo)
where d.nombre not like 'Matematica Aplicada';

-- del profesor
select distinct alumno
from matricular m join asignaturas a on (m.asignatura = a.codigo) join departamentos d on (a.departamento= d.codigo)
where UPPER(d.nombre) <> 'MATEMATICA APLICADA';

--continuar en casa
