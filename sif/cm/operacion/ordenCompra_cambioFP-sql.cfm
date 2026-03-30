<!---Cambio del Encabezado de la Orden de Compra--->
<cfif isdefined('form.EOidorden') and form.EOidorden NEQ ''>
 	<cfquery datasource="#session.DSN#">
		update EOrdenCM
			set CMFPid 	= 	<cfif isdefined("form.CMFPid") and Len(Trim(form.CMFPid)) and form.CMFPid NEQ -1>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMFPid#">
							<cfelse>
								null
							</cfif>
				,EOplazo	= <cfqueryparam cfsqltype="cf_sql_integer" 	value="#form.EOplazo#">
		where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" 		value="#session.Ecodigo#">
			and EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.EOidorden#">
	</cfquery>			
</cfif>

<!---Regresa al Form--->
<cflocation url="listaOrdenCM_cambioFP.cfm">