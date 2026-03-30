<cf_templateheader title="Idiomas disponibles">

<cf_web_portlet_start titulo="Idiomas disponibles">
<cfinclude template="/home/menu/pNavegacion.cfm">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		<cfquery datasource="sifcontrol" name="lista">
			select Iid,Icodigo,Descripcion
			from Idiomas
			order by Icodigo
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="Icodigo,Descripcion"
			etiquetas="Código,Idioma"
			formatos="S,S"
			align="left,left"
			ira="Idiomas.cfm"
			form_method="get"
			keys="Iid"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="Idiomas-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


