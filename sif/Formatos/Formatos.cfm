<cf_templateheader> 
	 <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#">
			<cfif Session.Menues.SScodigo EQ "RH" >
				<cfset Regresar = '/cfmx/rh/indexAdm.cfm'>
				<cfset navBarItems = ArrayNew(1)>
				<cfset navBarLinks = ArrayNew(1)>
				<cfset navBarStatusText = ArrayNew(1)>			 
				<cfset navBarItems[1] = "Administraci&oacute;n de N&oacute;mina">
				<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
				<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
				<cfinclude template="../portlets/pNavegacion.cfm">
			<cfelseif Session.Menues.SScodigo EQ "SIF">
				<cfset Regresar = '/cfmx/sif/ad/MenuAD.cfm'>
				<cfinclude template="../portlets/pNavegacionAD.cfm">
			</cfif>
			<cfinclude template="formFormatos.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>