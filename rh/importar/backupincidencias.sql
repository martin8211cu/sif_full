declare @check1 int, @check2 int

select @check1 = count(1)
from #table_name# a, DatosEmpleado b, CIncidentes c, Incidencias d
where a.DEidentificacion=b.DEidentificacion
  and a.CIcodigo=c.CIcodigo 
  and b.DEid=d.DEid
  and c.CIid=d.CIid
  and a.Ifecha=d.Ifecha
  and b.Ecodigo=@Ecodigo
  and c.Ecodigo=@Ecodigo


if @check1 < 1 begin 

	select @check2 = count(1) 
	from #table_name# 
	where (CFcodigo is not null and CFcodigo <> ' ')
	    and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)

	if @check2 < 1 begin

		-- Inserta Incidencias
	
		insert Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion )
		select DEid, CIid, cf.CFid, Ifecha, Ivalor, getDate(), @Usucodigo, @Ulocalizacion
		from #table_name# a, DatosEmpleado b, CIncidentes c, CFuncional cf
		where a.DEidentificacion=b.DEidentificacion
		  and a.CIcodigo=c.CIcodigo 
		  and b.Ecodigo=@Ecodigo
		  and c.Ecodigo=@Ecodigo
		  and a.CFcodigo *= cf.CFcodigo
		  and cf.Ecodigo = @Ecodigo

		select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
		where a.DEidentificacion not in ( select DEidentificacion from DatosEmpleado b where a.DEidentificacion=b.DEidentificacion )
		union
		select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
		where a.CIcodigo not in ( select CIcodigo from CIncidentes c where a.CIcodigo=c.CIcodigo )
	end
	else begin 
		select 'Centro Funcional no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, CFcodigo, Ivalor from #table_name# a
		where (CFcodigo is not null and CFcodigo <> ' ')
                                   and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)
	end
end
else begin
	select 'Registro ya existe' Motivo, a.DEidentificacion, a.CIcodigo, a.Ifecha, a.Ivalor
	from #table_name# a, DatosEmpleado b, CIncidentes c
	where a.DEidentificacion=b.DEidentificacion
	  and a.CIcodigo=c.CIcodigo 
	  and b.Ecodigo=@Ecodigo
	  and c.Ecodigo=@Ecodigo
	union 
	select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
	where a.DEidentificacion not in ( select DEidentificacion from DatosEmpleado b where a.DEidentificacion=b.DEidentificacion )
	union
	select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
	where a.CIcodigo not in ( select CIcodigo from CIncidentes c where a.CIcodigo=c.CIcodigo )
	order by Motivo
end
