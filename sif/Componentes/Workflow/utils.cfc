<cffunction name="query2CFC" access="public">
	<cfargument name="query" type="query" required="yes">
	<cfargument name="cfc"   type="any"   required="yes">

	<cfset props = GetMetaData(Arguments.cfc).properties>

	<cfset Arguments.cfc.RecordCount = Arguments.query.RecordCount>
	<cfif Arguments.query.RecordCount>
		<cfloop from="1" to="#ArrayLen(props)#" index="i">
			<cfif IsDefined('Arguments.query.' & props[i].name)>
				<cfset "Arguments.cfc.#props[i].name#" = Arguments.query[ props[i].name]>
			</cfif>
		</cfloop>
	</cfif>
</cffunction>

<!---
	Busca el CF de un usuario:
	Depende del parámetro 3500:
		USU:		en UsuarioCFuncional
		EMP:		en EmpleadoCFuncional
		"":			RH:
			Primero,	si es empleado y está nombrado: 		busca en LineaTiempo
			sino, 		si es empleado y lo están nombrando: 	busca en RHAcciones
--->
<cffunction name="CF_usuario" access="package" output="false" returntype="query">
	<cfargument name="Usucodigo" type="numeric" required="yes">

	<cfquery name="rsSQL" datasource="#session.DSN#">
		select Pvalor
		  from Parametros
		 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		   and Pcodigo=3500
	</cfquery>
	<cfset LvarTipoUsuCF = trim(rsSQL.Pvalor)>

	<cfset cf = QueryNew('CFpk,CFpkresp,CFboss')>

	<cfif LvarTipoUsuCF EQ "USU">
		<cfquery datasource="#session.dsn#" name="cf">
			select 	cf.CFid as CFpk, cf.CFidresp as CFpkresp,
					case
						when cf.CFuresponsable = #session.Usucodigo# then 1
						else 0
					end as CFboss
			  from UsuarioCFuncional cfu
				inner join CFuncional cf on cf.CFid = cfu.CFid
			 where cfu.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and cfu.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
		</cfquery>
	<cfelseif LvarTipoUsuCF EQ "EMP">
		<cfquery datasource="#session.dsn#" name="infousuario" maxrows="1">
			select b.llave
			from UsuarioReferencia b
			where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
		</cfquery>
		<cfif Len(infousuario.llave)>
			<cfquery datasource="#session.dsn#" name="cf">
				select 	cf.CFid as CFpk, cf.CFidresp as CFpkresp,
						case
							when cf.CFuresponsable = #session.Usucodigo# then 1
							else 0
						end as CFboss
				  from EmpleadoCFuncional eaf
					inner join DatosEmpleado e		on e.DEid = eaf.DEid
					inner join CFuncional cf		on cf.CFid = eaf.CFid
				 where eaf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and eaf.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
				   and <cf_dbfunction name="today"> between ECFdesde and ECFhasta
			</cfquery>
		</cfif>
	<cfelse>
		<cfquery datasource="#session.dsn#" name="infousuario" maxrows="1">
			select b.llave
			from UsuarioReferencia b
			where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
			  and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			  and b.STabla = <cfqueryparam cfsqltype="cf_sql_varchar" value="DatosEmpleado">
		</cfquery>
		<cfif Len(infousuario.llave)>
			<!--- si el usuario es un empleado y ya esta nombrado--->
			<cfquery datasource="#session.dsn#" name="cf">
				select 	cf.CFid as CFpk, cf.CFidresp as CFpkresp,
						case
							when coalesce(cf.CFuresponsable,-2) = #session.Usucodigo# then 1
							when lt.RHPid = cf.RHPid then 1
							else 0
						end as CFboss
				from LineaTiempo lt
					inner join RHPlazas pl
						on pl.RHPid = lt.RHPid
						and pl.Ecodigo = lt.Ecodigo
					inner join CFuncional cf
						on cf.CFid = pl.CFid
				where lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
				  and <cf_dbfunction name="today"> between lt.LTdesde and lt.LThasta<!--- fcastro 18-5-12  se cambia la funcion 'now' por 'today' recortar la fecha actual sin horas, minutos y segundos--->
			</cfquery>

			<cfif not cf.recordcount>
				<!--- si el usuario es un empleado y lo estan nombrando (NO TIENE LT)--->
				<cfquery datasource="#session.dsn#" name="cf">
					select 	cf.CFid as CFpk, cf.CFidresp as CFpkresp,
							case
								when coalesce(cf.CFuresponsable,-2) = #session.Usucodigo# then 1
								when Accion.RHPid = cf.RHPid then 1
								else 0
							end as CFboss
					from RHAcciones Accion
					join RHPlazas pl
						 on pl.RHPid = Accion.RHPid
						and pl.Ecodigo = Accion.Ecodigo
					join RHTipoAccion p
						on p.RHTid=Accion.RHTid
						and RHTcomportam  =1
					join CFuncional cf
						on cf.CFid = pl.CFid
					where Accion.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Accion.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#infousuario.llave#">
					  and <cf_dbfunction name="today"> between Accion.DLfvigencia and coalesce(Accion.DLffin,<cfqueryparam cfsqltype="cf_sql_date" value="#createDate(6100,1,1)#">)<!--- fcastro 18-5-12  se cambia la funcion 'now' por 'today' recortar la fecha actual sin horas, minutos y segundos--->
					  and Accion.RHAlinea = (select max(b.RHAlinea) from RHAcciones b where b.DEid = Accion.DEid)
				</cfquery>
			</cfif>
		</cfif>
	</cfif>

	<cfreturn cf>
