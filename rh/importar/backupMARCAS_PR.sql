declare @check1 numeric, @Dcodigo numeric, @Ocodigo numeric, @RHPMid numeric, @RHPMfproceso datetime

-- Chequear existencia de Tarjetas Correctas
select @check1 = count(1)
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where b.DEtarjeta = a.Tarjeta
and b.Ecodigo = @Ecodigo
)

if @check1 < 1 begin

select @Dcodigo = min(Dcodigo) 
from Departamentos
where Ecodigo = @Ecodigo

select @Ocodigo = min(Ocodigo) 
from Oficinas
where Ecodigo = @Ecodigo

insert RMarcas(Ecodigo, RHPMid, RMtiporegis, RMfecha, Dcodigo, Ocodigo, DEid, DEidentificacion, RMreloj, RMmarcaproces, BMUsucodigo, BMfecha)
select @Ecodigo, -@Ecodigo, '1', convert(varchar, convert(datetime, a.Fecha), 106) || ' ' || substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2), @Dcodigo, @Ocodigo, b.DEid, b.DEidentificacion, a.RMreloj, 0, @Usucodigo, getDate()
from #table_name# a, DatosEmpleado b
where a.Tarjeta = b.DEtarjeta
and b.Ecodigo = @Ecodigo
and convert(datetime, substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2)) < '12:00:00'

insert RMarcas(Ecodigo, RHPMid, RMtiporegis, RMfecha, Dcodigo, Ocodigo, DEid, DEidentificacion, RMreloj, RMmarcaproces, BMUsucodigo, BMfecha)
select @Ecodigo, -@Ecodigo, '2', convert(varchar, convert(datetime, a.Fecha), 106) || ' ' || substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2), @Dcodigo, @Ocodigo, b.DEid, b.DEidentificacion, a.RMreloj, 0, @Usucodigo, getDate()
from #table_name# a, DatosEmpleado b
where a.Tarjeta = b.DEtarjeta
and b.Ecodigo = @Ecodigo
and convert(datetime, substring(a.Hora, 1, 2) || ':' || substring(a.Hora, 3, 2) || ':' || substring(a.Hora, 5, 2)) >= '12:00:00'

end -- check1
else begin -- else check1

select distinct 'No existe nigún empleado con esta tarjeta, nombrado hasta la fecha' as Error, a.Tarjeta as Tarjeta
from #table_name# a
where not exists(
select 1
from DatosEmpleado b
where b.DEtarjeta = a.Tarjeta
and b.Ecodigo = @Ecodigo
)

end -- else check1