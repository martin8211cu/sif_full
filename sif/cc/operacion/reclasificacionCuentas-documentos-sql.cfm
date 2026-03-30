<cfif isdefined("url.chk") and len(trim(url.chk))>
	<cfloop list="#url.chk#" index="i">
		<cfquery datasource="#session.DSN#">
			delete from RCBitacora
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and RCBestado = 0
			  and IDbitacora = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
		</cfquery>
	</cfloop>
</cfif>

<cfset params = '?SNcodigo=#url.SNcodigo#&Ccuenta=#url.Ccuenta#' >
<cfif isdefined("url.Ccuenta2") and len(trim(url.Ccuenta2))>
	<cfset params = params & '&Ccuenta2=#url.ccuenta2#'>
</cfif>

<cfif isdefined("url.filtrar_por") and url.filtrar_por eq "D" and isdefined("url.Ddocumento") and len(trim(url.Ddocumento))>
	<cfset params = params & '&filtrar_por=D&Ddocumento=#url.Ddocumento#'>
<cfelse>
	<cfset params = params & '&filtrar_por=T'>
	<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
		<cfset params = params & '&id_direccion=#url.id_direccion#'>
	</cfif>
	
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		<cfset params = params & '&Ocodigo=#url.Ocodigo#'>
	</cfif>
	
	<cfif isdefined("url.antiguedad") and len(trim(url.antiguedad))>
		<cfset params = params & '&antiguedad=#url.antiguedad#'>
	</cfif>
	
	<cfif isdefined("url.CCTcodigo") and len(trim(url.CCTcodigo))>
		<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
	</cfif>	
</cfif>
<cflocation url="reclasificacionCuentas-documentos.cfm#JSStringFormat(params)#">

