<cf_templateheader title="Arqueo de Caja Chica de Cuentas Bancarias"> 
	<cf_navegacion name="Config" navegacion="">
		<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>		  
			<cfset titulo = 'Arqueo de Caja Chica de Cuentas Bancarias'>			
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
		<cfif isdefined ('url.CBid')>
			<cfset form.CBid=#url.CBid#>
		</cfif>
	
		<cfif isdefined ('url.BTNregresar') or isdefined ('form.BTNregresar')>
			<cfset form.CBid=''>
		</cfif>
	
		<cfif isdefined ('url.chkResumen')>
			<cfset form.chkResumen=#url.chkResumen#>
		</cfif>
        <cfset form.arqueoCH = true>
		<cfif isdefined ('url.BTNreporte') or isdefined ('form.BTNreporte')>
			<cfinclude template="TESarqueoCBRep.cfm">
		<cfelse>
			<cfinclude template="TESarqueoCB_form.cfm">
		</cfif>		
	  	<cf_web_portlet_end>
<cf_templatefooter>
