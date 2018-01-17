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



-- VISTAS -- es un select con un nombre

select * from alumnos;
create table alumnos2 as select * from alumnos;

create or replace view Alumnos_con_experiencia(Codigo,Cuando) as (select Dni, to_char(fecha_prim_matricula,'yyyy') from alumnos2 where apellido1 like 'M%');

select *
from Alumnos_con_experiencia
WHERE to_number(to_char(sysdate,'yyyy')) - to_number(Cuando) > 2;


-- OPCIONES DE VISTA
create or replace view al2 as select * from alumnos where apellido1 like 'M%' With check option; --PONIENDO WITH CHECK OPTION SOLO SE PUEDEN AÑADIR LUEGO CON INSERT LA GENTE CON APELLIDOS QUE EMPIECEN POR M

select * from al2;

desc alumnos;

insert into al2 (dni,nombre,apellido1,fecha_prim_matricula)
values (4444, 'GANDALF', 'MARTIN', sysdate);

-- LA PARTE QUE VIENE AHORA DE PERMISOS SOLO CAEN EN EL TEST DE TEORIA

--grant y revoke... 

-- user = todo lo mío ( de mi usuario)
SELECT * from user_tables; -- a traves de esta tabla vemos una lista de todas las tablas propias de 'mi usuario'
select * from user_views; -- a traves de esta tabla vemos una lista de todas las vistas propias de 'mi usuario'
select * from user_tab_columns where table_name = 'ALUMNOS2'; -- (cuidado que todas la tablas y demas se guarda en mayusculas(el nombre)) (si hubiesemos puesto 'alumnos2' en minusculas no sale nada <- puede caer en test
select * from user_constraints; -- R=clave foranea 
-- all = todo a lo que tenemos acceso
select * from all_tables order by table_name; -- tabla alumnos -> el usuario docencia hizo un grant para que podamos ver la tabla alumnos, impartir, etc..
select * from all_views;

select * from user_constraints;

select user from dual; -- mi usuario

select *
from all_tables
where owner != user; -- != es igual que <> (... es distinto de...)



-- TRIGGERS (esto solo cae en el test creo) (las diapositivas estan en la sala comun>tema1>sql>disparadores y trabajos.pdf)

create or replace trigger control_alumnos2
after insert or delete or update on alumnos2
begin
    insert into ctrl_alumnos2(Tabla,Usuario,Fecha)
    values ('Alumnos2', user,sysdate);
end control_alumnos2;

