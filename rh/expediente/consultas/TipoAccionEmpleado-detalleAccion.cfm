<cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">

	<cf_templatecss>
	
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConsultaTipoDeAccionPorEmpleado"
		Default="Consulta Tipo de Acci&oacute;n por empleado"
		returnvariable="LB_ConsultaTipoDeAccionPorEmpleado"/>
	<cf_web_portlet_start titulo="#LB_ConsultaTipoDeAccionPorEmpleado#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		<table width="98%" class="Container" align="center" cellpadding="2" cellspacing="0">
			<tr>
				<td>
					<cfinclude template="consultas-frame-header.cfm">
					<cfinclude template="frame-infoEmpleado.cfm"> 
					<cfinclude template="frame-detalleAcciones.cfm">
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
	
	</cf_templatearea>
</cf_template>