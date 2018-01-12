-- no completados: 7, 9

-- Ejercicio 1: (Hecho en clase)
select nombre, apellido1, apellido2
from profesores p join departamentos d on (p.departamento=d.codigo)
where upper(d.nombre) like 'LENGUAJES%';

desc profesores;
desc departamentos;

-- Ejercicio 2:
desc asignaturas;
desc matricular;

select asig.codigo, asig.nombre, nvl (to_char(asig.practicos), 'No tiene') PRACTICOS -- practicos es un alias. to char_ porque si no toma a 'No tiene' como a un numero
from asignaturas asig join matricular m on (asig.codigo=m.asignatura) join alumnos a on (m.alumno=a.dni)
where upper(a.nombre) like 'NICOLAS' and upper(a.apellido1) like 'BERSABE' and upper(a.apellido2) like 'ALBA';
-- Nicolas Bersabe Alba

-- Ejercicio 3: (Hecho en casa)
desc profesores;
desc departamentos;

select p.nombre, p.apellido1, d.nombre "Nombre de Departamento", trunc((sysdate-p.antiguedad)/7) "Semanas", (((trunc((sysdate-p.antiguedad)/7))+1)*7)+p.antiguedad "Fecha para nueva semana"
from profesores p join departamentos d on (p.departamento=d.codigo)
where d.nombre = 'Ingenieria de Comunicaciones';

-- Ejercicio 4: (hecho en casa)
desc asignaturas;
desc alumnos;
desc matricular;

select a.apellido1, a.apellido2, a.nombre, m.calificacion
from alumnos a join matricular m on (a.dni=m.alumno) join asignaturas asig on (asig.codigo=m.asignatura)
where asig.nombre='Bases de Datos' and not(m.calificacion='SP')
order by a.apellido1, a.apellido2, a.nombre;

-- Ejercicio 5: (hecho en casa)
desc profesores;
desc impartir;
desc asignaturas;

select p.apellido1, p.apellido2, p.nombre, p.id "Codigo de profesor", asig.nombre "Nombre de asignatura", asig.codigo "Codigo de asignatura"
from profesores p join impartir i on (p.id = i.profesor) join asignaturas asig on (asig.codigo = i.asignatura)
order by p.apellido1, p.apellido2, p.nombre;

-- Ejercicio 6: (Hecho en clase)
select a1.nombre, a1.apellido1, a1.apellido2, a2.nombre, a2.apellido1, a2.apellido2
from alumnos a1 join alumnos a2 on (a1.DNI<a2.DNI)
where upper(a1.apellido1)=upper(a2.apellido1);

-- (No completado) Ejercicio 7: (hecho en casa)
desc alumnos;

select a1.apellido1, a2.apellido2
from alumnos a1, alumnos a2
where a1.fecha_nacimiento is between('31/12/1994','01/01/1997');

--  Ejercicio 8:
desc profesores;

select p1.nombre, p1.apellido1, p1.apellido2, p2.nombre, p2.apellido1, p2.apellido2
from profesores p1, profesores p2
where (months_between(p1.antiguedad, sysdate)/12 - months_between(p2.antiguedad, sysdate)/12 )<2 and p1.departamento=p2.departamento and p1.id<p2.ID;

