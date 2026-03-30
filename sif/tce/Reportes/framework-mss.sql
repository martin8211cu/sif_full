 -- Exportación del proceso SIF TCE TCEestCta
 -- SYBASE: isql -Usa -Ppasswd -Sserver_name -D asp -i framework-app.sql 
 
 -- ORACLE: sqlplus user/passwd@server_name @framework-app.sql 
 
 -- DB2:    db2 -td/ vf framework-app.sql 
 
 -- 

go

set nocount on
go

print 'Actualizar PLista (update/insert)...'
print 'PLista fila: 1 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.nuevo'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.nuevo', 'Politica para usuarios nuevos (admit/reject)', 1, 1,
  0, 'reject', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Politica para usuarios nuevos (admit/reject)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'reject'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'auth.nuevo'
end -- if 
commit 
go
print 'PLista fila: 2 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.orden'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.orden', 'Orden de métodos de autenticación', 1, 1,
  0, 'asp', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Orden de métodos de autenticación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'asp'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'auth.orden'
end -- if 
commit 
go
print 'PLista fila: 3 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.validar.horario'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.validar.horario', 'Validar horario de acceso', 0, 1,
  0, '0', '20060622 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Validar horario de acceso'
,   es_global = 0
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060622 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'auth.validar.horario'
end -- if 
commit 
go
print 'PLista fila: 4 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'auth.validar.ip'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'auth.validar.ip', 'Validar dirección IP', 0, 1,
  0, '0', '20060622 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Validar dirección IP'
,   es_global = 0
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060622 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'auth.validar.ip'
end -- if 
commit 
go
print 'PLista fila: 5 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'correo.cuenta'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'correo.cuenta', 'Dirección de correo para los correos que salen del portal', 1, 0,
  0, 'anav@soin.co.cr', '20080626 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Dirección de correo para los correos que salen del portal'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'anav@soin.co.cr'
,   BMfecha = '20080626 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'correo.cuenta'
end -- if 
commit 
go
print 'PLista fila: 6 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'debug.expira'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'debug.expira', 'Expiracion del debug', 1, 0,
  0, null, '20060613 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Expiracion del debug'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20060613 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'debug.expira'
end -- if 
commit 
go
print 'PLista fila: 7 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.CuentaEmpresarial'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.CuentaEmpresarial', 'Cuenta empresarial de las empresas de demostraciones', 1, 0,
  0, null, '20050608 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Cuenta empresarial de las empresas de demostraciones'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20050608 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'demo.CuentaEmpresarial'
end -- if 
commit 
go
print 'PLista fila: 8 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.Ecodigo'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.Ecodigo', 'Ecodigo de la Empresa Base de Demostraciones', 1, 0,
  0, '1097', '20090129 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Ecodigo de la Empresa Base de Demostraciones'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '1097'
,   BMfecha = '20090129 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'demo.Ecodigo'
end -- if 
commit 
go
print 'PLista fila: 9 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.cache'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.cache', 'Nombre del datasource donde se creara la empresa de demos', 1, 0,
  0, null, '20050714 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Nombre del datasource donde se creara la empresa de demos'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20050714 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'demo.cache'
end -- if 
commit 
go
print 'PLista fila: 10 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'demo.vigencia'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'demo.vigencia', 'Vigencia en dias del usuario que solicito una demostracion', 1, 0,
  0, '22', '20050608 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Vigencia en dias del usuario que solicito una demostracion'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '22'
,   BMfecha = '20050608 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'demo.vigencia'
end -- if 
commit 
go
print 'PLista fila: 11 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'error.detalles'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'error.detalles', 'Ocultar detalles técnicos del error a los usuarios', 1, 0,
  0, '0', '20060927 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Ocultar detalles técnicos del error a los usuarios'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20060927 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'error.detalles'
end -- if 
commit 
go
print 'PLista fila: 12 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.adminDN'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.adminDN', 'DN del administrador', 1, 1,
  0, 'cn=Directory Manager', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'DN del administrador'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'cn=Directory Manager'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.adminDN'
end -- if 
commit 
go
print 'PLista fila: 13 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.adminPass'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.adminPass', 'Contraseña del administrador', 1, 1,
  0, 'ninguno', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Contraseña del administrador'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'ninguno'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.adminPass'
end -- if 
commit 
go
print 'PLista fila: 14 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.baseDN'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.baseDN', 'DN raíz del directorio por usar', 1, 1,
  0, 'dc=example,dc=com', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'DN raíz del directorio por usar'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'dc=example,dc=com'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.baseDN'
end -- if 
commit 
go
print 'PLista fila: 15 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.dominio'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.dominio', 'Usa dominio para autenticar al usuario al servidor LDAP', 1, 1,
  0, '0', '20070530 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Usa dominio para autenticar al usuario al servidor LDAP'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '0'
,   BMfecha = '20070530 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.dominio'
end -- if 
commit 
go
print 'PLista fila: 16 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.port'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.port', 'Puerto de LDAP', 1, 1,
  0, '389', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Puerto de LDAP'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '389'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.port'
end -- if 
commit 
go
print 'PLista fila: 17 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'ldap.server'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'ldap.server', 'Servidor de LDAP', 1, 1,
  0, 'localhost', '20060510 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Servidor de LDAP'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'localhost'
,   BMfecha = '20060510 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'ldap.server'
end -- if 
commit 
go
print 'PLista fila: 18 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'monitor.habilitar'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'monitor.habilitar', 'Habilitar monitoreo', 1, 0,
  0, '1', '20061012 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Habilitar monitoreo'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20061012 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'monitor.habilitar'
end -- if 
commit 
go
print 'PLista fila: 19 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'monitor.historia'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'monitor.historia', 'Días para mantener en históricos de monitoreo', 1, 0,
  0, '15', '20040528 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Días para mantener en históricos de monitoreo'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '15'
,   BMfecha = '20040528 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'monitor.historia'
end -- if 
commit 
go
print 'PLista fila: 20 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.default'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.default', 'Expiración de contraseñas', 1, 1,
  1, '365', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.default'
end -- if 
commit 
go
print 'PLista fila: 21 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.max'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.max', 'Expiración de contraseñas (máximo)', 1, 1,
  0, '3650', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas (máximo)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '3650'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.max'
end -- if 
commit 
go
print 'PLista fila: 22 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.min'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.min', 'Expiración de contraseñas (mínimo)', 1, 1,
  0, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Expiración de contraseñas (mínimo)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.min'
end -- if 
commit 
go
print 'PLista fila: 23 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.recordat'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.recordat', 'Recordatorio de expiración de contraseñas', 1, 1,
  1, '7', '20040524 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Recordatorio de expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '7'
,   BMfecha = '20040524 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.recordat'
end -- if 
commit 
go
print 'PLista fila: 24 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.expira.recordatorio'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.expira.recordatorio', 'Recordatorio de expiración de contraseñas', 1, 1,
  1, '7', '20040524 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Recordatorio de expiración de contraseñas'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '7'
