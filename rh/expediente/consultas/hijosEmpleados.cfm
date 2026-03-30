<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_titulo" Default="#nav__SPdescripcion#" returnvariable="LB_titulo"/>
<cf_templateheader title="#LB_titulo#">
	<cf_web_portlet_start titulo="#LB_titulo#">
		<cfoutput>#pNavegacion#</cfoutput>
			<br/>
			<table width="775" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td width="25">&nbsp;</td>
				<td width="300" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ayuda" Default="Ayuda" 	returnvariable="LB_ayuda"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_ayuda#" tituloalign="left" wifth="300" height="300">
						<p>
							<cf_translate  key="LB_texto_de_ayuda">
							Es reporte muestra un listado de un tipo de
							familiares de los empleados con una edad tope
							a una fecha seleccionada.
							</cf_translate>
						</p>
					    <cf_web_portlet_end>
				</td>
				<td width="25">&nbsp;</td>
				<td width="400" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
					<cf_web_portlet_start tipo="mini" titulo="#LB_filtros#" tituloalign="left" wifth="300" height="300">
						<cfinclude  template="hijosEmpleados-form.cfm">		
					<cf_web_portlet_end>
				</td>
				<td width="25">&nbsp;</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>