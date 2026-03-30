declare @check1 int

select @check1 = count(1) 

from 
        #table_name# a, 
        Oficinas b

where 
        b.Ecodigo = @Ecodigo and 
        b.Oficodigo = a.Codigo

if (@check1 < 1)

insert Oficinas 
        (Ecodigo, Ocodigo, Oficodigo, Odescripcion)

select 
        @Ecodigo, Numero, Codigo, Descripcion 

from 
       #table_name#


else

select 
        'Registros ya insertados' as Motivo, @Ecodigo as Empresa,
        Numero as OCodigo, Codigo as Oficodigo, Descripcion as Descripción 

from 
        #table_name# a, Oficinas b

where 
        b.Ecodigo = @Ecodigo and
        b.Oficodigo = a.Codigo

order by Codigo