</cffunction>

<!---
	Busca el JEFE y sus Asistentes de un usuario:
	Asistentes dependen del Tipo Tramite:
		Busca el CF del Usuario
		Busca el Jefe y Asistentes del CF
		Si el Usuario es el Jefe del CF o no hay Jefe ni Asistentes se repite para los CFs padres hasta RAIZ
		Si el Usuario es el Jefe del CF pero no encuentra Jefe ni Asistentes en los Padres, se escoge el mismo
--->
<cffunction name="jefeAsistentes_usuario" access="package" output="false" returntype="query">
	<cfargument name="Usucodigo" type="numeric" required="yes">
	<cfargument name="pakage" 	 type="string"	required="yes">

	<cfset cf = CF_usuario(Arguments.Usucodigo)>
	<cfif cf.Recordcount>
		<cfinvoke component="utils" method="jefeAsistentes_cf" returnvariable="real_users">
			<cfinvokeargument name="centro_funcional"	value="#cf.CFpk#">
			<cfinvokeargument name="pakage"				value="#arguments.pakage#">
			<cfinvokeargument name="Usucodigo"			value="#arguments.Usucodigo#">
		</cfinvoke>
		<cfif cf.CFboss EQ 1 AND real_users.recordCount EQ 0>
			<!--- Aunque el Usuario sea jefe del CF, no se encontró ningún jefe ni asistentes de CFs padres --->
			<!--- O sea, el Usuario es el jefe de más alto nivel --->
			<cfinvoke component="utils" method="jefeAsistentes_cf" returnvariable="real_users">
				<cfinvokeargument name="centro_funcional"	value="#cf.CFpk#">
				<cfinvokeargument name="pakage"				value="#arguments.pakage#">
			</cfinvoke>
		</cfif>
		<cfif real_users.recordCount GT 0>
			<cfreturn real_users>
		</cfif>
	</cfif>

	<cfset real_users = QueryNew('Usucodigo,Name,Description')>
	<cflog file="workflow" text="jefeAsistentes_usuario(): no se encontro el usuario">
	<cfreturn real_users>
</cffunction>

<!---
	Busca el JEFE y sus Asistentes de un CF:
	Asistentes dependen del Tipo Tramite:
		Busca el Usuario Jefe (plaza o responsable)
			Si el Jefe de CF original es el Usuario Interesado se repite para CF padre
			Busca Asistentes
			Si no hay Jefe ni Asistentes se repite para CF padre hasta RAIZ
			Si llega a RAIZ devuelve un query vacío
