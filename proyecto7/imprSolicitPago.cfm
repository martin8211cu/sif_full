<cf_navegacion name="TESSPid" default=""> 
<cfparam name="LvarFiltroPorUsuario" default="false">
<cfparam name="LvarSufijoForm" default="">

<cfif isdefined("LvarFiltroPorUsuario") and #LvarFiltroPorUsuario#>
	<cfset titulo="Impresi&oacute;n de Solicitudes de Pago(Usuario)">
    <cfset LvarSufijoForm="Usuario">
<cfelse>
	<cfset titulo="Impresi&oacute;n de Solicitudes de Pago">
</cfif>


<cfif form.TESSPid NEQ "" and not isdefined("url.regresar")>
	<cfset paramsuri='&imprime=1'>
	<cfif isdefined("Form.TESSPid")>
		<cfset paramsuri = paramsuri & '&TESSPid=#form.TESSPid#'>
	</cfif>
	<cfset form.MSG="">
	<cfif isdefined ('Attributes.location') and (Attributes.location eq 'solicitudesAnticipo.cfm' or Attributes.location eq 'solicitudesAnticipoE.cfm' )>
		<cf_htmlReportsHeaders 
		title="Impresion de Solicitud de Pago" 
		filename="SolicitudPago.xls"		
		irA="#Attributes.location#?regresar=1"
		download="no"
		preview="no"
		>
	<cfelse>
		<cf_htmlReportsHeaders 
		title="Impresion de Solicitud de Pago" 
		filename="SolicitudPago.xls"		
		irA="imprSolicitPago#LvarSufijoForm#.cfm?regresar=1"
		download="no"
		preview="no"
		>
	</cfif>
	<cf_templatecss>
	<cfinclude template="../sif/tesoreria/Solicitudes/imprSolicitPago_form.cfm">
<cfelse>
	<cf_templateheader title="#titulo#">
		<cfinclude template="../sif/tesoreria/Solicitudes/imprSolicitPago_lista.cfm">
	<cf_templatefooter>
</cfif>
