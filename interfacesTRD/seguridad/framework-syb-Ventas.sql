
 -- Exportacion del proceso SIF INTERPMI VentasF
 -- SYBASE: isql -Usa -Ppasswd -Sserver_name -D asp -i framework-app.sql 
 
 -- ORACLE: sqlplus user/passwd@server_name @framework-app.sql 
 
 -- DB2:    db2 -td/ vf framework-app.sql 
 
 -- 

go

set nocount on
go

print 'Actualizar PLista (update/insert)...'
print 'PLista fila: 1 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.nuevo'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.nuevo', 'Politica para usuarios nuevos (admit/reject)', 1, 1,
  0, 'reject', '20060510 14:00:00.717', 1)
end else begin 
update PLista
set pnombre = 'Politica para usuarios nuevos (admit/reject)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'reject'
,   BMfecha = '20060510 14:00:00.717'
,   BMUsucodigo = 1
where parametro = 'auth.nuevo'

end -- if 
commit 
go
print 'PLista fila: 2 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.orden'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.orden', 'Orden de métodos de autenticación', 1, 1,
  0, 'asp', '20060510 13:55:53.310', 1)
end else begin 
update PLista
set pnombre = 'Orden de métodos de autenticación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'asp'
,   BMfecha = '20060510 13:55:53.310'
,   BMUsucodigo = 1
where parametro = 'auth.orden'

end -- if 
commit 
go
print 'PLista fila: 3 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.validar.horario'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.validar.horario', 'Validar horario de acceso', 0, 1,
  0, '0', '20060622 09:38:01.250', 1)
end else begin 
update PLista
set pnombre = 'Validar horario de acceso'
,   es_global = 0
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060622 09:38:01.250'
,   BMUsucodigo = 1
where parametro = 'auth.validar.horario'

end -- if 
commit 
go
print 'PLista fila: 4 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.validar.ip'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.validar.ip', 'Validar dirección IP', 0, 1,
  0, '0', '20060622 09:37:41.623', 1)
end else begin 
update PLista
set pnombre = 'Validar dirección IP'
,   es_global = 0
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060622 09:37:41.623'
,   BMUsucodigo = 1
where parametro = 'auth.validar.ip'

end -- if 
commit 
go
print 'PLista fila: 5 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'correo.cuenta'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'correo.cuenta', 'Dirección de correo para los correos que salen del portal', 1, 0,
  0, 'gestion@soin.co.cr', '20050825 10:35:18.557', 1)
end else begin 
update PLista
set pnombre = 'Dirección de correo para los correos que salen del portal'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'gestion@soin.co.cr'
,   BMfecha = '20050825 10:35:18.557'
,   BMUsucodigo = 1
where parametro = 'correo.cuenta'

end -- if 
commit 
go
print 'PLista fila: 6 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'debug.expira'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'debug.expira', 'Expiracion del debug', 1, 0,
  0, ' ', '20060613 15:38:49.263', 1)
end else begin 
update PLista
set pnombre = 'Expiracion del debug'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20060613 15:38:49.263'
,   BMUsucodigo = 1
where parametro = 'debug.expira'

end -- if 
commit 
go
print 'PLista fila: 7 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.CuentaEmpresarial'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.CuentaEmpresarial', 'Cuenta empresarial de las empresas de demostraciones', 1, 0,
  0, ' ', '20050608 15:57:48.500', 1)
end else begin 
update PLista
set pnombre = 'Cuenta empresarial de las empresas de demostraciones'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20050608 15:57:48.500'
,   BMUsucodigo = 1
where parametro = 'demo.CuentaEmpresarial'

end -- if 
commit 
go
print 'PLista fila: 8 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.cache'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.cache', 'Nombre del datasource donde se creara la empresa de demos', 1, 0,
  0, ' ', '20050714 15:31:37.243', 1)
end else begin 
update PLista
set pnombre = 'Nombre del datasource donde se creara la empresa de demos'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20050714 15:31:37.243'
,   BMUsucodigo = 1
where parametro = 'demo.cache'

end -- if 
commit 
go
print 'PLista fila: 9 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.vigencia'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.vigencia', 'Vigencia en días del usuario que solicitó una demostración', 1, 0,
  0, '22', '20050608 10:35:17.840', 1)
end else begin 
update PLista
set pnombre = 'Vigencia en días del usuario que solicitó una demostración'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '22'
,   BMfecha = '20050608 10:35:17.840'
,   BMUsucodigo = 1
where parametro = 'demo.vigencia'

end -- if 
commit 
go
print 'PLista fila: 10 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'error.detalles'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'error.detalles', 'Ocultar detalles técnicos del error a los usuarios', 1, 0,
  0, '0', '20060927 10:05:30.923', 1)
end else begin 
update PLista
set pnombre = 'Ocultar detalles técnicos del error a los usuarios'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060927 10:05:30.923'
,   BMUsucodigo = 1
where parametro = 'error.detalles'

end -- if 
commit 
go
print 'PLista fila: 11 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.adminDN'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.adminDN', 'DN del administrador', 1, 1,
  0, 'cn=Directory Manager', '20060510 13:58:27.653', 1)
end else begin 
update PLista
set pnombre = 'DN del administrador'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'cn=Directory Manager'
,   BMfecha = '20060510 13:58:27.653'
,   BMUsucodigo = 1
where parametro = 'ldap.adminDN'

end -- if 
commit 
go
print 'PLista fila: 12 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.adminPass'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.adminPass', 'Contraseña del administrador', 1, 1,
  0, 'ninguno', '20060510 13:58:53.310', 1)
end else begin 
update PLista
set pnombre = 'Contraseña del administrador'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'ninguno'
,   BMfecha = '20060510 13:58:53.310'
,   BMUsucodigo = 1
where parametro = 'ldap.adminPass'

end -- if 
commit 
go
print 'PLista fila: 13 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.baseDN'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.baseDN', 'DN raíz del directorio por usar', 1, 1,
  0, 'dc=example,dc=com', '20060510 13:57:51.577', 1)
end else begin 
update PLista
set pnombre = 'DN raíz del directorio por usar'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'dc=example,dc=com'
,   BMfecha = '20060510 13:57:51.577'
,   BMUsucodigo = 1
where parametro = 'ldap.baseDN'

end -- if 
commit 
go
print 'PLista fila: 14 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.port'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.port', 'Puerto de LDAP', 1, 1,
  0, '389', '20060510 13:56:29.187', 1)
end else begin 
update PLista
set pnombre = 'Puerto de LDAP'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '389'
,   BMfecha = '20060510 13:56:29.187'
,   BMUsucodigo = 1
where parametro = 'ldap.port'

end -- if 
commit 
go
print 'PLista fila: 15 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.server'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.server', 'Servidor de LDAP', 1, 1,
  0, 'localhost', '20060510 13:57:03.060', 1)
end else begin 
update PLista
set pnombre = 'Servidor de LDAP'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'localhost'
,   BMfecha = '20060510 13:57:03.060'
,   BMUsucodigo = 1
where parametro = 'ldap.server'

end -- if 
commit 
go
print 'PLista fila: 16 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'monitor.habilitar'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'monitor.habilitar', 'Habilitar monitoreo', 1, 0,
  0, '1', '20061012 16:26:42.880', 1)
end else begin 
update PLista
set pnombre = 'Habilitar monitoreo'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20061012 16:26:42.880'
,   BMUsucodigo = 1
where parametro = 'monitor.habilitar'

end -- if 
commit 
go
print 'PLista fila: 17 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'monitor.historia'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'monitor.historia', 'Días para mantener en históricos de monitoreo', 1, 0,
  0, '15', '20040528 16:01:10.920', 1)
end else begin 
update PLista
set pnombre = 'Días para mantener en históricos de monitoreo'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '15'
,   BMfecha = '20040528 16:01:10.920'
,   BMUsucodigo = 1
where parametro = 'monitor.historia'

end -- if 
commit 
go
print 'PLista fila: 18 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.default'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.default', 'Expiración de contraseñas', 1, 1,
  1, '365', '20040521 14:30:48.407', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 14:30:48.407'
,   BMUsucodigo = 1
where parametro = 'pass.expira.default'

end -- if 
commit 
go
print 'PLista fila: 19 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.max'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.max', 'Expiración de contraseñas (máximo)', 1, 1,
  0, '3650', '20040521 14:31:24.127', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas (máximo)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '3650'
