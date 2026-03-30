<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Impresion de Folios" returnvariable="LB_Title"/>
<cf_templateheader title="#LB_Title#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Title#'>
		<!--- <cfdump var="#form#"> --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td>
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<tr>
				<td>
					<cfif isdefined('form.btnAplicar')>
                        <cfinclude template="ImpresionFolios_sql.cfm">
                    </cfif>
                    <cfinclude template="ImpresionFolios_form.cfm">
				</td>
			</tr>
			<tr>
				<td>
					&nbsp;
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>