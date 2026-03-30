/* 
   Exportacion de Concursante 
  Ejecutar asi: isql -Usa -Ppasswd -Sserver_name -D asp -i archivo.sql  
*/
go
set nocount on
go

set identity_insert Concursante on

go


print 'Actualizar Concursante...'
print 'Concursante fila: 1 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 1
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  1, 'Karen Dur'||char(225)|| 'n', '19830425 00:00:00.000', 21,
  'Periodismo', 'Leer', 'San Sebasti'||char(225)|| 'n', 'Caf'||char(233),
  'Rubio', 'AGUA', 'karen')
end else begin 
update Concursante
set nombre_concursante = 'Karen Dur'||char(225)|| 'n'
,   fecha_nacimiento = '19830425 00:00:00.000'
,   edad = 21
,   estudios = 'Periodismo'
,   hobbies = 'Leer'
,   direccion = 'San Sebasti'||char(225)|| 'n'
,   color_ojos = 'Caf'||char(233)
,   color_cabello = 'Rubio'
,   elemento = 'AGUA'
,   foto = 'karen'
where concursante = 1
end -- if 
commit 
go
print 'Concursante fila: 2 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 2
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  2, 'Annick Hervot', '19841031 00:00:00.000', 19,
  'Farmacia', 'Nadar, M'||char(250)|| 'sica', 'Barrio Dent', 'Caf'||char(233),
  'Casta'||char(241)|| 'o claro', 'AGUA', 'annick')
end else begin 
update Concursante
set nombre_concursante = 'Annick Hervot'
,   fecha_nacimiento = '19841031 00:00:00.000'
,   edad = 19
,   estudios = 'Farmacia'
,   hobbies = 'Nadar, M'||char(250)|| 'sica'
,   direccion = 'Barrio Dent'
,   color_ojos = 'Caf'||char(233)
,   color_cabello = 'Casta'||char(241)|| 'o claro'
,   elemento = 'AGUA'
,   foto = 'annick'
where concursante = 2
end -- if 
commit 
go
print 'Concursante fila: 3 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 3
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  3, 'Viorica Stan', '19811207 00:00:00.000', 22,
  'Ballet Cl'||char(225)|| 'sico', 'Actuaci'||char(243)|| 'n, canto', 'Escaz'||char(250), 'Verdes',
  'Rojizo', 'FUEGO', 'viorica')
end else begin 
update Concursante
set nombre_concursante = 'Viorica Stan'
,   fecha_nacimiento = '19811207 00:00:00.000'
,   edad = 22
,   estudios = 'Ballet Cl'||char(225)|| 'sico'
,   hobbies = 'Actuaci'||char(243)|| 'n, canto'
,   direccion = 'Escaz'||char(250)
,   color_ojos = 'Verdes'
,   color_cabello = 'Rojizo'
,   elemento = 'FUEGO'
,   foto = 'viorica'
where concursante = 3
end -- if 
commit 
go
print 'Concursante fila: 4 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 4
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  4, 'Angela Stan', '19811207 00:00:00.000', 22,
  'Ballet Cl'||char(225)|| 'sico', 'Actuaci'||char(243)|| 'n, canto', 'Escaz'||char(250), 'Verdes',
  'Rojizo', 'FUEGO', 'angela')
end else begin 
update Concursante
set nombre_concursante = 'Angela Stan'
,   fecha_nacimiento = '19811207 00:00:00.000'
,   edad = 22
,   estudios = 'Ballet Cl'||char(225)|| 'sico'
,   hobbies = 'Actuaci'||char(243)|| 'n, canto'
,   direccion = 'Escaz'||char(250)
,   color_ojos = 'Verdes'
,   color_cabello = 'Rojizo'
,   elemento = 'FUEGO'
,   foto = 'angela'
where concursante = 4
end -- if 
commit 
go
print 'Concursante fila: 5 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 5
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  5, 'Sigal Kahana', '19850118 00:00:00.000', 19,
  'Relaciones P'||char(250)|| 'blicas', 'Leer', 'Santa Ana', 'Verdes',
  'Casta'||char(241)|| 'o Oscuro', 'AIRE', 'sigal')
