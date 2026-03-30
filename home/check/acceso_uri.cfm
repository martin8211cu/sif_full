<!--- funciones usadas en acceso.cfm --->
<!---
	acceso_uri_paths
	Descompone un uri en una lista que contiene tanto el 
	mismo uri como todos sus ancestros, excepto '/'.
	Esta lista se utiliza para buscar los SComponentes 
	que podrían usarse para obtener acceso al URI indicado
--->
<cfsetting enablecfoutputonly="yes">
<cffunction name="acceso_RegistroProceso" output="false">
	<cfargument name="Proceso" required="yes">
	<cfargument name="SScodigo" required="yes">
	<cfargument name="SMcodigo" required="yes">
	<cfargument name="SPcodigo" required="yes">
	<cfargument name="setcontext" type="boolean" default="false">

	<cfif len(arguments.Proceso) GT 0>
		<cfset session.Proceso.proceso_autorizado10 = session.Proceso.proceso_autorizado09>
		<cfset session.Proceso.proceso_autorizado10_setcontext = session.Proceso.proceso_autorizado09_setcontext>
		<cfset session.Proceso.proceso_autorizado10_SScodigo   = session.Proceso.proceso_autorizado09_SScodigo>
		<cfset session.Proceso.proceso_autorizado10_SMcodigo   = session.Proceso.proceso_autorizado09_SMcodigo>
		<cfset session.Proceso.proceso_autorizado10_SPcodigo   = session.Proceso.proceso_autorizado09_SPcodigo>

		<cfset session.Proceso.proceso_autorizado09 = session.Proceso.proceso_autorizado08>
		<cfset session.Proceso.proceso_autorizado09_setcontext = session.Proceso.proceso_autorizado08_setcontext>
		<cfset session.Proceso.proceso_autorizado09_SScodigo   = session.Proceso.proceso_autorizado08_SScodigo>
		<cfset session.Proceso.proceso_autorizado09_SMcodigo   = session.Proceso.proceso_autorizado08_SMcodigo>
		<cfset session.Proceso.proceso_autorizado09_SPcodigo   = session.Proceso.proceso_autorizado08_SPcodigo>

		<cfset session.Proceso.proceso_autorizado08 = session.Proceso.proceso_autorizado07>
		<cfset session.Proceso.proceso_autorizado08_setcontext = session.Proceso.proceso_autorizado07_setcontext>
		<cfset session.Proceso.proceso_autorizado08_SScodigo   = session.Proceso.proceso_autorizado07_SScodigo>
		<cfset session.Proceso.proceso_autorizado08_SMcodigo   = session.Proceso.proceso_autorizado07_SMcodigo>
		<cfset session.Proceso.proceso_autorizado08_SPcodigo   = session.Proceso.proceso_autorizado07_SPcodigo>

		<cfset session.Proceso.proceso_autorizado07 = session.Proceso.proceso_autorizado06>
		<cfset session.Proceso.proceso_autorizado07_setcontext = session.Proceso.proceso_autorizado06_setcontext>
		<cfset session.Proceso.proceso_autorizado07_SScodigo   = session.Proceso.proceso_autorizado06_SScodigo>
		<cfset session.Proceso.proceso_autorizado07_SMcodigo   = session.Proceso.proceso_autorizado06_SMcodigo>
		<cfset session.Proceso.proceso_autorizado07_SPcodigo   = session.Proceso.proceso_autorizado06_SPcodigo>

		<cfset session.Proceso.proceso_autorizado06 = session.Proceso.proceso_autorizado05>
		<cfset session.Proceso.proceso_autorizado06_setcontext = session.Proceso.proceso_autorizado05_setcontext>
		<cfset session.Proceso.proceso_autorizado06_SScodigo   = session.Proceso.proceso_autorizado05_SScodigo>
		<cfset session.Proceso.proceso_autorizado06_SMcodigo   = session.Proceso.proceso_autorizado05_SMcodigo>
		<cfset session.Proceso.proceso_autorizado06_SPcodigo   = session.Proceso.proceso_autorizado05_SPcodigo>

		<cfset session.Proceso.proceso_autorizado05 = session.Proceso.proceso_autorizado04>
		<cfset session.Proceso.proceso_autorizado05_setcontext = session.Proceso.proceso_autorizado04_setcontext>
		<cfset session.Proceso.proceso_autorizado05_SScodigo   = session.Proceso.proceso_autorizado04_SScodigo>
		<cfset session.Proceso.proceso_autorizado05_SMcodigo   = session.Proceso.proceso_autorizado04_SMcodigo>
		<cfset session.Proceso.proceso_autorizado05_SPcodigo   = session.Proceso.proceso_autorizado04_SPcodigo>

		<cfset session.Proceso.proceso_autorizado04 = session.Proceso.proceso_autorizado03>
		<cfset session.Proceso.proceso_autorizado04_setcontext = session.Proceso.proceso_autorizado03_setcontext>
		<cfset session.Proceso.proceso_autorizado04_SScodigo   = session.Proceso.proceso_autorizado03_SScodigo>
		<cfset session.Proceso.proceso_autorizado04_SMcodigo   = session.Proceso.proceso_autorizado03_SMcodigo>
		<cfset session.Proceso.proceso_autorizado04_SPcodigo   = session.Proceso.proceso_autorizado03_SPcodigo>

		<cfset session.Proceso.proceso_autorizado03 = session.Proceso.proceso_autorizado02>
		<cfset session.Proceso.proceso_autorizado03_setcontext = session.Proceso.proceso_autorizado02_setcontext>
		<cfset session.Proceso.proceso_autorizado03_SScodigo   = session.Proceso.proceso_autorizado02_SScodigo>
		<cfset session.Proceso.proceso_autorizado03_SMcodigo   = session.Proceso.proceso_autorizado02_SMcodigo>
		<cfset session.Proceso.proceso_autorizado03_SPcodigo   = session.Proceso.proceso_autorizado02_SPcodigo>

		<cfset session.Proceso.proceso_autorizado02 = session.Proceso.proceso_autorizado01>
		<cfset session.Proceso.proceso_autorizado02_setcontext = session.Proceso.proceso_autorizado01_setcontext>
		<cfset session.Proceso.proceso_autorizado02_SScodigo   = session.Proceso.proceso_autorizado01_SScodigo>
		<cfset session.Proceso.proceso_autorizado02_SMcodigo   = session.Proceso.proceso_autorizado01_SMcodigo>
		<cfset session.Proceso.proceso_autorizado02_SPcodigo   = session.Proceso.proceso_autorizado01_SPcodigo>

		<cfset session.Proceso.proceso_autorizado01 = session.Proceso.proceso_autorizado00>
		<cfset session.Proceso.proceso_autorizado01_setcontext = session.Proceso.proceso_autorizado00_setcontext>
		<cfset session.Proceso.proceso_autorizado01_SScodigo   = session.Proceso.proceso_autorizado00_SScodigo>
		<cfset session.Proceso.proceso_autorizado01_SMcodigo   = session.Proceso.proceso_autorizado00_SMcodigo>
		<cfset session.Proceso.proceso_autorizado01_SPcodigo   = session.Proceso.proceso_autorizado00_SPcodigo>

		<cfset session.Proceso.proceso_autorizado00            = Arguments.Proceso>
		<cfset session.Proceso.proceso_autorizado00_setcontext = Arguments.setcontext>
		<cfset session.Proceso.proceso_autorizado00_SScodigo   = Arguments.SScodigo>
		<cfset session.Proceso.proceso_autorizado00_SMcodigo   = Arguments.SMcodigo>
		<cfset session.Proceso.proceso_autorizado00_SPcodigo   = Arguments.SPcodigo>
		
		<cfset Session.Proceso.proceso_Ecodigo                 = Session.Ecodigo>
	</cfif>

	<cfreturn true>
