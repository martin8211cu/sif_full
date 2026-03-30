<!---
	insertar. se verifica que:
		a) el rol sea interno,
		b) que no lo tenga ya asignado el usuario.

 --->
 
<cfset form.SScodigo = Mid(form.SScodigo & "          ",1, 10)>
<cfset form.SRcodigo = Mid(form.SRcodigo & "          ",1, 10)>
<cfquery datasource="asp">
	insert into UsuarioRol (Usucodigo, Ecodigo, SScodigo, SRcodigo)
	select
		<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.uid#">,
		<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#form.emp#">,
		SScodigo, SRcodigo
	from SRoles r
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SScodigo#">
	  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SRcodigo#">
	  and SRinterno = 1
	  and not exists (select 1 from UsuarioRol ur
	  	where ur.SScodigo = r.SScodigo
		  and ur.SRcodigo = r.SRcodigo
		  and ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.uid#">)
</cfquery>

<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
	method="actualizar">
	<cfinvokeargument name="Usucodigo" value="#form.uid#">
	<cfinvokeargument name="SScodigo"  value="#form.SScodigo#">
	<cfinvokeargument name="Ecodigo"   value="#form.emp#">
</cfinvoke>

<cflocation url="roles.cfm">