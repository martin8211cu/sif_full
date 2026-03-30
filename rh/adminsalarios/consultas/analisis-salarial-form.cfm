<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_AnalisisSalarial"
	Default="An&aacute;lisis Salarial"
	returnvariable="LB_AnalisisSalarial"/>
<!--- FIN VARIABLES DE TRADUCCION --->
<cfif isdefined('url.paso') and not isdefined('form.paso')>
	<cfset form.paso = url.paso>
</cfif>

<cfinclude template="analisis-salarial-config.cfm">
<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
	<td valign="top" style="padding-right: 3px;">
		<cf_web_portlet_start titulo="#LB_AnalisisSalarial#" width="100%" border="true">
			<cfinclude template="/home/menu/pNavegacion.cfm">
			<cfinclude template="analisis-salarial-header.cfm">
			<cfif Form.paso EQ 0>
				<cfinclude template="analisis-salarial-listaReportes.cfm">
			<cfelseif Form.paso EQ 1>
				<cfinclude template="analisis-salarial-paso1.cfm">
			<cfelseif Form.paso EQ 2>
				<cfinclude template="analisis-salarial-paso2.cfm">
			<cfelseif Form.paso EQ 3>
				<cfinclude template="analisis-salarial-paso3.cfm">
			<cfelseif Form.paso EQ 4>
			<cfinclude template="analisis-salarial-paso4.cfm">
			<cfelseif Form.paso EQ 5>
				<cfinclude template="analisis-salarial-paso5.cfm">
			</cfif>
		<cf_web_portlet_end>	</td>
	<td width="190" valign="top">
		<cfinclude template="analisis-salarial-progreso.cfm"><br>
		<cfinclude template="analisis-salarial-ayuda.cfm">	</td>
  </tr>
</table>