--->
<cffunction name="jefeAsistentes_cf" access="package" output="false" returntype="query">
	<cfargument name="centro_funcional" type="numeric" required="yes">
	<cfargument name="pakage" 	 		type="string" required="yes">
	<cfargument name="usucodigo" 		type="numeric" default="0">

	<cfset LvarAssistantType = fnAssistantType(Arguments.pakage)>
	<cflog file="workflow" text="jefeAsistentes_cf(#Arguments.centro_funcional#): entrando">
	<cfset centro_funcional_actual = Arguments.centro_funcional>
	<cfloop condition="Len(centro_funcional_actual)">
		<!--- Busca al Jefe --->
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select cf.Ecodigo, CFuresponsable, lt.DEid as DEid_jefe, CFidresp
			from CFuncional cf
				left join RHPlazas pl
					on cf.RHPid = pl.RHPid
				left join LineaTiempo lt
					on lt.RHPid = pl.RHPid
					and <cf_dbfunction name="today"> between LTdesde and LThasta<!--- fcastro 18-5-12  se cambia la funcion 'now' por 'today' recortar la fecha actual sin horas, minutos y segundos--->
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#centro_funcional_actual#">
			  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarJefeUsucodigo = buscar_cf.CFuresponsable>
		<cfif buscar_cf.RecordCount GT 0 AND LvarJefeUsucodigo EQ "" AND buscar_cf.DEid_jefe NEQ "">
			<cfquery datasource="#session.dsn#" name="buscar_cfJ"><!--- fcastro 17-5-12 se cambia el  nombre de la variable buscar_cf por buscar_cfJ----->
				select ur.Usucodigo
				  from UsuarioReferencia ur
				 where ur.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#buscar_cf.DEid_jefe#">
				   and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				   and ur.STabla = 'DatosEmpleado'
			</cfquery>
			<cfset LvarJefeUsucodigo = buscar_cfJ.Usucodigo>
		</cfif>

		<!---
			Si el Jefe de CF original es el Usuario Interesado se repite para CF padre
			Busca Asistentes
			Si no hay Jefe ni Asistentes se repite para CF padre hasta RAIZ
		--->
		<cfif NOT (LvarJefeUsucodigo EQ arguments.Usucodigo AND centro_funcional_actual EQ Arguments.centro_funcional)>
			<!--- Jefe y Asistentes --->
			<!--- Depende del tipo Tramite --->
			<cf_dbfunction name="op_concat" returnvariable="_Cat" datasource="#session.dsn#">
			<cfquery datasource="#session.dsn#" name="real_users">
				select u.Usucodigo, dp.Pid as Name, dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description
				from Usuario u
					join DatosPersonales dp
						on dp.datos_personales = u.datos_personales
				where
				<cfif NOT (LvarJefeUsucodigo EQ arguments.Usucodigo OR LvarJefeUsucodigo EQ "")>
					u.Usucodigo = #LvarJefeUsucodigo# OR
				</cfif>
				<cfif LvarAssistantType EQ "AUT">
					(
				   		select count(1)
						  from CFautoriza
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
					) > 0
				<cfelseif LvarAssistantType EQ "TES">
					(
				   		select count(1)
						  from TESusuarioSP
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
						   and TESUSPaprobador = 1
					) > 0
				<cfelseif LvarAssistantType EQ "PRES">
					(
				   		select count(1)
						  from CPSeguridadUsuario
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
						   and CPSUaprobacion = 1
					) > 0
				<cfelse>
					<cfthrow message="No se ha implementado AssistantType = '#LvarAssistantType#'">
				</cfif>
				order by u.Usucodigo
			</cfquery>
			<cfif real_users.recordCount GT 0>
				<cfreturn real_users>
			</cfif>
		</cfif>

		<cfset centro_funcional_actual = buscar_cf.CFidresp>

		<cfparam name="real_users" default="#QueryNew('Usucodigo,Name,Description')#">
		<cflog file="workflow" text="jefeAsistentes_cf(2)=RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#,Name=#real_users.Name#,Description:#real_users.Description#">
	</cfloop>

	<cfset real_users = QueryNew('Usucodigo,Name,Description')>
	<cflog file="workflow" text="jefeAsistentes_cf(): no se encontro ningun jefe">
	<cfreturn real_users>
</cffunction>


