declare @check1 int

select 
         @check1 = count(1) 
from  
         #table_name# a, DatosEmpleado b, RHAcciones c, 
         RHTipoAccion d

where 
        a.cedula = b.DEidentificacion and
        b.DEid = c.DEid and
        a.tipo_accion  = d.RHTcodigo and
        c.RHTid = d.RHTid and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin  and
        c.Ecodigo  = @Ecodigo


if (@check1 < 1)


insert RHAcciones 
           (DEid,RHTid,Ecodigo,Tcodigo, RVid, RHJid, RHTCid, 
            Dcodigo, Ocodigo, RHPid, RHPcodigo, DLfvigencia, 
            DLffin, DLsalario, DLobs, Usucodigo, Ulocalizacion,
            RHAporc, RHAporcsal, RHAidtramite, RHAvdisf, 
            RHAvcomp, IEid ,TEid )

select   DEid, RHTid, @Ecodigo, nomina, RVid, RHJid, e.RHTCid, 
           departamento, oficina, RHPid, puesto, desde, hasta, 
           salario, descripcion, @Usucodigo, @Ulocalizacion, 
           porc_plaza, porc_salario, null, disfrutados, compensados,
           null, null
                             
from    #table_name# a, RegimenVacaciones b, RHJornadas c, 
           RHPlazas d, RHCategoriasTipoTabla e, 
           RHTTablaSalarial f, RHTipoAccion g, DatosEmpleado h

where 
          a.cedula = h.DEidentificacion and
          a.tipo_accion  = g.RHTcodigo and
          a.regimen = b.RVcodigo and
          a.jornada  = c.RHJcodigo and
          a.plaza  = d.RHPcodigo and
          a.tabla_salarial  = f.RHTTcodigo and
          e.RHTTid  = f.RHTTid and
          e.RHMCcodigo  = a.categoria and
          e.RHMCpaso  = a.paso and
          f.Ecodigo  = @Ecodigo
        
else 

select 'Datos ya existen', c.DEid,  c.RHTid, DLfvigencia, DLffin , c.Ecodigo 

from         
		#table_name# a, DatosEmpleado b, RHAcciones c, RHTipoAccion d
		
where 
        a.cedula = b.DEidentificacion and
        b.DEid = c.DEid and
        a.tipo_accion  = d.RHTcodigo and
        c.RHTid = d.RHTid and
        a.desde = c.DLfvigencia and
        a.hasta = c.DLffin  and
        c.Ecodigo  = @Ecodigo