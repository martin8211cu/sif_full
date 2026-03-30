<cf_templateheader title="#Request.Translate('ModuloFA','Facturación','/sif/Utiles/Generales.xml')#">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Consulta de Comisiones por Vendedor">
			<form action="repComisiones.cfm" method="post" name="form1">
				<cfinclude template="repComisiones-form.cfm">
			</form>
		<cf_web_portlet_end>
<cf_templatefooter> 