,   BMfecha = '20040521 14:31:24.127'
,   BMUsucodigo = 1
where parametro = 'pass.expira.max'

end -- if 
commit 
go
print 'PLista fila: 20 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.min'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.min', 'Expiración de contraseñas (mínimo)', 1, 1,
  0, '1', '20040521 14:31:06.610', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas (mínimo)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 14:31:06.610'
,   BMUsucodigo = 1
where parametro = 'pass.expira.min'

end -- if 
commit 
go
print 'PLista fila: 21 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.recordat'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.recordat', 'Recordatorio de expiración de contraseñas', 1, 1,
  1, '7', '20040524 09:40:06.000', 1)
end else begin 
update PLista
set pnombre = 'Recordatorio de expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '7'
,   BMfecha = '20040524 09:40:06.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.recordat'

end -- if 
commit 
go
print 'PLista fila: 22 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.recordatorio'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.recordatorio', 'Recordatorio de expiración de contraseñas', 1, 1,
  1, '7', '20040524 09:40:06.000', 1)
end else begin 
update PLista
set pnombre = 'Recordatorio de expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '7'
,   BMfecha = '20040524 09:40:06.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.recordatorio'

end -- if 
commit 
go
print 'PLista fila: 23 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.long.max'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.long.max', 'Longitud máxima de contraseña', 1, 1,
  1, '20', '20040521 14:54:10.157', 1)
end else begin 
update PLista
set pnombre = 'Longitud máxima de contraseña'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '20'
,   BMfecha = '20040521 14:54:10.157'
,   BMUsucodigo = 1
where parametro = 'pass.long.max'

end -- if 
commit 
go
print 'PLista fila: 24 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.long.min'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.long.min', 'Longitud mínima de contraseña', 1, 1,
  1, '4', '20040521 14:54:27.767', 1)
end else begin 
update PLista
set pnombre = 'Longitud mínima de contraseña'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '4'
,   BMfecha = '20040521 14:54:27.767'
,   BMUsucodigo = 1
where parametro = 'pass.long.min'

end -- if 
commit 
go
print 'PLista fila: 25 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.dicciona'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.dicciona', 'La contraseña no debe estar en el diccionario', 1, 1,
  1, '0', '20040521 16:38:50.780', 1)
end else begin 
update PLista
set pnombre = 'La contraseña no debe estar en el diccionario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 16:38:50.780'
,   BMUsucodigo = 1
where parametro = 'pass.valida.dicciona'

end -- if 
commit 
go
print 'PLista fila: 26 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.diccionario'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.diccionario', 'La contraseña no debe estar en el diccionario', 1, 1,
  1, '0', '20040521 16:38:50.780', 1)
end else begin 
update PLista
set pnombre = 'La contraseña no debe estar en el diccionario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 16:38:50.780'
,   BMUsucodigo = 1
where parametro = 'pass.valida.diccionario'

end -- if 
commit 
go
print 'PLista fila: 27 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.digitos'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.digitos', 'La contraseña debe contener dígitos', 1, 1,
  1, '1', '20040521 14:54:51.657', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener dígitos'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 14:54:51.657'
,   BMUsucodigo = 1
where parametro = 'pass.valida.digitos'

end -- if 
commit 
go
print 'PLista fila: 28 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.letras'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.letras', 'La contraseña debe contener letras', 1, 1,
  0, '1', '20040521 14:55:03.343', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener letras'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 14:55:03.343'
,   BMUsucodigo = 1
where parametro = 'pass.valida.letras'

end -- if 
commit 
go
print 'PLista fila: 29 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.lista'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.lista', 'Lista de contraseñas anteriores por recordar', 1, 1,
  1, '0', '20040521 14:56:26.203', 1)
end else begin 
update PLista
set pnombre = 'Lista de contraseñas anteriores por recordar'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 14:56:26.203'
,   BMUsucodigo = 1
where parametro = 'pass.valida.lista'

end -- if 
commit 
go
print 'PLista fila: 30 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.simbolos'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.simbolos', 'La contraseña debe contener símbolos', 1, 1,
  1, '0', '20040521 14:55:18.267', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener símbolos'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 14:55:18.267'
,   BMUsucodigo = 1
where parametro = 'pass.valida.simbolos'

end -- if 
commit 
go
print 'PLista fila: 31 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.usuario'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.usuario', 'La contraseña debe ser distinta al usuario', 1, 1,
  1, '1', '20040521 14:55:36.500', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe ser distinta al usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 14:55:36.500'
,   BMUsucodigo = 1
where parametro = 'pass.valida.usuario'

end -- if 
commit 
go
print 'PLista fila: 32 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.id'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.id', 'Opciones identity (in)', 1, 0,
  0, '-E', '20061106 16:22:18.943', 1)
end else begin 
update PLista
set pnombre = 'Opciones identity (in)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-E'
,   BMfecha = '20061106 16:22:18.943'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.id'

end -- if 
commit 
go
print 'PLista fila: 33 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.in'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.in', 'Opciones IN BCP', 1, 0,
  0, ' ', '20061106 16:20:59.160', 1)
end else begin 
update PLista
set pnombre = 'Opciones IN BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20061106 16:20:59.160'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.in'

end -- if 
commit 
go
print 'PLista fila: 34 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.opt'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.opt', 'Opciones comunes BCP', 1, 0,
  0, '-c -t$@!\t$@! -r$@!\r\n -T 512000', '20061106 16:20:39.660', 1)
end else begin 
update PLista
set pnombre = 'Opciones comunes BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-c -t$@!\t$@! -r$@!\r\n -T 512000'
,   BMfecha = '20061106 16:20:39.660'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.opt'

end -- if 
commit 
go
print 'PLista fila: 35 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.out'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.out', 'Opciones OUT BCP', 1, 0,
  0, ' ', '20061106 16:21:10.480', 1)
end else begin 
update PLista
set pnombre = 'Opciones OUT BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20061106 16:21:10.480'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.out'

end -- if 
commit 
go
print 'PLista fila: 36 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.server'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.server', 'Servidor (-S) BCP', 1, 0,
  0, 'MINISIF', '20061106 16:22:41.793', 1)
end else begin 
update PLista
set pnombre = 'Servidor (-S) BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'MINISIF'
,   BMfecha = '20061106 16:22:41.793'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.server'

end -- if 
commit 
go
print 'PLista fila: 37 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.tool'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.tool', 'Ruta completa del BCP', 1, 0,
  0, '/sybase/OCS-15_0/bin/bcp', '20061106 16:20:19.953', 1)
end else begin 
update PLista
set pnombre = 'Ruta completa del BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/sybase/OCS-15_0/bin/bcp'
,   BMfecha = '20061106 16:20:19.953'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.tool'

end -- if 
commit 
go
print 'PLista fila: 38 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.user'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.user', 'Usuario y contraseña BCP', 1, 0,
  0, '-Uadmin -Psecret', '20061106 16:21:51.120', 1)
end else begin 
update PLista
set pnombre = 'Usuario y contraseña BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-Uadmin -Psecret'
,   BMfecha = '20061106 16:21:51.120'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.user'

end -- if 
commit 
go
print 'PLista fila: 39 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.fileext'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.fileext', 'Extensión por generar (gzip)', 1, 0,
  0, 'gz', '20061106 16:23:31.467', 1)
end else begin 
update PLista
set pnombre = 'Extensión por generar (gzip)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'gz'
,   BMfecha = '20061106 16:23:31.467'
,   BMUsucodigo = 1
where parametro = 'respaldo.fileext'

end -- if 
commit 
go
print 'PLista fila: 40 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.fileutil'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.fileutil', 'Utilitario archivador (GNU tar)', 1, 0,
  0, '/bin/tar', '20061106 16:25:02.850', 1)
end else begin 
update PLista
set pnombre = 'Utilitario archivador (GNU tar)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/bin/tar'
,   BMfecha = '20061106 16:25:02.850'
,   BMUsucodigo = 1
where parametro = 'respaldo.fileutil'

end -- if 
commit 
go
print 'PLista fila: 41 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.path'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.path', 'Ruta de los archivos', 1, 0,
  0, '/tmp/aspweb-backup/', '20061106 16:22:58.640', 1)
end else begin 
update PLista
set pnombre = 'Ruta de los archivos'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/tmp/aspweb-backup/'
,   BMfecha = '20061106 16:22:58.640'
,   BMUsucodigo = 1
where parametro = 'respaldo.path'