</cffunction>

<cffunction name="acceso_VerificaProceso" output="false">
	<cfargument name="Proceso" required="yes">
	<!--- Si la estructura no se ha definido, o si el usuario cambio de empresa, se debe de inicializar --->

	<cfset var LvarInit = not isdefined("session.proceso.proceso_Ecodigo") or not isdefined("session.Ecodigo") or (Session.proceso.proceso_Ecodigo NEQ session.Ecodigo)>
	<cfif NOT LvarInit AND isdefined("session.monitoreo.forzar") and session.monitoreo.forzar>
		<cfset LvarInit = true>
	</cfif>

	<cfif LvarInit>
		<cfset session.monitoreo.forzar = false>
		<cfif isdefined("Session.Ecodigo") and Session.Ecodigo GT 0>
			<cfset Session.Proceso.proceso_Ecodigo = Session.Ecodigo>
		<cfelse>
			<cfset Session.Proceso.proceso_Ecodigo = 0>
		</cfif>
		<cfset Session.Proceso.proceso_autorizado10 = "">
		<cfset session.Proceso.proceso_autorizado10_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado10_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado10_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado10_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado09 = "">
		<cfset session.Proceso.proceso_autorizado09_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado09_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado09_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado09_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado08 = "">
		<cfset session.Proceso.proceso_autorizado08_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado08_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado08_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado08_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado07 = "">
		<cfset session.Proceso.proceso_autorizado07_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado07_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado07_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado07_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado06 = "">
		<cfset session.Proceso.proceso_autorizado06_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado06_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado06_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado06_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado05 = "">
		<cfset session.Proceso.proceso_autorizado05_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado05_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado05_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado05_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado04 = "">
		<cfset session.Proceso.proceso_autorizado04_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado04_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado04_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado04_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado03 = "">
		<cfset session.Proceso.proceso_autorizado03_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado03_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado03_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado03_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado02 = "">
		<cfset session.Proceso.proceso_autorizado02_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado02_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado02_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado02_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado01 = "">
		<cfset session.Proceso.proceso_autorizado01_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado01_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado01_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado01_SPcodigo   = "">

		<cfset Session.Proceso.proceso_autorizado00 = "">
		<cfset session.Proceso.proceso_autorizado00_setcontext = 0>
		<cfset session.Proceso.proceso_autorizado00_SScodigo   = "">
		<cfset session.Proceso.proceso_autorizado00_SMcodigo   = "">
		<cfset session.Proceso.proceso_autorizado00_SPcodigo   = "">

		<cfreturn false>
	</cfif>

	<cfif session.Proceso.proceso_autorizado00 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado00_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado00_SScodigo & ',' 
				& session.Proceso.proceso_autorizado00_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado00_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado00_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado00_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado00_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado01 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado01_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado01_SScodigo & ',' 
				& session.Proceso.proceso_autorizado01_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado01_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado01_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado01_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado01_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado02 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado02_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado02_SScodigo & ',' 
				& session.Proceso.proceso_autorizado02_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado02_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado02_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado02_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado02_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado03 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado03_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado03_SScodigo & ',' 
				& session.Proceso.proceso_autorizado03_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado03_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado03_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado03_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado03_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado04 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado04_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado04_SScodigo & ',' 
				& session.Proceso.proceso_autorizado04_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado04_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado04_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado04_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado04_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado05 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado05_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado05_SScodigo & ',' 
				& session.Proceso.proceso_autorizado05_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado05_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado05_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado05_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado05_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado06 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado06_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado06_SScodigo & ',' 
				& session.Proceso.proceso_autorizado06_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado06_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado06_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado06_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado06_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado07 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado07_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado07_SScodigo & ',' 
				& session.Proceso.proceso_autorizado07_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado07_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado07_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado07_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado07_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado08 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado08_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado08_SScodigo & ',' 
				& session.Proceso.proceso_autorizado08_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado08_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado08_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado08_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado08_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado09 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado09_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado09_SScodigo & ',' 
				& session.Proceso.proceso_autorizado09_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado09_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado09_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado09_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado09_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfif session.Proceso.proceso_autorizado10 eq Arguments.Proceso>
		<cfif session.Proceso.proceso_autorizado10_setcontext>
			<cfset monitoreo_modulo = session.Proceso.proceso_autorizado10_SScodigo & ',' 
				& session.Proceso.proceso_autorizado10_SMcodigo & ',' 
				& session.Proceso.proceso_autorizado10_SPcodigo>
			<cfset session.monitoreo.SScodigo = session.Proceso.proceso_autorizado10_SScodigo>
			<cfset session.monitoreo.SMcodigo = session.Proceso.proceso_autorizado10_SMcodigo>
			<cfset session.monitoreo.SPcodigo = session.Proceso.proceso_autorizado10_SPcodigo>
		</cfif>
		<cfreturn true>
	</cfif>
	<cfreturn false>
