<cfif not len(trim(form.ESid))>
	<cflocation url="escala-salarial-filtro.cfm">
</cfif>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>
				<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Valoraci&oacute;n HAY vs Escala Salarial">
					<table width="100%" cellpadding="0" cellspacing="0">
						<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
						<tr>
							<td>
								<cfoutput>
								<cfset param = "&ESid=#form.ESid#">
								<cfif isdefined("form.DESlinea") and len(trim(form.DESlinea))>
									<cfset param = param & "&DESlinea=#form.DESlinea#">
								</cfif>
								<cf_rhimprime datos="/rh/adminsalarios/consultas/escala-salarial-form.cfm" paramsuri="#param#"> 
								<cfinclude template="escala-salarial-form.cfm">
								</cfoutput>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				<cf_web_portlet_end>
			</td></tr>
		</table>
	<cf_templatefooter>	


 
  

 