end -- if 
commit 
go
print 'PLista fila: 42 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'servidor.principal'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'servidor.principal', 'Servidor principal del cluster', 1, 0,
  0, ' ', '20060104 00:00:00.000', 0)
end else begin 
update PLista
set pnombre = 'Servidor principal del cluster'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = ' '
,   BMfecha = '20060104 00:00:00.000'
,   BMUsucodigo = 0
where parametro = 'servidor.principal'

end -- if 
commit 
go
print 'PLista fila: 43 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.cant'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.cant', 'Bloquear contraseña: Cantidad de errores', 1, 1,
  1, '5', '20040521 14:56:56.750', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Cantidad de errores'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '5'
,   BMfecha = '20040521 14:56:56.750'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.cant'

end -- if 
commit 
go
print 'PLista fila: 44 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.durac'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.durac', 'Bloquear contraseña: Duración del bloqueo', 1, 1,
  1, '10', '20040521 14:57:29.360', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Duración del bloqueo'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 14:57:29.360'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.durac'

end -- if 
commit 
go
print 'PLista fila: 45 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.duracion'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.duracion', 'Bloquear contraseña: Duración del bloqueo', 1, 1,
  1, '10', '20040521 14:57:29.360', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Duración del bloqueo'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 14:57:29.360'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.duracion'

end -- if 
commit 
go
print 'PLista fila: 46 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.perio'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.perio', 'Bloquear contraseña: Periodo de validación', 1, 1,
  1, '10', '20040521 14:57:54.030', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Periodo de validación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 14:57:54.030'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.perio'

end -- if 
commit 
go
print 'PLista fila: 47 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.periodo'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.periodo', 'Bloquear contraseña: Periodo de validación', 1, 1,
  1, '10', '20040521 14:57:54.030', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Periodo de validación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 14:57:54.030'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.periodo'

end -- if 
commit 
go
print 'PLista fila: 48 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.defa'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.defa', 'Duración de la sesión', 1, 1,
  1, '365', '20040521 14:58:09.360', 1)
end else begin 
update PLista
set pnombre = 'Duración de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 14:58:09.360'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.defa'

end -- if 
commit 
go
print 'PLista fila: 49 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.default'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.default', 'Duración de la sesión', 1, 1,
  1, '365', '20040521 14:58:09.360', 1)
end else begin 
update PLista
set pnombre = 'Duración de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 14:58:09.360'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.default'

end -- if 
commit 
go
print 'PLista fila: 50 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.max'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.max', 'Duración máxima de la sesión', 1, 1,
  1, '10080', '20040521 14:58:41.627', 1)
end else begin 
update PLista
set pnombre = 'Duración máxima de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10080'
,   BMfecha = '20040521 14:58:41.627'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.max'

end -- if 
commit 
go
print 'PLista fila: 51 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.min'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.min', 'Duración mínima de la sesión', 1, 1,
  0, '1', '20040521 14:58:25.267', 1)
end else begin 
update PLista
set pnombre = 'Duración mínima de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 14:58:25.267'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.min'

end -- if 
commit 
go
print 'PLista fila: 52 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.modo'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.modo', 'Duración total(1) o inactiva(2)', 1, 1,
  1, '2', '20040524 17:50:01.267', 1)
end else begin 
update PLista
set pnombre = 'Duración total(1) o inactiva(2)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '2'
,   BMfecha = '20040524 17:50:01.267'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.modo'

end -- if 
commit 
go
print 'PLista fila: 53 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.multiple'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.multiple', 'Permitir varias sesiones por usuario(1=si,2=close,3=timeout)', 1, 1,
  1, '1', '20040521 15:53:27.920', 1)
end else begin 
update PLista
set pnombre = 'Permitir varias sesiones por usuario(1=si,2=close,3=timeout)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 15:53:27.920'
,   BMUsucodigo = 1
where parametro = 'sesion.multiple'

end -- if 
commit 
go
print 'PLista fila: 54 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.long.max'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.long.max', 'Longitud máxima del usuario', 1, 1,
  0, '30', '20060517 12:20:25.093', 1)
end else begin 
update PLista
set pnombre = 'Longitud máxima del usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '30'
,   BMfecha = '20060517 12:20:25.093'
,   BMUsucodigo = 1
where parametro = 'user.long.max'

end -- if 
commit 
go
print 'PLista fila: 55 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.long.min'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.long.min', 'Longitud mínima del usuario', 1, 1,
  0, '4', '20060517 12:19:43.153', 1)
end else begin 
update PLista
set pnombre = 'Longitud mínima del usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '4'
,   BMfecha = '20060517 12:19:43.153'
,   BMUsucodigo = 1
where parametro = 'user.long.min'

end -- if 
commit 
go
print 'PLista fila: 56 de 56'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.valid.chars'
if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.valid.chars', 'Caracteres validos para el usuario', 1, 1,
  0, 'a-zA-Z0-9@_.-', '20060517 17:07:05.750', 1)
end else begin 
update PLista
set pnombre = 'Caracteres validos para el usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'a-zA-Z0-9@_.-'
,   BMfecha = '20060517 17:07:05.750'
,   BMUsucodigo = 1
where parametro = 'user.valid.chars'

end -- if 
commit 
go

print 'Terminado PLista'

print 'Actualizar SSistemas (update/insert)...'
print 'SSistemas fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SSistemas 
where SScodigo = 'SIF       '
if (@n = 0) begin
insert into SSistemas (
SScodigo, SSdescripcion, SShomeuri, SSmenu,
  BMfecha, BMUsucodigo, SSorden, SSlogo,
  SShablada)
