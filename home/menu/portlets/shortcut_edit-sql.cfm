<cfif isdefined("form.Modificar")>
	<cfquery datasource="asp">
		update SShortcut
		set descripcion_shortcut = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.descripcion_shortcut)#">
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and id_shortcut = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_shortcut#">
	</cfquery>
<cfelseif isdefined("form.Eliminar")>
	<cfquery datasource="asp">
		delete SShortcut
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		and id_shortcut = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_shortcut#">
	</cfquery>
</cfif>

<!---<cflocation url="shortcut_edit.cfm?id_shortcut=#form.id_shortcut#">--->
<cflocation url="shortcut_edit.cfm">