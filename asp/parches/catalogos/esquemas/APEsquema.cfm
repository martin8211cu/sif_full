<cf_templateheader title="Mantenimiento de Esquemas">

<cf_web_portlet_start titulo="Mantenimiento de Esquemas">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		<cfquery datasource="asp" name="lista">
			select esquema, nombre, datasource
			from APEsquema <!--- falta el where --->
			order by esquema
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="esquema,nombre,datasource"
			etiquetas="Código,Nombre,Datasource"
			formatos="S,S,S"
			align="left,left,left"
			ira="APEsquema.cfm"
			form_method="get"
			keys="esquema"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="APEsquema-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>

