<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Valores de las Variables" 
returnvariable="LB_Titulo" xmlfile="Index.xml"/>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cfparam name="nav__SPdescripcion" default="#LB_Titulo#">

<cfoutput>
	<cf_templateheader title="#LB_Titulo#">
		#pNavegacion#
		<cf_web_portlet_start titulo="#LB_Titulo#">
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td width="90%" valign="top">
							<cfinclude template="form.cfm">
						</td>
					</tr>
				</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
</cfoutput>