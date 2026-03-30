<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="portal_control.cfm">
	
	<!--- OOPS ! --->
	<cfparam name="id_pagina" default="4">
	<cfinclude template="portlets/pzn/init-portlet-preferencias.cfm">

	<cfquery datasource="asp" name="portlets">
		select pp.id_pagina, pp.id_portlet, p.nombre_portlet, pp.columna, pp.fila, p.url_portlet
		from SPortletPreferencias pp
			join SPortlet p
				on pp.id_portlet = p.id_portlet
		where pp.id_pagina = <cfqueryparam cfsqltype="cf_sql_numeric" value="#id_pagina#">
		  and pp.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		order by pp.columna, pp.fila
	</cfquery>
	
	<cfset colwidth = "162,631,162">
	<cfset porwidth = "164,450,166">
	
	<table width="955" border="0" cellspacing="2" cellpadding="0">
		<tr>
		<cfoutput query="portlets" group="columna">
			<td width="#ListFirst(colwidth)#" valign="top">
				<cfoutput>
				
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#portlets.id_portlet#"
					Default="#portlets.nombre_portlet#"
					VSgrupo="121"
					Idioma="#Session.Idioma#"
					returnvariable="translated_value" />
				
				<cf_web_portlet pzn="yes" titulo="#translated_value#" skin="portlet" width="#ListFirst(porwidth)#" id_pagina="#portlets.id_pagina#" id_portlet="#portlets.id_portlet#">
				<cftry>
				<cfinclude template="#portlets.url_portlet#">
				<cfcatch type="any">#cfcatch.Message# #cfcatch.Detail#</cfcatch>
				</cftry>
				</cf_web_portlet><br>
				</cfoutput>
			</td>
			<cfset colwidth=ListRest(colwidth)>
			<cfset porwidth=ListRest(porwidth)>
		</cfoutput>
		</tr>
	</table>

</cf_templatearea>
</cf_template>