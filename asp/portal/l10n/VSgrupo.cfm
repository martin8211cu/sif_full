<cf_templateheader title="Grupos de Localización">
<cf_web_portlet_start titulo="Grupos de Localización">
<cfinclude template="/home/menu/pNavegacion.cfm">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		<cfquery datasource="sifcontrol" name="lista">
			select VSgrupo, VSnombre_grupo
			from VSgrupo
			order by VSgrupo
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="VSgrupo,VSnombre_grupo"
			etiquetas="Numero,Grupo"
			formatos="S,S"
			align="left,left"
			ira="VSgrupo.cfm"
			form_method="get"
			keys="VSgrupo"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="VSgrupo-form.cfm">
	</td>
  </tr>
</table>

<cf_web_portlet_end><cf_templatefooter>


