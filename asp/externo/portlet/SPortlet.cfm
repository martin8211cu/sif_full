<cf_templateheader title="Mantenimiento de Portlet Reutilizable">
<cf_web_portlet_start titulo="Portlets">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		
		<cfquery datasource="asp" name="lista">
			select id_portlet, nombre_portlet
			from SPortlet
			<!--- falta el where --->
			order by nombre_portlet
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_portlet"
			etiquetas="Portlet"
			formatos="S"
			align="left"
			ira="SPortlet.cfm"
			form_method="get"
			keys="id_portlet"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="SPortlet-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


