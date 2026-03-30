<!--- ====================================================================================================================== --->
<!--- ====================================================================================================================== --->
<!--- PROCESO SQL DE APICACION DE RECLASIFICACION DE CUENTAS --->
<cfinvoke returnvariable="rs_Res" component="sif.Componentes.CC_ReclasificacionCuentas" method="reclasificacionCuentas">
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	<cfinvokeargument name="SNcodigo" value="#url.SNcodigo#">
	<cfinvokeargument name="debug" value="false">
	<cfinvokeargument name="usuario" value="#session.Usucodigo#">
	<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion))>
		<cfinvokeargument name="id_direccion" value="#url.id_direccion#">
	</cfif>
</cfinvoke>
<!--- ====================================================================================================================== --->
<!--- ====================================================================================================================== --->

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

<cflocation url="reclasificacionCuentas-final.cfm#params#">