</cffunction>

<cffunction name="acceso_uri_paths" output="false">
	<cfargument name="uri" required="yes">
	<cfset var p = Find('/', uri, 2)>
	<cfset var uri_list = ''>
	<cfloop from="1" to="20" index="dummy">
		<!--- maximo de 20 iteraciones para que no se encicle --->
		<cfif p EQ 0>
			<cfbreak>
		</cfif>
		<cfset uri_list = ListAppend(uri_list, "'" & Mid(arguments.uri, 1, p) & "'")>
		<cfset p = Find('/', uri, p + 1)>
	</cfloop>
	<cfif (Len(uri_list) EQ 0) OR (Mid(arguments.uri, Len(arguments.uri), 1) NEQ '/')>
		<cfset uri_list = ListAppend(uri_list, "'" & arguments.uri & "'")>
	</cfif>
	<cfreturn uri_list>
</cffunction>


<cffunction name="grant_access" output="false" returntype="boolean">
	<cfargument name="Ecodigo" required="yes">
	<cfargument name="SScodigo" required="yes">
	<cfargument name="SMcodigo" required="yes">
	<cfargument name="SPcodigo" required="yes">
	<cfargument name="setcontext" type="boolean" default="false">
	<cfargument name="proceso" type="string" required="yes">
	
	<cfif Arguments.setcontext>
		<!---
		    Primero verifica si el horario y dirección  IP de acceso son válidos, si aplica
		    Como setcontext viene en false para objetos públicos y anónimos,
		    sólo se verifica en operaciones con permisos asignados
		--->
		<cfif Not IsDefined('Request.PoliticasEmpresariales')>
			<cfinvoke component="home.Componentes.Politicas" method="trae_parametros_cuenta"
				CEcodigo="#session.CEcodigo#" returnvariable="Request.PoliticasEmpresariales"/>
		</cfif>
		<cfif Request.PoliticasEmpresariales.auth.validar.ip is 1 Or Request.PoliticasEmpresariales.auth.validar.horario is 1>
			<cfquery datasource="asp" name="grant_access_acceso_remoto">
				select ar.acceso, ar.SScodigo, ar.SRcodigo
				from UsuarioRol ur
					join SProcesosRol pr
						on ur.SScodigo = pr.SScodigo
						and ur.SRcodigo = pr.SRcodigo
					join AccesoRol ar
						on ar.SScodigo = pr.SScodigo
						and ar.SRcodigo = pr.SRcodigo
					<cfif Request.PoliticasEmpresariales.auth.validar.ip is 1>
						<cfinvoke component="home.Componentes.NormalizarIP" method="NormalizarIP"
							direccion="#session.sitio.ip#" returnvariable="ipNormal"/>
						join AccesoIP ai
							on ai.acceso = ar.acceso
							and <cfqueryparam cfsqltype="cf_sql_varchar" value="#ipNormal#">
								between ai.ipdesdeNormal and ai.iphastaNormal
					</cfif>
					<cfif Request.PoliticasEmpresariales.auth.validar.horario is 1>
						join AccesoHorario ah
							on ah.acceso = ar.acceso
							and ah.dia = <cfqueryparam cfsqltype="cf_sql_integer" value="#DatePart('w', Now())#">
							and <cfqueryparam cfsqltype="cf_sql_varchar" value="# TimeFormat(Now(), 'HHmm') #">
								between ah.desde and ah.hasta
					</cfif>
				where ur.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				  and pr.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SScodigo#">
				  and pr.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SMcodigo#">
				  and pr.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SPcodigo#">
			</cfquery>
			<cfif Not(grant_access_acceso_remoto.RecordCount)>
				<cfset Request.RestriccionAccesoRemoto = Arguments>
				<cfreturn false>
			</cfif>
		</cfif>
	</cfif>
	
	<cfif Arguments.setcontext>
		<cfset monitoreo_modulo = Trim(Arguments.SScodigo) & ',' & Trim(Arguments.SMcodigo) & ',' & Trim(Arguments.SPcodigo)>
		<cfset session.monitoreo.SScodigo = Arguments.SScodigo>
		<cfset session.monitoreo.SMcodigo = Arguments.SMcodigo>
		<cfset session.monitoreo.SPcodigo = Arguments.SPcodigo>
	</cfif>
	
	<cfif (Not IsDefined("session.EcodigoSDC") Or Len(Session.EcodigoSDC) Is 0 Or Session.EcodigoSDC Is 0)
	    and Arguments.Ecodigo Neq 0 >
		<!--- este if neq 0 && neq 1 es para que no se haga bolas con los objetos públicos --->
		<cfset CreateObject("Component","functions").seleccionar_empresa(Arguments.Ecodigo)>
	</cfif>
	<cfset Lvar_Dummy = acceso_RegistroProceso(Arguments.proceso, Arguments.SScodigo, Arguments.SMcodigo, Arguments.SPcodigo, Arguments.setcontext)>
	<cfreturn true>
