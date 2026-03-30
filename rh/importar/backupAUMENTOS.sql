declare @check1 numeric, @check2 numeric, @check3 numeric, @check4 numeric, @check5 numeric, @check6 numeric, @lote int, @llave numeric, @fechavigente datetime

-- Chequear existencia de empleado
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

if @check1 < 1 begin

-- Validar que no existan duplicados en el archivo
select @check2 = count(count(1))
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

if @check2 < 1 begin

-- Validar que no existan montos negativos en los datos a importar
select @check3 = count(1)
from #table_name#
where RHDvalor < 0.00

if @check3 < 1 begin
    
-- Validar que la fecha de vigencia del aumento sea unico en todo el archivo de importacion
select @check4 = count(distinct RHAfdesde)
from #table_name#

if @check4 = 1 begin

-- Validar que la fecha de Aumento en el Lote no haya sido registrado anteriormente para un empleado
select @check5 = count(1)
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

if @check5 < 1 begin

-- Valida que los tipos de Identificación sea válidos
select @check6 = count(1)
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

if @check6 < 1 begin

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
select @lote = isnull(max(RHAlote)+1, 1) from RHEAumentos
where Ecodigo = @Ecodigo

select @fechavigente = RHAfdesde
from #table_name#

-- Insertar Encabezado de Relación
insert RHEAumentos (Ecodigo, RHAlote, Usucodigo, RHAfecha, RHAfdesde, RHAestado, RHAusucodigo, RHAfautoriza)
values (@Ecodigo, @lote, @Usucodigo, getdate(), @fechavigente, 0, null, null)

select @llave = @@identity

-- Insertar Detalle de Relación
insert RHDAumentos (RHAid, NTIcodigo, DEidentificacion, RHDtipo, RHDvalor)
select @llave, NTIcodigo, DEidentificacion, 0, RHDvalor
from #table_name#

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end -- check6
else begin -- check6

select distinct 'Tipo de Identificación Inválido' as Error, NTIcodigo as TipoIdentificacion
from #table_name# a
where not exists(
select 1
from NTipoIdentificacion b
where b.NTIcodigo = a.NTIcodigo
)

end -- else check6

end -- check5
else begin -- check5

select distinct 'Fecha de Aumento en el Lote ya fue registrado para este empleado' as Error, a.RHAfdesde as FechaVigencia, a.DEidentificacion as Cedula
from #table_name# a
where exists(
select 1
from RHEAumentos b, RHDAumentos e
where b.RHAfdesde = a.RHAfdesde
   and e.RHAid = b.RHAid
   and e.NTIcodigo = a.NTIcodigo
   and e.DEidentificacion = a.DEidentificacion
)

end -- else check5

end -- check4
else begin -- check4

select 'No debe haber mas de una fecha vigente en el archivo de importacion' as Error, RHAfdesde as Vigencia
from #table_name#
group by RHAfdesde

end -- else check4
 
end -- check3
else begin -- check3

select 'Aumento NO puede ser negativo' as Error, DEidentificacion as Empleado, RHDvalor as Aumento
from #table_name#
where RHDvalor < 0.00

end -- else check3
 
end -- check2
else begin -- check2

select 'Empleado con mas de un Aumento Salarial' as Error, DEidentificacion as Empleado
from #table_name#
group by NTIcodigo, DEidentificacion
having count(1) > 1

end -- else check2
 
end -- check1
else begin -- check1

select distinct 'Empleado no Existe o no esta Nombrado' as Error, NTIcodigo as TipoIdentificacion, DEidentificacion as Empleado
from #table_name# a
where not exists(
select 1
from DatosEmpleado b, LineaTiempo c
where b.DEidentificacion = a.DEidentificacion
and b.NTIcodigo = a.NTIcodigo
and b.Ecodigo = @Ecodigo
and b.DEid = c.DEid
and a.RHAfdesde between c.LTdesde and c.LThasta
)

end -- else check1