<cffunction name="jefeAPROBADOR_cf" access="package" output="false" returntype="query">
	<cfargument name="centro_funcional" type="numeric" required="yes">
	<cfargument name="pakage" 	 		type="string" required="yes">
	<cfargument name="usucodigo" 		type="numeric" default="0">

	<cfset LvarAssistantType = fnAssistantType(Arguments.pakage)>
	<cflog file="workflow" text="jefeAPROBADOR_cf(#Arguments.centro_funcional#): entrando">
	<cfset centro_funcional_actual = Arguments.centro_funcional>
	<cfloop condition="Len(centro_funcional_actual)">
		<!--- Busca al Jefe --->
		<cfquery datasource="#session.dsn#" name="buscar_cf">
			select cf.Ecodigo, CFuaprobado,CFuresponsable, lt.DEid as DEid_jefe, CFidresp
			from CFuncional cf
				left join RHPlazas pl
					on cf.RHPid = pl.RHPid
				left join LineaTiempo lt
					on lt.RHPid = pl.RHPid
					and <cf_dbfunction name="today"> between LTdesde and LThasta<!--- fcastro 18-5-12  se cambia la funcion 'now' por 'today' recortar la fecha actual sin horas, minutos y segundos--->
			where cf.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#centro_funcional_actual#">
			  and cf.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfset LvarJefeUsucodigo = buscar_cf.CFuaprobado>
		<cfif buscar_cf.RecordCount GT 0 AND LvarJefeUsucodigo EQ "" AND buscar_cf.DEid_jefe NEQ "">
			<cfquery datasource="#session.dsn#" name="buscar_cfJ"><!--- fcastro 17-5-12 se cambia el  nombre de la variable buscar_cf por buscar_cfJ----->
				select ur.Usucodigo
				  from UsuarioReferencia ur
				 where ur.llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#buscar_cf.DEid_jefe#">
				   and ur.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
				   and ur.STabla = 'DatosEmpleado'
			</cfquery>
			<cfset LvarJefeUsucodigo = buscar_cfJ.Usucodigo>
		</cfif>

		<!---
			Si el Jefe de CF original es el Usuario Interesado se repite para CF padre
			Busca Asistentes
			Si no hay Jefe ni Asistentes se repite para CF padre hasta RAIZ
		--->
		<!--- OPARRALES 2018-05-15
			- Se antepone validacion para el caso donde el aprobador sea el mismo que hace la solicitud
			- le llegue la notificacion y lo pueda aprobar... Con el fin de seguir y mantener el flujo de aprobaciones.
		 --->

		<cfif LvarJefeUsucodigo neq "" and LvarJefeUsucodigo EQ arguments.Usucodigo or (NOT (LvarJefeUsucodigo EQ arguments.Usucodigo AND centro_funcional_actual EQ Arguments.centro_funcional))>

			<!--- Jefe y Asistentes --->
			<!--- Depende del tipo Tramite --->
			<cf_dbfunction name="op_concat" returnvariable="_Cat" datasource="#session.dsn#">
			<cfquery datasource="#session.dsn#" name="real_users">
				select u.Usucodigo, dp.Pid as Name, dp.Pnombre #_CAT# ' ' #_CAT# dp.Papellido1 #_CAT# ' ' #_CAT# dp.Papellido2 as Description
				from Usuario u
					join DatosPersonales dp
						on dp.datos_personales = u.datos_personales
				where
				<!--- OPARRALES 2018-05-15
					- Validacion para agregar Usucodigo al where cuando el aprobador es el mismo que solicita.
				--->
				<cfif LvarJefeUsucodigo NEQ "" and LvarJefeUsucodigo EQ arguments.Usucodigo>
					u.Usucodigo = #LvarJefeUsucodigo# OR
				<cfelseif NOT (LvarJefeUsucodigo EQ arguments.Usucodigo OR LvarJefeUsucodigo EQ "")>
					u.Usucodigo = #LvarJefeUsucodigo# OR
				</cfif>
				<cfif LvarAssistantType EQ "AUT">
					(
				   		select count(1)
						  from CFautoriza
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
					) > 0
				<cfelseif LvarAssistantType EQ "TES">
					(
				   		select count(1)
						  from TESusuarioSP
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
						   and TESUSPaprobador = 1
					) > 0
				<cfelseif LvarAssistantType EQ "PRES">
					(
				   		select count(1)
						  from CPSeguridadUsuario
						 where Ecodigo	= #session.Ecodigo#
						   and Usucodigo= u.Usucodigo
						   and CFid		= #centro_funcional_actual#
						   and CPSUaprobacion = 1
					) > 0
				<cfelse>
					<cfthrow message="No se ha implementado AssistantType = '#LvarAssistantType#'">
				</cfif>
				order by u.Usucodigo
			</cfquery>


			<cfif real_users.recordCount GT 0>
				<cfreturn real_users>
			</cfif>
		</cfif>

		<cfset centro_funcional_actual = buscar_cf.CFidresp>

		<cfparam name="real_users" default="#QueryNew('Usucodigo,Name,Description')#">
		<cflog file="workflow" text="jefeAsistentes_cf(2)=RecordCount=#real_users.RecordCount#, Usucodigo=#real_users.Usucodigo#,Name=#real_users.Name#,Description:#real_users.Description#">
	</cfloop>

	<cfset real_users = QueryNew('Usucodigo,Name,Description')>
	<cflog file="workflow" text="jefeAsistentes_cf(): no se encontro ningun jefe">
	<cfreturn real_users>
