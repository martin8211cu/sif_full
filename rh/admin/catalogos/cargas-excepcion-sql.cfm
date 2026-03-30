
<cfif isdefined("form.ALTA")>
	<cfquery datasource="#session.DSN#">
		insert into RHCargasRebajar( ECid, ECidreb, Ecodigo, BMUsucodigo, RHCRporc_emp, RHCRporc_pat )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECidreb#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHCRporc_emp, ',', '', 'all')#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHCRporc_pat, ',', '', 'all')#"> )
	</cfquery>

<cfelseif isdefined("form.CAMBIO") >
	<cfquery datasource="#session.DSN#">
		update RHCargasRebajar
		set RHCRporc_emp = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHCRporc_emp, ',', '', 'all')#">, 
			RHCRporc_pat = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHCRporc_pat, ',', '', 'all')#">
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#" >
		  and ECidreb = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECidreb#" >
	</cfquery>

<cfelseif isdefined("form.BAJA") >

	<cfinvoke component="rh.Componentes.RHActualizaUsucodigo" method="actualizarUsucodigo"><!--- actualiza el Usucodigo antes de eliminar, para efectos de auditoria--->
				<cfinvokeargument  name="nombreTabla" value="RHCargasRebajar">		
				<cfinvokeargument name="nombreCampo" value="BMUsucodigo">
				<cfinvokeargument name="condicion" value="ECid = #form.ECid# and ECidreb = #form.ECidreb#">
	</cfinvoke>
	
	<cfquery datasource="#session.DSN#">
		delete from RHCargasRebajar
		where ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#" >
		  and ECidreb = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECidreb#" >
	</cfquery>
</cfif>
<cflocation url="cargas-excepcion.cfm?ECid=#form.ECid#">