</cffunction>

<cffunction name="test_access" returntype="boolean" output="false">
	<cfargument name="proceso" required="yes">
	<cfargument name="proc_query" type="query">
	<cfargument name="setcontext" type="boolean" default="false">
 
	<cfloop query="proc_query">
		<cfif proc_query.SCtipo eq 'D'>	<!--- acceso por directorio, sin subdirectorios --->
			<cfif find(proc_query.SCuri, Arguments.proceso) eq 1 and find('/', Arguments.proceso, Len(Arguments.proceso)+1) EQ 0 
						And grant_access(0, proc_query.SScodigo, proc_query.SMcodigo, proc_query.SPcodigo, setcontext, arguments.proceso)>
				<cfreturn true>
			</cfif>
		<cfelseif proc_query.SCtipo eq 'S'>	<!--- acceso por directorio con subdirectorios --->
			<cfif find(proc_query.SCuri, Arguments.proceso) eq 1 
						And grant_access(0, proc_query.SScodigo, proc_query.SMcodigo, proc_query.SPcodigo, setcontext, arguments.proceso)>
				<cfreturn true>
			</cfif>
		<cfelse> <!--- Acceso especifico al uri  --->
			<cfif Trim(Arguments.proceso) eq Trim(proc_query.SCuri)
						And grant_access(0, proc_query.SScodigo, proc_query.SMcodigo, proc_query.SPcodigo, setcontext, arguments.proceso)>
				<cfreturn true>
			</cfif>
		</cfif>
	</cfloop>
	<cfreturn false>