,   BMfecha = '20040524 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.expira.recordatorio'
end -- if 
commit 
go
print 'PLista fila: 25 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.long.max'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.long.max', 'Longitud máxima de contraseña', 1, 1,
  1, '20', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Longitud máxima de contraseña'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '20'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.long.max'
end -- if 
commit 
go
print 'PLista fila: 26 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.long.min'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.long.min', 'Longitud mínima de contraseña', 1, 1,
  1, '4', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Longitud mínima de contraseña'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '4'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.long.min'
end -- if 
commit 
go
print 'PLista fila: 27 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.mail.cambiar'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.mail.cambiar', 'Cambio obligatorio de passwords enviados por mail', 1, 1,
  1, '0', '20080507 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Cambio obligatorio de passwords enviados por mail'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20080507 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.mail.cambiar'
end -- if 
commit 
go
print 'PLista fila: 28 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.dicciona'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.dicciona', 'La contraseña no debe estar en el diccionario', 1, 1,
  1, '0', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña no debe estar en el diccionario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.dicciona'
end -- if 
commit 
go
print 'PLista fila: 29 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.diccionario'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.diccionario', 'La contraseña no debe estar en el diccionario', 1, 1,
  1, '0', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña no debe estar en el diccionario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.diccionario'
end -- if 
commit 
go
print 'PLista fila: 30 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.digitos'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.digitos', 'La contraseña debe contener dígitos', 1, 1,
  1, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener dígitos'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.digitos'
end -- if 
commit 
go
print 'PLista fila: 31 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.letras'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.letras', 'La contraseña debe contener letras', 1, 1,
  0, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener letras'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.letras'
end -- if 
commit 
go
print 'PLista fila: 32 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.lista'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.lista', 'Lista de contraseñas anteriores por recordar', 1, 1,
  1, '0', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Lista de contraseñas anteriores por recordar'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.lista'
end -- if 
commit 
go
print 'PLista fila: 33 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.simbolos'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.simbolos', 'La contraseña debe contener símbolos', 1, 1,
  1, '0', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe contener símbolos'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '0'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.simbolos'
end -- if 
commit 
go
print 'PLista fila: 34 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'pass.valida.usuario'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'pass.valida.usuario', 'La contraseña debe ser distinta al usuario', 1, 1,
  1, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'La contraseña debe ser distinta al usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'pass.valida.usuario'
end -- if 
commit 
go
print 'PLista fila: 35 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.id'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.id', 'Opciones identity (in)', 1, 0,
  0, '-E', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Opciones identity (in)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-E'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.id'
end -- if 
commit 
go
print 'PLista fila: 36 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.in'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.in', 'Opciones IN BCP', 1, 0,
  0, null, '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Opciones IN BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.in'
end -- if 
commit 
go
print 'PLista fila: 37 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.opt'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.opt', 'Opciones comunes BCP', 1, 0,
  0, '-c -t$@!\t$@! -r$@!\r\n -T 512000', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Opciones comunes BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-c -t$@!\t$@! -r$@!\r\n -T 512000'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.opt'
end -- if 
commit 
go
print 'PLista fila: 38 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.out'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.out', 'Opciones OUT BCP', 1, 0,
  0, null, '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Opciones OUT BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.out'
end -- if 
commit 
go
print 'PLista fila: 39 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.server'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.server', 'Servidor (-S) BCP', 1, 0,
  0, 'MINISIF', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Servidor (-S) BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'MINISIF'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.server'
end -- if 
commit 
go
print 'PLista fila: 40 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.tool'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.tool', 'Ruta completa del BCP', 1, 0,
  0, '/sybase/OCS-15_0/bin/bcp', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Ruta completa del BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/sybase/OCS-15_0/bin/bcp'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.tool'
end -- if 
commit 
go
print 'PLista fila: 41 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.bcp.user'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.bcp.user', 'Usuario y contraseña BCP', 1, 0,
  0, '-Uadmin -Psecret', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Usuario y contraseña BCP'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '-Uadmin -Psecret'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.bcp.user'
end -- if 
commit 
go
print 'PLista fila: 42 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.fileext'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.fileext', 'Extensión por generar (gzip)', 1, 0,
  0, 'gz', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Extensión por generar (gzip)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = 'gz'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.fileext'
end -- if 
commit 
go
print 'PLista fila: 43 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.fileutil'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.fileutil', 'Utilitario archivador (GNU tar)', 1, 0,
  0, '/bin/tar', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Utilitario archivador (GNU tar)'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/bin/tar'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.fileutil'
end -- if 
commit 
go
print 'PLista fila: 44 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'respaldo.path'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'respaldo.path', 'Ruta de los archivos', 1, 0,
  0, '/tmp/aspweb-backup/', '20061106 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Ruta de los archivos'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = '/tmp/aspweb-backup/'
,   BMfecha = '20061106 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'respaldo.path'
end -- if 
commit 
go
print 'PLista fila: 45 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'servidor.principal'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'servidor.principal', 'Servidor principal del cluster', 1, 0,
  0, null, '20060104 00:00:00.000', 0)
end else begin 
update PLista
set pnombre = 'Servidor principal del cluster'
,   es_global = 1
,   es_cuenta = 0
,   es_usuario = 0
,   predeterminado = null
,   BMfecha = '20060104 00:00:00.000'
,   BMUsucodigo = 0
where parametro = 'servidor.principal'
end -- if 
commit 
go
print 'PLista fila: 46 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.cant'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.cant', 'Bloquear contraseña: Cantidad de errores', 1, 1,
  1, '5', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Cantidad de errores'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '5'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.cant'
end -- if 
commit 
go
print 'PLista fila: 47 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.durac'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.durac', 'Bloquear contraseña: Duración del bloqueo', 1, 1,
  1, '10', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Duración del bloqueo'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.durac'
end -- if 
commit 
go
print 'PLista fila: 48 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.duracion'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.duracion', 'Bloquear contraseña: Duración del bloqueo', 1, 1,
  1, '10', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Duración del bloqueo'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.duracion'
end -- if 
commit 
go
print 'PLista fila: 49 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.perio'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.perio', 'Bloquear contraseña: Periodo de validación', 1, 1,
  1, '10', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Periodo de validación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.perio'
end -- if 
commit 
go
print 'PLista fila: 50 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.bloqueo.periodo'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.bloqueo.periodo', 'Bloquear contraseña: Periodo de validación', 1, 1,
  1, '10', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Bloquear contraseña: Periodo de validación'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.bloqueo.periodo'
end -- if 
commit 
go
print 'PLista fila: 51 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.defa'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.defa', 'Duración de la sesión', 1, 1,
  1, '365', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Duración de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.defa'
end -- if 
commit 
go
print 'PLista fila: 52 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.default'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.default', 'Duración de la sesión', 1, 1,
  1, '365', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Duración de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '365'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.default'
