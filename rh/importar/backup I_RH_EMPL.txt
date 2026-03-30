declare @check1 int

select @check1 = count(1) 

from 
       #table_name# a,
       DatosEmpleado d

where 
       DEidentificacion = identificacion and
       d.Ecodigo = @Ecodigo

if (@check1 < 1)

insert DatosEmpleado 
        (Ecodigo, Usucodigo, Ulocalizacion, DEnombre, 
         DEapellido1, DEapellido2, NTIcodigo, DEidentificacion, 
         DEcivil, DEfechanac, DEsexo, DEdireccion, Bid, CBcc, 
         Mcodigo, DEtelefono1, DEtelefono2, DEemail, DEtarjeta, 
         DEcantdep, DEsistema) 

select 
        @Ecodigo, @Usucodigo, @Ulocalizacion, nombre, 
        apellido1, apellido2, tipo_id, identificacion, civil, 
        fecha_nac, sexo, direccion, banco, cuenta, moneda, 
        telefono1, telefono2, correo, tarjeta, 0 , 1

from #table_name#

else 

select 
       'Datos ya existen', DEnombre, DEapellido1, DEapellido2, 
        DEidentificacion

from 
       DatosEmpleado, 
       #table_name# 

where 
       DEidentificacion = identificacion
       and Ecodigo = @Ecodigo