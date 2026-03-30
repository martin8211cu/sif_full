<cf_templateheader>
	<cf_web_portlet_start>
			<table align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td >&nbsp;</td>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
						
							<cf_translate  key="LB_texto_de_ayuda">
								Este reporte muestra el detalle <br>
								de los elementos exonerados <br>
								en cargas sociales y renta 
							</cf_translate>
						
					    <cf_web_portlet_end>
				</td>
				<td >&nbsp;</td>
				<td valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_filtros#" tituloalign="left" wifth="300" height="300">
						<cfinclude  template="ReporteExoneracion-form.cfm">
					<cf_web_portlet_end>
				</td>
				<td >&nbsp;</td>
			  </tr>
			</table>
	<cf_web_portlet_end>
<cf_templatefooter>