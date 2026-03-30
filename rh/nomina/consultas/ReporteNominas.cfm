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
				<td width="600" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
						<cfinclude  template="ReporteNominas-form.cfm">		
				</td>
				<td width="15">&nbsp;</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>