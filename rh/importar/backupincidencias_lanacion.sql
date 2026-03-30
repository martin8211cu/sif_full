declare @check1 int, @check2 int, @check3 int

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
     where CPcodigo is not null and CPcodigo != ''
       and CPcodigo not in (select CPcodigo from CalendarioPagos where Ecodigo = @Ecodigo and CPtipo = 1 and CPfcalculo is null)


	if @check2 < 1 begin

		select @check3 = count(1) 
		from #table_name# 
		where CFcodigo is not null and CFcodigo != ''
		  and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)

		if @check3 < 1 begin 


			-- Inserta Incidencias
		
			insert Incidencias ( DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, RCNid )
			select DEid, CIid, cf.CFid, Ifecha, Ivalor, getDate(), @Usucodigo, @Ulocalizacion, cp.CPid
			from #table_name# a, DatosEmpleado b, CIncidentes c, CFuncional cf, CalendarioPagos cp
			where a.DEidentificacion=b.DEidentificacion
			  and a.CIcodigo=c.CIcodigo 
			  and b.Ecodigo=@Ecodigo
			  and c.Ecodigo=@Ecodigo
			  and a.CFcodigo *= cf.CFcodigo
			  and cf.Ecodigo = @Ecodigo
              and a.CPcodigo *=cp.CPcodigo
              and cp.Ecodigo = @Ecodigo

			select 'Empleado no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
			where a.DEidentificacion not in ( select DEidentificacion from DatosEmpleado b where a.DEidentificacion=b.DEidentificacion )
			union
			select 'Concepto Incidente no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
			where a.CIcodigo not in ( select CIcodigo from CIncidentes c where a.CIcodigo=c.CIcodigo )
        end 
        else begin 
			 select 'Centro Funcional no existe' as Motivo, DEidentificacion, CIcodigo, Ifecha, Ivalor from #table_name# a
		  	  where CFcodigo is not  null and CFcodigo != ''
			    and CFcodigo not in (select CFcodigo from CFuncional where Ecodigo = @Ecodigo)
        end --@check3
 	end
	else begin 
  	  select 'Nomina no existe' as Motivo, DEidentificacion, CPcodigo, CIcodigo, Ifecha, Ivalor from #table_name# a
       where CPcodigo is not null and CPcodigo != ''
         and CPcodigo not in (select CPcodigo from CalendarioPagos where Ecodigo = @Ecodigo and CPtipo = 1 and CPfcalculo is null)
		
	end --@check2
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