<cfparam name="id_pagina" default="4">
<cfinclude template="init-portlet-preferencias.cfm">
<cfquery datasource="asp" name="portlets">
	select pp.id_pagina, pp.id_portlet, p.nombre_portlet, pp.columna, pp.fila, p.url_portlet, pr.id_portlet as hay
	from SPortletPagina pp
		join SPortlet p
			on pp.id_portlet = p.id_portlet
		left join SPortletPreferencias pr
			on  pr.id_portlet = pp.id_portlet
			and pr.id_pagina  = pp.id_pagina
			and pr.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	where pp.id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
	order by pp.columna, pp.fila
</cfquery>



<cfoutput>
<form action="/cfmx/home/menu/portlets/pzn/customize-apply.cfm" method="post">
	<input type="hidden" name="id_pagina" value="#HTMLEditFormat(id_pagina)#">
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<input name="SNcodigo"  type="hidden" value="#url.SNcodigo#" />
	</cfif>
</cfoutput>
<table width="100%"  border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td width="21">&nbsp;</td>
    <td colspan="3"><strong>Seleccione los portlets que aparecer&aacute;n en su p&aacute;gina inicial </strong></td>
    <td width="26">&nbsp;</td>
  </tr>
  <cfoutput query="portlets" group="columna">
  <tr>
    <td>&nbsp;</td>
    <td colspan="3">&nbsp;</td>
    <td>&nbsp;</td>
  </tr><cfoutput>
  <tr>
    <td>&nbsp;</td>
    <td width="40" valign="middle">&nbsp;</td>
    <td width="30" valign="middle"><input type="checkbox" name="portlet" id="portlet#portlets.id_portlet#" value="#HTMLEditFormat(portlets.id_portlet)#" <cfif Len(portlets.hay)>checked </cfif>></td>
    <td valign="middle"><label for="portlet#portlets.id_portlet#">#HTMLEditFormat(portlets.nombre_portlet)#</label></td>
    <td>&nbsp;</td>
  </tr></cfoutput></cfoutput>
  <tr><td colspan="5" align="center"><input type="submit" value="Guardar"></td></tr>
  <tr><td colspan="5" align="center">&nbsp;</td></tr>
</table>

</form>