<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Tratado_De_Libre_Comercio"
	Default="Tratado de Libre Comercio"
	returnvariable="LB_title"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Empresas"
	Default="Empresas"
	returnvariable="LB_Empresas"/>
	
	<cf_templatearea name="title">
		<cfoutput>#LB_title#</cfoutput>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cfinclude template="../../../../sif/Utiles/params.cfm">
		<cf_web_portlet_start border="true" titulo="<cfoutput>#LB_Empresas#</cfoutput>" skin="#Session.Preferences.Skin#">
			<table width="100%" cellpadding="2" cellspacing="0">
				<tr>
					<td valign="top">
						<cfinclude template="EmpresasTLC.cfm">
					</td>	
				</tr>
				<tr>
					<td>
						<form name="form2" action="ConciliacionTLC.cfm" method="post">
							<cf_botones formname="form2" name="ConciliarEmpresas" values="Conciliar Empresas">
						</form>
					</td>
				</tr>
			</table>	
		<cf_web_portlet_end>
	</cf_templatearea>
</cf_template>