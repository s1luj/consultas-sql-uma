-- insert into tour_view values (999,'A','España','Juan','Esp','A');
create or replace trigger tr_inserta_ciclista
instead of insert on tour_view
begin
    insert into info_personal values(:new.id, :new.nombre, :new.nacionalidad); --esta primero que la otra apunta a ella
    insert into info_profesional values(:new.id, :new.equipo,:new.pais, :new.categoria);
end tr_inserta_ciclista;