end -- if 
commit 
go
print 'PLista fila: 53 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.max'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.max', 'Duración máxima de la sesión', 1, 1,
  1, '10080', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Duración máxima de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '10080'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.max'
end -- if 
commit 
go
print 'PLista fila: 54 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.min'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.min', 'Duración mínima de la sesión', 1, 1,
  0, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Duración mínima de la sesión'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.min'
end -- if 
commit 
go
print 'PLista fila: 55 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.duracion.modo'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.duracion.modo', 'Duración total(1) o inactiva(2)', 1, 1,
  1, '2', '20040524 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Duración total(1) o inactiva(2)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '2'
,   BMfecha = '20040524 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.duracion.modo'
end -- if 
commit 
go
print 'PLista fila: 56 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'sesion.multiple'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'sesion.multiple', 'Permitir varias sesiones por usuario(1=si,2=close,3=timeout)', 1, 1,
  1, '1', '20040521 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Permitir varias sesiones por usuario(1=si,2=close,3=timeout)'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 1
,   predeterminado = '1'
,   BMfecha = '20040521 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'sesion.multiple'
end -- if 
commit 
go
print 'PLista fila: 57 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.long.max'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.long.max', 'Longitud máxima del usuario', 1, 1,
  0, '30', '20060517 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Longitud máxima del usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '30'
,   BMfecha = '20060517 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'user.long.max'
end -- if 
commit 
go
print 'PLista fila: 58 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.long.min'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.long.min', 'Longitud mínima del usuario', 1, 1,
  0, '4', '20060517 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Longitud mínima del usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = '4'
,   BMfecha = '20060517 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'user.long.min'
end -- if 
commit 
go
print 'PLista fila: 59 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.valid.chars'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.valid.chars', 'Caracteres validos para el usuario', 1, 1,
  0, 'a-zA-Z0-9@_.-', '20060517 00:00:00.000', 1)
end else begin 
update PLista
set pnombre = 'Caracteres validos para el usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'a-zA-Z0-9@_.-'
,   BMfecha = '20060517 00:00:00.000'
,   BMUsucodigo = 1
where parametro = 'user.valid.chars'
end -- if 
commit 
go
print 'PLista fila: 60 de 60'
declare @n int 
begin tran
select @n = count(1)
from PLista 
where parametro = 'user.valid.varchar2s'if (@n = 0) begin
insert into PLista (
parametro, pnombre, es_global, es_cuenta,
  es_usuario, predeterminado, BMfecha, BMUsucodigo)
values (
  'user.valid.varchar2s', 'Caracteres validos para el usuario', 1, 1,
  0, 'a-zA-Z0-9@_.-', '20060517 17:07:05.000', 1)
end else begin 
update PLista
set pnombre = 'Caracteres validos para el usuario'
,   es_global = 1
,   es_cuenta = 1
,   es_usuario = 0
,   predeterminado = 'a-zA-Z0-9@_.-'
,   BMfecha = '20060517 17:07:05.000'
,   BMUsucodigo = 1
where parametro = 'user.valid.varchar2s'
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
where SScodigo = 'SIF'if (@n = 0) begin
insert into SSistemas (
SScodigo, SSdescripcion, SShomeuri, SSmenu,
  BMfecha, BMUsucodigo, SSorden, SSlogo,
  SShablada)
