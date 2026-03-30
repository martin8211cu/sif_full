<cfquery name="rs" datasource="asp">
	select id_pagina
	from SPagina
	where nombre_pagina = 'CC Socio'
</cfquery>

<cfif rs.recordcount GT 0>
	<cfset _LVaridPagina = rs.id_pagina>
<cfelse>
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
					'CxC Ventas Direccion', 
					'/sif/cc/consultas/analisisSocioHT.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'CxC Historico Saldo Socio', 
					'/sif/cc/consultas/analisisSocioH1.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'CxC Historico Ventas Socio', 
					'/sif/cc/consultas/analisisSocioH2.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'CxC Productos Socio', 
					'/sif/cc/consultas/analisisSocioH3.cfm', 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
					#session.Usucodigo#, 
					450, 
					200)
			</cfquery>
		
			<cfquery datasource="asp">
				insert into SPortlet (nombre_portlet, url_portlet, BMfecha, BMUsucodigo, w_portlet, h_portlet)
				values (
					'CxC Historico Producto Socio', 
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
				where nombre_portlet = 'CxC Ventas Direccion'
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
				where nombre_portlet = 'CxC Historico Saldo Socio'
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
				where nombre_portlet = 'CxC Historico Ventas Socio'
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
				where nombre_portlet = 'CxC Productos Socio'
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
				where nombre_portlet = 'CxC Historico Producto Socio'
			</cfquery>
		<cftransaction action="commit" />
		</cftransaction>
	</cflock>
</cfif>

<cfset Lvardireccionurl = "./analisisSocioHM.cfm?SNcodigo=#url.SNcodigo#">
<cfinclude template="analisisSocioH_sql.cfm">

<p align="center" style="font-family:'Times New Roman', Times, serif; font-size:24px">Analisis por Socio</p>
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