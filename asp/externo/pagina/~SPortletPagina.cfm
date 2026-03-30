
<cf_template>
<cf_templatearea name="title">
	Mantenimiento de Contenido de Página
</cf_templatearea>
<cf_templatearea name="body">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top">
		
		<cfquery datasource="asp" name="lista">
			select id_pagina,id_portlet
			from SPortletPagina
			<!--- falta el where --->
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="id_pagina,id_portlet"
			etiquetas="id pagina,id_portlet"
			formatos="S,S"
			align="left,left"
			ira="SPortletPagina.cfm"
			form_method="get"
			keys="id_pagina,id_portlet"
		/>		
	</td>
    <td valign="top">
		<cfinclude template="SPortletPagina-form.cfm">
	</td>
  </tr>
</table>
</cf_templatearea>
</cf_template>