values (
  'SIF       ', 'Sistema Financiero Integral', null, 1,
  '19000101 00:00:00.000', -1, 100, 0xFFD8FFE000104A46494600010101004800480000FFDB004300070404040504070505070A0705070A0C090707090C0D0B0B0C0B0B0D110D0D0D0D0D0D110D0F1011100F0D1414161614141E1D1D1D1E22222222222222222222FFDB0043010807070D0C0D181010181A1511151A20202020202020202020202020212020202020202121212020202121212121212121222222222222222222222222222222FFC00011080037007603011100021101031101FFC4001C0000010501010100000000000000000000060002030405010708FFC4003C1000020201030204040305040B000000000102030405001112062107132231143241511523613362718191172425421618526372829293C1D2D3FFC40017010101010100000000000000000000000000010203FFC4002411000202020202020301010000000000000001021112132151314103612281F071A1FFDA000C03010002110311003F00FA47402D00B402D00B403279628A269256091A02CEE7B0000DC93FA0D00174E862B3B1D8EACEA2AD0CB5EC0DB1915A40CB0504F91F66F679CFACFE9B0FA6B6E4D708C55F2CCFC860BA4F87991F4F0F2DC808C28763BF65DBB6FDFF0051AB94BB18C7A33686428748F504393A91255C5CDB56CB451A844E04FE5D82076DE173EAFDD27EDAB7970FC92B13D5D5811B8EE3E875C8E83B402D00B402D00B40737D00B7D00B7D01DDF402D0031D78ED60E330931F2B1995B5E45EB1F428ABCC56FD3E25870FE1B8FA8D6E1D999126725ACC9146EC91409342DC4FCA446E1B801DBEDDB59895A28CF298EE0B54EF40F36FE94959A32E5BB043BEC093F6DF5116C00CF5BF9A1688CD2CAFE42D6037691E46E023D8FD493B6AC55B249F019F4964FAFF000780871996C235992AEF1C132DC8391807ECC3EE7E651E9FE5ADC947B331CBA2D5AF12EE518CCF90C1CF0D38FBCF32CF04A513FCCFC15B760A3B9DB5305D97261843345346B2C4C1E270191C770411B820FEA358343F402D00B400F75DDCCF56C445F82122D4962359447E535835FB997E1926211E5D87607E9AD7C757C999F80771DD7790A8238E796D64A6492E6F51AB2D7B9B41544E90D98F88FCC3BFA5A3D811B6B78599CE87278A390B1263AC435A05A266B2B93E13894AC75EB79E4AFA55D5946FE9750771F6EFA6A26C1D47C5F96DC1BC78866B12FC29A91ACBE8616E5F29564919155245DC1651BF6F63A9ABEC6D2C55F13AF79BC6FE23E1E3FEFB0F35B31B6F671EA5A550582288CF1F4B93FC468FE2FB2EC1F88CF53F1031B95C2DB8040D124244B04BE72FE702F0CB149C633CE274DFDBDC6A38E1C954B232FE39F2107C2E693FC471D2B4391887A794AA8784A87FCA24561229FE5A3E02E4CFBB6E8C4E24733D86460CB1C8D1842CA771CCA282C371BEC36D6723544BE1BE1DF2F9CB1D5177D5528BC915107DA4B4DFB69FFE4DF82FEBBEB4FF00155ED99F2EFD04599B794390445915694D2450A7150CEAD237124F223700B0D44915D9879792388BA79EF39DCAB878D507DBB6C5B7D4E0A5DF09BA8955A6E94B0DBB545F3B18CC7BB5527631FF001858EDFF000EDAD4B956663E683FDF58362DF40774066E77A7B159CA6B5B2119758E459A174668E48E55F9648DD086561BFB8D552A24959413C3FE9858B83C0F33B34CF24F2CD2BCAED3C7E548CF216E44F0000FB7D36D5D8C98233E1E9EE86390B5566329BD8E9A1B36ED5A9E42CED3405115E576FCC43082A54F6DB5ACE467143A8E0FA0EAE521C624CD2DC30C572A24B66598257A926F1794598858D5CEE00FFC6A3948A947C16EE74CF42DEC717B5E4C98F924B0FE619BF2CC973759BD5CB6DDBF8F6FA6A6522E28B186C474DE1ED4D356B1CAEDC44F3E69ECB4D2489003C4EF23376404FB68DB61248A39FE99E95CD4FF008E3645EA9318AF25AA962344902B6E8AE583292A4F6FAE8A4D701A30E8741745E631D56E4797C82A6417955592C469230F6EC8537246B5935E8CE3F668F4B4FF0087E1DBA6A4458AE6108AD22A8D84911F543640FF007CBDCFEF72D665D9A8BF456B773CFCA55AF10792516AB1708ACC1479A0EEC40D8761A44B205FA832689259964E51C68CECCEEACA3604EFF301BEA50B353A4BC3A8A6A353A973166E53CC485A7AB1579BC9F878645E2884713BB32777DFEFB7D35BCAB84631BE5F0695EAB243BF0CDE4FF9DB4FFE7A99FD169764FD0BD4D6E3CDCBD3D93B325913A9B38BB3310CEC17F6D033003729F3AF6F94FE9A8F95655C701C8D64D0B4070E8009CC744E4323D5135C9A08A6C6C990C759292303BC756BCA926E87ECEEBB0FAEBA4674BF47370E41FB3E17F533547AD0410273AD90ACAEB22AF08E4C8FC54117CA7D3243F97DBB2EFDC6DAE9B57F7F86759158C149D39257C965E9A3559ADCAC3197658CC449AC104CCD0C5F0F1B2F1202EDEA1FBDA6764C289305D0596B1D2335B8F1B58E42CE2A957A296403C02C9234C9B3EC57D0E38F2F7FAE8FE457FB2E0C971BD01D4D52FB5FB18E8EF5216DE75C54F2D71C84B5161F348445803A321EC07B1F72751FC882832387C34EA58F0831CF8EAD25AB14E9D686EF9C3FC35EBBB16F2F71CC81BF3529DC9F7D362FEF6307414F5F632C41E5753D04692D515315E8906ED3D263BB80A37E4F11FCC5FE63EBAE507E99B97607D9EAD8139FC1CB6543FCDC2BDA5E5F6DFD037D35B2E6883A7AB58EB1EA7828DC9267C4D002E5D4B0244E6036D144AB2804AB3AEEFB0F61B6B58E2AC976E83BEAB1059851E4F9A0951E3F6DB76708790208238B1D621E4B24655C0F0DD9267C6C71E32BC83CD9248635E40C9C42C6389E5DBEE46A940FEA1B927C5FC5E34F9166BCFF001340EDB0474278291FEC953C587DB48C838D9EB7D27D415FA87A769E66052896A3E4636F757078BAFEBB30237FAEA4953A11768D4D428B407361A03BA03CE70FE24E4EF457279AEE390544BB2C9496BD969952A170096E5C1BE40481FCB5D9FC48E2A766ED3F11B132DF8E8982D6E665A6F7443FDDBE29A11388C1DCBF753DBB7E9EFAE7AD9BD888BFB55E9F549DA6AD761781229442F08F3648E794411944562413230055B6237F6D6B5326D449FDA5E24C60251BD2643CC9A3931A9083623F86E265665E5C7880EBB6CC77DC6DA9A99761149E26626AB4AB3096CCC669160AD044525114314723B389993E5F346FEDDFB6DA6A63621EDE2A74E798C208ADD988475DD678A1DD1DEE286AF0A6E4319240DD86DDBEBB69A98D88AD96C97E2F4FFD25C34134798C0CB2457684CBC26787606C56600B024A6D246412370344AB87E186FDF457B9918B2095A5AD2A7E1F6384DF12DB91E582B20E2AA0925B6DB594A8D59899AC8D857B0A2C46F05872DC62E7EC1895E5CD57BF7FA6FA8540DD7C65BEA4CED6C0D462AD68936651EF1564FDABFF001D8F15FD4EB50EFA3327E8F74A146B51A30D2A8822AB5D1628635F65441B01FD3596ECD13348ABEFA0226BB02FB93A0236CBD25F727FA68089BA831ABEECDFF49D01830C7D3757A567E9B1627352C2598DA42BEB02D33B36DDB6EDE61DBB6B59736671E0A469F48254F8736AD041705FE406CDCC41E46C081D871EFDBBEFABB1FF00C260A8C8A180E89A1C37C8596F2A386150B0431FA2B4E9610B7968BCDCB27A99BB9D69FCA4C0B57A4E9137E5C952CA5DA3939A59DCD88A3563C2C2C6B247C5D48DBF254A9F70759CFD15C3D946EC7E1EBB89A3BF6D2E2BC8C2C4B04764F195234752274704FE4AB06F7DFF00A6AED64D648F90F0E56AD8856F5D49246A72C3638032432D040B0C8BDB627D3BB6E363A99B2EB2FE07C42E85C2C7619EF5AB776DCDF1172D4B0ECCF2150A3608155555540006A49D9A8A052EF50E020B5623C3E5E3871524AD2C156C539DDA1327AA4446460387325947D37D325C5F9262D1956F338D937E79DAE37FB51B3FFBEAFE3F64FCBE8DBF0FBAFBC38E955B762DE424B995B8C049623AB222AC51FC9120624EC0924FDCE9295954426FF587F0CC76F88B1FF61F58347FFFD9,
  ' ')