end else begin 
update Concursante
set nombre_concursante = 'Sigal Kahana'
,   fecha_nacimiento = '19850118 00:00:00.000'
,   edad = 19
,   estudios = 'Relaciones P'||char(250)|| 'blicas'
,   hobbies = 'Leer'
,   direccion = 'Santa Ana'
,   color_ojos = 'Verdes'
,   color_cabello = 'Casta'||char(241)|| 'o Oscuro'
,   elemento = 'AIRE'
,   foto = 'sigal'
where concursante = 5
end -- if 
commit 
go
print 'Concursante fila: 6 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 6
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  6, 'Mar'||char(237)|| 'a Jos'||char(233)|| ' Gadea', '19830915 00:00:00.000', 20,
  'Relaciones P'||char(250)|| 'blicas y Franc'||char(233)|| 's', 'Ballet Cl'||char(225)|| 'sico', 'Lomas de Ayarco Sur', 'Caf'||char(233)|| ' Claro',
  'Casta'||char(241)|| 'o Claro', 'AIRE', 'mariajose')
end else begin 
update Concursante
set nombre_concursante = 'Mar'||char(237)|| 'a Jos'||char(233)|| ' Gadea'
,   fecha_nacimiento = '19830915 00:00:00.000'
,   edad = 20
,   estudios = 'Relaciones P'||char(250)|| 'blicas y Franc'||char(233)|| 's'
,   hobbies = 'Ballet Cl'||char(225)|| 'sico'
,   direccion = 'Lomas de Ayarco Sur'
,   color_ojos = 'Caf'||char(233)|| ' Claro'
,   color_cabello = 'Casta'||char(241)|| 'o Claro'
,   elemento = 'AIRE'
,   foto = 'mariajose'
where concursante = 6
end -- if 
commit 
go
print 'Concursante fila: 7 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 7
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  7, 'Carol Quir'||char(243)|| 's', '19841001 00:00:00.000', 19,
  'Bachillerato', 'Teatro', 'Puntarenas', 'Caf'||char(233)|| ' Oscuro',
  'Negro', 'TIERRA', 'carol')
end else begin 
update Concursante
set nombre_concursante = 'Carol Quir'||char(243)|| 's'
,   fecha_nacimiento = '19841001 00:00:00.000'
,   edad = 19
,   estudios = 'Bachillerato'
,   hobbies = 'Teatro'
,   direccion = 'Puntarenas'
,   color_ojos = 'Caf'||char(233)|| ' Oscuro'
,   color_cabello = 'Negro'
,   elemento = 'TIERRA'
,   foto = 'carol'
where concursante = 7
end -- if 
commit 
go
print 'Concursante fila: 8 de 8'
declare @n int 
select @n = count(1)
from Concursante 
where concursante = 8
if (@n = 0) begin 
insert into Concursante (
concursante, nombre_concursante, fecha_nacimiento, edad,
  estudios, hobbies, direccion, color_ojos,
  color_cabello, elemento, foto)
values (
  8, 'Shirley Mena', '19810416 00:00:00.000', 23,
  'Psicolog'||char(237)|| 'a', 'Cocina Gourmet', 'Heredia', 'Caf'||char(233)|| ' Oscuro',
  'Caf'||char(233), 'TIERRA', 'shirley')
end else begin 
update Concursante
set nombre_concursante = 'Shirley Mena'
,   fecha_nacimiento = '19810416 00:00:00.000'
,   edad = 23
,   estudios = 'Psicolog'||char(237)|| 'a'
,   hobbies = 'Cocina Gourmet'
,   direccion = 'Heredia'
,   color_ojos = 'Caf'||char(233)|| ' Oscuro'
,   color_cabello = 'Caf'||char(233)
,   elemento = 'TIERRA'
,   foto = 'shirley'
where concursante = 8
end -- if 
commit 
go

print 'Terminado Concursante'
set identity_insert Concursante off 
go

set identity_insert Concursante off

go



print 'Importacion finalizada'

/* Fin de archivo */

go

