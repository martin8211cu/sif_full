declare @check1 int

select @check1 = count(1) 

from 
        #table_name# a, 
        Departamentos b

where 
        b.Ecodigo = @Ecodigo and
        b.Deptocodigo = a.Codigo

if @check1 < 1

insert Departamentos 
         (Ecodigo,  Deptocodigo, Dcodigo, Ddescripcion)

select 
         @Ecodigo, Codigo, Numero, Descripcion 

from 
        #table_name#

else 

select 
       'Registros ya insertados' as Motivo, @Ecodigo as Empresa, 
       Codigo as Código, Descripcion as Descripción 

from 
       #table_name# a, 
       Departamentos b

where 
       b.Ecodigo = @Ecodigo and
       b.Deptocodigo = a.Codigo

order by Codigo