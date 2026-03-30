<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_CXCHist 	= t.Translate('LB_CXCHist','CxC Historico Saldo Socio')>
<cfset LB_CXCHistV= t.Translate('LB_CXCHistV','CxC Historico Ventas Socio')>
<cfset LB_CXCPrd= t.Translate('LB_CXCPrd','CxC Productos Socio')>
<cfset LB_CXCHPrd= t.Translate('LB_CXCHPrd','CxC Historico Producto Socio')>
<cfset LB_CXCVDir= t.Translate('LB_CXCVDir','CxC Ventas Direccion')>
<cfset LB_CXCPrd= t.Translate('LB_CXCPrd','CxC Productos Socio')>
<cfset LB_AnaXSocio= t.Translate('LB_AnaXSocio','Analisis por Socio')>

<cfquery name="rs" datasource="asp">
	select id_pagina
	from SPagina
	where nombre_pagina = 'CC Socio'
</cfquery>

<cfif rs.recordcount GT 0>
	<cfset _LVaridPagina = rs.id_pagina>
<cfelse>
	<cfoutput>

	<cflock scope="application" timeout="10" throwontimeout="yes">
		<cftransaction>
			<!--- 
				No se han generado lor portlets. 
				Se insertan para la pagina requerida
			--->
		
			<cfquery datasource="asp">
				insert into SPagina (nombre_pagina, BMfecha, BMUsucodigo)
				values ('CC Socio', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, #session.Usucodigo#)
			</cfquery>
	
			<cfquery name="rs" datasource="asp">
				select id_pagina
				from SPagina
				where nombre_pagina = 'CC Socio'
			</cfquery>
		
			<cfset _LVaridPagina = rs.id_pagina>
			
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'#LB_CXCVDir#', 
					'/sif/cc/consultas/analisisSocioHT.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'#LB_CXCHist#', 
					'/sif/cc/consultas/analisisSocioH1.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'#LB_CXCHistV#', 
					'/sif/cc/consultas/analisisSocioH2.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'#LB_CXCPrd#', 
					'/sif/cc/consultas/analisisSocioH3.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'#LB_CXCHPrd#', 
					'/sif/cc/consultas/analisisSocioH4.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>

			<cfquery datasource="asp">
				insert into SPortletPagina (
					id_pagina, 
					id_portlet, 
					columna, 
					fila, 
					parametros, 
					BMfecha, 
					BMUsucodigo)
				select 
					#_LVaridPagina#, 
					id_portlet, 
					1, 
					1, 
					'', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#
				from SPortlet
				where nombre_portlet = '#LB_CXCVDir#'
			</cfquery>

			<cfquery datasource="asp">
				insert into SPortletPagina (
					id_pagina, 
					id_portlet, 
					columna, 
					fila, 
					parametros, 
					BMfecha, 
					BMUsucodigo)
				select 
					#_LVaridPagina#, 
					id_portlet, 
					1, 
					2, 
					'', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#
				from SPortlet
				where nombre_portlet = '#LB_CXCHist#'
			</cfquery>

			<cfquery datasource="asp">
				insert into SPortletPagina (
					id_pagina, 
					id_portlet, 
					columna, 
					fila, 
					parametros, 
					BMfecha, 
					BMUsucodigo)
				select 
					#_LVaridPagina#, 
					id_portlet, 
					2, 
					2, 
					'', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#
				from SPortlet
				where nombre_portlet = '#LB_CXCHistV#'
			</cfquery>

			<cfquery datasource="asp">
				insert into SPortletPagina (
					id_pagina, 
					id_portlet, 
					columna, 
					fila, 
					parametros, 
					BMfecha, 
					BMUsucodigo)
				select 
					#_LVaridPagina#, 
					id_portlet, 
					1, 
					3, 
					'', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#
				from SPortlet
				where nombre_portlet = '#LB_CXCPrd#'
			</cfquery>

			<cfquery datasource="asp">
				insert into SPortletPagina (
					id_pagina, 
					id_portlet, 
					columna, 
					fila, 
					parametros, 
					BMfecha, 
					BMUsucodigo)
				select 
					#_LVaridPagina#, 
					id_portlet, 
					2, 
					3, 
					'', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#
				from SPortlet
				where nombre_portlet = '#LB_CXCHPrd#'
			</cfquery>
		<cftransaction action="commit" />
		</cftransaction>
        
	</cflock>
	</cfoutput>
    
</cfif>

<cfset Lvardireccionurl = "./analisisSocioHM.cfm?SNcodigo=#url.SNcodigo#">
<cfinclude template="analisisSocioH_sql.cfm">

<cfoutput><p align="center" style="font-family:'Times New Roman', Times, serif; font-size:24px">#LB_AnaXSocio#</p></cfoutput>
<cfif trim(LVarNombreDireccion) NEQ ''>
	<p align="center" style="font-family:'Times New Roman', Times, serif; font-size:20px"><cfoutput>#LvarNombreDireccion#</cfoutput></p>
</cfif>

<form name="customize" action="/cfmx/home/menu/portlets/pzn/customize.cfm" method="get">
	<cfset id_pagina = _LVaridPagina>
	<cfoutput>
		<input name="id_pagina" type="hidden" value="#_LvaridPagina#" />
		<input name="SNcodigo"  type="hidden" value="#url.SNcodigo#" />
	</cfoutput>
	<cfinclude template="/home/menu/portalST.cfm">
</form>