select p1.nombre, p1.apellido1, p1.apellido2, round(months_beween(sysdate p2.nombre,     
from profesores p1 join profesores p2 on (p1.id<p2.id)
where p1.departamento=p2.departamento and abs (months_between(p1.antiguiedad,p2.antiguedad)/12) <2;

-- Ejercicio 9: (hecho en casa)
desc matricular;
desc alumnos;

select am.apellido1 "Apellido1 Ella", am.nombre "Nombre Ella", ah.apellido1 "Apellido1 Él", ah.nombre "Nombre Él",  mm.calificacion "Calificación Ella", mh.calificacion "Calificación Él", abs(ah.fecha_prim_matricula - am.fecha_prim_matricula),ah.fecha_prim_matricula,am.fecha_prim_matricula
from alumnos ah join matricular mh on (mh.alumno=ah.dni) join asignaturas asigh on (asigh.codigo=mh.asignatura), alumnos am join matricular mm on (mm.alumno=am.dni) join asignaturas asigm on (asigm.codigo=mm.asignatura)
where to_char(asigh.codigo) like '112' and to_char(asigm.codigo) like '112' /*and abs(ah.fecha_prim_matricula - am.fecha_prim_matricula)<7*/ -- el calculo de semanas no es correcto
        and decode(mm.calificacion,
                            'SP',1,
                            'AP',2,
                            'NT',3,
                            'SB',4,
                            'MH',5,
                            0)            >  decode(mm.calificacion,
                                                        'SP',1,
                                                        'AP',2,
                                                        'NT',3,
                                                        'SB',4,
                                                        'MH',5,
                                                        0);

-- Ejercicio 11: (Hecho en clase)
desc alumnos;
desc asignaturas;
desc matricular;

select a.nombre, a.apellido1, a.apellido2, asig.nombre, decode (m.calificacion,
                                                                    'SP', 'Suspenso',
                                                                    'AP', 'Aprobado',
                                                                    'NT', 'Notable',
                                                                    'SB', 'Sobresaliente',
                                                                    'MH', 'Matricula de honor',
                                                                    'No presentado') NOTA -- no presentado es por defecto, y nota es un alias
from alumnos a join matricular m on (m.alumno=a.dni) join asignaturas asig on (asig.codigo=m.asignatura)
where months_between(sysdate, a.fecha_nacimiento)/12 > 22
order by a.apellido1, a.apellido2, a.nombre;

-- Ejercicio 12:
desc matricular;
desc impartir;
/*
select a.nombre, a.apellido1, a.apellido2
from alumnos a join matricular m on (a.dni=m.alumno) join impartir i on (m.asignatura=i.asignatura) join profesores p on (i.profesor=p.id) 
where upper(p.nombre) like 'ENRIQUE' and upper(p.apellido1) like 'SOLER';
*/
select a.nombre, a.apellido1, a.apellido2
from alumnos a join matricular m on (a.dni=m.alumno) join impartir i using (asignatura, grupo, curso) join profesores p ON (p.id=i.profesor)
where upper(p.nombre) like 'ENRIQUE' and upper(p.apellido1) like 'SOLER'
ORDER BY A.APELLIDO1, A.APELLIDO2,A.NOMBRE;
-- 
-- Ejercicio 16: (Hecho en clase)
desc impartir;

select codigo from asignaturas -- todas las asignaturas
minus                           -- menos....
select asignatura from impartir; -- las asignaturas que se imparten

-- Ejercicio 17: 
desc alumnos;

select email
from alumnos
where email is not null

UNION ALL

select email
from profesores
where email is not null;

-- Ejercicio 21: (Hecho en clase)
desc asignaturas;
desc impartir;
desc profesores;

select a.nombre, a.creditos, a.teoricos, a.practicos, p.nombre, p.apellido1, p.APELLIDO2
from asignaturas a left outer join impartir i on (a.codigo=i.asignatura) left outer join profesores p on (p.id=i.profesor) -- left outer para sacar tambien aquellas asignaturas que no se imparten(estadistica)
where creditos != teoricos+practicos;

-- Ejercicio 22:
desc profesores;

select p.nombre, p.apellido1, p.apellido2, d.nombre Nombre_Director, d.apellido1 apellido1_director, d.apellido2 apellido2_director
from profesores p left outer join profesores d on (p.director_tesis=d.id) -- para que nos aparezcan todos los profesores (aunque tengan en director de tesis un null)
order by p.apellido1, p.apellido2, p.nombre;


-- Ejercicio 26: (Hecho en clase)
select *
from profesores
where id not in (select profesor from impartir); -- todos los profesores - los que han dado alguna vez clase

