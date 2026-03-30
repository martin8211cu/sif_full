<cfif isdefined("Request.PNAVEGACION_SHOWN")><cfreturn></cfif>
<cfif isdefined("session.menues.omite_pnavegacion")><cfreturn></cfif>
<cfset Request.PNAVEGACION_SHOWN = 1>
<cfinclude template="rsMenues.cfm">
<cfparam name="session.menues.SPcodigo" default="">
<cfif session.menues.SPcodigo NEQ "" AND session.menues.SPcodigo NEQ session.monitoreo.SPcodigo>
	<cfquery name="nuevoProc" dbtype="query">
		select SMNcodigo
		  from rsMenues_
		 where SScodigo = '#session.monitoreo.SScodigo#'
		   and SMcodigo = '#session.monitoreo.SMcodigo#'
		   and SPcodigo = '#session.monitoreo.SPcodigo#'
	</cfquery>
	<cfset session.menues.SScodigo = session.monitoreo.SScodigo>
	<cfset session.menues.SMcodigo = session.monitoreo.SMcodigo>
	<cfset session.menues.SPcodigo = session.monitoreo.SPcodigo>
	
	<cfif nuevoProc.recordCount GT 0>
		<cfset session.menues.SMNcodigo = nuevoProc.SMNcodigo>
	<cfelse>
		<cfset session.menues.SMNcodigo = -1>
	</cfif>
</cfif>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="inicio"
		Default="Inicio"
		XmlFile="/home/menu/general.xml"
		returnvariable="vInicio"/>
<table width="100%" class="navbar" border="0">
<tr><td>
<table width="100%" class="navbar" border="0">
	<tr>
	<cfif NOT isdefined("session.menues.Ecodigo") OR session.menues.Ecodigo EQ "">
		<td nowrap valign="top" width="100%"><cfoutput>#fnNivelMenu(vInicio)#</cfoutput></td>
	<cfelseif isdefined("session.menues.Empresa1") AND session.menues.Empresa1 AND isdefined("session.menues.Sistema1") AND session.menues.Sistema1 AND isdefined("session.menues.Modulo1") AND session.menues.Modulo1>
		<td nowrap valign="top" width="100%"><cfoutput>#fnNivelMenu(vInicio)#</cfoutput></td>
	<cfelseif isdefined("session.menues.Empresa1") AND (NOT isdefined("session.menues.SScodigo") OR session.menues.SScodigo EQ "")>
		<td nowrap valign="top" width="100%"><cfoutput>#fnNivelMenu(vInicio)#</cfoutput></td>
	<cfelse>
		<td nowrap valign="top"><a tabindex="-1" href="/cfmx/home/menu/index.cfm"><cfoutput>#vInicio#</cfoutput></a></td>
		<td valign="top" width="100%">
		<cfif NOT isdefined("session.menues.SScodigo") OR session.menues.SScodigo EQ "">
			&gt;&nbsp;<cfoutput>#fnNivelMenu(session.Enombre)#</cfoutput>
		<cfelseif isdefined("session.menues.Sistema1") AND session.menues.Sistema1 AND isdefined("session.menues.Modulo1") AND session.menues.Modulo1>
			&gt;&nbsp;<cfoutput>#fnNivelMenu(session.Enombre)#</cfoutput>
		<cfelse>
			<cfif NOT (isdefined("session.menues.Empresa1") AND session.menues.Empresa1)>
			&gt;&nbsp;<cfoutput><a tabindex="-1" href="/cfmx/home/menu/empresa.cfm">#fnTituloMenu(session.Enombre)#</a></cfoutput>
			</cfif>
			<cfquery name="sistema" dbtype="query">
			select distinct SScodigo, SSdescripcion from rsMenues_ where SScodigo = '#session.menues.SScodigo#'
			</cfquery>
			<cfif isdefined("session.menues.Modulo1") AND session.menues.Modulo1>
				<cfset nav_SScodigo = sistema.SScodigo >
				&gt;&nbsp;<cfoutput>#fnNivelMenu(sistema.SSdescripcion)#</cfoutput>
			<cfelse>
				<cfquery name="modulo" dbtype="query">
				select distinct SScodigo, SSdescripcion, SMcodigo, SMdescripcion from rsMenues_ where SScodigo = '#session.menues.SScodigo#' and SMcodigo = '#session.menues.SMcodigo#'
				</cfquery>
				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#modulo.SScodigo#"
					Default="#modulo.SSdescripcion#"
					VSgrupo="101"
					returnvariable="nav_SSdesc"/>

				<cfinvoke component="sif.Componentes.TranslateDB"
					method="Translate"
					VSvalor="#modulo.SScodigo#.#modulo.SMcodigo#"
					Default="#modulo.SMdescripcion#"
					VSgrupo="102"
					returnvariable="nav_SMdesc"/>
				&gt;&nbsp;<cfoutput><a tabindex="-1" href="/cfmx/home/menu/sistema.cfm?s=#URLEncodedFormat(modulo.SScodigo)#">#fnTituloMenu(nav_SSdesc)#</a></cfoutput>
				&gt;&nbsp;<cfoutput><strong>#fnTituloMenu(nav_SMdesc)#</strong></cfoutput>
			</cfif>
		</cfif>
	</cfif>
	</tr>
