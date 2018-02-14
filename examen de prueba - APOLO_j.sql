/* FERN�NDEZ M�RQUEZ JOS� LUIS

Lea atentamente estas instrucciones:

    Introduzca la sentencia SQL que responde a cada enunciado separadamente en cada caja del formulario.

    NO escriba punto y coma al final de la sentencia

    Siga al pie de la letra el esquema de la salida de cada consulta. Si cambia el nombre de los atributos o su orden la consulta no puede ser procesada.

    La sentencia SQL no debe tener en cuenta los valores de la tabla en este momento. En la correcci�n pueden cambiarse algunos valores o disponer de nuevas tuplas.*/

   -- Cuando termine pulse ENTREGAR EXAMEN en este formulario. Una vez hecho, ya no podr� modificar nada. La entrega solo puede hacerse una vez.
 /*   1. OBTENGA EL NOMBRE DE CADA ASIGNATURA JUNTO CON EL NOMBRE Y APELLIDOS DEL ALUMNO M�S JOVEN MATRICULADO EN ELLA. NO MUESTRE INFORMACI�N DUPLICADA
    ESQUEMA: NOMBREASIGNATURA,NOMBREALUMNO,APELLIDO1,APELLIDO2
    PUNTOS :,66*/
desc asignaturas;
desc matricular;
desc alumnos;

select max(a.fecha_nacimiento)
from alumnos a;

select max(a.fecha_nacimiento)
from alumnos a join matricular m on (a.dni=m.alumno) join asignaturas asig on (asig.codigo=m.asignatura)
group by asig.codigo;

select *
from asignaturas;



select distinct asig.nombre, a.nombre, a.apellido1, a.apellido2
from asignaturas asig join matricular m on (asig.codigo=m.asignatura) join alumnos a on (a.dni=m.alumno)
where a.fecha_nacimiento=(select max(a.fecha_nacimiento)
                                from alumnos a join);



/*    2. OBTENGA NOMBRE Y N�MERO DE CREDITOS DE LAS ASIGNATURAS QUE NO SON IMPARTIDAS POR PROFESORES CON MENOS DE 50 A�OS
    ESQUEMA: NOMBREASIGNATURA,CREDITOS
    PUNTOS :,66*/
desc profesores;    
desc matricular;
desc impartir;
    
select asig.nombre, asig.creditos
from asignaturas asig join impartir i on (asig.codigo=i.asignatura) join profesores p on (p.id=i.profesor)
where abs(months_between(p.fecha_nacimiento, sysdate))/12>50;


  /*  3. OBTENGA EL NOMBRE Y 2 APELLIDOS DE LOS PROFESORES DE LOS M�DULOS 1 Y 3 JUNTO CON EL NOMBRE DE LA ASIGNATURA QUE IMPARTEN 
  Y EL N�MERO DE CR�DITOS QUE TIENE DICHA ASIGNATURA (USE EL ATRIBUTO CREDITOS DE LA TABLA ASIGNATURAS).
  EL M�DULO ES EL PRIMER CAR�CTER DEL ATRIBUTO DESPACHO (UTILICE SUBSTR).
  SI UN PROFESOR NO IMPARTE NINGUNA ASIGNATURA, TAMBI�N DEBE APARECER EN EL LISTADO CON EL VALOR 0 EN EL CAMPO CR�DITOS
    ESQUEMA: NOMBRE,APELLIDO1,APELLIDO2,NOMBREASIGNATURA,CREDITOS
    PUNTOS :,67*/

desc profesores;

select despacho
from profesores
where substr(despacho,1,1)='3';

select *
from impartir;

   
select distinct p.nombre, p.apellido1, p.apellido2, asig.nombre, nvl(asig.creditos, 0) "Creditos"
from profesores p left outer join (impartir i join asignaturas asig on (asig.codigo=i.asignatura))on (p.id=i.profesor)
where substr(despacho,1,1)='3' or substr(despacho,1,1)='1';


select distinct p.nombre, p.apellido1, p.apellido2, asig.nombre, asig.creditos
from (impartir i join asignaturas asig on (asig.codigo=i.asignatura)) right outer join profesores p on (p.id=i.profesor)
where substr(despacho,1,1)='3' or substr(despacho,1,1)='1';


 /*   4. OBTENER LA NOTA MEDIA DE TODOS LOS ALUMNOS QUE NO NACIERON EN FIN DE SEMANA, REDONDEANDO A 2 DECIMALES. 
 PARA CALCULAR LA NOTA MEDIA USE DECODE Y CONSIDERE AP=1, NT=2, SB=3 Y MH=4. NO SUME LOS SUSPENSOS NI LOS NO PRESENTADOS
    ESQUEMA: NOMBRE,APELLIDO1,APELLIDO2,NOTA
    PUNTOS :,67*/
desc matricular;
desc alumnos;

select *
from asignaturas;
    
select a.nombre, a.apellido1, a.apellido2, DECODE(m.calificacion, 'AP', 1, 'NT', 2, 'SB', 3, 'MH', 4, 0) "Nota"
from alumnos a join on matricular m (m.alumno=a.dni);

 /*   5. Muestre el nombre y apellidos de alumnos de la misma poblaci�n y provincia que est�n matriculados en m�s de 3 asignaturas en com�n en el mismo curso
    ESQUEMA: Nombre1, apellido1_1, apellido2_1, nombre2, apellido1_2, apellido2_2
    PUNTOS :,67*/


 /*   6. Extraer, para cada director de tesis, su id, el n�mero de tramos de investigaci�n que tiene (de la tabla investigadores) y el n�mero de personas a las que le ha dirigido la tesis. Pero s�lo sacamos a los directores que tienen el m�ximo n�mero de tramos de toda la tabla. Adem�s quitaremos del listado los directores que han dirigido solo una tesis
    ESQUEMA: DNI_DIRECTOR,TRAMOS,NUM_PROFESORES
    PUNTOS :,67 */