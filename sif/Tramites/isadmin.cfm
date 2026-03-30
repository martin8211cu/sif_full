<cfquery datasource="sdc" name="isadmin_cuantos_roles">
select count(1) as cuantos
from UsuarioPermiso
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
  and rol = 'sys.admin'
</cfquery>
<cfif #isadmin_cuantos_roles.cuantos# NEQ 1>
	<cflocation url="index.cfm">
</cfif>