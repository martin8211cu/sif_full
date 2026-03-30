
<cf_templateheader>
	<cf_web_portlet_start>
			<br/>
			<table width="775" align="center" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td width="25">&nbsp;</td>
				<td width="600" valign="top">
					<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_filtros" Default="Filtros" 	returnvariable="LB_filtros"/>
						<cfinclude  template="reporteCostosSalariales-form.cfm">		
				</td>
				<td width="15">&nbsp;</td>
			  </tr>
			</table>
			<br/>
	<cf_web_portlet_end>
<cf_templatefooter>