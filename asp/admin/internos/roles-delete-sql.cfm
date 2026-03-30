<cfparam name="url.s" type="string" default="">
<cfparam name="url.r" type="string" default="">
<cfparam name="url.e" type="numeric" default="0">
<cfparam name="url.u" type="numeric" default="0">
<!---
	insertar. se verifica que:
		a) el rol sea interno,
		b) que no lo tenga ya asignado el usuario.

 --->
<cfset url.s = Mid(url.s & "          ",1, 10)>
<cfset url.r = Mid(url.r & "          ",1, 10)>

<cfquery datasource="asp">
	delete from UsuarioRol
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.u#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.e#">
	  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">
	  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.r#">
	  and exists (select 1
	  from SRoles
	  where SRinterno = 1
	    and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">
	    and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.r#"> )
</cfquery>

<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
	method="actualizar">
	<cfinvokeargument name="Usucodigo" value="#url.u#">
	<cfinvokeargument name="SScodigo"  value="#url.s#">
	<cfinvokeargument name="Ecodigo"   value="#url.e#">
</cfinvoke>

<cflocation url="roles.cfm">
