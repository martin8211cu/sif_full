<cfif Not IsDefined('_PORTAL_CONTROL_')>
<cfset _PORTAL_CONTROL_ = 1>
<cfparam name="session.menues.Ecodigo" default="">
<cfparam name="session.menues.SScodigo" default="">
<cfparam name="session.menues.SMcodigo" default="">
<cfparam name="session.menues.SPcodigo" default="">
<cfparam name="session.menues.SMNcodigo" default="">

<cfparam name="session.menues.id_menu" default="500000000000002"><!--- punto de venta --->
<cfparam name="session.menues.id_root" default="7"><!--- punto de venta --->

<cfif IsDefined('url._nav')>
	<cfif IsDefined('url.seleccionar_EcodigoSDC')>
		<cfset session.menues.Ecodigo = session.Ecodigo>
	</cfif>
	<cfif IsDefined('url.s')>
		<cfset session.menues.SScodigo = url.s>
		<cfset session.menues.SMcodigo = "">
		<cfset session.menues.SPcodigo = "">
	</cfif>
	<cfif IsDefined('url.m')>
		<cfset session.menues.SMcodigo = url.m>
		<cfset session.menues.SPcodigo = "">
	</cfif>
	<cfif IsDefined('url.p')>
		<cfset session.menues.SPcodigo = url.p>
		
		<cfquery datasource="asp" name="get_home_page">
			select SPhomeuri
			from SProcesos p
			where p.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
			  and p.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
			  and p.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
		</cfquery>
		<cfif Len(Trim(get_home_page.SPhomeuri)) GT 1>
			<cflocation url="/cfmx#Trim(get_home_page.SPhomeuri)#" addtoken="no">
		</cfif>
		
	</cfif>
	<cfif IsDefined('url.mn')>
		<cfset session.menues.SMNcodigo = url.mn>
	</cfif>
</cfif>

<!--- buscar empresas --->
<cfquery name="rsEmpresas" datasource="asp" >
	select distinct
		e.Ecodigo,
		e.Enombre,
		e.Ereferencia,
		c.Ccache, e.ts_rversion
		<!--- para manejar el cache de la imagen --->
	from vUsuarioProcesos up, Empresa e, Caches c
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and up.Ecodigo = e.Ecodigo
	  and c.Cid = e.Cid
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	order by upper( e.Enombre )
	</cfif>
</cfquery>

<cfif rsEmpresas.RecordCount EQ 1>
	<cfset session.EcodigoSDC = rsEmpresas.Ecodigo>
	<cfset session.Ecodigo = rsEmpresas.Ereferencia>
	<cfset session.Enombre = rsEmpresas.Enombre>
	<cfset session.DSN = rsEmpresas.Ccache>
</cfif>

<cfquery name="rsSistemas" datasource="asp" >
	select distinct 
	  rtrim(s.SScodigo) as SScodigo,
	  s.SSdescripcion,
	  s.SShomeuri,
	  s.ts_rversion SStimestamp
	from vUsuarioProcesos up
		join SSistemas s
			on up.SScodigo = s.SScodigo
		join SModulos m
			on  up.SScodigo = m.SScodigo
			and up.SMcodigo = m.SMcodigo
		join SProcesos p
			on  up.SScodigo = p.SScodigo
			and up.SMcodigo = p.SMcodigo
			and up.SPcodigo = p.SPcodigo
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and s.SSmenu = 1
	  and m.SMmenu = 1
	  and p.SPmenu = 1
	order by s.SSorden, upper( s.SSdescripcion )
</cfquery>
<cfif rsSistemas.RecordCount is 1 Or Len(session.menues.SScodigo) is 0>
	<cfset session.menues.SScodigo = Trim(rsSistemas.SScodigo)>
</cfif>

<cfquery name="rsModulos" datasource="asp" >
	select distinct 
	  rtrim(m.SScodigo) as SScodigo,
	  rtrim(m.SMcodigo) as SMcodigo,
	  rtrim(p.SPcodigo) as SPcodigo,
	  m.SMdescripcion,
	  p.SPdescripcion,
	  m.SMhomeuri,
	  p.SPhomeuri,
	  m.ts_rversion SMtimestamp,
	  p.ts_rversion SPtimestamp
	from vUsuarioProcesos up
		join SSistemas s
			on up.SScodigo = s.SScodigo
		join SModulos m
			on  up.SScodigo = m.SScodigo
			and up.SMcodigo = m.SMcodigo
		join SProcesos p
			on  up.SScodigo = p.SScodigo
			and up.SMcodigo = p.SMcodigo
			and up.SPcodigo = p.SPcodigo
	where up.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
	  and up.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
	  and s.SSmenu = 1
	  and m.SMmenu = 1
	  and p.SPmenu = 1
	  and m.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	order by coalesce (m.SMorden, 9999), upper( m.SMdescripcion ), coalesce (p.SPorden, 9999), upper( p.SPdescripcion )
</cfquery>

<cfquery datasource="asp" name="ubicacionSS">
	select SScodigo, SSdescripcion
	from SSistemas
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
</cfquery>
<cfquery datasource="asp" name="ubicacionSM">
	select SMcodigo, SMdescripcion
	from SModulos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
</cfquery>
<cfquery datasource="asp" name="ubicacionSP">
	select SPcodigo, SPdescripcion
	from SProcesos
	where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
	  and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#">
	  and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
</cfquery>

<!--- fin ifdef --->
</cfif>

