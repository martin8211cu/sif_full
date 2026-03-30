print 'Actualizar SProcesos (update/insert)...'
print 'SProcesos fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SProcesos 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '
if (@n = 0) begin
insert into SProcesos (
SScodigo, SMcodigo, SPcodigo, SPdescripcion,
  SPhomeuri, SPmenu, BMfecha, BMUsucodigo,
  SPorden, SPhablada, SPlogo, SPanonimo,
  SPpublico, SPinterno)
values (
  'SIF       ', 'INTERPMI  ', 'VentasOC  ', 'Reporte de Ventas por Orden Comercial',
  '/interfacesTRD/reporteoc/ventas.cfm', 1, '20070330 15:42:18.443', 1,
  420, ' ', null, 0,
  0, 0)
end else begin 
update SProcesos
set SPdescripcion = 'Reporte de Ventas por Orden Comercial'
,   SPhomeuri = '/interfacesTRD/reporteoc/ventas.cfm'
,   SPmenu = 1
,   BMfecha = '20070330 15:42:18.443'
,   BMUsucodigo = 1
,   SPorden = 420
,   SPhablada = ' '
,   SPlogo = null
,   SPanonimo = 0
,   SPpublico = 0
,   SPinterno = 0
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '

end -- if 
commit 
go

print 'Terminado SProcesos'

print 'Actualizar SProcesosRol (update/insert)...'
print 'SProcesosRol fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SProcesosRol 
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '
if (@n = 0) begin
insert into SProcesosRol (
SScodigo, SRcodigo, SMcodigo, SPcodigo,
  BMfecha, BMUsucodigo)
values (
  'SIF       ', 'ADM       ', 'INTERPMI  ', 'VentasOC  ',
  '20070330 13:40:14.080', 1)
end else begin 
update SProcesosRol
set BMfecha = '20070330 13:40:14.080'
,   BMUsucodigo = 1
where SScodigo = 'SIF       '
  and SRcodigo = 'ADM       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '

end -- if 
commit 
go

print 'Terminado SProcesosRol'

print 'Actualizar SComponentes (update/insert)...'
print 'SComponentes fila: 1 de 1'
declare @n int 
begin tran
select @n = count(1)
from SComponentes 
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '
  and SCuri = '/interfacesTRD/reporteoc/ventas.cfm'
if (@n = 0) begin
insert into SComponentes (
SScodigo, SMcodigo, SPcodigo, SCuri,
  SCtipo, SCauto, BMfecha, BMUsucodigo)
values (
  'SIF       ', 'INTERPMI  ', 'VentasOC  ', '/interfacesTRD/reporteoc/ventas.cfm',
  'P', 0, '20070330 13:27:01.437', 1)
end else begin 
update SComponentes
set SCtipo = 'P'
,   SCauto = 0
,   BMfecha = '20070330 13:27:01.437'
,   BMUsucodigo = 1
where SScodigo = 'SIF       '
  and SMcodigo = 'INTERPMI  '
  and SPcodigo = 'VentasOC  '
  and SCuri = '/interfacesTRD/reporteoc/ventas.cfm'

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
where SMNcodigo = 12677
if (@n = 0) begin
insert into SMenues (
SScodigo, SMcodigo, SMNcodigo, SMNcodigoPadre,
  SMNnivel, SMNpath, SMNtipo, SPcodigo,
  SMNtipoMenu, SMNtitulo, SMNexplicativo, SMNorden,
  SMNimagenGrande, SMNimagenPequena, SMNenConstruccion, SMNcolumna,
  opcionprin, siempreabierto)
values (
  'SIF       ', 'INTERPMI  ', 12677, 12598,
  1, '000|004', 'P', 'VentasOC  ',
  null, null, null, 4,
  null, null, 0, 1,
  null, null)
end else begin 
update SMenues
set SScodigo = 'SIF       '
,   SMcodigo = 'INTERPMI  '
,   SMNcodigoPadre = 12598
,   SMNnivel = 1
,   SMNpath = '000|004'
,   SMNtipo = 'P'
,   SPcodigo = 'VentasOC  '
,   SMNtipoMenu = null
,   SMNtitulo = null
,   SMNexplicativo = null
,   SMNorden = 4
,   SMNimagenGrande = null
,   SMNimagenPequena = null
,   SMNenConstruccion = 0
,   SMNcolumna = 1
,   opcionprin = null
,   siempreabierto = null
where SMNcodigo = 12677

end -- if 
commit 
go