</cffunction>

<cffunction name="fnAssistantType" returntype="string" output="false">
	<cfargument name="pakage" 	 		type="string" required="yes">

	<cfset LvarType = listGetAt(arguments.pakage,1,"/")>
	<!--- RH,Acciones de Personal;RHPP,Planilla Presupuestaria;CM,Solicitudes de Compras;TESSP,Solicitudes de Pago Tesorería;TPRES,Traslados de Presupuesto; --->
	<cfif LvarType EQ "TESSP">
		<cfreturn "TES">
	<cfelseif LvarType EQ "TPRES">
		<cfreturn "PRES">
	<cfelse>
		<cfreturn "AUT">
	</cfif>
</cffunction>

<cffunction name="version_formato" returntype="string" output="false">
	<cfargument name="Version" type="string">

	<cfset v1 = Right('     ' & ListFirst(Arguments.Version,'.'), 4)>
	<cfset v2 = Right('     ' & ListRest (Arguments.Version,'.'), 5)>
	<cfreturn v1 & '.' & v2>
</cffunction>

<cffunction name="version_incrementa" returntype="string" output="true">
	<cfargument name="VersionQuery" type="query">
	<cfargument name="Field" type="numeric" default="2">

	<cfif Not ListFind('1,2',Arguments.Field)>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DebeSer"
		Default="debe ser"
		returnvariable="MSG_DebeSer"/>
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_O"
		Default="o"
		returnvariable="MSG_O"/>

		<cf_errorCode	code = "51409"
						msg  = "Field @errorDat_1@ 1 @errorDat_2@ 2"
						errorDat_1="#MSG_DebeSer#"
						errorDat_2="#MSG_O#"
		>
	</cfif>

	<cfset max_version_1 = 0>
	<cfset max_version_2 = 0>

	<cfloop query="VersionQuery">
		<cfset v1 = Trim(ListFirst(Version, '.'))>
		<cfif ListLen(Version, '.') GT 1>
			<cfset v2 = Trim(ListGetAt(Version, 2, '.'))>
		<cfelse>
			<cfset v2 = ''>
		</cfif>
		<cfif REFind('^[0-9]+$', v1)>
			<cfset cur_version_1 = Int(v1)>
			<cfif REFind('^[0-9]+$', v2)>
				<cfset cur_version_2 = Int(v2)>
			<cfelse>
				<cfset cur_version_2 = 0>
			</cfif>
		<cfelse>
			<cfset cur_version_1 = 0>
			<cfset cur_version_2 = 0>
		</cfif>

		<cfif cur_version_1 gt max_version_1>
			<cfset max_version_1 = cur_version_1>
			<cfset max_version_2 = cur_version_2>
		<cfelseif cur_version_1 is max_version_1 and cur_version_2 gt max_version_2>
			<cfset max_version_2 = cur_version_2>
		</cfif>
	</cfloop>
	<cfif Arguments.Field is 1>
		<cfset max_version_1 = max_version_1 + 1>
		<cfset max_version_2 = 0>
	<cfelse>
		<cfset max_version_2 = max_version_2 + 1>
	</cfif>
	<cfreturn max_version_1 & '.' & max_version_2>
</cffunction>

