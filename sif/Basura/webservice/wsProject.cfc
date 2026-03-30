<cfcomponent>
	<cffunction name="login" access="remote" returntype="query">
		<cfargument name="empresa" type="string">
		<cfargument name="usuario" type="string">
		<cfargument name="password" type="string">
	
		<cfset fnVerificaSesion(False)>

		<cftry>
			<cfinclude template="../../../home/check/dominio.cfm">
			<cfset Session.Usuario = "">
			<cfset Session.Usucodigo = 0>
			<cfset Session.CEcodigo = "">
			<cfset Session.Sitio.IP = "">
			<cfset StructDelete(Session, "logoninfo")>
			<cfset StructDelete(Session, "datos_personales")>
			<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
			<cfparam name="Arguments.empresa" default="">

			<cfset form_CEcodigo = sec.buscarAliasLogin(Arguments.empresa)>
			<cfif sec.autenticar(form_CEcodigo, Arguments.usuario, Arguments.password)>
				<cfset info_usuario = sec.infoUsuario(form_CEcodigo, arguments.usuario)>

				<cfinvoke component="home.Componentes.aspmonitor" method="ValidarSiSePuedeIniciarSesion">
					<cfinvokeargument name="Usucodigo" value="#info_usuario.Usucodigo#">
				</cfinvoke>
				
				<cfquery name="rsUsuario" datasource="asp">
					select 
						a.Usucodigo, 
						a.Usulogin,
						a.datos_personales,
						a.Utemporal,
						a.CEcodigo,
						b.CEnombre, a.LOCIdioma, a.Usurespuesta
					from Usuario a
					join CuentaEmpresarial b
					  on a.CEcodigo = b.CEcodigo
					where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#info_usuario.Usucodigo#">
				</cfquery>
		
				<cfif len(rsUsuario.Usucodigo) GT 0>
					<cfset session.logoninfo = StructNew()>
					<cfset session.logoninfo.Utemporal = rsUsuario.Utemporal>
					<cfset Session.Usuario=rsUsuario.Usulogin>
					<cfset Session.Usulogin=rsUsuario.Usulogin>
					<cfset Session.Ulocalizacion="00"><!--- para compatibilidad con tramites --->
					<cfset Session.Usucodigo=rsUsuario.Usucodigo>
					<cfset Session.CEcodigo=rsUsuario.CEcodigo>
					<cfset Session.CEnombre=rsUsuario.CEnombre>
					<cfset Session.idioma=Ucase(rsUsuario.LOCIdioma)>
					<cf_datospersonales action="select" key="#rsUsuario.datos_personales#" name="datos_personales">
					<cfset Session.datos_personales = datos_personales>
					<cfloginuser name="#Session.Usuario#" roles="none" password="#rsUsuario.Usucodigo#">
				<cfelse>
					<cfthrow message="Usuario no existe">
				</cfif>
				<cfquery name="rsEmpresas" datasource="asp">
					select distinct p.Ecodigo as EcodigoSDC, Enombre, 
						'#trim(session.datos_personales.Nombre) & " " & trim(session.datos_personales.Apellido1) & " " & trim(session.datos_personales.Apellido2)#' as Nombre
					  from vUsuarioProcesos p
						   inner join Empresa e 
							  on CEcodigo = #Session.CEcodigo#
							 and p.Ecodigo = e.Ecodigo
					 where Usucodigo=#Session.Usucodigo#
				</cfquery>
				<cfif rsEmpresas.recordCount EQ 1>
					<cfset CreateObject("Component","functions").seleccionar_empresa(rsEmpresa.EcodigoSDC)>
				</cfif>
				<cfreturn rsEmpresas>
			<cfelse>
				<cfthrow message="Login Failed">
			</cfif>
		<cfcatch type="any">
			<cfthrow message="#cfcatch.Message & ':' & cfcatch.Detail#">
		</cfcatch>
		</cftry>
	</cffunction>

	<cffunction name="escogeEmpresa" access="remote" returntype="boolean">
		<cfargument name="EcodigoSDC" type="string">

		<cfset fnVerificaSesion(true)>
		<cfset CreateObject("Component","home/check/functions").seleccionar_empresa(Arguments.EcodigoSDC)>
		<cfreturn true>
	</cffunction>

	<cffunction name="listaProyectos" access="remote" returntype="query">
		<cfset fnVerificaSesion(true)>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select PRJid, PRJcodigo, PRJdescripcion, 'PRJ' + PRJcodigo + '.mpp' as PRJfileName 
			  from PRJproyecto
			 where Ecodigo = #session.Ecodigo#
			   and PRJestado = '1'
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="leeProyecto" access="remote" returntype="query">
		<cfargument name="PRJid" type="string">

		<cfset fnVerificaSesion(true)>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select p.PRJarchivo, p.Cmayor, p.CFformatoNiv1, n.PCNlongitud as CFrecursoLon
			  from PRJproyecto p
				   INNER JOIN PCNivelMascara n
					  ON n.PCEMid = p.PCEMid
					 AND n.PCNid  = p.PCNidRecurso
			 where p.Ecodigo=#session.Ecodigo#
			   and p.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="grabaProyecto" access="remote" returntype="boolean">
		<cfargument name="PRJid" type="string">
		<cfargument name="PRJcodigo" type="string">
		<cfargument name="PRJdescripcion" type="string">
		<cfargument name="PRJarchivo" type="binary">
		
		<cfset fnVerificaSesion(true)>
		<cfquery name="rsUsuario" datasource="#Session.DSN#">
			update PRJproyecto 
			   set PRJdescripcion=<cfqueryparam cfsqltype="cf_sql_char" value="#PRJdescripcion#">
			      ,PRJarchivo    =<cfqueryparam cfsqltype="cf_sql_blob" value="#PRJarchivo#">
			 where Ecodigo=#session.Ecodigo#
			   and PRJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
		</cfquery>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="listaCuentas" access="remote" returntype="query">
		<cfargument name="PRJid" type="string">
		<cfargument name="Cmayor" type="string">
		<cfargument name="CFformatoNiv1" type="string">

		<cfset fnVerificaSesion(true)>
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as total
			  from PCNivelMascara n
				   INNER JOIN PRJproyecto p
				      ON n.PCEMid = p.PCEMid
			 where p.Ecodigo=#session.Ecodigo#
			   and p.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
		</cfquery>
		<cfset LvarTot = rsSQL.total>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			SELECT PCNlongitud
			  FROM PCNivelMascara n
				   INNER JOIN PRJproyecto p
				      ON n.PCEMid = p.PCEMid
			 WHERE p.Ecodigo=#session.Ecodigo#
			   AND p.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
			   AND n.PCNid <= p.PCNidRecurso
			  ORDER BY p.PCNidRecurso
		</cfquery>
		
		<cfset LvarIni = 0>
		<cfloop query="rsSQL">
			<cfif rsSQL.currentRow LT rsSQL.recordCount>
				<cfset LvarIni = LvarIni + rsSQL.PCNlongitud + 1>
			<cfelse>
				<cfset LvarLon = rsSQL.PCNlongitud>
			</cfif>
		</cfloop>
		<cfset LvarIni = LvarIni + 6>
		
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select DISTINCT
				   substring(CFformato,1,#LvarIni-1#) || '#repeatString("R",LvarLon)#'
				<cfif rsSQL.recordCount LT LvarTot>
					|| substring(CFformato,#LvarIni+LvarLon#,100)
				</cfif>
					as CFformato
				  , CFdescripcion 
			  from CFinanciera
			 where Ecodigo=#session.Ecodigo#
			   and Cmayor = <cfqueryparam cfsqltype="cf_sql_char" value="#Cmayor#">
			   <cfif CFformatoNiv1 NEQ "">
			   and CFformato like '#Cmayor#-#CFformatoNiv1#%'
			   </cfif>
			   and CFmovimiento = 'S'
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>

	<cffunction name="leeActividades" access="remote" returntype="query">
		<cfargument name="PRJid" type="string">

		<cfset fnVerificaSesion(true)>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 
				 a.PRJAid,
				 a.PRJAnivel,
				 a.PRJAorden,
				 a.PRJAcodigo,
				 a.PRJAdescripcion,
				 a.PRJAduracion,
				 a.PRJAunidadTiempo,
				 a.PRJAfechaInicio,
				 a.PRJAfechaFinal,
				 a.PRJAporcentajeAvance,
				 a.PRJAcostoActual,
				 r.PRJRcodigo,
				 r.PRJRdescripcion,
				 r.PRJtipoRecurso,
				 r.Ucodigo,
				 pr.PRJPRcostoUnitModificado as PRJPRcostoUnit,
				 ar.PRJARcantidadModificada as PRJARcantidad,
				 ar.PRJARcantidadModificada*pr.PRJPRcostoUnitModificado as PRJARcosto,
				 ar.PRJARcantidadReal,
				 ar.PRJARcostoReal
			  from PRJActividad a 
				    LEFT JOIN PRJActividadRecurso ar
					   INNER JOIN PRJProyectoRecurso pr
						  ON pr.PRJid = ar.PRJid
						 AND pr.PRJRid = ar.PRJRid
					   INNER JOIN PRJRecurso r
						  ON r.PRJRid = ar.PRJRid
					  ON ar.PRJid = a.PRJid
					 AND ar.PRJAid = a.PRJAid
			 where a.Ecodigo=#session.Ecodigo#
			   and a.PRJid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#PRJid#">
			  order by a.PRJApath
		</cfquery>
		<cfreturn rsSQL>
	</cffunction>


	<cffunction name="fnVerificaSesion" access="private">
		<cfargument name="ConLogin" type="boolean">
		
		<cfsetting enablecfoutputonly="yes">
			<cfapplication name="SIF_ASP" 
			sessionmanagement="Yes"
			clientmanagement="Yes"
			setclientcookies="Yes"
			sessiontimeout=#CreateTimeSpan(0,10,0,0)#>
		<cfheader name = "Expires" value = "0">
		<cfparam name="Session.Idioma" default="ES_CR">

		<cfif arguments.ConLogin AND (NOT isdefined("Session.Usucodigo") OR Session.Usucodigo EQ 0)>
			<cfthrow message="No se ha autenticado al portal">
		</cfif>
	</cffunction>

</cfcomponent>