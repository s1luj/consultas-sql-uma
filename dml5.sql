-- SQL EL LENGUAJE DE CONSULTA ESTRUCTURADO: OPERACIONES DE MANIPULACIÓN, VISTA, METADATOS

desc matricular;

select *
from matricular2;

create table matricular2 as 
    select *
    from matricular;

insert into matricular2 values ('1127891', '112', 'A', '20/21', null);

select count(*)
from matricular2;

insert into matricular2(Asignatura,Grupo,Curso,Alumno)
select 111, 'B', '16/17', dni
from alumnos;

select count(*)
from matricular2;

rollback; --vuelve atras (desde el inicio de sesion o el ultimo create o alter)

commit; -- guarda cambios en los datos

insert into PRUEBA select * from PRUEBA; -- para duplicar los datos en una base de datos(si lo hacemos infinito y si no hay cuota de disco nos la cargamos)

update matricular2
set calificacion = 'AP'
where grupo = 'B' and asignatura = 112 and curso = '15/16'; --aprobado general

create table asignaturas2 as (select * from asignaturas); -- copiamos la tabla de asignaturas de docencia a asignaturas2 en nuestra cuenta

update asignaturas2
set creditos = creditos +1, practicos = practicos +1;-- (incrementa todos los creditos practicos a 1) para ejectuar los cambios hay que hacer un commit (si no queremos que esos cambios tenga ejecto hay que hacer un rollback)

select *
from asignaturas2;

-- si se hace un delete y se nos olvida el where nos cargamos la tabla entera(cuidado!!)
-- falta el delete

rollback;
