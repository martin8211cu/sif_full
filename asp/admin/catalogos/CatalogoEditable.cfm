<cf_templateheader title="Mantenimiento de CatalogoEditable"><cf_web_portlet_start titulo="Catálogos Editables">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		<cfquery datasource="asp" name="lista">
			select tabla
			from CatalogoEditable
			<!--- falta el where --->
			
		</cfquery>
		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="tabla"
			etiquetas="Tabla"
			formatos="S"
			align="left"
			ira="CatalogoEditable.cfm"
			form_method="get"
			keys="tabla"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="CatalogoEditable-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


