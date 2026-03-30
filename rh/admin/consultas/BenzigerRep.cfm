<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
		<cf_translate key="LB_RecursosHumanos" XmlFile="/rh/generales.xml">Recursos Humanos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">
		<cf_templatecss>
		<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
		<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_ConsultaDeSaldoDeVacaciones"
			Default="Consulta de Saldo de Vacaciones"
			returnvariable="LB_ConsultaDeSaldoDeVacaciones"/>			
		<cf_web_portlet_start titulo="#LB_ConsultaDeSaldoDeVacaciones#">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<cfset params = "&RHPcodigo=" & Form.RHPcodigo>
			<cf_rhimprime datos="/rh/admin/consultas/BenzigerRep-form.cfm" paramsuri="">
			<cfinclude template="BenzigerRep-form.cfm">
		<cf_web_portlet_end>

	</cf_templatearea>
</cf_template>