values (
  'SIF', 'Sistema Financiero Integral', null, 1,
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
where SScodigo = 'SIF'
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
where SScodigo = 'SIF'  and SMcodigo = 'TCE'if (@n = 0) begin
insert into SModulos (
SScodigo, SMcodigo, SMdescripcion, SMhomeuri,
  SMmenu, BMfecha, BMUsucodigo, SMorden,
  SMhablada, SMlogo)
values (
  'SIF', 'TCE', 'Tarjetas de Credito Empresarial', '/sif/tce/MenuTCE.cfm',
  1, '20110721 13:21:21.803', 1, 21,
  'Administrar las tarjetas de credito de la compañia y visualizando el detalle completo de las operaciones de cada una', 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080022002F03012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F7FAE2FC43F1234DF0EF88174CB882592354DD3CF1F222F623BF6ADFF11EB76FE1DD06EF53B86C2C284A8EECDD80AF9E6CDEEBC50F3DFDF21449642EE7392E7B01ED5BD0A5ED1EBB1857ADECE375B9EB1AAFC4B8E2BEB66D2E34B9B023749210417CF40BEF5A377E3478EE2378E0D96C1773F9B8040EF93D0579E69F05BA30134C8648C7D1631FE354356B8B6D5637B28A69A4B50732286C0947A13E9FCEB3C4D4A34969D3F12B0D0AB535975FC0F72B2D7F4CBF480DBDE44E675DC814E73F88E2B4ABE639358D434A952DF49801B8B68FCF4466D8AA8BE99EB8F415EFFE12D7CF88740B5BB96096DEE5A2569219576B0C8EB8F435CD46AB9EEAC74D4828BB2678D7C66F17A6A5AFC3E1F8253F63B36CDD15EEFE9F8565693716CDA794772A922EC0D01E157DBDEBD6FC63F0AF46F14B497510FB1EA0DCF9D18E18F3F7877AF2A4F871E21D0B554B2689A459D82ACB1F319F7F635EA509D371E591E6E26152EA50DC6F896D6E552D22B4B80BA738CB328E5CFAE696CADADB4C52A1F20E1B26BBDD37E1BDF9D367B7BA95141605232723EB9ED59B65E09D4A7BE7B63190CAFF003C8C98541D87BD78B8BA2FDA5A3AA67AD86AABD9DE6ACCCFD29A38B5FB49A5B1174A321004DCCA4F1B947722BD5744D32F12E05DCE5E218216366DEED9EA5CFAF0381C0A9F42F0CD9E8B1A955124F8C1908E7F0F4ADBAD685274E1CAD99D59A9CAE82908E94515B998B4800C9A28A005A28A2803FFD9)
end else begin 
update SModulos
set SMdescripcion = 'Tarjetas de Credito Empresarial'
,   SMhomeuri = '/sif/tce/MenuTCE.cfm'
,   SMmenu = 1
,   BMfecha = '20110721 13:21:21.803'
,   BMUsucodigo = 1
,   SMorden = 21
,   SMhablada = 'Administrar las tarjetas de credito de la compañia y visualizando el detalle completo de las operaciones de cada una'
,   SMlogo = 0xFFD8FFE000104A46494600010101006000600000FFDB004300080606070605080707070909080A0C140D0C0B0B0C1912130F141D1A1F1E1D1A1C1C20242E2720222C231C1C2837292C30313434341F27393D38323C2E333432FFDB0043010909090C0B0C180D0D1832211C213232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232323232FFC00011080022002F03012200021101031101FFC4001F0000010501010101010100000000000000000102030405060708090A0BFFC400B5100002010303020403050504040000017D01020300041105122131410613516107227114328191A1082342B1C11552D1F02433627282090A161718191A25262728292A3435363738393A434445464748494A535455565758595A636465666768696A737475767778797A838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE1E2E3E4E5E6E7E8E9EAF1F2F3F4F5F6F7F8F9FAFFC4001F0100030101010101010101010000000000000102030405060708090A0BFFC400B51100020102040403040705040400010277000102031104052131061241510761711322328108144291A1B1C109233352F0156272D10A162434E125F11718191A262728292A35363738393A434445464748494A535455565758595A636465666768696A737475767778797A82838485868788898A92939495969798999AA2A3A4A5A6A7A8A9AAB2B3B4B5B6B7B8B9BAC2C3C4C5C6C7C8C9CAD2D3D4D5D6D7D8D9DAE2E3E4E5E6E7E8E9EAF2F3F4F5F6F7F8F9FAFFDA000C03010002110311003F00F7FAE2FC43F1234DF0EF88174CB882592354DD3CF1F222F623BF6ADFF11EB76FE1DD06EF53B86C2C284A8EECDD80AF9E6CDEEBC50F3DFDF21449642EE7392E7B01ED5BD0A5ED1EBB1857ADECE375B9EB1AAFC4B8E2BEB66D2E34B9B023749210417CF40BEF5A377E3478EE2378E0D96C1773F9B8040EF93D0579E69F05BA30134C8648C7D1631FE354356B8B6D5637B28A69A4B50732286C0947A13E9FCEB3C4D4A34969D3F12B0D0AB535975FC0F72B2D7F4CBF480DBDE44E675DC814E73F88E2B4ABE639358D434A952DF49801B8B68FCF4466D8AA8BE99EB8F415EFFE12D7CF88740B5BB96096DEE5A2569219576B0C8EB8F435CD46AB9EEAC74D4828BB2678D7C66F17A6A5AFC3E1F8253F63B36CDD15EEFE9F8565693716CDA794772A922EC0D01E157DBDEBD6FC63F0AF46F14B497510FB1EA0DCF9D18E18F3F7877AF2A4F871E21D0B554B2689A459D82ACB1F319F7F635EA509D371E591E6E26152EA50DC6F896D6E552D22B4B80BA738CB328E5CFAE696CADADB4C52A1F20E1B26BBDD37E1BDF9D367B7BA95141605232723EB9ED59B65E09D4A7BE7B63190CAFF003C8C98541D87BD78B8BA2FDA5A3AA67AD86AABD9DE6ACCCFD29A38B5FB49A5B1174A321004DCCA4F1B947722BD5744D32F12E05DCE5E218216366DEED9EA5CFAF0381C0A9F42F0CD9E8B1A955124F8C1908E7F0F4ADBAD685274E1CAD99D59A9CAE82908E94515B998B4800C9A28A005A28A2803FFD9
where SScodigo = 'SIF'  and SMcodigo = 'TCE'
end -- if 
commit 
go

print 'Terminado SModulos'

print 'Actualizar SRoles (update/insert)...'
print 'SRoles fila: 1 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM', 'Administrador', '20040204 15:08:15.250',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador'
,   BMfecha = '20040204 15:08:15.250'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM'
end -- if 
commit 
go
print 'SRoles fila: 2 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM_CAT'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM_CAT', 'Administrador de Catalogos', '20050808 16:09:11.346',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Catalogos'
,   BMfecha = '20050808 16:09:11.346'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM_CAT'
end -- if 
commit 
go
print 'SRoles fila: 3 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM_GastoE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM_GastoE', 'Administrador Gastos de Empleado', '20080812 11:15:09.606',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador Gastos de Empleado'
,   BMfecha = '20080812 11:15:09.606'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM_GastoE'
end -- if 
commit 
go
print 'SRoles fila: 4 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM_PRES'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM_PRES', 'Administrador de Presupuesto', '20050302 11:01:30.326',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Presupuesto'
,   BMfecha = '20050302 11:01:30.326'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM_PRES'
end -- if 
commit 
go
print 'SRoles fila: 5 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM_PROY'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM_PROY', 'Administrador de Proyectos', '20040616 15:58:33.813',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Proyectos'
,   BMfecha = '20040616 15:58:33.813'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM_PROY'
end -- if 
commit 
go
print 'SRoles fila: 6 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ADM_SIST'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ADM_SIST', 'Administrador de Sistemas', '20040204 15:08:15.250',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Sistemas'
,   BMfecha = '20040204 15:08:15.250'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ADM_SIST'
end -- if 
commit 
go
print 'SRoles fila: 7 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ANAL_CONTA'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ANAL_CONTA', 'Analista de Contabilidad', '20050818 09:32:00.083',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Analista de Contabilidad'
,   BMfecha = '20050818 09:32:00.083'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ANAL_CONTA'
end -- if 
commit 
go
print 'SRoles fila: 8 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ANOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ANOperador', 'Operador Anexos Financieros', '20070114 11:54:42.653',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Anexos Financieros'
,   BMfecha = '20070114 11:54:42.653'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ANOperador'
end -- if 
commit 
go
print 'SRoles fila: 9 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ANSuperv'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ANSuperv', 'Supervisor Anexos Financieros', '20070114 11:14:21.063',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Anexos Financieros'
,   BMfecha = '20070114 11:14:21.063'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ANSuperv'
end -- if 
commit 
go
print 'SRoles fila: 10 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'A_DESA'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'A_DESA', 'Programas en Desarrollo', '20080219 10:44:47.263',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Programas en Desarrollo'
,   BMfecha = '20080219 10:44:47.263'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'A_DESA'
end -- if 
commit 
go
print 'SRoles fila: 11 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'AdminCons'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'AdminCons', 'Consultas Administrativas y Generación de Reporte', '20070114 11:24:55.870',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Administrativas y Generación de Reporte'
,   BMfecha = '20070114 11:24:55.870'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'AdminCons'
end -- if 
commit 
go
print 'SRoles fila: 12 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'Ant_GastoE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'Ant_GastoE', 'Solicitante de Anticipos', '20080812 11:16:20.436',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante de Anticipos'
,   BMfecha = '20080812 11:16:20.436'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'Ant_GastoE'
end -- if 
commit 
go
print 'SRoles fila: 13 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'ApLiq_GasE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'ApLiq_GasE', 'Aprobación de Liquidaciones', '20080812 11:45:06.203',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Aprobación de Liquidaciones'
,   BMfecha = '20080812 11:45:06.203'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'ApLiq_GasE'
end -- if 
commit 
go
print 'SRoles fila: 14 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'B2B_ALL'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'B2B_ALL', 'B2B con permisos de acceso total', '20110625 16:16:29.603',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'B2B con permisos de acceso total'
,   BMfecha = '20110625 16:16:29.603'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'B2B_ALL'
end -- if 
commit 
go
print 'SRoles fila: 15 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CCCnsFis'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CCCnsFis', 'Consultas Fiscales Cuentas por Cobrar', '20070114 12:42:34.733',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Fiscales Cuentas por Cobrar'
,   BMfecha = '20070114 12:42:34.733'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CCCnsFis'
end -- if 
commit 
go
print 'SRoles fila: 16 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CCCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CCCnsRpt', 'Consultas y Generación de reportes Cuentas por Cobrar', '20070114 12:49:37.300',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Cuentas por Cobrar'
,   BMfecha = '20070114 12:49:37.300'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CCCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 17 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CCConsGrl'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CCConsGrl', 'Consultas Generales Cuentas por Cobrar', '20070114 11:38:43.933',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Cuentas por Cobrar'
,   BMfecha = '20070114 11:38:43.933'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CCConsGrl'
end -- if 
commit 
go
print 'SRoles fila: 18 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CCH1'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CCH1', 'Configuración de Caja Chica', '20090512 14:23:51.563',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Configuración de Caja Chica'
,   BMfecha = '20090512 14:23:51.563'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CCH1'
end -- if 
commit 
go
print 'SRoles fila: 19 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CCOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CCOperador', 'Operador de Cuentas por Cobrar', '20070114 09:12:08.360',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Cuentas por Cobrar'
,   BMfecha = '20070114 09:12:08.360'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CCOperador'
end -- if 
commit 
go
print 'SRoles fila: 20 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CGCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CGCnsRpt', 'Consultas y Generación de reportes Contabilidad', '20070113 15:58:49.750',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Contabilidad'
,   BMfecha = '20070113 15:58:49.750'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CGCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 21 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CGConsGrl'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CGConsGrl', 'Consultas Generales Contabilidad', '20070113 15:59:53.623',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Contabilidad'
,   BMfecha = '20070113 15:59:53.623'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CGConsGrl'
end -- if 
commit 
go
print 'SRoles fila: 22 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CGOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CGOperador', 'Operador de Contabilidad', '20070113 15:58:04.320',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Contabilidad'
,   BMfecha = '20070113 15:58:04.320'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CGOperador'
end -- if 
commit 
go
print 'SRoles fila: 23 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CGSuperv'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CGSuperv', 'Supervisor Contabilidad', '20070113 15:56:43.710',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Contabilidad'
,   BMfecha = '20070113 15:56:43.710'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CGSuperv'
end -- if 
commit 
go
print 'SRoles fila: 24 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CGTCOperad'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CGTCOperad', 'Operador Tipos de Cambio', '20070114 12:28:12.433',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Tipos de Cambio'
,   BMfecha = '20070114 12:28:12.433'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CGTCOperad'
end -- if 
commit 
go
print 'SRoles fila: 25 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CLIENTE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CLIENTE', 'Socio de Negocios / Cliente', '20040714 09:26:45.216',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Socio de Negocios / Cliente'
,   BMfecha = '20040714 09:26:45.216'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CLIENTE'
end -- if 
commit 
go
print 'SRoles fila: 26 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'COMPRADOR'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'COMPRADOR', 'Comprador', '20040625 15:34:24.906',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Comprador'
,   BMfecha = '20040625 15:34:24.906'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'COMPRADOR'
end -- if 
commit 
go
print 'SRoles fila: 27 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CONS_SIST'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CONS_SIST', 'CONSULTA USUARIO DE SISTEMAS', '20100126 16:12:39.863',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'CONSULTA USUARIO DE SISTEMAS'
,   BMfecha = '20100126 16:12:39.863'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CONS_SIST'
end -- if 
commit 
go
print 'SRoles fila: 28 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CPCnsFis'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CPCnsFis', 'Consultas Fiscales Cuentas por Pagar', '20070114 09:06:46.336',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Fiscales Cuentas por Pagar'
,   BMfecha = '20070114 09:06:46.336'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CPCnsFis'
end -- if 
commit 
go
print 'SRoles fila: 29 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CPCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CPCnsRpt', 'Consultas y Generación de reportes Cuentas por Pagar', '20070114 12:30:31.950',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Cuentas por Pagar'
,   BMfecha = '20070114 12:30:31.950'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CPCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 30 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CPConsGrl'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CPConsGrl', 'Consultas Generales Cuentas por Pagar', '20070114 11:35:56.413',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Cuentas por Pagar'
,   BMfecha = '20070114 11:35:56.413'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CPConsGrl'
end -- if 
commit 
go
print 'SRoles fila: 31 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'CPOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'CPOperador', 'Operador de Cuentas por Pagar', '20070113 17:15:33.763',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Cuentas por Pagar'
,   BMfecha = '20070113 17:15:33.763'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'CPOperador'
end -- if 
commit 
go
print 'SRoles fila: 32 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'Cajeros'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'Cajeros', 'Cajeros', '20090207 15:09:44.656',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Cajeros'
,   BMfecha = '20090207 15:09:44.656'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'Cajeros'
end -- if 
commit 
go
print 'SRoles fila: 33 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'Cons_GastE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'Cons_GastE', 'Consultas', '20080812 11:46:02.153',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas'
,   BMfecha = '20080812 11:46:02.153'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'Cons_GastE'
end -- if 
commit 
go
print 'SRoles fila: 34 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'Custodio'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'Custodio', 'Custodio de Caja Chica', '20090225 15:28:36.686',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Custodio de Caja Chica'
,   BMfecha = '20090225 15:28:36.686'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'Custodio'
end -- if 
commit 
go
print 'SRoles fila: 35 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'GERE_CONTA'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'GERE_CONTA', 'Gerente de Contabilidad', '20050818 10:06:55.030',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Gerente de Contabilidad'
,   BMfecha = '20050818 10:06:55.030'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'GERE_CONTA'
end -- if 
commit 
go
print 'SRoles fila: 36 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'IMPINT'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'IMPINT', 'Importador de Interfaces', '20070706 10:10:35.843',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Importador de Interfaces'
,   BMfecha = '20070706 10:10:35.843'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'IMPINT'
end -- if 
commit 
go
print 'SRoles fila: 37 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INTConsult'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INTConsult', 'Consulta de Interfaces con sistemas externos', '20070114 11:21:20.720',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consulta de Interfaces con sistemas externos'
,   BMfecha = '20070114 11:21:20.720'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INTConsult'
end -- if 
commit 
go
print 'SRoles fila: 38 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INTERFASES'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INTERFASES', 'Administrador de Interfases', '20050829 16:06:43.446',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Interfases'
,   BMfecha = '20050829 16:06:43.446'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INTERFASES'
end -- if 
commit 
go
print 'SRoles fila: 39 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INTOperad'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INTOperad', 'Operador de Interfaces con sistemas externos', '20070114 11:22:49.356',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Interfaces con sistemas externos'
,   BMfecha = '20070114 11:22:49.356'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INTOperad'
end -- if 
commit 
go
print 'SRoles fila: 40 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INVCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INVCnsRpt', 'Consultas y Generación de reportes Inventarios', '20070114 13:12:59.773',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Inventarios'
,   BMfecha = '20070114 13:12:59.773'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INVCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 41 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INVConsGrl'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INVConsGrl', 'Consultas Generales Inventarios', '20070114 11:43:12.230',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Inventarios'
,   BMfecha = '20070114 11:43:12.230'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INVConsGrl'
end -- if 
commit 
go
print 'SRoles fila: 42 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'INVOperad'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'INVOperad', 'Operador de Inventarios', '20070116 08:24:17.306',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Inventarios'
,   BMfecha = '20070116 08:24:17.306'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'INVOperad'
end -- if 
commit 
go
print 'SRoles fila: 43 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'MBCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'MBCnsRpt', 'Consultas y Generación de reportes Bancos', '20070114 13:23:11.733',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Bancos'
,   BMfecha = '20070114 13:23:11.733'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'MBCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 44 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'MBConsGrl'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'MBConsGrl', 'Consultas Generales Bancos', '20070114 13:25:19.483',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas Generales Bancos'
,   BMfecha = '20070114 13:25:19.483'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'MBConsGrl'
end -- if 
commit 
go
print 'SRoles fila: 45 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'MBOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'MBOperador', 'Operador Bancos', '20070114 10:30:08.836',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador Bancos'
,   BMfecha = '20070114 10:30:08.836'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'MBOperador'
end -- if 
commit 
go
print 'SRoles fila: 46 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'OCOperador'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'OCOperador', 'Operador de Ordenes Comerciales en Tránsito', '20070114 13:02:53.766',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Ordenes Comerciales en Tránsito'
,   BMfecha = '20070114 13:02:53.766'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'OCOperador'
end -- if 
commit 
go
print 'SRoles fila: 47 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'OPER_CONTA'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'OPER_CONTA', 'Analista de Contabilidad', '20050721 11:56:33.810',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Analista de Contabilidad'
,   BMfecha = '20050721 11:56:33.810'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'OPER_CONTA'
end -- if 
commit 
go
print 'SRoles fila: 48 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'PMI'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'PMI', 'PMI Interfaces', '20070122 14:02:20.920',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'PMI Interfaces'
,   BMfecha = '20070122 14:02:20.920'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'PMI'
end -- if 
commit 
go
print 'SRoles fila: 49 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'PROVEEDOR'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'PROVEEDOR', 'Socio de Negocios / Proveedor', '20040714 09:27:01.076',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Socio de Negocios / Proveedor'
,   BMfecha = '20040714 09:27:01.076'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'PROVEEDOR'
end -- if 
commit 
go
print 'SRoles fila: 50 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'RolNuevo'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'RolNuevo', 'Para Prueba GAFH', '20110404 14:47:30.633',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Para Prueba GAFH'
,   BMfecha = '20110404 14:47:30.633'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'RolNuevo'
end -- if 
commit 
go
print 'SRoles fila: 51 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'SALDOSCONT'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'SALDOSCONT', 'CONSULTAS SALDOS CONTABLES', '20100415 08:53:18.476',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'CONSULTAS SALDOS CONTABLES'
,   BMfecha = '20100415 08:53:18.476'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'SALDOSCONT'
end -- if 
commit 
go
print 'SRoles fila: 52 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'SLiq_GastE'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'SLiq_GastE', 'Solicitante de Liquidación', '20080812 11:43:40.343',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante de Liquidación'
,   BMfecha = '20080812 11:43:40.343'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'SLiq_GastE'
end -- if 
commit 
go
print 'SRoles fila: 53 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'SOLIC'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'SOLIC', 'Solicitante de Compras', '20040628 11:21:32.376',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante de Compras'
,   BMfecha = '20040628 11:21:32.376'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'SOLIC'
end -- if 
commit 
go
print 'SRoles fila: 54 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'Soporte'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'Soporte', 'Soporte de aplicación', '20080512 12:43:54.013',
  1, 1)