end else begin 
update SSistemas
set SSdescripcion = 'Sistema Financiero Integral'
,   SShomeuri = null
,   SSmenu = 1
,   BMfecha = '19000101 00:00:00.000'
,   BMUsucodigo = -1
,   SSorden = 100
,   SSlogo = 0xFFD8FFE000104A46494600010101004800480000FFDB004300070404040504070505070A0705070A0C090707090C0D0B0B0C0B0B0D110D0D0D0D0D0D110D0F1011100F0D1414161614141E1D1D1D1E22222222222222222222FFDB0043010807070D0C0D181010181A1511151A20202020202020202020202020212020202020202121212020202121212121212121222222222222222222222222222222FFC00011080037007603011100021101031101FFC4001C0000010501010100000000000000000000060002030405010708FFC4003C1000020201030204040305040B000000000102030405001112062107132231143241511523613362718191172425421618526372829293C1D2D3FFC40017010101010100000000000000000000000000010203FFC4002411000202020202020301010000000000000001021112132151314103612281F071A1FFDA000C03010002110311003F00FA47402D00B402D00B403279628A269256091A02CEE7B0000DC93FA0D00174E862B3B1D8EACEA2AD0CB5EC0DB1915A40CB0504F91F66F679CFACFE9B0FA6B6E4D708C55F2CCFC860BA4F87991F4F0F2DC808C28763BF65DBB6FDFF0051AB94BB18C7A33686428748F504393A91255C5CDB56CB451A844E04FE5D82076DE173EAFDD27EDAB7970FC92B13D5D5811B8EE3E875C8E83B402D00B402D00B40737D00B7D00B7D01DDF402D0031D78ED60E330931F2B1995B5E45EB1F428ABCC56FD3E25870FE1B8FA8D6E1D999126725ACC9146EC91409342DC4FCA446E1B801DBEDDB59895A28CF298EE0B54EF40F36FE94959A32E5BB043BEC093F6DF5116C00CF5BF9A1688CD2CAFE42D6037691E46E023D8FD493B6AC55B249F019F4964FAFF000780871996C235992AEF1C132DC8391807ECC3EE7E651E9FE5ADC947B331CBA2D5AF12EE518CCF90C1CF0D38FBCF32CF04A513FCCFC15B760A3B9DB5305D97261843345346B2C4C1E270191C770411B820FEA358343F402D00B400F75DDCCF56C445F82122D4962359447E535835FB997E1926211E5D87607E9AD7C757C999F80771DD7790A8238E796D64A6492E6F51AB2D7B9B41544E90D98F88FCC3BFA5A3D811B6B78599CE87278A390B1263AC435A05A266B2B93E13894AC75EB79E4AFA55D5946FE9750771F6EFA6A26C1D47C5F96DC1BC78866B12FC29A91ACBE8616E5F29564919155245DC1651BF6F63A9ABEC6D2C55F13AF79BC6FE23E1E3FEFB0F35B31B6F671EA5A550582288CF1F4B93FC468FE2FB2EC1F88CF53F1031B95C2DB8040D124244B04BE72FE702F0CB149C633CE274DFDBDC6A38E1C954B232FE39F2107C2E693FC471D2B4391887A794AA8784A87FCA24561229FE5A3E02E4CFBB6E8C4E24733D86460CB1C8D1842CA771CCA282C371BEC36D6723544BE1BE1DF2F9CB1D5177D5528BC915107DA4B4DFB69FFE4DF82FEBBEB4FF00155ED99F2EFD04599B794390445915694D2450A7150CEAD237124F223700B0D44915D9879792388BA79EF39DCAB878D507DBB6C5B7D4E0A5DF09BA8955A6E94B0DBB545F3B18CC7BB5527631FF001858EDFF000EDAD4B956663E683FDF58362DF40774066E77A7B159CA6B5B2119758E459A174668E48E55F9648DD086561BFB8D552A24959413C3FE9858B83C0F33B34CF24F2CD2BCAED3C7E548CF216E44F0000FB7D36D5D8C98233E1E9EE86390B5566329BD8E9A1B36ED5A9E42CED3405115E576FCC43082A54F6DB5ACE467143A8E0FA0EAE521C624CD2DC30C572A24B66598257A926F1794598858D5CEE00FFC6A3948A947C16EE74CF42DEC717B5E4C98F924B0FE619BF2CC973759BD5CB6DDBF8F6FA6A6522E28B186C474DE1ED4D356B1CAEDC44F3E69ECB4D2489003C4EF23376404FB68DB61248A39FE99E95CD4FF008E3645EA9318AF25AA962344902B6E8AE583292A4F6FAE8A4D701A30E8741745E631D56E4797C82A6417955592C469230F6EC8537246B5935E8CE3F668F4B4FF0087E1DBA6A4458AE6108AD22A8D84911F543640FF007CBDCFEF72D665D9A8BF456B773CFCA55AF10792516AB1708ACC1479A0EEC40D8761A44B205FA832689259964E51C68CECCEEACA3604EFF301BEA50B353A4BC3A8A6A353A973166E53CC485A7AB1579BC9F878645E2884713BB32777DFEFB7D35BCAB84631BE5F0695EAB243BF0CDE4FF9DB4FFE7A99FD169764FD0BD4D6E3CDCBD3D93B325913A9B38BB3310CEC17F6D033003729F3AF6F94FE9A8F95655C701C8D64D0B4070E8009CC744E4323D5135C9A08A6C6C990C759292303BC756BCA926E87ECEEBB0FAEBA4674BF47370E41FB3E17F533547AD0410273AD90ACAEB22AF08E4C8FC54117CA7D3243F97DBB2EFDC6DAE9B57F7F86759158C149D39257C965E9A3559ADCAC3197658CC449AC104CCD0C5F0F1B2F1202EDEA1FBDA6764C289305D0596B1D2335B8F1B58E42CE2A957A296403C02C9234C9B3EC57D0E38F2F7FAE8FE457FB2E0C971BD01D4D52FB5FB18E8EF5216DE75C54F2D71C84B5161F348445803A321EC07B1F72751FC882832387C34EA58F0831CF8EAD25AB14E9D686EF9C3FC35EBBB16F2F71CC81BF3529DC9F7D362FEF6307414F5F632C41E5753D04692D515315E8906ED3D263BB80A37E4F11FCC5FE63EBAE507E99B97607D9EAD8139FC1CB6543FCDC2BDA5E5F6DFD037D35B2E6883A7AB58EB1EA7828DC9267C4D002E5D4B0244E6036D144AB2804AB3AEEFB0F61B6B58E2AC976E83BEAB1059851E4F9A0951E3F6DB76708790208238B1D621E4B24655C0F0DD9267C6C71E32BC83CD9248635E40C9C42C6389E5DBEE46A940FEA1B927C5FC5E34F9166BCFF001340EDB0474278291FEC953C587DB48C838D9EB7D27D415FA87A769E66052896A3E4636F757078BAFEBB30237FAEA4953A11768D4D428B407361A03BA03CE70FE24E4EF457279AEE390544BB2C9496BD969952A170096E5C1BE40481FCB5D9FC48E2A766ED3F11B132DF8E8982D6E665A6F7443FDDBE29A11388C1DCBF753DBB7E9EFAE7AD9BD888BFB55E9F549DA6AD761781229442F08F3648E794411944562413230055B6237F6D6B5326D449FDA5E24C60251BD2643CC9A3931A9083623F86E265665E5C7880EBB6CC77DC6DA9A99761149E26626AB4AB3096CCC669160AD044525114314723B389993E5F346FEDDFB6DA6A63621EDE2A74E798C208ADD988475DD678A1DD1DEE286AF0A6E4319240DD86DDBEBB69A98D88AD96C97E2F4FFD25C34134798C0CB2457684CBC26787606C56600B024A6D246412370344AB87E186FDF457B9918B2095A5AD2A7E1F6384DF12DB91E582B20E2AA0925B6DB594A8D59899AC8D857B0A2C46F05872DC62E7EC1895E5CD57BF7FA6FA8540DD7C65BEA4CED6C0D462AD68936651EF1564FDABFF001D8F15FD4EB50EFA3327E8F74A146B51A30D2A8822AB5D1628635F65441B01FD3596ECD13348ABEFA0226BB02FB93A0236CBD25F727FA68089BA831ABEECDFF49D01830C7D3757A567E9B1627352C2598DA42BEB02D33B36DDB6EDE61DBB6B59736671E0A469F48254F8736AD041705FE406CDCC41E46C081D871EFDBBEFABB1FF00C260A8C8A180E89A1C37C8596F2A386150B0431FA2B4E9610B7968BCDCB27A99BB9D69FCA4C0B57A4E9137E5C952CA5DA3939A59DCD88A3563C2C2C6B247C5D48DBF254A9F70759CFD15C3D946EC7E1EBB89A3BF6D2E2BC8C2C4B04764F195234752274704FE4AB06F7DFF00A6AED64D648F90F0E56AD8856F5D49246A72C3638032432D040B0C8BDB627D3BB6E363A99B2EB2FE07C42E85C2C7619EF5AB776DCDF1172D4B0ECCF2150A3608155555540006A49D9A8A052EF50E020B5623C3E5E3871524AD2C156C539DDA1327AA4446460387325947D37D325C5F9262D1956F338D937E79DAE37FB51B3FFBEAFE3F64FCBE8DBF0FBAFBC38E955B762DE424B995B8C049623AB222AC51FC9120624EC0924FDCE9295954426FF587F0CC76F88B1FF61F58347FFFD9
,   SShablada = ' '
where SScodigo = 'SIF       '

end -- if 
commit 
go

print 'Terminado SSistemas'

print 'Actualizar SModulos (update/insert)...'
print 'SModulos fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SModulos 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
if (@n = 0) begin
insert into SModulos (
SScodigo, SMcodigo, SMdescripcion, SMhomeuri,
  SMmenu, BMfecha, BMUsucodigo, SMorden,
  SMhablada, SMlogo)
values (
  'SIF       ', 'INTERPMI  ', 'Interfaces de PMI', null,
  1, '20070114 11:50:03.513', 1, 25,
  ' ', null)
