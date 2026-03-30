declare @check1 int

select @check1 = count(1) 
from 
        RHPlazas d, 
        #table_name# a

where 
        d.RHPcodigo = a.codigo and
        d.Ecodigo = @Ecodigo

if (@check1 < 1)
begin

/*
  select 'Estos puestos no existen en RHPuestos',* from #table_name# a
  where not exists 
    (select 1 from RHPuestos b 
    where b.Ecodigo = @Ecodigo 
      and a.puesto = b.RHPcodigo )
*/

update #table_name# 
set descripcion = 'Plaza '||codigo||' - '||p.RHPdescpuesto
from #table_name# a, RHPuestos p
where p.Ecodigo = @Ecodigo
   and a.puesto = p.RHPcodigo
   and a.descripcion is Null


insert RHPlazas 
       (Ecodigo, RHPcodigo, RHPdescripcion, RHPpuesto, CFid, 
        Dcodigo, Ocodigo) 

select 
       @Ecodigo, codigo, descripcion, puesto, CFid, Dcodigo, Ocodigo
from 
       #table_name# a, 
       CFuncional b

where 
       a.centro_func = b.CFcodigo and 
       b.Ecodigo = @Ecodigo

end

else 

select 
       'Datos ya existen', RHPcodigo, RHPdescripcion, RHPpuesto

from 
       RHPlazas d, 
       #table_name# a

where 
       d.RHPcodigo = a.codigo and
       d.Ecodigo = @Ecodigo