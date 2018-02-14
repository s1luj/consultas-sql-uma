-- EJERCICIO 1:
desc alumnos;

select initcap(nombre), apellido1, apellido2, trunc(abs(months_between(sysdate,fecha_nacimiento)/12)) "Edad"
from alumnos
where email is not null and abs(months_between(sysdate,fecha_nacimiento)/12)<27;

-- EJERCICIO 2:
desc profesores;

select nombre, apellido1, apellido2, next_day(to_date(to_char(antiguedad,'dd/mm/')||to_char(sysdate,'yy')), 'VIERNES') "Primer viernes"
from profesores
where abs(months_between(sysdate,antiguedad)/12)>20;

select to_date(sysdate,'dd/mm/yy') from dual;

-- EJERCICIO 3:
desc alumnos;
desc matricular;

        --AP=1, NT=2, SB=3 y MH=4
        
select *
from (select a.nombre, a.apellido1, a.apellido2, ROUND(avg(decode(m.calificacion, 'AP',1,'NT',2,'SB',3,'MH',4)),2) "Nota Media"
        from alumnos a join matricular m on (a.dni=m.alumno)
        where m.calificacion in ('AP','NT','SB','MH')
        group by a.nombre, a.apellido1, a.apellido2
        having count(*)>1
        order by "Nota Media" desc)
where rownum <=3;


-- EJERCICIO 4:
desc profesores;
desc alumnos;

select distinct a.nombre, a.apellido1, p.nombre, p.apellido1
from alumnos a join matricular m on (a.dni=m.alumno), profesores p join impartir i on (p.id=i.PROFESOR)
where substr(a.nombre,1,1)=substr(p.nombre,1,1) and substr(a.apellido1,1,1)=substr(p.apellido1,1,1) and m.asignatura=i.asignatura and m.grupo = i.grupo and m.curso = i.curso
;

-- EJERCICIO 5:

select a1.codigo, a1.nombre, a2.codigo, a2.nombre
from asignaturas a1, asignaturas a2
where a1.codigo < a2.codigo and (select count(distinct alumno)
                                from matricular m1
                                where asignatura = a1.codigo) = (select count(distinct m2.alumno)
                                                                from matricular m2
                                                                where m2.asignatura=a2.codigo) and (select count(distinct alumno)
                                                                                                        from matricular m1
                                                                                                        where asignatura = a1.codigo)!=0;
-- EJERCICIO 6:
select d.codigo, p.nombre, p.apellido1, p.apellido2
from profesores p join departamentos d on (p.departamento=d.codigo)
group by d.codigo
having p.antiguedad = ();

select p.id, p.nombre
from impartir i join profesores p on (i.profesor=p.id), matricular m join alumnos a on (m.alumno=a.dni)
where (i.asignatura=m.asignatura and i.grupo=m.grupo and i.curso=m.curso) and (a.fecha_nacimiento< to_date('01/01/1990') or a.fecha_nacimiento>to_date('31/12/1999'))
;
select 1 from dual where sysdate>to_date('13/02/2000');