end else begin 
update SRoles
set SRdescripcion = 'Soporte de aplicación'
,   BMfecha = '20080512 12:43:54.013'
,   BMUsucodigo = 1
,   SRinterno = 1
where SScodigo = 'SIF'  and SRcodigo = 'Soporte'
end -- if 
commit 
go
print 'SRoles fila: 55 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TESCnsRpt'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TESCnsRpt', 'Consultas y Generación de reportes Tesorería', '20070114 13:07:37.330',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Consultas y Generación de reportes Tesorería'
,   BMfecha = '20070114 13:07:37.330'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TESCnsRpt'
end -- if 
commit 
go
print 'SRoles fila: 56 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TESOperad'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TESOperad', 'Operador de Tesorería', '20070114 10:48:27.823',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Operador de Tesorería'
,   BMfecha = '20070114 10:48:27.823'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TESOperad'
end -- if 
commit 
go
print 'SRoles fila: 57 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TESSuperv'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TESSuperv', 'Supervisor Tesorería', '20070114 10:39:31.120',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Supervisor Tesorería'
,   BMfecha = '20070114 10:39:31.120'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TESSuperv'
end -- if 
commit 
go
print 'SRoles fila: 58 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TES_ADM'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TES_ADM', 'Administrador de Tesorería', '20050709 16:27:58.003',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Tesorería'
,   BMfecha = '20050709 16:27:58.003'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TES_ADM'
end -- if 
commit 
go
print 'SRoles fila: 59 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TES_OP'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TES_OP', 'Administrador de Pagos en Tesorería', '20050709 16:32:19.263',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Administrador de Pagos en Tesorería'
,   BMfecha = '20050709 16:32:19.263'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TES_OP'
end -- if 
commit 
go
print 'SRoles fila: 60 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TES_SP'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TES_SP', 'Solicitante Empresarial de Pagos a Tesorería', '20050709 16:33:12.873',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Solicitante Empresarial de Pagos a Tesorería'
,   BMfecha = '20050709 16:33:12.873'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TES_SP'
end -- if 
commit 
go
print 'SRoles fila: 61 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TES_SPA'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TES_SPA', 'Aprobador Empresarial de Pagos a Tesorería', '20050709 16:51:36.843',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Aprobador Empresarial de Pagos a Tesorería'
,   BMfecha = '20050709 16:51:36.843'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TES_SPA'
end -- if 
commit 
go
print 'SRoles fila: 62 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TR_Planif'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TR_Planif', 'Autorizadores Traslados Planificacion', '20100901 11:18:58.170',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Autorizadores Traslados Planificacion'
,   BMfecha = '20100901 11:18:58.170'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TR_Planif'
end -- if 
commit 
go
print 'SRoles fila: 63 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TR_Presup'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TR_Presup', 'Autorizadores Tralados Presupuesto', '20100901 11:19:19.376',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Autorizadores Tralados Presupuesto'
,   BMfecha = '20100901 11:19:19.376'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TR_Presup'
end -- if 
commit 
go
print 'SRoles fila: 64 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TR_PrgmAdm'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TR_PrgmAdm', 'Autorizadores Traslados Administracion', '20100901 11:17:28.063',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Autorizadores Traslados Administracion'
,   BMfecha = '20100901 11:17:28.063'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TR_PrgmAdm'
end -- if 
commit 
go
print 'SRoles fila: 65 de 65'
declare @n int 
begin tran
select @n = count(1)
from SRoles 
where SScodigo = 'SIF'  and SRcodigo = 'TR_PrgmDoc'if (@n = 0) begin
insert into SRoles (
SScodigo, SRcodigo, SRdescripcion, BMfecha,
  BMUsucodigo, SRinterno)
