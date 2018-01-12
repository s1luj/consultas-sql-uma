-- EJERCICIO 1:
select d.nombre, count(p.id)  
from departamentos d join profesores p on (d.codigo=p.departamento)
group by p.departamento, d.nombre;

desc departamentos;
desc profesores;

-- EJERCICIO 3:
select a.curso, count (distinct m.alumno)
from asignaturas a join matricular m on (a.codigo=m.asignatura)
group by a.curso
having a.curso is not null;

desc asignaturas;
desc matricular;

-- EJERCICIO 5:
desc alumnos;
select * from alumnos;
/*
select count(m.alumno) Alumnas
from asignaturas asig join matricular m on (m.asignatura=asig.codigo) join alumnos alu on (alu.dni=m.alumno)
where alu.genero like 'FEM'
group by m.asignatura, asig.nombre;

select count(m.alumno) AlumnosYalumnas
from asignaturas asig join matricular m on (m.asignatura=asig.codigo) join alumnos alu on (alu.dni=m.alumno)
--where alu.genero like 'FEM'
group by m.asignatura, asig.nombre;*/

select m.asignatura, asig.nombre, count(m.alumno), sum(decode(genero, 'FEM', 1, 0)), round (100*sum(decode(genero, 'FEM', 1, 0))/count(m.alumno), 2) porcentaje
from asignaturas asig join matricular m on (m.asignatura=asig.codigo) join alumnos alu on (alu.dni=m.alumno)
group by m.asignatura, asig.nombre
having round (100*sum(decode(genero, 'FEM', 1, 0))/count(m.alumno)) >20; -- el alias porcentaje no lo pilla, hay que copiar y pegar

-- EJERCICIO 7:
desc profesores;
/*
select d.codigo,d.nombre, p.nombre, min(p.fecha_nacimiento)
from departamentos d join profesores p on (d.codigo= p.departamento)
group by d.codigo,d.nombre, p.nombre;
*/

select *
from profesores
where (departamento, fecha_nacimiento) in (
    select departamento, min(fecha_nacimiento)
    from profesores
    group by departamento
);

select *
from profesores p1
where fecha_nacimiento = (
        select min(fecha_nacimiento)
        from profesores p2
        where p2.departamento=p1.departamento
);

--EJERCICIO 15:
desc asignaturas;
desc impartir;
/*
select distinct(p.id),avg(asig.creditos)
from profesores p join impartir i on (p.id=i.profesor) join asignaturas asig on (asig.codigo=i.asignatura)
group by p.id;
*/
select profesor, sum(carga_creditos)
from impartir
group by profesor
having sum(carga_creditos)>
    (select avg(sum(carga_creditos))
    from impartir
    group by profesor);
    
    
    
--DE AQUÍ PARA ABAJO ME LO PASÓ FERNANDO EL DIA 22 DE DICIEMBRE:
    
--Relacion DML3 - Consultas negativas , subconsultas avanzadas

--Negativas 1
--18
select nombre 
from  departamentos
where codigo not in (
            select departamento
            from asignaturas
            where creditos > 6
            );
            
select nombre 
from  departamentos d
where not exists (
            select *
            from asignaturas
            where creditos > 6 and departamento = d.codigo
            );
            
select nombre from departamentos where codigo in (
select codigo from  departamentos 
minus 
select departamento from asignaturas where creditos > 6 );


--20
select p1.id , p2.id
from profesores p1 join profesores p2 on (p1.id < p2.id)
where not exists (
                select alumno
                from impartir join matricular using (asignatura , curso , grupo)
                where profesor = p1.id
                
                intersect
                
                select alumno
                from impartir join matricular using (asignatura , curso , grupo)
                where profesor = p2.id
                );


--Complementarias 1
--24
select nombre , apellido1 , apellido2
from matricular join alumnos on (alumno = dni)
where alumno not in (
                    select alumno
                    from matricular join impartir using (asignatura , curso , grupo)
                    where profesor in (
                                        select id
                                        from profesores p join departamentos d on (p.departamento = d.codigo)
                                        where upper(d.nombre) = 'MATEMATICA APLICADA'
                                        )
                    )
group by dni , nombre , apellido1 , apellido2
having count(distinct asignatura) > 2;

--28
select nombre  , fecha_nacimiento
from matricular join alumnos on (alumno = dni)
where fecha_nacimiento = (
                        select min (fecha_nacimiento)
                        from matricular join alumnos on (alumno = dni)
                        where curso = '15/16' and asignatura in (
                                                                select asignatura       
                                                                from matricular 
                                                                where curso = '15/16' 
                                                                group by asignatura having count(distinct alumno) > 3 
                                                                )
                        );

select min (fecha_nacimiento)
from matricular join alumnos on (alumno = dni)
where curso = '15/16' and asignatura in (
                                        select asignatura       
                                        from matricular 
                                        where curso = '15/16' 
                                        group by asignatura having count(distinct alumno) > 3 
                                        );


--listar el codigo y nombre de las asignaturas de codigo par junto con el año de creacion 
--del departamento al que pertenecen, para aquellos departamentos que se crearon hace menos de 33 años.
--Usar la funcion MOD.
select a.codigo , a.nombre , to_char(d.fecha_creacion , 'yyyy') "año"
from asignaturas a join departamentos d on (a.departamento = d.codigo)
where  mod(a.codigo,2) = 0 and months_between(sysdate , d.fecha_creacion) < 33*12; 



--obtener nombre y apellidos junto con la nota media de los alumnos que tiene aprobadas mas de tres asignaturas.
--Mostrar unicamente los alumnos que lleven menos de 10 años. Para calcular la nota media , considerar los valores numericos: 
--MH=10,SB=9,etc. Utilizar DECODE y ROUND a 1 decimal.
select a.nombre , a.apellido1 , a.apellido2 , a.fecha_prim_matricula , 
       round ( avg ( decode(m.calificacion , 'MH' , 10 , 'SB' , 9 , 'NT' , 7 , 5)), 1) "MEDIA"
from alumnos a join matricular m on (m.alumno = a.dni)
where m.calificacion in ( 'MH' , 'SB' , 'NT' , 'AP' ) and months_between(sysdate , a.fecha_prim_matricula) < 10*12
group by a.dni , a.nombre , a.apellido1 , a.apellido2 , a.fecha_prim_matricula
having count (distinct m.asignatura) > 3;



--visualizar la asignatura de menos creditos de cada departamento de entre aquellas no impartidas por un profesor 
--que entrase a la universidad antes del año 2000
select departamento , nombre , creditos
from asignaturas 
where codigo not in (
                select i.asignatura
                from impartir i join profesores p on (i.profesor = p.id)
                where extract(year from p.antiguedad) < 2000
            )
            
    and (departamento , creditos) in (
            
                                select departamento ,  min(creditos) "CREDITOS" 
                                from asignaturas 
                                where codigo not in (
                                                select i.asignatura
                                                from impartir i join profesores p on (i.profesor = p.id)
                                                where extract(year from p.antiguedad) < 2000
                                            )
                                group by departamento 
                                );
