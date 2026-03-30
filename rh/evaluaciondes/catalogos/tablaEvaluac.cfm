<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cf_templateheader title="#LB_RecursosHumanos#">
	<cf_templatecss>
	  <cfinclude template="/rh/Utiles/params.cfm">
	  <cfset Session.Params.ModoDespliegue = 1>
	  <cfset Session.cache_empresarial = 0>

		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_TablasDeEvaluacion"
						Default="Tablas de Evaluaci&oacute;n"
						returnvariable="LB_TablasDeEvaluacion"/>					
                  	<cf_web_portlet_start border="true" titulo="#LB_TablasDeEvaluacion#" skin="#Session.Preferences.Skin#">
				  		<cfinclude template="/rh/portlets/pNavegacion.cfm">
				  
							<cfparam name="form.TEcodigo" default="">
							<cfif form.TEcodigo EQ "">
								<cfif isdefined("form.modo") AND form.modo EQ "ALTA">
									<cfinclude template="/rh/portlets/pNavegacion.cfm">
									<cfinclude template="TablaEvaluac_form.cfm">
								<cfelse>
									<cfinclude template="TablaEvaluac_lista.cfm">
								</cfif>
							<cfelseif NOT (isdefined("form.btnLista") AND form.btnLista NEQ "" OR isdefined("form.modo") AND form.modo EQ "LISTA")>
								<cfparam name="form.modo" default="CAMBIO">
								<cfinclude template="TablaEvaluac_form.cfm">
							<cfelse>
								<cfinclude template="TablaEvaluac_lista.cfm">
							</cfif>		
	                <cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
<cf_templatefooter>