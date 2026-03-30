<cf_templateheader title="Mantenimiento de Página Personalizable">
<cf_web_portlet_start titulo="Páginas">
<cfinclude template="/home/menu/pNavegacion.cfm">
<table width="100%" border="0" cellspacing="6">
  <tr>
    <td rowspan="2" valign="top">
		
		<cfquery datasource="asp" name="lista">
			select id_pagina, nombre_pagina
			from SPagina
			<!--- falta el where --->
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="nombre_pagina"
			etiquetas="nombre_pagina"
			formatos="S"
			align="left"
			ira="SPagina.cfm"
			form_method="get"
			keys="id_pagina"
		/>		
	</td>
    <td colspan="2" valign="top">
		<cfinclude template="SPagina-form.cfm">
		
	</td>
  </tr>
  <tr>
    <td valign="top">

		<cfif Len(url.id_pagina)>
		<cfquery datasource="asp" name="lista2">
			select pp.id_pagina,pp.id_portlet, p.nombre_portlet, pp.columna, pp.fila
			from SPortletPagina pp
				join SPortlet p
					on pp.id_portlet = p.id_portlet
			where pp.id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_pagina#">
			
		</cfquery>
		

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista2#"
			desplegar="nombre_portlet,columna,fila"
			etiquetas="Portlet,Columna,Fila"
			formatos="S,S,S"
			align="left,left,left"
			ira="SPagina.cfm"
			form_method="get"
			keys="id_pagina,id_portlet"
			formName="lista2"
		/>
		
		</cfif></td>
    <td valign="top">

		<cfif Len(url.id_pagina)>
		<cfinclude template="SPortletPagina-form.cfm">
		</cfif></td>
  </tr>
</table>
<cf_web_portlet_end><cf_templatefooter>


