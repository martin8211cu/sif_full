<!--
	requiere de:
		existente - Usuario existente, activo, que va a permanecer
			existente.Usucodigo
			existente.Ulocalizacion
		data - Usuario nuevo, temporal, que se va a inactivar
			data.Usucodigo
			data.Ulocalizacion			
			
	Este archivo se utiliza en DOS lugares, OJO al modificar:
		/framework/afiliacion/recibo/recibo_apply.cfm
		/framework/signup/signup3-apply.cfm
--->
<cfquery name="rsupdate" datasource="SDC">

begin tran 

insert UsuarioBitacora 
(Usucodigo, Ulocalizacion, UBtipo, UBumod, UBdata)
values (
	<cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
	<cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">,
	'unir', <cfqueryparam cfsqltype="cf_sql_char" value="#session.usuario#">,
	'Los permisos del usuario '
	|| convert (varchar, <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#"> )
	|| 'se incorporan al usuario '
	|| convert (varchar, <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">) )

if (not exists (select * from UsuarioSustituto
	where CodOrigen = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
	  and LocOrigen = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
	  and CodNuevo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
	  and LocNuevo = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
	))
BEGIN
	insert UsuarioSustituto (CodOrigen, LocOrigen, CodNuevo, LocNuevo)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">,
		<cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">,
	  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
	  	<cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">)
END

update UsuarioBitacora
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
     Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">

update Buzon
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
     Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">

update ContratoAdhesion
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
     Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
         and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
            
delete CalendarioSuscripcion
from CalendarioSuscripcion old, CalendarioSuscripcion new
where new.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
     and new.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
     and old.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
     and old.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
     and new.Ccodigo = old.Ccodigo

update CalendarioSuscripcion
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
     Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">

insert UsuarioEmpresarial (
    Usucodigo, Ulocalizacion, cliente_empresarial, admin,
    Pnombre, Papellido1, Papellido2, Ppais,
    TIcodigo, Pid, Pnacimiento, Psexo,
    Pemail1, Pemail2, Pdireccion, Pcasa,
    Poficina, Pcelular, Pfax, Ppagertel,
    Ppagernum, Pfoto, PfotoType, PfotoName,
    activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod)
select
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
	<cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">,
	cliente_empresarial, admin,
    Pnombre, Papellido1, Papellido2, Ppais,
    TIcodigo, Pid, Pnacimiento, Psexo,
    Pemail1, Pemail2, Pdireccion, Pcasa,
    Poficina, Pcelular, Pfax, Ppagertel,
    Ppagernum, Pfoto, PfotoType, PfotoName,
    activo, BMUsucodigo, BMUlocalizacion, BMUsulogin, BMfechamod
from UsuarioEmpresarial a
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
  and not exists (select 1 from UsuarioEmpresarial b
where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
  and b.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
  and b.cliente_empresarial = a.cliente_empresarial)

insert UsuarioEmpresa (
    Usucodigo, Ulocalizacion, cliente_empresarial, Ecodigo,
    activo, BMUsucodigo, BMUlocalizacion, BMfechamod)
select
    <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
	<cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">, cliente_empresarial, Ecodigo,
    activo, BMUsucodigo, BMUlocalizacion, BMfechamod
from UsuarioEmpresa a
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
  and not exists (select 1 from UsuarioEmpresa b
where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
  and b.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
  and b.cliente_empresarial = a.cliente_empresarial
  and b.Ecodigo = a.Ecodigo)

delete UsuarioPermiso
from UsuarioPermiso old, UsuarioPermiso new
where new.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
     and new.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
     and old.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
     and old.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
	 and isnull(new.Ecodigo, -1) = isnull(old.Ecodigo, -1)
	 and new.rol = old.rol
	 and new.num_referencia = old.num_referencia
	 and new.int_referencia = old.int_referencia

update UsuarioPermiso
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
     Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#existente.Ulocalizacion#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">

delete UsuarioEmpresa
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
 
delete UsuarioEmpresarial
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#">
 
update Usuario
set activo = 0
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#"> 
   and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#data.Ulocalizacion#"> 

commit

</cfquery>