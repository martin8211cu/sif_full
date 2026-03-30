<cf_templateheader title="Arqueo de Caja Chica"> 
	<cf_navegacion name="Config" navegacion="">
	<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="verificacion">
	</cfinvoke>
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = 'Arqueo de Caja Chica'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		
		<cfif isdefined ('url.CCHAid')>
			<cfset form.CCHAid=#url.CCHAid#>
		</cfif>
		<cfif isdefined ('url.rep')>
			<cfinclude template="CCHarqueoRep.cfm">
		<cfelseif (isdefined ('form.CCHAid') or isdefined ('form.btnNuevo')) and not isdefined ('url.rep')>
			<cfinclude template="CCHarqueo_form.cfm">
		<cfelse>
			<cfinclude template="CCHarqueo_lista.cfm">
		</cfif>		
	  	<cf_web_portlet_end>
<cf_templatefooter>