end else begin 
update SModulos
set SMdescripcion = 'Interfaces de PMI'
,   SMhomeuri = null
,   SMmenu = 1
,   BMfecha = '20070114 11:50:03.513'
,   BMUsucodigo = 1
,   SMorden = 25
,   SMhablada = ' '
,   SMlogo = null
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '

end -- if 
commit 
go

print 'Terminado SModulos'

print 'Actualizar SRoles (update/insert)...'
print 'SRoles fila: 1 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM       '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADM       ', 'Administrador', '20040204 15:08:15.250',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador'
,   BMfecha = '20040204 15:08:15.250'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM       '

end -- if 
commit 
go
print 'SRoles fila: 2 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADMON_HOU '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADMON_HOU ', 'Administrador de Houston', '20050818 12:47:16.310',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Houston'
,   BMfecha = '20050818 12:47:16.310'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADMON_HOU '

end -- if 
commit 
go
print 'SRoles fila: 3 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_CAT   '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADM_CAT   ', 'Administrador de Catalogos', '20050808 16:09:11.347',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Catalogos'
,   BMfecha = '20050808 16:09:11.347'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_CAT   '

end -- if 
commit 
go
print 'SRoles fila: 4 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_PRES  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADM_PRES  ', 'Administrador de Presupuesto', '20050302 11:01:30.327',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Presupuesto'
,   BMfecha = '20050302 11:01:30.327'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_PRES  '

end -- if 
commit 
go
print 'SRoles fila: 5 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_PROY  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADM_PROY  ', 'Administrador de Proyectos', '20040616 15:58:33.813',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Proyectos'
,   BMfecha = '20040616 15:58:33.813'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_PROY  '

end -- if 
commit 
go
print 'SRoles fila: 6 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_SIST  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ADM_SIST  ', 'Administrador de Sistemas', '20040204 15:08:15.250',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Sistemas'
,   BMfecha = '20040204 15:08:15.250'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM_SIST  '

end -- if 
commit 
go
print 'SRoles fila: 7 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ANAL_CONTA'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ANAL_CONTA', 'Analista de Contabilidad', '20050818 09:32:00.083',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Analista de Contabilidad'
,   BMfecha = '20050818 09:32:00.083'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ANAL_CONTA'

end -- if 
commit 
go
print 'SRoles fila: 8 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ANOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ANOperador', 'Operador Anexos Financieros', '20070114 11:54:42.653',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Anexos Financieros'
,   BMfecha = '20070114 11:54:42.653'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ANOperador'

end -- if 
commit 
go
print 'SRoles fila: 9 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'ANSuperv  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'ANSuperv  ', 'Supervisor Anexos Financieros', '20070114 11:14:21.063',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Anexos Financieros'
,   BMfecha = '20070114 11:14:21.063'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'ANSuperv  '

end -- if 
commit 
go
print 'SRoles fila: 10 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'AdminCons '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'AdminCons ', 'Consultas Administrativas y Generación de Reporte', '20070114 11:24:55.870',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Administrativas y Generación de Reporte'
,   BMfecha = '20070114 11:24:55.870'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'AdminCons '

end -- if 
commit 
go
print 'SRoles fila: 11 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'BORRAME   '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'BORRAME   ', 'BORRRAME', '20061113 16:25:13.780',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'BORRRAME'
,   BMfecha = '20061113 16:25:13.780'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'BORRAME   '

end -- if 
commit 
go
print 'SRoles fila: 12 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'BORRAR    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'BORRAR    ', 'BORRAR', '20040120 09:35:43.327',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'BORRAR'
,   BMfecha = '20040120 09:35:43.327'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'BORRAR    '

end -- if 
commit 
go
print 'SRoles fila: 13 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CCCnsFis  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CCCnsFis  ', 'Consultas Fiscales Cuentas por Cobrar', '20070114 12:42:34.733',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Fiscales Cuentas por Cobrar'
,   BMfecha = '20070114 12:42:34.733'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CCCnsFis  '

end -- if 
commit 
go
print 'SRoles fila: 14 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CCCnsRpt  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CCCnsRpt  ', 'Consultas y Generación de reportes Cuentas por Cobrar', '20070114 12:49:37.300',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Cuentas por Cobrar'
,   BMfecha = '20070114 12:49:37.300'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CCCnsRpt  '

end -- if 
commit 
go
print 'SRoles fila: 15 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CCConsGrl '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CCConsGrl ', 'Consultas Generales Cuentas por Cobrar', '20070114 11:38:43.933',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Cuentas por Cobrar'
,   BMfecha = '20070114 11:38:43.933'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CCConsGrl '

end -- if 
commit 
go
print 'SRoles fila: 16 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CCOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CCOperador', 'Operador de Cuentas por Cobrar', '20070114 09:12:08.360',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Cuentas por Cobrar'
,   BMfecha = '20070114 09:12:08.360'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CCOperador'

end -- if 
commit 
go
print 'SRoles fila: 17 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CGCnsRpt  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CGCnsRpt  ', 'Consultas y Generación de reportes Contabilidad', '20070113 15:58:49.750',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Contabilidad'
,   BMfecha = '20070113 15:58:49.750'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CGCnsRpt  '

end -- if 
commit 
go
print 'SRoles fila: 18 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CGConsGrl '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CGConsGrl ', 'Consultas Generales Contabilidad', '20070113 15:59:53.623',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Contabilidad'
,   BMfecha = '20070113 15:59:53.623'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CGConsGrl '

end -- if 
commit 
go
print 'SRoles fila: 19 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CGOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CGOperador', 'Operador de Contabilidad', '20070113 15:58:04.320',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Contabilidad'
,   BMfecha = '20070113 15:58:04.320'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CGOperador'

end -- if 
commit 
go
print 'SRoles fila: 20 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CGSuperv  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CGSuperv  ', 'Supervisor Contabilidad', '20070113 15:56:43.710',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Contabilidad'
,   BMfecha = '20070113 15:56:43.710'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CGSuperv  '

end -- if 
commit 
go
print 'SRoles fila: 21 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CGTCOperad'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CGTCOperad', 'Operador Tipos de Cambio', '20070114 12:28:12.433',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Tipos de Cambio'
,   BMfecha = '20070114 12:28:12.433'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CGTCOperad'

end -- if 
commit 
go
print 'SRoles fila: 22 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CG_DAF1234'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CG_DAF1234', 'dfdf', '20051207 16:16:22.473',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'dfdf'
,   BMfecha = '20051207 16:16:22.473'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CG_DAF1234'

end -- if 
commit 
go
print 'SRoles fila: 23 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CLIENTE   '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CLIENTE   ', 'Socio de Negocios / Cliente', '20040714 09:26:45.217',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Socio de Negocios / Cliente'
,   BMfecha = '20040714 09:26:45.217'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CLIENTE   '

end -- if 
commit 
go
print 'SRoles fila: 24 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'COMPRADOR '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'COMPRADOR ', 'Comprador', '20040625 15:34:24.907',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Comprador'
,   BMfecha = '20040625 15:34:24.907'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'COMPRADOR '

end -- if 
commit 
go
print 'SRoles fila: 25 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CPCnsFis  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CPCnsFis  ', 'Consultas Fiscales Cuentas por Pagar', '20070114 09:06:46.337',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Fiscales Cuentas por Pagar'
,   BMfecha = '20070114 09:06:46.337'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CPCnsFis  '

end -- if 
commit 
go
print 'SRoles fila: 26 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CPCnsRpt  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CPCnsRpt  ', 'Consultas y Generación de reportes Cuentas por Pagar', '20070114 12:30:31.950',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Cuentas por Pagar'
,   BMfecha = '20070114 12:30:31.950'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CPCnsRpt  '

end -- if 
commit 
go
print 'SRoles fila: 27 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CPConsGrl '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CPConsGrl ', 'Consultas Generales Cuentas por Pagar', '20070114 11:35:56.413',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Cuentas por Pagar'
,   BMfecha = '20070114 11:35:56.413'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CPConsGrl '

end -- if 
commit 
go
print 'SRoles fila: 28 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'CPOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'CPOperador', 'Operador de Cuentas por Pagar', '20070113 17:15:33.763',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Cuentas por Pagar'
,   BMfecha = '20070113 17:15:33.763'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'CPOperador'