values (
  'SIF', 'TR_PrgmDoc', 'Autorizadores Traslados Docencia', '20100901 11:20:29.546',
  1, 0)
end else begin 
update SRoles
set SRdescripcion = 'Autorizadores Traslados Docencia'
,   BMfecha = '20100901 11:20:29.546'
,   BMUsucodigo = 1
,   SRinterno = 0
where SScodigo = 'SIF'  and SRcodigo = 'TR_PrgmDoc'
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
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'if (@n = 0) begin
insert into SProcesos (
SScodigo, SMcodigo, SPcodigo, SPdescripcion,
  SPhomeuri, SPmenu, BMfecha, BMUsucodigo,
  SPorden, SPhablada, SPlogo, SPanonimo,
  SPpublico, SPinterno)
values (
  'SIF', 'TCE', 'TCEestCta', 'Registro Estados de Cuenta TCE',
  '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm', 1, '20110722 11:17:42.106', 1,
  null, ' ', null, 0,
  0, 0)
end else begin 
update SProcesos
set SPdescripcion = 'Registro Estados de Cuenta TCE'
,   SPhomeuri = '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm'
,   SPmenu = 1
,   BMfecha = '20110722 11:17:42.106'
,   BMUsucodigo = 1
,   SPorden = null
,   SPhablada = ' '
,   SPlogo = null
,   SPanonimo = 0
,   SPpublico = 0
,   SPinterno = 0
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'
end -- if 
commit 
go