</table>
</td><td align="right"><a href="/cfmx/commons/Licenses.html">Copyright</a></td>
</table>
<cffunction name="fnNivelMenu" output="false" returntype="string">
	<cfargument name="Titulo" type="string">
	<cfoutput>
	<cfset session.menues.SMNcodigo = "-1">
	<cfset url.n = 10 >
	<cfparam name="session.menues.SMNcodigo" default="-1">
	<cfparam name="url.n" default="#session.menues.SMNcodigo#">
	<cfif url.n EQ -1>
		<cfreturn "<strong>#fnTituloMenu(Titulo)#</strong>">
	<cfelse>
		<cfset LvarLinea = "">
		<cfset LvarSMNcodigo = url.n>
		<cfloop condition="true">
			<cfquery name="menues" dbtype="query">
			select SMNcodigo, SMNcodigoPadre
			  from rsMenues_
			 where SMNcodigo = #LvarSMNcodigo#
			</cfquery>
			<cfif menues.SMNcodigoPadre EQ "">
				<cfbreak>
			</cfif>
			<cfquery name="menuPadre" dbtype="query">
			select SMNtipoMenu
			  from rsMenues_
			 where SMNcodigo = #menues.SMNcodigoPadre#
			</cfquery>
			<cfif menuPadre.SMNtipoMenu EQ 1 OR menuPadre.SMNtipoMenu EQ 3>
				<cfif LvarSMNcodigo EQ url.n>
					<cfset LvarLinea = " &gt;&nbsp;<strong>#fnTituloMenu(menues.SMNtitulo)#</strong>">
				<cfelse>
					<cfset LvarLinea = " &gt;&nbsp;<a tabindex='-1' href='/cfmx/home/menu/modulo.cfm?n=#menues.SMNcodigo#&p=#menues.SMNcodigoPadre#'>#fnTituloMenu(menues.SMNtitulo)#</a>" & LvarLinea>
				</cfif> 
			</cfif>
			<cfset LvarSMNcodigo = menues.SMNcodigoPadre>
		</cfloop>
		<cfset LvarLinea = "<a tabindex='-1' href='/cfmx/home/menu/modulo.cfm'>#fnTituloMenu(Titulo)#</a>" & LvarLinea>
		<cfreturn LvarLinea>
	</cfif>
	</cfoutput>
</cffunction>
<cffunction name="fnTituloMenu" output="false" returntype="string">
	<cfargument name="Titulo" type="string">
	<cfreturn replace(Titulo," ","&nbsp;","all")>
</cffunction>