end -- if 
commit 
go
print 'SRoles fila: 29 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'DPAUTO    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'DPAUTO    ', 'GRUPO DE AUTORIZADORES CM', '20050526 08:16:20.223',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'GRUPO DE AUTORIZADORES CM'
,   BMfecha = '20050526 08:16:20.223'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'DPAUTO    '

end -- if 
commit 
go
print 'SRoles fila: 30 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'GERE_CONTA'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'GERE_CONTA', 'Gerente de Contabilidad', '20050818 10:06:55.030',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Gerente de Contabilidad'
,   BMfecha = '20050818 10:06:55.030'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'GERE_CONTA'

end -- if 
commit 
go
print 'SRoles fila: 31 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'IMPINT    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'IMPINT    ', 'Importador de Interfaces', '20070706 10:10:35.843',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Importador de Interfaces'
,   BMfecha = '20070706 10:10:35.843'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'IMPINT    '

end -- if 
commit 
go
print 'SRoles fila: 32 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INTConsult'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INTConsult', 'Consulta de Interfaces con sistemas externos', '20070114 11:21:20.720',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consulta de Interfaces con sistemas externos'
,   BMfecha = '20070114 11:21:20.720'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INTConsult'

end -- if 
commit 
go
print 'SRoles fila: 33 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INTERFASES'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INTERFASES', 'Administrador de Interfases', '20050829 16:06:43.447',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Interfases'
,   BMfecha = '20050829 16:06:43.447'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INTERFASES'

end -- if 
commit 
go
print 'SRoles fila: 34 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INTOperad '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INTOperad ', 'Operador de Interfaces con sistemas externos', '20070114 11:22:49.357',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Interfaces con sistemas externos'
,   BMfecha = '20070114 11:22:49.357'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INTOperad '

end -- if 
commit 
go
print 'SRoles fila: 35 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INVCnsRpt '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INVCnsRpt ', 'Consultas y Generación de reportes Inventarios', '20070114 13:12:59.773',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Inventarios'
,   BMfecha = '20070114 13:12:59.773'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INVCnsRpt '

end -- if 
commit 
go
print 'SRoles fila: 36 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INVConsGrl'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INVConsGrl', 'Consultas Generales Inventarios', '20070114 11:43:12.230',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Inventarios'
,   BMfecha = '20070114 11:43:12.230'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INVConsGrl'

end -- if 
commit 
go
print 'SRoles fila: 37 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'INVOperad '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'INVOperad ', 'Operador de Inventarios', '20070116 08:24:17.307',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Inventarios'
,   BMfecha = '20070116 08:24:17.307'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'INVOperad '

end -- if 
commit 
go
print 'SRoles fila: 38 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'MBCnsRpt  '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'MBCnsRpt  ', 'Consultas y Generación de reportes Bancos', '20070114 13:23:11.733',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Bancos'
,   BMfecha = '20070114 13:23:11.733'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'MBCnsRpt  '

end -- if 
commit 
go
print 'SRoles fila: 39 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'MBConsGrl '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'MBConsGrl ', 'Consultas Generales Bancos', '20070114 13:25:19.483',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Bancos'
,   BMfecha = '20070114 13:25:19.483'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'MBConsGrl '

end -- if 
commit 
go
print 'SRoles fila: 40 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'MBOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'MBOperador', 'Operador Bancos', '20070114 10:30:08.837',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Bancos'
,   BMfecha = '20070114 10:30:08.837'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'MBOperador'

end -- if 
commit 
go
print 'SRoles fila: 41 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'NBPRU1    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'NBPRU1    ', 'REASIGNA ORDEN DE COMPRA', '20060629 10:05:03.603',
  1, 1)
end else begin 
update SRoles
set SRdescripcion = 'REASIGNA ORDEN DE COMPRA'
,   BMfecha = '20060629 10:05:03.603'
,   BMUsucodigo = 1
,   SRinterno = 1
where SScodigo = 'SIF       '
  and SRcodigo = 'NBPRU1    '

end -- if 
commit 
go
print 'SRoles fila: 42 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'OCOperador'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'OCOperador', 'Operador de Ordenes Comerciales en Tránsito', '20070114 13:02:53.767',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Ordenes Comerciales en Tránsito'
,   BMfecha = '20070114 13:02:53.767'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'OCOperador'

end -- if 
commit 
go
print 'SRoles fila: 43 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'OPER_CONTA'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'OPER_CONTA', 'Analista de Contabilidad', '20050721 11:56:33.810',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Analista de Contabilidad'
,   BMfecha = '20050721 11:56:33.810'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'OPER_CONTA'

end -- if 
commit 
go
print 'SRoles fila: 44 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'PMI       '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'PMI       ', 'PMI Interfaces', '20070122 14:02:20.920',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'PMI Interfaces'
,   BMfecha = '20070122 14:02:20.920'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'PMI       '

end -- if 
commit 
go
print 'SRoles fila: 45 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'PROVEEDOR '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'PROVEEDOR ', 'Socio de Negocios / Proveedor', '20040714 09:27:01.077',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Socio de Negocios / Proveedor'
,   BMfecha = '20040714 09:27:01.077'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'PROVEEDOR '

end -- if 
commit 
go
print 'SRoles fila: 46 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'Rol 5     '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'Rol 5     ', 'Rol 5', '20070113 16:00:28.347',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Rol 5'
,   BMfecha = '20070113 16:00:28.347'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'Rol 5     '

end -- if 
commit 
go
print 'SRoles fila: 47 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'SOLIC     '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'SOLIC     ', 'Solicitante de Compras', '20040628 11:21:32.377',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante de Compras'
,   BMfecha = '20040628 11:21:32.377'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'SOLIC     '

end -- if 
commit 
go
print 'SRoles fila: 48 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'SUGE_CONTA'
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'SUGE_CONTA', 'Subgerente de Contabilidad', '20050810 15:52:04.397',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Subgerente de Contabilidad'
,   BMfecha = '20050810 15:52:04.397'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'SUGE_CONTA'

end -- if 
commit 
go
print 'SRoles fila: 49 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TESCnsRpt '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TESCnsRpt ', 'Consultas y Generación de reportes Tesorería', '20070114 13:07:37.330',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Tesorería'
,   BMfecha = '20070114 13:07:37.330'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TESCnsRpt '

end -- if 
commit 
go
print 'SRoles fila: 50 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TESOperad '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TESOperad ', 'Operador de Tesorería', '20070114 10:48:27.823',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Tesorería'
,   BMfecha = '20070114 10:48:27.823'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TESOperad '

end -- if 
commit 
go
print 'SRoles fila: 51 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TESSuperv '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TESSuperv ', 'Supervisor Tesorería', '20070114 10:39:31.120',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Tesorería'
,   BMfecha = '20070114 10:39:31.120'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TESSuperv '

end -- if 
commit 
go
print 'SRoles fila: 52 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_ADM   '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TES_ADM   ', 'Administrador de Tesorería', '20050709 16:27:58.003',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Tesorería'
,   BMfecha = '20050709 16:27:58.003'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_ADM   '

end -- if 
commit 
go
print 'SRoles fila: 53 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_OP    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TES_OP    ', 'Administrador de Pagos en Tesorería', '20050709 16:32:19.263',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Pagos en Tesorería'
,   BMfecha = '20050709 16:32:19.263'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_OP    '

end -- if 
commit 
go
print 'SRoles fila: 54 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_SP    '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TES_SP    ', 'Solicitante Empresarial de Pagos a Tesorería', '20050709 16:33:12.873',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante Empresarial de Pagos a Tesorería'
,   BMfecha = '20050709 16:33:12.873'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_SP    '

end -- if 
commit 
go
print 'SRoles fila: 55 de 55'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_SPA   '
if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF       ', 'TES_SPA   ', 'Aprobador Empresarial de Pagos a Tesorería', '20050709 16:51:36.843',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Aprobador Empresarial de Pagos a Tesorería'
,   BMfecha = '20050709 16:51:36.843'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF       '
  and SRcodigo = 'TES_SPA   '

end -- if 
commit 
go

print 'Terminado SRoles'

print 'Actualizar SProcesos (update/insert)...'
print 'SProcesos fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SProcesos 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
if (@n = 0) begin
insert into SProcesos (
SScodigo, SMcodigo, SPcodigo, SPdescripcion,
  SPhomeuri, SPmenu, BMfecha, BMUsucodigo,
  SPorden, SPhablada, SPlogo, SPanonimo,
  SPpublico, SPinterno)
