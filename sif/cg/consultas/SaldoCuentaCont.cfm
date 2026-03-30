<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfinvoke key="LB_Titulo" 			default="Saldos por Cuenta Contable - Libro de Mayor" 			returnvariable="LB_Titulo" 				component="sif.Componentes.Translate" method="Translate" xmlfile="SaldoCuentaCont.xml"/>
<!---<cfthrow message="#nav__SPdescripcion#">--->
	<cf_templateheader title="#LB_Titulo#">
	    <cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#LB_Titulo#</cfoutput>">
			
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr> 
					<td valign="top">
						<cfinclude template="SaldoCuentaContform.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
