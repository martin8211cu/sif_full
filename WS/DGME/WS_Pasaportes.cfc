<cfcomponent>
	<cffunction name="HayPasaportes" output="false" returntype="boolean" access="remote">
		<cfargument name="Tipo" 	type="string" required="yes">
		<cfargument name="Numero" 	type="string" required="yes">
		
		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Pasaporte 
			<cfif Arguments.Tipo EQ "P">
			 where NumeroPasaporte = '#Arguments.Numero#'
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = '#Arguments.Numero#'
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o P=Pasaporte")>
			</cfif>
		</cfquery>

		<cfreturn (rsSQL.recordCount GT 0)>
	</cffunction>

	<cffunction name="LeePasaporteVigente" output="false" returntype="Pasaporte" access="remote">
		<cfargument name="Tipo" 			type="string" required="yes">
		<cfargument name="Numero" 			type="string" required="yes">
		<cfargument name="TipoPasaporte" 	type="string" required="no" default="">

		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Pasaporte 
			<cfif Arguments.Tipo EQ "P">
			 where NumeroPasaporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o P=Pasaporte")>
			</cfif>
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cfif Arguments.Tipo EQ "P">
				<cfset wsThrow ("Numero Pasaporte #Arguments.Numero# no existe")>
			<cfelseif Arguments.Tipo EQ "I">
				<cfset wsThrow ("Numero Identificacion #Arguments.Numero# no existe")>
			</cfif>
		</cfif>

		<cfset LvarNombre = rsSQL.Nombre>
		
		<cfquery name="rsSQL" dbtype="query">
			select * from rsSQL
			<cfif Arguments.TipoPasaporte NEQ "">
			 where TipoPasaporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#mid(Arguments.TipoPasaporte,1,10)#">
			</cfif>
			 order by SecuenciaPasaporte desc
		</cfquery>

		<cfif rsSQL.recordCount EQ 0>
			<cfset wsThrow ("#LvarNombre# no posee pasaporte tipo '#Arguments.TipoPasaporte#'")>
		</cfif>

		<cfobject component="Pasaporte" name="Resultado">
		<cfset Resultado.NumeroPasaporte 		= rsSQL.NumeroPasaporte >
		<cfset Resultado.TipoPasaporte 			= rsSQL.TipoPasaporte >
		<cfset Resultado.SecuenciaPasaporte		= rsSQL.SecuenciaPasaporte >
		<cfset Resultado.CodigoEstado 			= rsSQL.CodigoEstado >
		<cfset Resultado.TipoIdentificacion 	= rsSQL.TipoIdentificacion >
		<cfset Resultado.Identificacion 		= rsSQL.Identificacion >
		<cfset Resultado.Nombre 				= rsSQL.Nombre >
		<cfset Resultado.Nacionalidad			= rsSQL.Nacionalidad>
		<cfset Resultado.FechaNacimiento		= rsSQL.FechaNacimiento>
		<cfset Resultado.LugarNacimiento		= rsSQL.LugarNacimiento>
		<cfset Resultado.Sexo					= rsSQL.Sexo>
		<cfset Resultado.CodigoControl			= rsSQL.CodigoControl>
		<cfset Resultado.FechaEmision 			= rsSQL.FechaEmision >
		<cfset Resultado.FechaVencimiento 		= rsSQL.FechaVencimiento >
		<cfset Resultado.FuncionarioAutorizado	= rsSQL.FuncionarioAutorizado>

		<cfreturn Resultado>
	</cffunction>

	<cffunction name="ListaPasaporte" output="false" returntype="Pasaporte[]" access="remote">
		<cfargument name="Tipo" 	type="string" required="yes">
		<cfargument name="Numero" 	type="string" required="yes">
		
		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Pasaporte 
			<cfif Arguments.Tipo EQ "P">
			 where NumeroPasaporte = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o P=Pasaporte")>
			</cfif>
			 order by SecuenciaPasaporte asc
		</cfquery>

		<cfset LvarRetorno = ArrayNew(1)>
		<cfloop query="rsSQL">
			<cfobject component="Pasaporte" name="Resultado">
			<cfset Resultado.NumeroPasaporte 		= rsSQL.NumeroPasaporte >
			<cfset Resultado.TipoPasaporte 			= rsSQL.TipoPasaporte >
			<cfset Resultado.SecuenciaPasaporte		= rsSQL.SecuenciaPasaporte >
			<cfset Resultado.CodigoEstado 			= rsSQL.CodigoEstado >
			<cfset Resultado.TipoIdentificacion 	= rsSQL.TipoIdentificacion >
			<cfset Resultado.Identificacion 		= rsSQL.Identificacion >
			<cfset Resultado.Nombre 				= rsSQL.Nombre >
			<cfset Resultado.Nacionalidad			= rsSQL.Nacionalidad>
			<cfset Resultado.FechaNacimiento		= rsSQL.FechaNacimiento>
			<cfset Resultado.LugarNacimiento		= rsSQL.LugarNacimiento>
			<cfset Resultado.Sexo					= rsSQL.Sexo>
			<cfset Resultado.CodigoControl			= rsSQL.CodigoControl>
			<cfset Resultado.FechaEmision 			= rsSQL.FechaEmision >
			<cfset Resultado.FechaVencimiento 		= rsSQL.FechaVencimiento >
			<cfset Resultado.FuncionarioAutorizado	= rsSQL.FuncionarioAutorizado>
			
			<cfset arrayappend(LvarRetorno,Resultado)>
		</cfloop>

		<cfreturn LvarRetorno>
	</cffunction>
	
	<cffunction name="AgregaPasaporte" output="false" access="remote" returntype="void">
		<cfargument name="NumeroPasaporte" 			type="string">
		<cfargument name="TipoPasaporte" 			type="string">
		<cfargument name="CodigoEstado" 			type="string">
		<cfargument name="TipoIdentificacion" 		type="string">
		<cfargument name="Identificacion" 			type="string">
		<cfargument name="Nombre" 					type="string">
		<cfargument name="Nacionalidad" 			type="string">
		<cfargument name="FechaNacimiento" 			type="date">
		<cfargument name="LugarNacimiento" 			type="string">
		<cfargument name="Sexo" 					type="string">
		<cfargument name="FechaEmision" 			type="date">
		<cfargument name="FechaVencimiento" 		type="date">
		<cfargument name="FuncionarioAutorizado"	type="string">
		
		<cflogin>
			<cfif not isdefined("cflogin.name")>
				<cfset wsThrow ("Debe especificar Usuario y Password para utilizar esta Función")>
			</cfif>
			<cfquery name="rsSQL" datasource="tramites">
				select PWD from WS_SEG
				 where UID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cflogin.name#">
			</cfquery>
			<cfif rsSQL.recordCount EQ 0>
				<cfset wsThrow ("Usuario '#cflogin.name#' no autorizado")>
			<cfelseif rsSQL.PWD EQ cflogin.password>
				<cfquery name="rsSQL" datasource="tramites">
					update WS_SEG
					   set PWD = '#hash(cflogin.password)#'
					 where UID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cflogin.name#">
				</cfquery>
			<cfelseif rsSQL.PWD NEQ hash(cflogin.password)>
				<cfset wsThrow ("Usuario '#cflogin.name#' no autenticado")>
			</cfif>
			<cflogout>
		</cflogin>

		<cfquery name="rsSQL" datasource="tramites">
			select max(SecuenciaPasaporte) as ultimo from WS_Pasaporte 
			 where NumeroPasaporte = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.NumeroPasaporte#">
		</cfquery>
		<cfif rsSQL.ultimo eq "">
			<cfset LvarSiguiente =  1>
		<cfelse>
			<cfset LvarSiguiente =  rsSQL.ultimo + 1>
		</cfif>

		<cfset LvarCodigoControl = NumberFormat(rand()*1e10,"9999999999")>

		<cfquery name="rsSQL" datasource="tramites">
			insert into WS_Pasaporte 
				(
					NumeroPasaporte 	,
					TipoPasaporte 		,
					SecuenciaPasaporte 	,
					CodigoEstado 		,
					TipoIdentificacion 	,
					Identificacion 		,
					Nombre 				,
					Nacionalidad		,
					FechaNacimiento		,
					LugarNacimiento		,
					Sexo				,
					CodigoControl		,
					FechaEmision 		,
					FechaVencimiento 	,
					FuncionarioAutorizado	
				)
			values (
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.NumeroPasaporte#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.TipoPasaporte#">
					,<cfqueryparam cfsqltype="cf_sql_integer" 		value="#LvarSiguiente#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.CodigoEstado#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.TipoIdentificacion#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Identificacion#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Nombre#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Nacionalidad#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.FechaNacimiento#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.LugarNacimiento#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Sexo#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#LvarCodigoControl#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.FechaEmision#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.FechaVencimiento#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.FuncionarioAutorizado#">
				)
		</cfquery>
	</cffunction>

	<cffunction name="wsThrow" output="false" access="private">
		<cfargument name="Mensaje" 	type="string" required="yes">
		<cfthrow message="WSERRTOC(#Arguments.Mensaje#)WSERRTOC">
	</cffunction>
</cfcomponent>
