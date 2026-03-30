<cf_templateheader title="Transacciones de Caja Chica"> 
	<cf_navegacion name="Config" navegacion="">
	<cfparam name="Attributes.entrada"		default="">
	<!---<cfquery name="rsSQLD" datasource="#session.dsn#">
		select count(1) as cantidad from CCHica where CCHresponsable=
	</cfquery>--->
		<cfif isdefined ('url.CCHTtipo')>
			<cfset form.CCHTtipo=#url.CCHTtipo#>
		</cfif>

			<cfif isdefined ('url.CCHTestado')>
			<cfset form.CCHTestado=#url.CCHTestado#>
		</cfif>
	<!---	<cfdump var="-#form.CCHTtipo#-"><br />
		<cfdump var="-#form.CCHTestado#-"><br />
		<cfabort>--->

		
		
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = 'Gesti&oacute;n de Transacciones de Caja Chica'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">																						
		<cfif isdefined ('form.CCHTtipo') and len(trim(form.CCHTtipo)) gt 0 and (form.CCHTtipo eq 'DISMINUCION' OR form.CCHTtipo eq 'CIERRE') and isdefined ('form.CCHTestado') and form.CCHTestado eq 'POR CONFIRMAR' or isdefined ('form.CCHDid') >
				<cfinclude template="CCHReintegro_form.cfm">
		<cfelseif isdefined ('form.CCHTid') or isdefined ('url.CCHTid') or isdefined ('form.Nuevo') or isdefined ('form.btnNuevo') or isdefined ('url.Nuevo')>
			<cfinclude template="CCHReintegro_form.cfm"> 
		<cfelse>
			<cfinclude template="CCHReintegro_lista.cfm">
		</cfif>			
	  	<cf_web_portlet_end>
<cf_templatefooter>