print 'Terminado SProcesos'

print 'Actualizar SProcesosRol (update/insert)...'

print 'Terminado SProcesosRol'

print 'Actualizar SComponentes (update/insert)...'
print 'SComponentes fila: 1 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasMasivoTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasMasivoTCE.cfm',
  'P', 0, '20110830 14:18:57.686', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110830 14:18:57.686'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasMasivoTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 2 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE-frame.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE-frame.cfm',
  'P', 0, '20110725 10:51:52.490', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110725 10:51:52.490'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE-frame.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 3 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfm',
  'P', 0, '20110725 11:05:33.490', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110725 11:05:33.490'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 4 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfr'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfr',
  'P', 0, '20110725 11:05:57.726', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110725 11:05:57.726'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfr'
end -- if 
commit 
go
print 'SComponentes fila: 5 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/TCERPRegistroEstadosCtasMasivo-frame.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/TCERPRegistroEstadosCtasMasivo-frame.cfm',
  'P', 0, '20110830 14:23:29.996', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110830 14:23:29.996'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/Reportes/TCERPRegistroEstadosCtasMasivo-frame.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 6 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/EstadosCuentaTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/EstadosCuentaTCE.cfm',
  'P', 0, '20110722 16:51:35.200', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110722 16:51:35.200'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/EstadosCuentaTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 7 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/ImportarECarchivoTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/ImportarECarchivoTCE.cfm',
  'P', 0, '20110725 09:20:35.976', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110725 09:20:35.976'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/ImportarECarchivoTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 8 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/SQLEstadosCuentaTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/SQLEstadosCuentaTCE.cfm',
  'P', 0, '20110808 16:12:24.910', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110808 16:12:24.910'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/SQLEstadosCuentaTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 9 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/formEstadosCuentaTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/formEstadosCuentaTCE.cfm',
  'P', 0, '20110722 16:52:01.223', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110722 16:52:01.223'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/formEstadosCuentaTCE.cfm'
end -- if 
commit 
go
print 'SComponentes fila: 10 de 10'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm'if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm',
  'P', 0, '20110722 11:17:42.136', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20110722 11:17:42.136'
,   BMUsucodigo = 1
where SScodigo = 'SIF'  and SMcodigo = 'TCE'  and SPcodigo = 'TCEestCta'  and SCuri = '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm'
end -- if 
commit 
go

print 'Terminado SComponentes'

print 'Actualizar SMenues (update/insert)...'
print 'SMenues fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SMenues 
where SMNcodigo = 14122if (@n = 0) begin
insert into SMenues (
SScodigo, SMcodigo, SMNcodigo, SMNcodigoPadre,
  SMNnivel, SMNpath, SMNtipo, SPcodigo,
  SMNtipoMenu, SMNtitulo, SMNexplicativo, SMNorden,
  SMNimagenGrande, SMNimagenPequena, SMNenConstruccion, SMNcolumna,
  opcionprin, siempreabierto, BMUsucodigo)
values (
  'SIF', 'TCE', 14122, 14117,
  2, '000|001|001', 'P', 'TCEestCta',
  null, null, null, 1,
  null, null, 0, 1,
  null, null, null)
end else begin 
update SMenues
set SScodigo = 'SIF'
,   SMcodigo = 'TCE'
,   SMNcodigoPadre = 14117
,   SMNnivel = 2
,   SMNpath = '000|001|001'
,   SMNtipo = 'P'
,   SPcodigo = 'TCEestCta'
,   SMNtipoMenu = null
,   SMNtitulo = null
,   SMNexplicativo = null
,   SMNorden = 1
,   SMNimagenGrande = null
,   SMNimagenPequena = null
,   SMNenConstruccion = 0
,   SMNcolumna = 1
,   opcionprin = null
,   siempreabierto = null
,   BMUsucodigo = null
where SMNcodigo = 14122
end -- if 
commit 
go

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



insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasMasivoTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE-frame.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/RPRegistroEstadosCtasTCE.cfr')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/Reportes/TCERPRegistroEstadosCtasMasivo-frame.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/EstadosCuentaTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/ImportarECarchivoTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/SQLEstadosCuentaTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/formEstadosCuentaTCE.cfm')

go


insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta', '/sif/tce/operaciones/listaEstadosCuentaTCE.cfm')

go


delete from SComponentes
where 1=1
		 and SScodigo = 'SIF'
		 and SMcodigo = 'TCE'
		 and SPcodigo = 'TCEestCta'
		 
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SComponentes.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SComponentes.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SComponentes.SPcodigo)
	  and TMPDATA_IMPORT.SCuri = rtrim(SComponentes.SCuri))

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


insert INTO TMPDATA_IMPORT values (14122)

go


