<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_nav__SPdescripcion" Default="#nav__SPdescripcion#" returnvariable="LB_nav__SPdescripcion"/>
<cf_templateheader title="#LB_nav__SPdescripcion#">
	<cf_web_portlet_start titulo="#LB_nav__SPdescripcion#">
			<cfset params="">
			<cfoutput>#pNavegacion#</cfoutput>
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td width="10">&nbsp;</td>
					<td width="40%" valign="top">
						<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
						<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
							<p><cf_translate  key="LB_texto_de_ayuda">
								Este reporte muestra un listado de las incidencias segun el rango de fechas del calendario de pago, hist&oacute;ricas o sin aplicar, y segun su estado de aprobaci&oacute;n
							</cf_translate></p>
							<cf_web_portlet_end>
					</td>
					<td width="15">&nbsp;</td>
					<td width="60%" valign="top">
						<cfinclude template="ConsultaIncidenciasProceso-Filtro.cfm">
					</td>
						<td width="15">&nbsp;</td>
					  </tr>
					</table>
			
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>