values (
  'SIF       ', 'INTERPMI  ', 'VentasF   ', 'Ventas Producto FACT',
  '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm', 0, '20070222 16:20:52.957', 1,
  140, ' ', null, 0,
  0, 0)
end else begin 
update SProcesos
set SPdescripcion = 'Ventas Producto FACT'
,   SPhomeuri = '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm'
,   SPmenu = 0
,   BMfecha = '20070222 16:20:52.957'
,   BMUsucodigo = 1
,   SPorden = 140
,   SPhablada = ' '
,   SPlogo = null
,   SPanonimo = 0
,   SPpublico = 0
,   SPinterno = 0
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '

end -- if 
commit 
go

print 'Terminado SProcesos'

print 'Actualizar SProcesosRol (update/insert)...'

print 'Terminado SProcesosRol'

print 'Actualizar SComponentes (update/insert)...'
print 'SComponentes fila: 1 de 3'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/FacturasProdVentasA-sql.cfm'
if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/FacturasProdVentasA-sql.cfm',
  'P', 0, '20070223 21:21:20.630', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20070223 21:21:20.630'
,   BMUsucodigo = 1
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/FacturasProdVentasA-sql.cfm'

end -- if 
commit 
go
print 'SComponentes fila: 2 de 3'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm'
if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm',
  'P', 0, '20070222 16:20:52.963', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20070222 16:20:52.963'
,   BMUsucodigo = 1
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm'

end -- if 
commit 
go
print 'SComponentes fila: 3 de 3'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/ProcFactProdVent.cfm'
if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/ProcFactProdVent.cfm',
  'P', 0, '20070222 16:21:37.800', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20070222 16:21:37.800'
,   BMUsucodigo = 1
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasF   '
  and SCuri = '/interfacesTRD/componentesInterfaz/ProcFactProdVent.cfm'

end -- if 
commit 
go

print 'Terminado SComponentes'

print 'Actualizar SMenues (update/insert)...'

print 'Terminado SMenues'

print 'Actualizar SProcesoRelacionado (update/insert)...'

print 'Terminado SProcesoRelacionado'

-- Eliminar componentes que no van

print 'Eliminar componentes que no van'


go

create table TMPDATA_IMPORT (
  SScodigo char(10) not null,
  SMcodigo char(10) not null,
  SPcodigo char(10) not null,
  SCuri varchar(255) not null)

go


insert INTO TMPDATA_IMPORT values ('SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/FacturasProdVentasA-sql.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/FacturasProdVentasParam.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF       ', 'INTERPMI  ', 'VentasF   ', '/interfacesTRD/componentesInterfaz/ProcFactProdVent.cfm')

go


delete from SComponentes
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SComponentes.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SComponentes.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SComponentes.SPcodigo
	  and TMPDATA_IMPORT.SCuri = SComponentes.SCuri)

go


print 'SComponentes eliminados'

drop table TMPDATA_IMPORT

go


-- Eliminar menues que no van

print 'Eliminar menues que no van'


go

create table TMPDATA_IMPORT (
  SMNcodigo numeric(18) not null)

go


delete from SMenues
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SMNcodigo = SMenues.SMNcodigo)

go


print 'SMenues eliminados'

drop table TMPDATA_IMPORT

go


-- Eliminar procesos relacionados que no van

print 'Eliminar procesos relacionados que no van'


go

create table TMPDATA_IMPORT (
  SSorigen char(10) not null,
  SMorigen char(10) not null,
  SPorigen char(10) not null,
  SSdestino char(10) not null,
  SMdestino char(10) not null,
  SPdestino char(10) not null
)

go


delete from SProcesoRelacionado
where 1=1
  and ((SSorigen = 'SIF' and SMorigen = 'INTERPMI' and SPorigen = 'VentasF')
   or (SSdestino = 'SIF' and SMdestino = 'INTERPMI' and SPdestino = 'VentasF'))
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SSorigen = SProcesoRelacionado.SSorigen
	  and TMPDATA_IMPORT.SMorigen = SProcesoRelacionado.SMorigen
	  and TMPDATA_IMPORT.SPorigen = SProcesoRelacionado.SPorigen
	  and TMPDATA_IMPORT.SSdestino = SProcesoRelacionado.SSdestino
	  and TMPDATA_IMPORT.SMdestino = SProcesoRelacionado.SMdestino
	  and TMPDATA_IMPORT.SPdestino = SProcesoRelacionado.SPdestino
  )

go


print 'SProcesoRelacionado eliminados'

drop table TMPDATA_IMPORT

go


-- Eliminar procesos que no van

print 'Eliminar procesos que no van'


go

create table TMPDATA_IMPORT (
  SScodigo char(10) not null,
  SRcodigo char(10) not null,
  SMcodigo char(10) not null,
  SPcodigo char(10) not null)

go


delete from SProcesosRol
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SProcesosRol.SScodigo
	  and TMPDATA_IMPORT.SRcodigo = SProcesosRol.SRcodigo
	  and TMPDATA_IMPORT.SMcodigo = SProcesosRol.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SProcesosRol.SPcodigo)

go


print 'SProcesosRol eliminados'

delete from UsuarioProceso
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = UsuarioProceso.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = UsuarioProceso.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = UsuarioProceso.SPcodigo)

go


print 'UsuarioProceso eliminados'

delete from SShortcut
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SShortcut.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SShortcut.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SShortcut.SPcodigo)

go


print 'SShortcut eliminados'

delete from SRelacionado
where id_padre in (
select id_item
from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SMenuItem.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SMenuItem.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SMenuItem.SPcodigo))

go


print 'SRelacionado/id_padre eliminados'

delete from SRelacionado
where id_hijo in (
select id_item
from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SMenuItem.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SMenuItem.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SMenuItem.SPcodigo))

go


print 'SRelacionado/id_hijo eliminados'

delete from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SMenuItem.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SMenuItem.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SMenuItem.SPcodigo)

go


print 'SMenuItem eliminados'

delete from SProcesos
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = SProcesos.SScodigo
	  and TMPDATA_IMPORT.SMcodigo = SProcesos.SMcodigo
	  and TMPDATA_IMPORT.SPcodigo = SProcesos.SPcodigo)

go


print 'SProcesos eliminados'

drop table TMPDATA_IMPORT

go





print 'Regenerando vUsuarioProcesos'


go


delete vUsuarioProcesos
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'

go

insert INTO vUsuarioProcesos (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
from vUsuarioProcesosCalc
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'INTERPMI'
  and SPcodigo = 'VentasF'

go



while @@trancount > 0 begin
	select 'cerrando transaccion ', @@trancount 
	commit tran
end

go




print 'Importacion finalizada. A continuacion la cuenta de los registros'


go



select 'Politicas            ' as tipo, count(1) as real, 56 as esperado
from PLista

go



select 'Sistemas             ' as tipo, count(1) as real, 1 as esperado
from SSistemas
where SScodigo = 'SIF'


go


select 'Modulos              ' as tipo, count(1) as real, 1 as esperado
from SModulos
where SScodigo = 'SIF'
and SMcodigo = 'INTERPMI'


go


select 'Procesos             ' as tipo, count(1) as real, 1 as esperado
from SProcesos
where SScodigo = 'SIF'
and SMcodigo = 'INTERPMI'
and SPcodigo = 'VentasF'


go


select 'Componentes          ' as tipo, count(1) as real, 3 as esperado
from SComponentes
where SScodigo = 'SIF'
and SMcodigo = 'INTERPMI'
and SPcodigo = 'VentasF'


go


select 'Roles                ' as tipo, count(1) as real, 55 as esperado
from SRoles
where SScodigo = 'SIF'


go


select 'ProcesosRol          ' as tipo, count(1) as real, 0 as esperado
from SProcesosRol
where SScodigo = 'SIF'
and SMcodigo = 'INTERPMI'
and SPcodigo = 'VentasF'


go


select 'Menues               ' as tipo, count(1) as real, 0 as esperado
from SMenues
where SScodigo = 'SIF'
and SMcodigo = 'INTERPMI'
and SPcodigo = 'VentasF'


go


select 'SProcesoRelacionado  ' as tipo, count(1) as real, 0 as esperado
from SProcesoRelacionado 
where (SSorigen = 'SIF' and SMorigen = 'INTERPMI' and SPorigen = 'VentasF')
   or (SSdestino = 'SIF' and SMdestino = 'INTERPMI' and SPdestino = 'VentasF')


go


-- Fin de archivo
