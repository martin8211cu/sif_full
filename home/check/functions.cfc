<cfcomponent >

<cffunction name="seleccionar_empresa" access="public" output="true">
	<cfargument name="EcodigoSDC" type="numeric"><!--- 0 => Primera que se encuentre --->
	
	<cfif Arguments.EcodigoSDC Neq 0 and Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0
		and session.sitio.Ecodigo Neq Arguments.EcodigoSDC>
		<cfthrow message="No se permite cambiar de empresa para este sitio.">
	</cfif>
	
	<!--- olvidar adonde estaba --->
	<cfset session.Ecodigo    = 0>
	<cfset session.EcodigoSDC = 0>
	<cfset session.DSN        = "">
	<cfset session.Enombre    = "">
	<cfset session.dsinfo     = "">
	<cfset session.EcodigoCorp= 0>
	

	<cfif IsDefined("session.Usucodigo") and Len(session.Usucodigo) neq 0 and session.Usucodigo neq 0>
		<cfquery datasource="asp" name="Preferencias">
			select Ecodigo from Preferencias
			where Usucodigo = #session.Usucodigo#
		</cfquery>
		<cfquery name="_rsEmpresasUsuario" datasource="asp" cachedwithin="#createtimespan(0, 0, 3, 0)#">
			select min(Ecodigo) as Ecodigo
			from vUsuarioProcesos up 
			where up.Usucodigo = #Session.Usucodigo# 
				<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
				  and up.Ecodigo   = #session.sitio.Ecodigo#
				<cfelseif Arguments.EcodigoSDC Neq 0>
				  and up.Ecodigo   = #Arguments.EcodigoSDC#
				<cfelseif Len(Preferencias.Ecodigo)>
				  and up.Ecodigo   = #Preferencias.Ecodigo#
				</cfif>
		</cfquery>
		
		<cfif not len(trim(_rsEmpresasUsuario.Ecodigo))>
			<!--- Si no encuentra la empresa anterior, da la primera empresa --->
			<cfquery name="_rsEmpresasUsuario" datasource="asp">
				select min(Ecodigo) as Ecodigo
				from vUsuarioProcesos up 
				where up.Usucodigo = #Session.Usucodigo# 
			</cfquery>
		</cfif>

		<cfif not len(trim(_rsEmpresasUsuario.Ecodigo))>
			<cfthrow message="No tiene acceso a ninguna empresa, Usuario #session.Usucodigo#">
		</cfif>

		<!--- si estoy logueado, ver que tenga permiso de entrar a esta empresa --->
		<cfquery name="rsSeleccionarEmpresaQuery" datasource="asp">
			select e.Ecodigo, c.Ccache, coalesce ( e.Ereferencia, 0 ) as Ereferencia, e.Enombre, e.CEcodigo, e.Eactiva
			from Empresa e, Caches c 
			where e.Ecodigo = #_rsEmpresasUsuario.Ecodigo#
			  and c.Cid = e.Cid 
			<cfif _rsEmpresasUsuario.recordcount GT 1>
				order by e.Eactiva desc <!---habiendo varias empresas, mostrar primero la que esté habilitada--->
			</cfif>
		</cfquery>
		
		<cfif rsSeleccionarEmpresaQuery.RecordCount>
			<cfif Preferencias.RecordCount Is 0>
				<cfquery datasource="asp">
					insert into Preferencias (Usucodigo, Ecodigo, BMfecha, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSeleccionarEmpresaQuery.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
				</cfquery>
			<cfelseif Preferencias.Ecodigo neq rsSeleccionarEmpresaQuery.Ecodigo>
				<cfquery datasource="asp">
					update Preferencias
					set Ecodigo = #rsSeleccionarEmpresaQuery.Ecodigo#
					,   BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					,   BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where Usucodigo = #session.Usucodigo#
				</cfquery>
			</cfif>
		</cfif>
	<cfelse>
		<!--- si no estoy logueado, ver que tenga haya algo público para esta empresa --->
		<cfquery name="rsSeleccionarEmpresaQuery" datasource="asp" >
			select e.Ecodigo, c.Ccache, coalesce ( e.Ereferencia, 0 ) as Ereferencia, e.Enombre, e.CEcodigo, e.Eactiva
			from Empresa e, Caches c
			where c.Cid = e.Cid
			<cfif Arguments.EcodigoSDC Neq 0>
			  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EcodigoSDC#">
			</cfif>
			<cfif Len(session.sitio.CEcodigo) and session.sitio.CEcodigo neq 0>
			  and e.CEcodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.CEcodigo#">
			</cfif>
			<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
			  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
			</cfif>
			order by e.Eactiva desc <!---habiendo varias empresas, mostrar primero la que esté habilitada--->
		</cfquery>
	</cfif>
	<cfif rsSeleccionarEmpresaQuery.RecordCount NEQ 0 And rsSeleccionarEmpresaQuery.Eactiva NEQ 1>
		<cfthrow message="La empresa #rsSeleccionarEmpresaQuery.Enombre# está inactiva">
	<cfelseif rsSeleccionarEmpresaQuery.RecordCount NEQ 0>
		<cfset session.EcodigoSDC = rsSeleccionarEmpresaQuery.Ecodigo>
		<cfset session.Ecodigo    = rsSeleccionarEmpresaQuery.Ereferencia>
		<cfset session.DSN        = rsSeleccionarEmpresaQuery.Ccache>
		<cfset session.Enombre    = rsSeleccionarEmpresaQuery.Enombre>
		<!--- fcastro 2013-08-22, se carga el pais de la empresa en la session---->
		<cfquery datasource="asp" name="rsPaisActual">
			select b.Ppais
			from Empresa a
				inner join Direcciones b
					on a.id_direccion=b.id_direccion
			where a.Ecodigo= #Session.EcodigoSDC#
			and a.Ereferencia =#session.Ecodigo#
		</cfquery>
		<cfif len(rsPaisActual.Ppais)>
			<cfset session.Pais    	  = trim(rsPaisActual.Ppais)>
		</cfif>
		<cfquery datasource="asp" name="EcodigoCorp">
			select e.Ereferencia
			from CuentaEmpresarial c
				join Empresa e
				on e.Ecodigo = c.Ecorporativa
			where c.CEcodigo = #rsSeleccionarEmpresaQuery.CEcodigo#
		</cfquery>
		<cfif Len(EcodigoCorp.Ereferencia)>
			<cfset session.EcodigoCorp = EcodigoCorp.Ereferencia>
		<cfelse>
			<cfset session.EcodigoCorp = rsSeleccionarEmpresaQuery.Ereferencia>
		</cfif>		
	<cfelseif Arguments.EcodigoSDC neq 0>
		<cfthrow message="No se puede ingresar a la empresa #Arguments.EcodigoSDC#, #session.Usucodigo#">
	</cfif>

	<!--- este codigo solamente verifica que este definido el Application.dsinfo --->
	<cfinvoke component="home.Componentes.DbUtils" method="generate_dsinfo">
	<cfinvokeargument name="refresh" value="no">
	</cfinvoke>
	<cfif StructKeyExists(Application.dsinfo, session.dsn)>
		<cfset session.dsinfo = Application.dsinfo[session.dsn]>
	<cfelseif StructKeyExists(Application.dsinfo, "asp")>
		<cfset session.dsinfo = Application.dsinfo.asp>
	<cfelse>
		<cfset session.dsinfo = "">
	</cfif>
</cffunction>

<cffunction name="seleccionar_dominio">
	<cfargument name="host" required="yes">
	
	<cfset basehost = ListFirst(host,':')>
	
	<cfset session.sitio.ip = GetPageContext().getRequest().getRemoteAddr()>
	<cfset _X_Forwarded_For = GetPageContext().getRequest().getHeader("X-Forwarded-For")>
	<cfif IsDefined("_X_Forwarded_For") and Len(_X_Forwarded_For) GT 0>
		<cfset session.sitio.ip = _X_Forwarded_For>
	</cfif>
	<cfif ListLen(session.sitio.ip) GT 1>
		<cfset session.sitio.ip = Trim(ListGetAt(session.sitio.ip, 1))>
	</cfif>
	
	<!--- Obtiene el sitio, dominio, home, login, template de la BD dado un host --->
	<cfquery name="rs" datasource="asp">
		select a.Scodigo, a.dominio,
			coalesce (d.SPhomeuri, a.home, e.home) as home,
			coalesce (a.login, e.login) as login,
			coalesce (a.css, e.css) as css,
            e.footer,
			e.template, a.Ecodigo, a.CEcodigo,
			a.ssl_login, a.ssl_todo, a.ssl_home, a.ssl_dominio
		from MSDominio a
		left outer join SProcesos d    on d.SScodigo = a.SScodigo
									  and d.SMcodigo = a.SMcodigo
									  and d.SPcodigo = a.SPcodigo
		inner join MSApariencia e	   on e.id_apariencia = a.id_apariencia
		where (a.dominio       = <cfqueryparam cfsqltype="cf_sql_varchar" value=  "#basehost#"  >
		    or a.MSDaliases    = <cfqueryparam cfsqltype="cf_sql_varchar" value=  "#basehost#"  >
		    or a.MSDaliases like <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#basehost#,%">
		    or a.MSDaliases like <cfqueryparam cfsqltype="cf_sql_varchar" value=  "#basehost#,%">
		    or a.MSDaliases like <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#basehost#"  >)
		order by case when 
			a.dominio       = <cfqueryparam cfsqltype="cf_sql_varchar" value=  "#basehost#"  >
			then 0 else 1 end
	</cfquery>
	<cfset session.sitio.defaultsite = false>
	<cfif rs.RecordCount EQ 0>
		<cfset session.sitio.defaultsite = true>
		<cfset session.sitio.defaultreason = 'dominio no existe: "#basehost#"'>
	<cfelseif Len(Trim(rs.home)) NEQ 0 and Not FileExists(ExpandPath(rs.home))>
		<cfset session.sitio.defaultsite = true>
		<cfset session.sitio.defaultreason = 'home no existe: "#rs.home#"'>
	<cfelseif Len(Trim(rs.login)) NEQ 0 and Not FileExists(ExpandPath(rs.login))>
		<cfset session.sitio.defaultsite = true>
		<cfset session.sitio.defaultreason = 'login no existe: "#rs.login#"'>
	<cfelseif Len(Trim(rs.css)) NEQ 0 and Not FileExists(ExpandPath(rs.css))>
		<cfset session.sitio.defaultsite = true>
		<cfset session.sitio.defaultreason = 'css no existe: "#rs.css#"'>
	<cfelseif Len(Trim(rs.template)) NEQ 0 and Not FileExists(ExpandPath(rs.template))>
		<cfset session.sitio.defaultsite = true>
		<cfset session.sitio.defaultreason = 'plantilla no existe: "#rs.template#"'>
	</cfif>
	
	<cfif session.sitio.defaultsite >
		<!--- Obtiene los datos por default para el sitio, dominio, home, login, template de la BD --->
		<cfquery name="rs" datasource="asp">
			select a.Scodigo, a.dominio,
			coalesce (d.SPhomeuri, a.home, e.home) as home,
			coalesce (a.login, e.login) as login,
			coalesce (a.css, e.css) as css,
            e.footer,
			e.template, a.Ecodigo, a.CEcodigo,
			a.ssl_login, a.ssl_todo, a.ssl_home, a.ssl_dominio
		from MSDominio a
		left outer join SProcesos d    on d.SScodigo = a.SScodigo
									  and d.SMcodigo = a.SMcodigo
									  and d.SPcodigo = a.SPcodigo
		inner join MSApariencia e	   on e.id_apariencia = a.id_apariencia
		where a.dominio = '*'
		</cfquery>
	</cfif>
	
	<!--- Poner variables en sesión --->
	<cfset Session.sitio.Scodigo = rs.Scodigo>
	<cfset Session.sitio.home = rs.home>
	<cfset Session.sitio.login = rs.login>
	<cfset Session.sitio.template = rs.template>
	<cfset Session.sitio.dominio = rs.dominio>
	<cfset Session.sitio.Ecodigo = rs.Ecodigo>
	<cfset Session.sitio.cliente_empresarial = rs.CEcodigo>
	<cfset Session.sitio.CEcodigo = rs.CEcodigo>
	<cfset Session.sitio.ssl_login = rs.ssl_login is 1>
	<cfset Session.sitio.ssl_todo = rs.ssl_todo is 1>
	<cfset Session.sitio.ssl_home = rs.ssl_home is 1>
	<cfset Session.sitio.ssl_dominio = Trim(rs.ssl_dominio)>
	<cfset Session.sitio.css = rs.css>
    <cfset Session.sitio.footer = rs.footer>
	
	<cfif Len(session.sitio.ssl_dominio) is 0>
		<cfif session.sitio.defaultsite>
			<cfset session.sitio.ssl_dominio = session.sitio.host>
		<cfelse>
			<cfquery datasource="asp" name="defaultdom">
				select ssl_dominio from MSDominio where dominio = '*'
			</cfquery>
			<cfif Len(Trim(defaultdom.ssl_dominio))>
				<cfset session.sitio.ssl_dominio = defaultdom.ssl_dominio>
			<cfelse>
				<cfset session.sitio.ssl_dominio = session.sitio.host>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
		<cfset seleccionar_empresa(session.sitio.Ecodigo)>
	<cfelse>
		<cfset seleccionar_empresa(0)>
	</cfif>
</cffunction>

<cffunction name="login_redirect">
	<cfargument name="errormsg"    type="string"  default="">
	<cfargument name="savecontext" type="boolean" default="no">

	<cfif Arguments.savecontext and structKeyExists(session, "LastUsucodigoLogged") and len(trim(session.LastUsucodigoLogged))>
		<cfset session.LoginRequest      = StructNew()>
		<cfset session.LoginRequest.owner = session.LastUsucodigoLogged>
		<cfset structDelete(session, "LastUsucodigoLogged")>
		<cfset session.LoginRequest.uri  = CGI.SCRIPT_NAME>
		<cfset session.LoginRequest.URL  = CGI.QUERY_STRING>
		<cfset session.LoginRequest.FORM = StructNew()>
		<cfif IsDefined('FORM')><!--- cuando se trata de web services, no aparece esta estructura --->
			<cfset keys = StructKeyArray(FORM)>
			<cfif ArrayLen(keys)>
				<cfloop from="1" to="#ArrayLen(keys)#" index="ikey">
					<cfif keys[ikey] neq 'FIELDNAMES'>
						<cfset StructInsert(session.LoginRequest.FORM, 
							keys[ikey], FORM[keys[ikey]])>
					</cfif>
				</cfloop>
			</cfif>
		</cfif>
	</cfif>
	<cf_ssl secure='login' url="/cfmx/home/public/login.cfm?errormsg=#URLEncodedFormat(Arguments.errormsg)#">
	<!---
	<cflocation url="/cfmx/home/public/login.cfm?errormsg=#URLEncodedFormat(errormsg)#">
	--->
</cffunction>

</cfcomponent>