</cffunction>

<cffunction name="acceso_uri" returntype="boolean" output="false">
	<cfargument name="proceso" required="yes">
	<cfargument name="setcontext" type="boolean" default="false">
	<!--- obtiene la lista del URL y sus ancestros --->
	<cfset var uri_paths = acceso_uri_paths(Arguments.proceso)>
	
	<cfif Find('?',Arguments.proceso)>
		<cfset Arguments.proceso = ListFirst(Arguments.proceso,'?')>
	</cfif>
	<!--- Verifica en la session si la pagina esta dentro de las ultimas 20 registradas.  En ese caso, el usuario tiene permiso de ejecucion --->
	<cfset Lvar_Dummy = false>
	<cfif len(Arguments.proceso)>
		<cfset Lvar_Dummy = acceso_VerificaProceso(Arguments.proceso)>
		<cfif Lvar_Dummy eq true>
			<cfreturn true>
		</cfif>	
	</cfif>
	<!--- el orden entre los queries es importante para no perder session.monitoreo --->
	<cfif session.Usucodigo NEQ 0>
		<!---
			se quita el atributo maxrows="1" porque podría darse que
			haya acceso posible por más de un proceso, pero los roles
			activos según el horario solamente permitan el acceso por
			uno de estos procesos y no sea necesariamente el primero.
		--->
		<cfquery name="perm1" datasource="asp" debug="no" maxrows="1">
			select 
				a.Ecodigo, 
				e.SCtipo, 
				e.SCuri, 
				rtrim (e.SScodigo) as SScodigo,
				rtrim (e.SMcodigo) as SMcodigo, 
				rtrim (e.SPcodigo) as SPcodigo,
				case when e.SScodigo = '#session.monitoreo.SScodigo#'
					then 1
					<cfif IsDefined('session.menues.SScodigo')>
					when e.SScodigo = '#session.menues.SScodigo#'
					then 2
					</cfif>
					else 0 end isSS,
				case when e.SMcodigo = '#session.monitoreo.SMcodigo#'
					then 1
					<cfif IsDefined('session.menues.SMcodigo')>
					when e.SMcodigo = <cfif not IsDefined('session.menues.SMcodigo')> null <cfelse>'#session.menues.SMcodigo#'</cfif>
					then 2 
					</cfif> else 0 end isSM,
				case when e.SPcodigo = '#session.monitoreo.SPcodigo#'
					then 1
					<cfif IsDefined('session.menues.SPcodigo')>
					when e.SPcodigo = '#session.menues.SPcodigo#'
					then 2
					</cfif> else 0 end isSP,
				case when a.Ecodigo = #session.Ecodigo#
					then 1 else 0 end isEmp,
					case when sp.SPhomeuri =  e.SCuri then 1 else 0 end as paginaHome
			from vUsuarioProcesos a
				inner join SComponentes e
					on e.SScodigo = a.SScodigo
				   	and e.SMcodigo = a.SMcodigo
				   	and e.SPcodigo = a.SPcodigo 
			    inner join SProcesos sp 
			            on e.SScodigo = sp.SScodigo 
			            and e.SMcodigo = sp.SMcodigo 
			            and e.SPcodigo = sp.SPcodigo 
			where a.Usucodigo = #session.Usucodigo#
			  <cfif isdefined("session.EcodigoSDC")>
				  and a.Ecodigo = #session.EcodigoSDC#
			  </cfif>
			  and e.SCuri in (#preservesinglequotes(uri_paths)#)
			order by paginaHome desc, isSS desc, isSM desc, isSP desc, isEmp desc, e.SCuri desc
			<cf_isolation nivel="read_uncommitted" datasource="asp">
		</cfquery>

		<cfif test_access(Arguments.proceso, perm1, setcontext)>
			<cfreturn true>
		</cfif>
		
		<!--- Permiso no encontrado ver si es publico --->
		<cfquery name="perm1" datasource="asp" debug="no" maxrows="1">
			select 0 as Ecodigo, SCtipo, SCuri, rtrim (e.SScodigo) as SScodigo,
				rtrim (e.SMcodigo) as SMcodigo, rtrim (e.SPcodigo) as SPcodigo,
				case when e.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#">
					then 1
					<cfif IsDefined('session.menues.SScodigo')>
					when e.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
					then 2
					</cfif>
					else 0 end isSS,
				case when e.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#">
					then 1
					<cfif IsDefined('session.menues.SMcodigo')>
					when e.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#" null="#not IsDefined('session.menues.SMcodigo')#">
					then 2 
					</cfif> else 0 end isSM,
				case when e.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
					then 1
					<cfif IsDefined('session.menues.SPcodigo')>
					when e.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#" null="#not IsDefined('session.menues.SPcodigo')#">
					then 2
					</cfif> else 0 end isSP
			from SProcesos a
				inner join SComponentes e
				on e.SScodigo = a.SScodigo
				and e.SMcodigo = a.SMcodigo
				and e.SPcodigo = a.SPcodigo 
			where a.SPpublico = 1
			  and e.SCuri in (#preservesinglequotes(uri_paths)#)
			order by isSS desc, isSM desc, isSP desc, e.SCuri desc
		</cfquery>
		<cfif test_access(Arguments.proceso, perm1, false)>
			<cfreturn true>
		</cfif>
	</cfif>
	
	<!--- Permiso no encontrado ver si hay acceso anonimo --->
	<cfquery name="perm1" datasource="asp" debug="no" maxrows="1">
		select 0 as Ecodigo, SCtipo, SCuri, rtrim (e.SScodigo) as SScodigo,
				rtrim (e.SMcodigo) as SMcodigo, rtrim (e.SPcodigo) as SPcodigo,
			case when e.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#">
				then 1
				<cfif IsDefined('session.menues.SScodigo')>
				when e.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SScodigo#">
				then 2
				</cfif>
				else 0 end isSS,
			case when e.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SMcodigo#">
				then 1
				<cfif IsDefined('session.menues.SMcodigo')>
				when e.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SMcodigo#" null="#not IsDefined('session.menues.SMcodigo')#">
				then 2 
				</cfif> else 0 end isSM,
			case when e.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SPcodigo#">
				then 1
				<cfif IsDefined('session.menues.SPcodigo')>
				when e.SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#" null="#not IsDefined('session.menues.SPcodigo')#">
				then 2
				</cfif> else 0 end isSP
		from SProcesos a
			inner join SComponentes e
			on e.SScodigo = a.SScodigo
			and e.SMcodigo = a.SMcodigo
			and e.SPcodigo = a.SPcodigo 
		where a.SPanonimo = 1
		  and e.SCuri in (#preservesinglequotes(uri_paths)#)
		order by isSS desc, isSM desc, isSP desc, e.SCuri desc
	</cfquery>
	<cfif test_access(Arguments.proceso, perm1, false)>
		<cfreturn true>
	</cfif>
	<cfreturn false>
</cffunction>
<cfsetting enablecfoutputonly="no">
