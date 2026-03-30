	<!--- valida CPid--->
	<cfif not isdefined("url.periodo")>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_No_se_ha_seleccionado_el_periodo"
		Default="Error. No se ha seleccionado el per&iacute;odo"
		returnvariable="LB_No_se_ha_seleccionado_el_periodo"/> 
		<cf_throw message="#LB_No_se_ha_seleccionado_el_periodo#" errorCode="1060">
	</cfif>
	<cfif not isdefined("url.mes")>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_No_se_ha_seleccionado_el_mes"
		Default="Error. No se ha seleccionado el mes"
		returnvariable="LB_No_se_ha_seleccionado_el_mes"/> 
		
		<cf_throw message="#LB_No_se_ha_seleccionado_el_periodo#" errorCode="1065">
	</cfif>
	
	<!--- Valiad Parametro 870 (cuenta de acumulacion de cesantia )--->
	<cfquery name="rs_870" datasource="#session.DSN#">
		select Pvalor
		from RHParametros 
		where Ecodigo=#session.Ecodigo# 
		  and Pcodigo=870	
	</cfquery>
	<cfif len(trim(rs_870.Pvalor)) eq 0 >
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_No_ha_definido_la_cuenta_de_Acumulacion_de_Cesantia_Verifique_sus_datos"
		Default="Error. No ha definido la cuenta de Acumulaci&oacute;n de Cesant&iacute;a. Verifique sus datos"
		returnvariable="LB_No_ha_definido_la_cuenta_de_Acumulacion_de_Cesantia_Verifique_sus_datos"/> 
		<cf_throw message="#LB_No_ha_definido_la_cuenta_de_Acumulacion_de_Cesantia_Verifique_sus_datos#" errorCode="1055">	
	</cfif>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_RecursosHumanos"
		Default="Recursos Humanos"
		XmlFile="/rh/generales.xml"
		returnvariable="LB_RecursosHumanos"/>
	<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
		<table width="100%" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top">	
					<cf_web_portlet_start border="true" titulo="Asiento de Liquidaci&oacute;n de Cesant&iacute;a" skin="#Session.Preferences.Skin#"> 
						<table width="100%">
							<tr>
								<td>
									<cfif isdefined("url.DEid") and len(trim(url.DEid))>
										<iframe width="100%" height="500" frameborder="0" src="asientoLiquidacion-form.cfm?periodo=<cfoutput>#url.periodo#</cfoutput>&mes=<cfoutput>#url.mes#</cfoutput>&DEid=<cfoutput>#url.DEid#</cfoutput>" ></iframe>
									<cfelse>										
										<iframe width="100%" height="500" frameborder="0" src="asientoLiquidacion-form.cfm?periodo=<cfoutput>#url.periodo#</cfoutput>&mes=<cfoutput>#url.mes#</cfoutput>" ></iframe>
									</cfif>
								</td>
							</tr>
						</table>
					<cf_web_portlet_end> 
				</td>	
			</tr>
		</table>	
	<cf_templatefooter>