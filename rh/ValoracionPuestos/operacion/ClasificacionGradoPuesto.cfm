<!--- modificado con notepad --->
<!--- Sección de Etiquetas de Traducción --->
<cfsilent>
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ClasificacionDeGradosPorPuesto"
	Default="Clasificación de Grados por puesto"
	returnvariable="LB_ClasificacionDeGradosPorPuesto"/>
</cfsilent>


<cf_templateheader title="#LB_ClasificacionDeGradosPorPuesto#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">
			<cf_web_portlet_start titulo="#LB_ClasificacionDeGradosPorPuesto#">
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td  valign="top"><cfinclude template="formClasificacionGradoPuesto.cfm"></td> 
					</tr>
				</table>
		        <cf_web_portlet_end>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>