delete from SMenues
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
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
  and ((SSorigen = 'SIF' and SMorigen = 'TCE' and SPorigen = 'TCEestCta')
   or (SSdestino = 'SIF' and SMdestino = 'TCE' and SPdestino = 'TCEestCta'))
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SSorigen = rtrim(SProcesoRelacionado.SSorigen)
	  and TMPDATA_IMPORT.SMorigen = rtrim(SProcesoRelacionado.SMorigen)
	  and TMPDATA_IMPORT.SPorigen = rtrim(SProcesoRelacionado.SPorigen)
	  and TMPDATA_IMPORT.SSdestino = rtrim(SProcesoRelacionado.SSdestino)
	  and TMPDATA_IMPORT.SMdestino = rtrim(SProcesoRelacionado.SMdestino)
	  and TMPDATA_IMPORT.SPdestino = rtrim(SProcesoRelacionado.SPdestino)
  )

go


print 'SProcesoRelacionado eliminados'

drop table TMPDATA_IMPORT

go


-- Eliminar procesos rol que no van

print 'Eliminar procesos que no van'


go


    create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SRcodigo char(10) not null,
      SMcodigo char(10) not null,
      SPcodigo char(10) not null)
    
go

    create table TMPDATA_IMPORTROL (
      SScodigo char(10) not null,
      SRcodigo char(10) not null)
    
go




insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM_CAT')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM_GastoE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM_PRES')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM_PROY')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ADM_SIST')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ANAL_CONTA')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ANOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ANSuperv')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'A_DESA')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'AdminCons')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'Ant_GastoE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'ApLiq_GasE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'B2B_ALL')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CCCnsFis')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CCCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CCConsGrl')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CCH1')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CCOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CGCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CGConsGrl')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CGOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CGSuperv')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CGTCOperad')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CLIENTE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'COMPRADOR')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CONS_SIST')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CPCnsFis')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CPCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CPConsGrl')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'CPOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'Cajeros')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'Cons_GastE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'Custodio')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'GERE_CONTA')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'IMPINT')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INTConsult')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INTERFASES')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INTOperad')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INVCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INVConsGrl')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'INVOperad')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'MBCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'MBConsGrl')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'MBOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'OCOperador')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'OPER_CONTA')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'PMI')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'PROVEEDOR')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'RolNuevo')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'SALDOSCONT')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'SLiq_GastE')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'SOLIC')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'Soporte')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TESCnsRpt')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TESOperad')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TESSuperv')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TES_ADM')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TES_OP')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TES_SP')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TES_SPA')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TR_Planif')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TR_Presup')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TR_PrgmAdm')

go


insert INTO TMPDATA_IMPORTROL values ('SIF', 'TR_PrgmDoc')

go


delete from SProcesosRol
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SProcesosRol.SScodigo)
	  and TMPDATA_IMPORT.SRcodigo = rtrim(SProcesosRol.SRcodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SProcesosRol.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SProcesosRol.SPcodigo))
  and exists (select * from TMPDATA_IMPORTROL
	where TMPDATA_IMPORTROL.SScodigo = rtrim(SProcesosRol.SScodigo)
	  and TMPDATA_IMPORTROL.SRcodigo = rtrim(SProcesosRol.SRcodigo))

go


print 'SProcesosRol eliminados'

delete from UsuarioProceso
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(UsuarioProceso.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(UsuarioProceso.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(UsuarioProceso.SPcodigo))

go


print 'UsuarioProceso eliminados'

delete from SShortcut
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SShortcut.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SShortcut.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SShortcut.SPcodigo))

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
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo)))

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
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo)))

go


print 'SRelacionado/id_hijo eliminados'

delete from SMenuItem
where SScodigo is not null
  and SMcodigo is not null
  and SPcodigo is not null
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SMenuItem.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SMenuItem.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SMenuItem.SPcodigo))

go


print 'SMenuItem eliminados'

drop table TMPDATA_IMPORT

go



    create table TMPDATA_IMPORT (
      SScodigo char(10) not null,
      SMcodigo char(10) not null,
      SPcodigo char(10) not null)
    
go



insert INTO TMPDATA_IMPORT values ('SIF', 'TCE', 'TCEestCta')

go


delete from SProcesos
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'
  and not exists (select * from TMPDATA_IMPORT
	where TMPDATA_IMPORT.SScodigo = rtrim(SProcesos.SScodigo)
	  and TMPDATA_IMPORT.SMcodigo = rtrim(SProcesos.SMcodigo)
	  and TMPDATA_IMPORT.SPcodigo = rtrim(SProcesos.SPcodigo))

go


print 'SProcesos eliminados'

drop table TMPDATA_IMPORT

go

drop table TMPDATA_IMPORTROL

go





print 'Regenerando vUsuarioProcesos'


go


delete from vUsuarioProcesos
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'

go

insert INTO vUsuarioProcesos (Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo)
select Usucodigo, Ecodigo, SScodigo, SMcodigo, SPcodigo
from vUsuarioProcesosCalc
where 1=1
  and SScodigo = 'SIF'
  and SMcodigo = 'TCE'
  and SPcodigo = 'TCEestCta'

go



while @@trancount > 0 begin
	select 'cerrando transaccion ', @@trancount 
	commit tran
end

go




print 'Importacion finalizada. A continuacion la cuenta de los registros'


go



select 'Politicas            ' as tipo, count(1) as real, 60 as esperado
from PLista

go



select 'Sistemas             ' as tipo, count(1) as real, 1 as esperado
from SSistemas
where SScodigo = 'SIF'


go


select 'Modulos              ' as tipo, count(1) as real, 1 as esperado
from SModulos
where SScodigo = 'SIF'
and SMcodigo = 'TCE'


go


select 'Procesos             ' as tipo, count(1) as real, 1 as esperado
from SProcesos
where SScodigo = 'SIF'
and SMcodigo = 'TCE'
and SPcodigo = 'TCEestCta'


go


select 'Componentes          ' as tipo, count(1) as real, 10 as esperado
from SComponentes
where SScodigo = 'SIF'
and SMcodigo = 'TCE'
and SPcodigo = 'TCEestCta'


go


select 'Roles                ' as tipo, count(1) as real, 65 as esperado
from SRoles
where SScodigo = 'SIF'


go


select 'ProcesosRol          ' as tipo, count(1) as real, 0 as esperado
from SProcesosRol
where SScodigo = 'SIF'
and SMcodigo = 'TCE'
and SPcodigo = 'TCEestCta'


go


select 'Menues               ' as tipo, count(1) as real, 1 as esperado
from SMenues
where SScodigo = 'SIF'
and SMcodigo = 'TCE'
and SPcodigo = 'TCEestCta'


go


select 'SProcesoRelacionado  ' as tipo, count(1) as real, 0 as esperado
from SProcesoRelacionado 
where (SSorigen = 'SIF' and SMorigen = 'TCE' and SPorigen = 'TCEestCta')
   or (SSdestino = 'SIF' and SMdestino = 'TCE' and SPdestino = 'TCEestCta')


go


-- Fin de archivo
