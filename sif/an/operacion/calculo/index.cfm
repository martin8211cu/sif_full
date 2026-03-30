<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Calcular Anexos" 
returnvariable="LB_Titulo" xmlfile="Index.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Debe seleccionar un Grupo de Anexos, para proceder con el cálculo de los mismos." returnvariable="LB_Mensaje" xmlfile="Index.xml"/>

<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		
		<table width="950" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td valign="top" width="250">
					<cfinclude template="arbol.cfm">
				</td>
				<td valign="top" width="5" style="background-color:#ededed; ">
				</td>
				<td valign="top" width="695">
					<cfif isdefined("url.GAid")>
						<cfinclude template="calcular-form.cfm">
					<cfelse>
						<br>
						<table width="60%" class="areaFiltro" align="center">
							<tr><td>&nbsp;</td></tr>
							<tr><td align="center"><strong><cfoutput>#LB_Mensaje#.</cfoutput></strong></td></tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</cfif>
				</td>
			</tr>
		</table>		
			
	<cf_web_portlet_end>
<cf_templatefooter>
