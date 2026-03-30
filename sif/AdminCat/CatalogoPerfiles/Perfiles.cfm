<!--- PINTA LA PANTALLA DE OPERACION --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<!---<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>--->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CatálogoPerfiles" Default="Catálogo de Perfiles" returnvariable="LB_CertificacionesDeRH"/> 
<cf_templateheader title="#LB_CertificacionesDeRH#"> 
	 <cf_web_portlet_start border="true" titulo="<cfoutput>#LB_CertificacionesDeRH#</cfoutput>" skin="#Session.Preferences.Skin#">
<!---			<cfif Session.Menues.SScodigo EQ "RH" >
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
			</cfif>--->
			<cfinclude template="formPerfiles.cfm">
		<cf_web_portlet_end>
<cf_templatefooter>