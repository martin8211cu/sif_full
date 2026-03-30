<!--- Dar o quitar permisos --->

<cfquery datasource="asp" name="rol">
	select 1
	from SRoles
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">
	  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.r#">
	  and SRoles.SRinterno = 0
</cfquery>
<cfif rol.RecordCount is 0>
	Rol interno o no existe, no hago nada
<cfelse>
	<!--- ok, rol existe y no es interno --->
	<cfoutput><cfset startTime=GetTickCount()>
	st=#url.st#</cfoutput>
	<cffunction name="ver_si_existe">
		<cfquery datasource="asp" name="existe">
			select 1
			from UsuarioRol
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.u#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._emp#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">
			  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.r#">
		</cfquery>
		<cfset existe = existe.RecordCount GT 0>
	</cffunction>
	<cfoutput>inicio:#GetTickCount()-startTime#</cfoutput>
	<cfset ver_si_existe()>
	<cfoutput>vio_si_existe:#GetTickCount()-startTime#</cfoutput>
	<cfset updated = false>
	<cfif (url.st is 1) and Not existe>
		<cfquery datasource="asp">
			insert INTO UsuarioRol( Usucodigo, Ecodigo, SScodigo, SRcodigo )
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.u#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._emp#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#url.r#">)
		</cfquery>
		<cfoutput>insertado:#GetTickCount()-startTime#</cfoutput>
		<cfset updated = true>
	<cfelseif (url.st is 0) and existe>
		<cfquery name="delete" datasource="asp">
			delete from UsuarioRol
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.u#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.simple._emp#">
			  and SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.s#">
			  and SRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#url.r#">
		</cfquery>
		<cfoutput>borrado:#GetTickCount()-startTime#</cfoutput>
		<cfset updated = true>
	</cfif>
	
	<cfif updated>
		<cfset ver_si_existe()>
		<cfoutput>vio_si_existe:#GetTickCount()-startTime#</cfoutput>
	</cfif>
	
	<cfoutput>
	<html><title>Resultado</title><head>
	<script type="text/javascript">
		window.parent.resp('#JSStringFormat(url.i)#', #IIF(existe,1,0)#);
	</script></head><body>
	respuesta:#GetTickCount()-startTime#
	<!---
	updated :#updated#<br>
	existe: #existe#<br>
	st:#url.st#--->
	</body></head></html><cfflush>
	</cfoutput>
	<cfif updated>
		<cfinvoke component="home.Componentes.MantenimientoUsuarioProcesos"
			method="actualizar"
			Usucodigo="#url.u#"
			SScodigo="#url.s#"
			Ecodigo="#session.simple._emp#" />
	</cfif>
	
	<cfoutput>fin:#GetTickCount()-startTime#</cfoutput>
</cfif>