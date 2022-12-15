create schema Siteedu;
use Siteedu;

CREATE TABLE IF NOT EXISTS aluno (
  id int(11) auto_increment,
  safe varchar(45),
  nome varchar(45) NOT NULL,
  senha int(11) NOT NULL,
  email varchar(65) NOT NULL,
  PRIMARY KEY (id)
)DEFAULT CHARSET=utf8;


CREATE TABLE IF NOT EXISTS professor (
  id int(11),
  nome_professor varchar(45),
  senha int(11) ,
  email varchar(145) ,
  PRIMARY KEY (id)
) DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS materia (
  codigo int(11),
  nome_materia varchar(45),
  id_professor int(11),
  img varchar(145),
  PRIMARY KEY (codigo),
  foreign key (id_professor) references professor(id)
)DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS presenca (
  id_aluno int(11),
  codigo_materia int(11),
  frequencia int(11),
  notas int(10),
  PRIMARY KEY (id_aluno,codigo_materia),
  FOREIGN KEY  (id_aluno) references aluno(id),
  FOREIGN KEY  (codigo_materia) references materia(codigo)
)DEFAULT CHARSET=utf8;


DELIMITER $
CREATE TRIGGER tr_tevechance after update
ON presenca
FOR EACH ROW
BEGIN
	declare frequencia int(11);
	select sum(presenca.frequencia) into frequencia from presenca where id_aluno=new.id_aluno;
	if (frequencia >= 180) then 
    update aluno set safe="(reprovado)" where id=new.id_aluno;
    else update aluno set safe="(aprovado)" where id=new.id_aluno;
    end if;
    
END $
DELIMITER ;

DELIMITER $
CREATE TRIGGER tr_fim before delete
ON aluno
FOR EACH ROW
BEGIN
	delete from presenca where id_aluno=old.id;
END $
DELIMITER ;

DELIMITER $
create function alterar_faltas(
	id int,
    cod int,
    freq int
    )
returns int deterministic
begin
	update presenca set
	frequencia=freq
	where id_aluno=id and codigo_materia=cod;
    return(select presenca.frequencia from presenca where codigo_materia=cod);
end $
DELIMITER ;

DELIMITER $
create function alterar_eview_notas(
	id int,
    cod int,
    nots int
    )
returns int deterministic
begin
	update presenca set
	notas=nots
	where id_aluno=id and codigo_materia=cod;
    return(select presenca.notas from presenca where codigo_materia=cod);
end $
DELIMITER ;


DELIMITER $
create procedure inicio(
	id01 int(11),
    nome01 varchar(45),
    senha01 int(11),
    email01 varchar(45)
    ) 

begin
	if id01 >=1000 then
 insert into aluno(id,nome, senha, email) values(id01,nome01,senha01, email01);
 else 
	insert into professor(id,nome_professor, senha, email) values(id01,nome01,senha01, email01);
    end if;
end $
DELIMITER ;

insert into aluno(id,safe, nome, senha, email) values( 1001,'neutra', 'gabri', 123, 'teste@testa');
insert into aluno(id,safe, nome, senha, email) values( 1002,'neutra', 'gab', 13, 'teste@tes.com');

 select*from aluno;
 
insert into professor(id, nome_professor, senha, email) values(5, 'roger', 321, 'teste@teste');
insert into professor(id, nome_professor, senha, email) values(7, 'roh', 5556, 'teste@teste2');

 select*from professor;


insert into materia(codigo, nome_materia, id_professor,img) values(4403, 'fisica', 5,'Mathematics-rafiki.svg');
insert into materia(codigo, nome_materia, id_professor,img) values(5567, 'ingles', 5,'Mathematics-rafiki.svg');

insert into presenca values(1001,4403,8,0);
insert into presenca values(1001,5567,5,0);

 select*from materia;

select*from presenca where id_aluno=1001 and codigo_materia=4403;


create view vw_edueduca as
select*from presenca inner join aluno on aluno.id=presenca.id_aluno 
inner join materia on materia.codigo=presenca.codigo_materia ;

select*from vw_edueduca;
create user 'aluno'@'127.0.0.1' identified by 'aluno';
grant select on Siteedu.aluno to 'aluno'@'127.0.0.1';
grant select on Siteedu.presenca to 'aluno'@'127.0.0.1';

show grants for 'aluno'@'127.0.0.1';

create user 'root2'@'127.0.0.1' identified by '';
grant all on *.* to 'root2'@'127.0.0.1';

create user 'professor'@'127.0.0.1' identified by 'professor';
grant select, delete, insert, update on Siteedu.* to 'professor'@'127.0.0.1';
















