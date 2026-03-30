<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		Recursos Humanos
	</cf_templatearea>
	
	<cf_templatearea name="body">
<cf_templatecss>

<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
	  <cfinclude template="/rh/Utiles/params.cfm">
		<table width="100%"  border="0" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
			  <cfif  isDefined("Form.DEid")>
				  <cfset Form.DEid = form.DEid>
			  </cfif>
				<!----================ TRADUCCION =======================--->
				<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Reporte_Control_de_Pago_de_Horas"
					Default="Reporte Control de Pago de Horas"	
					returnvariable="LB_Reporte_Control_de_Pago_de_Horas"/>
					
			   	 <cf_web_portlet_start border="true" titulo="#LB_Reporte_Control_de_Pago_de_Horas#" skin="#Session.Preferences.Skin#">
				   	<cfinclude template="/rh/portlets/pNavegacion.cfm">
					<cfif isdefined("form.DEid") and len(trim(form.DEid)) NEQ 0>
						<cf_rhimprime datos="/rh/marcas/consultas/ctrlPagoHoras-Imprime.cfm" paramsuri="&DEid=#form.DEid#"> 
					<cfelse>
						<cf_rhimprime datos="/rh/marcas/consultas/ctrlPagoHoras-Imprime.cfm"> 
					</cfif>
					 
 					<cf_sifHTML2Word>
					 		<cfinclude template="ctrlPagoHoras-Imprime.cfm">
					</cf_sifHTML2Word>

	              <cf_web_portlet_end>	
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>