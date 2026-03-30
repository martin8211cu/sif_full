<cf_templateheader title="Arqueo para Reintegros de Cuenta Bancaria"> 
	<cf_navegacion name="Config" navegacion="">
	<!---<cfinvoke component="sif.tesoreria.Componentes.TEScajaChica" method="verificacion">
	</cfinvoke>--->
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = 'Arqueo para Reintegros de Cuenta Bancaria'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
<!---		<cfdump var="#url#">
		<cf_dump var="#form#">--->
		<cfif isdefined ('url.CBid')>
			<cfset form.CBid=#url.CBid#>
		</cfif>
		
		
		<cfif isdefined ('url.BTNregresar') or isdefined ('form.BTNregresar')>
			<cfset form.CBid=''>
		</cfif>
	
		<cfif isdefined ('url.chkResumen')>
			<cfset form.chkResumen=#url.chkResumen#>
		</cfif>
		<cfif isdefined ('url.BTNreporte') or isdefined ('form.BTNreporte')>
			<cfinclude template="TESarqueoCBRep.cfm">
		<!---<cfelseif (isdefined ('form.CCHAid') or isdefined ('form.btnNuevo')) and not isdefined ('url.rep')>--->
		<cfelse>
			<cfinclude template="TESarqueoCB_form.cfm">
			<!---<cfinclude template="TESarqueoCB_lista.cfm">--->
		</cfif>		
	  	<cf_web_portlet_end>
<cf_templatefooter>
