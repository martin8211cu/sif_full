declare @check1 numeric,  @check2 numeric,
@check3 numeric, @check4 numeric

select @check1 = count(1)
from #table_name# a
where not exists ( select 1 from DatosEmpleado b
                   where 
                     a.cedula = b.DEidentificacion 
	     and  b.Ecodigo = @Ecodigo
)


select @check2 = count(distinct incidencia)
from #table_name# a
group by cedula,  incidencia

select @check3 = count(distinct salario_base) 
from #table_name#
group by cedula

select @check4 = count(1) 
from #table_name# a
where not exists ( select 1 from CIncidentes b
                           where b.Ecodigo = @Ecodigo
                           and a.incidencia = b.CIcodigo
)


if (@check1 = 0 and @check2 = 1  and @check3 = 1 and @check4 = 0)
begin

insert RHComisiones
  (CPid, DEid, Ecodigo, DEidentificacion, RHCmontobase, RHCmontocomision, 
Usucodigo, fechaalta)
  select CPid, DEid, @Ecodigo, cedula, salario_base, comision, @Usucodigo, 
getdate()
  from #table_name# a,  DatosEmpleado b, CalendarioPagos c
  where
	a.cedula = b.DEidentificacion 
	and a.nomina = c.Tcodigo
	and a.fecha_pago = c.CPfpago

  insert RHComisionesDetalle
	(CPid, DEid, CIid, CIcodigo, RHCDmontocomision, Usucodigo, fechaalta)
  select CPid, DEid, CIid, incidencia, comision, @Usucodigo, getdate()
  from #table_name# a,  DatosEmpleado b, CalendarioPagos c, CIncidentes d
  where
	a.cedula = b.DEidentificacion 
	and a.nomina = c.Tcodigo
	and a.fecha_pago = c.CPfpago
	and a.incidencia = d.CIcodigo
	and d.Ecodigo = @Ecodigo

end

else
begin

  if (@check1 > 0 )
    select 'El empleado no existe', cedula 
from #table_name# a
where not exists ( select 1 from DatosEmpleado b
                   where 
                     a.cedula = b.DEidentificacion 
	     and  b.Ecodigo = @Ecodigo
)

  if (@check2 != 1)  
    select 'Existen incidencias repetidas'  , incidencia
    from #table_name# a, DatosEmpleado b
    where 
        	a.cedula = b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo
    group by DEidentificacion,  incidencia


  if (@check3 != 1)

  select 'Existen salarios base diferentes' , salario_base
  from #table_name# a, DatosEmpleado b
  where
        	a.cedula = b.DEidentificacion 
	and  b.Ecodigo = @Ecodigo

  if (@check4 > 0)
    select 'No Existen Incidencia'  , incidencia, cedula
    from #table_name# a
    where not exists ( select 1 from CIncidentes b
                           where b.Ecodigo = @Ecodigo
                           and a.incidencia = b.CIcodigo
    )
end
