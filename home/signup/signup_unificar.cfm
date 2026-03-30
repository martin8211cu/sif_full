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
<cfquery name="rsupdate" datasource="asp">

begin tran 
<!---
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
--->
if (not exists (select * from UsuarioSustituto
	where Usucodigo1 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
	  and Usucodigo2 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
	))
BEGIN
	insert UsuarioSustituto (Usucodigo1, Usucodigo2, BMUsucodigo)
	values (
		<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">,
	  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">,
	  	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
END
<!---
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
--->

delete UsuarioProceso
from UsuarioProceso old, UsuarioProceso new
where new.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
     and old.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">
	 and new.Ecodigo = old.Ecodigo
	 and new.SScodigo = old.SScodigo
	 and new.SMcodigo = old.SMcodigo
	 and new.SPcodigo = old.SPcodigo

update UsuarioReferencia
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">

update UsuarioProceso
set Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#existente.Usucodigo#">
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#">

update Usuario
set Uestado = 0
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Usucodigo#"> 

commit

</cfquery>