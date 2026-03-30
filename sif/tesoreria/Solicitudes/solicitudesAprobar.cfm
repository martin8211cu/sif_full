<cfinvoke key="LB_Titulo" default="Aprobación de Solicitudes de Pago"	returnvariable="LB_Titulo"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="solicitudesAprobar.xml"/>



<cf_templateheader title="#LB_Titulo#">
	<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>
	<cf_navegacion name="TESOPid" navegacion="">
	<cfif isdefined("form.TESOPid")>
		<cfset Session.Tesoreria.ordenesPagoIrLista = "../Solicitudes/#Session.Tesoreria.solicitudesCFM#">
		<cflocation url="../Pagos/ordenesPago.cfm?TESOPid=#form.TESOPid#&PASO=10">
	</cfif>

	<cfinclude template="TESid_Ecodigo.cfm">
	<cfif isdefined("form.btnAprobar")>
		<cfinclude template="solicitudesAprobar_sql.cfm">
	<cfelseif isdefined("form.TESSPid")>
		<cfinclude template="solicitudesAprobar_form.cfm">
	<cfelse>
		<cfset parentEntrancePoint="Aprobar">
		<cfinclude template="solicitudesAprobar_lista.cfm">
	</cfif>
<cf_templatefooter>
<!---   --->