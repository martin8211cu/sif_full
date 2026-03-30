declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @lote int
 
-- Chequear que snnumero sea único
select @check1 = count(distinct snnumero)
from #table_name#
 
if @check1 = 1 begin
 
-- Chequear integridad referencial del socio y el tipo de deducción
select @check2 = count(1)
from #table_name# a
where not exists(
select 1
from SNegocios b
where a.snnumero = b.SNnumero
and b.Ecodigo = @Ecodigo
) or not exists(
select 1
from TDeduccion c
where a.tdcodigo = c.TDcodigo
and c.Ecodigo = @Ecodigo
)
 
if @check2 < 1 begin
 
-- Chequear existencia de empleado
 
select @check3 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where a.cedula = b.DEidentificacion
and b.Ecodigo = @Ecodigo
)
 
if @check3 < 1 begin
 
-- Chequear Validez de Metodo y Controla Saldo
select @check4 = count(1)
from #table_name# a
where (a.controlsaldo != 0
and a.controlsaldo != 1)
or
(a.metodo != 0
and a.metodo != 1)
 
if @check4 < 1 begin

-- Verificar si existen tipos de deducciones en el archivio que no son permitidas al usuario
select @check5 = count(1)
from #table_name# a
where not exists(
select 1
from TDeduccion b, RHUsuarioTDeduccion c
where a.tdcodigo = b.TDcodigo
and b.Ecodigo = @Ecodigo
and b.Ecodigo = c.Ecodigo
and b.TDid = c.TDid
and c.Usucodigo = @Usucodigo
)
and not exists (
select 1
from TDeduccion b
where a.tdcodigo = b.TDcodigo
and b.Ecodigo = @Ecodigo
and not exists (
   select 1 from RHUsuarioTDeduccion d where d.TDid = b.TDid and d.Ecodigo = b.Ecodigo
)
)

if @check5 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
 
   declare @TDcodigo varchar(5), @SNcodigo int, @SNnumero char(10), @TDid numeric
   select @TDcodigo = '', @lote = 0 
   -- calcula el socio de negocios
   select @SNnumero = min(snnumero) from #table_name#
   select @SNcodigo = SNcodigo from SNegocios where Ecodigo=@Ecodigo and SNnumero=@SNnumero
 

   while (1=1) begin
 
   select @TDcodigo = min(tdcodigo)
   from #table_name#
   where tdcodigo > @TDcodigo
   if @TDcodigo is null
      break
 
   select @TDid = TDid from TDeduccion 
   where Ecodigo=@Ecodigo 
     and TDcodigo=@TDcodigo
 
   select @lote = isnull(max(EIDlote)+1, 1) 
   from EIDeducciones
 
   insert into EIDeducciones(EIDlote, Ecodigo, TDid, SNcodigo, Usucodigo, Ulocalizacion, EIDfecha, EIDestado)
   values(@lote, @Ecodigo, @TDid, @SNcodigo, @Usucodigo,  @Ulocalizacion, getDate(), 0)
 
   -- detalles
   insert DIDeducciones ( EIDlote, DIDidentificacion, DIDreferencia, DIDmetodo, DIDvalor, DIDfechaini, DIDfechafin, DIDmonto, DIDcontrolsaldo)
   select @lote, cedula, referencia, metodo, valor, fechaini, fechafin, monto, controlsaldo
   from #table_name#
   where snnumero = @SNnumero
   and tdcodigo = @TDcodigo

   end
 
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>

end -- check5
else begin -- check5

select distinct 'No tiene permisos sobre este Tipo de Deducción' as Error, a.tdcodigo as Tipo_Deduccion 
from #table_name# a
where not exists(
select 1
from TDeduccion b, RHUsuarioTDeduccion c
where a.tdcodigo = b.TDcodigo
and b.Ecodigo = @Ecodigo
and b.Ecodigo = c.Ecodigo
and b.TDid = c.TDid
and c.Usucodigo = @Usucodigo
)
and not exists (
select 1
from TDeduccion b
where a.tdcodigo = b.TDcodigo
and b.Ecodigo = @Ecodigo
and not exists (
   select 1 from RHUsuarioTDeduccion d where d.TDid = b.TDid and d.Ecodigo = b.Ecodigo
)
)

end -- else check5
 
end -- check4
else begin -- check4
 
select distinct 'Metodo o Control de Saldo son incorrectos' as Error, metodo as Metodo, controlsaldo as Control_Saldo
from #table_name# a
where (a.controlsaldo != 0
and a.controlsaldo != 1)
or
(a.metodo != 0
and a.metodo != 1)
 
end -- check4
 
end -- check3
else begin -- check3
 
select distinct 'Empleado no Existe' as Error, cedula as Empleado
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where a.cedula = b.DEidentificacion
and b.Ecodigo = @Ecodigo
)
 
end -- check3
 
end -- check2
else begin -- check2
 
select distinct 'Socio o Tipo de Deducción son incorrectos.' as Error, snnumero as Socio_Negocio, tdcodigo as Tipo_Deduccion 
from #table_name# a
where not exists(
select 1
from SNegocios b
where a.snnumero = b.SNnumero
and b.Ecodigo = @Ecodigo
) or not exists(
select 1
from TDeduccion c
where a.tdcodigo = c.TDcodigo
and c.Ecodigo = @Ecodigo
)
 
end -- else check2
 
end -- check1
else begin -- check1
 
select distinct 'El archivo debe contener únicamente un número de socio de negocios' as Error, snnumero as Socio_Negocio, tdcodigo as Tipo_Deduccion 
from #table_name#
 
end -- else check1