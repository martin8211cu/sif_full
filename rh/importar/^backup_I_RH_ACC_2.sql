---  Graba el Detalle de la Accion

---- Verifica que NO exista ese componente en la accion

declare @check1 int


select @check1 = count(1) 

from  #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e,
        RHDAcciones f
		
where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid and
        f.CSid = b.CSid

		
---- Verifica que exista la accion en las fechas comprendidas
		
declare @check2 int

select @check2 = count(1) 

from
       #table_name# a, 
       RHAcciones c,
       DatosEmpleado d,
       RHTipoAccion e
		
where 
       a.cedula = d.DEidentificacion and
       a.tipo_accion  = e.RHTcodigo and
       a.desde = c.DLfvigencia and
       a.hasta = c.DLffin and		
       d.DEid = c.DEid and
       e.RHTid = c.RHTid 		
		
		
if ( (@check1 < 1) and   (@check2 >= 1)  )
		


insert RHDAcciones
         (Usucodigo, Ulocalizacion, RHAlinea, CSid, RHDAtabla, 
         RHDAunidad, RHDAmontobase, RHDAmontores) 

select 
         @Usucodigo, @Ulocalizacion, RHAlinea, CSid, null, 1, 
         monto, monto
		
from 
        #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e

where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid
		
else
begin

if ( @check1 >= 1) 

select 
         'Datos ya existen', cedula, tipo_accion, componente, 
        desde, hasta

from  
        #table_name# a, 
        ComponentesSalariales b, 
        RHAcciones c,
        DatosEmpleado d,
        RHTipoAccion e,
        RHDAcciones f
		
where 
        a.cedula = d.DEidentificacion and
        a.tipo_accion  = e.RHTcodigo and
        a.componente = b.CScodigo and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin and
        d.DEid = c.DEid and
        e.RHTid = c.RHTid and
        f.CSid = b.CSid		
		
if ( @check2 < 1)

select 'La Acción NO existe en esas fechas', 
         cedula, tipo_accion, componente, desde, hasta

from
        #table_name#

end