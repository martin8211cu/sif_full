<cfcomponent>
	<cffunction name="ExisteLicencia" output="false" returntype="boolean" access="remote">
		<cfargument name="Tipo" 	type="string" required="yes">
		<cfargument name="Numero" 	type="string" required="yes">
		
		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Licencia 
			<cfif Arguments.Tipo EQ "L">
			 where NumeroLicencia = '#Arguments.Numero#'
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = '#Arguments.Numero#'
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o L=Licencia")>
			</cfif>
		</cfquery>

		<cfreturn (rsSQL.recordCount GT 0)>
	</cffunction>

	<cffunction name="LeeUltimaLicencia" output="false" returntype="licencia" access="remote">
		<cfargument name="Tipo" 		type="string" required="yes">
		<cfargument name="Numero" 		type="string" required="yes">
		<cfargument name="TipoLicencia" type="string" required="no" default="">

		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Licencia 
			<cfif Arguments.Tipo EQ "L">
			 where NumeroLicencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o L=Licencia")>
			</cfif>
		</cfquery>
		<cfif rsSQL.recordCount EQ 0>
			<cfif Arguments.Tipo EQ "L">
				<cfset wsThrow ("Numero Licencia #Arguments.Numero# no existe")>
			<cfelseif Arguments.Tipo EQ "I">
				<cfset wsThrow ("Numero Identificacion #Arguments.Numero# no existe")>
			</cfif>
		</cfif>

		<cfset LvarNombre = rsSQL.Nombre>
		
		<cfquery name="rsSQL" dbtype="query">
			select * from rsSQL
			<cfif Arguments.TipoLicencia NEQ "">
			 where TipoLicencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.TipoLicencia#">
			</cfif>
			 order by SecuenciaLicencia desc
		</cfquery>

		<cfif rsSQL.recordCount EQ 0>
			<cfset wsThrow ("#LvarNombre# no posee licencia tipo '#Arguments.TipoLicencia#'")>
		</cfif>

		<cfobject component="licencia" name="Resultado">
		<cfset Resultado.NumeroLicencia		= rsSQL.NumeroLicencia>
		<cfset Resultado.TipoLicencia		= rsSQL.TipoLicencia>
		<cfset Resultado.SecuenciaLicencia	= rsSQL.SecuenciaLicencia>
		<cfset Resultado.Nombre				= rsSQL.Nombre>
		<cfset Resultado.TipoIdentificacion	= rsSQL.TipoIdentificacion>
		<cfset Resultado.Identificacion		= rsSQL.Identificacion>
		<cfset Resultado.Fecha_emision		= rsSQL.Fecha_emision>
		<cfset Resultado.Fecha_renovacion	= rsSQL.Fecha_renovacion>
		<cfset Resultado.Fecha_vencimiento	= rsSQL.Fecha_vencimiento>

		<cfreturn Resultado>
	</cffunction>

	<cffunction name="ListaLicencia" output="false" returntype="licencia[]" access="remote">
		<cfargument name="Tipo" 	type="string" required="yes">
		<cfargument name="Numero" 	type="string" required="yes">
		
		<cfquery name="rsSQL" datasource="tramites">
			select * from WS_Licencia 
			<cfif Arguments.Tipo EQ "L">
			 where NumeroLicencia = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelseif Arguments.Tipo EQ "I">
			 where Identificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Numero#">
			<cfelse>
				<cfset wsThrow ("Tipo debe ser I=Identificacion o L=Licencia")>
			</cfif>
			 order by SecuenciaLicencia asc
		</cfquery>

		<cfset LvarRetorno = ArrayNew(1)>
		<cfloop query="rsSQL">
			<cfobject component="licencia" name="Resultado">
			<cfset Resultado.NumeroLicencia		= rsSQL.NumeroLicencia>
			<cfset Resultado.TipoLicencia		= rsSQL.TipoLicencia>
			<cfset Resultado.SecuenciaLicencia	= rsSQL.SecuenciaLicencia>
			<cfset Resultado.Nombre				= rsSQL.Nombre>
			<cfset Resultado.TipoIdentificacion	= rsSQL.TipoIdentificacion>
			<cfset Resultado.Identificacion		= rsSQL.Identificacion>
			<cfset Resultado.Fecha_emision		= rsSQL.Fecha_emision>
			<cfset Resultado.Fecha_renovacion	= rsSQL.Fecha_renovacion>
			<cfset Resultado.Fecha_vencimiento	= rsSQL.Fecha_vencimiento>
			
			<cfset arrayappend(LvarRetorno,Resultado)>
		</cfloop>

		<cfreturn LvarRetorno>
	</cffunction>
	
	<cffunction name="AgregaLicencia" output="false" access="remote" returntype="void">
		<cfargument name="NumeroLicencia"		type="string">
		<cfargument name="TipoLicencia"			type="string">
		<cfargument name="Nombre"				type="string">
		<cfargument name="TipoIdentificacion"	type="string">
		<cfargument name="Identificacion"		type="string">
		<cfargument name="Fecha_emision"		type="date">
		<cfargument name="Fecha_renovacion"		type="date">
		<cfargument name="Fecha_vencimiento"	type="date">
		
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
			select max(SecuenciaLicencia) as ultimo from WS_Licencia 
			 where NumeroLicencia = <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.NumeroLicencia#">
		</cfquery>
		<cfif rsSQL.ultimo eq "">
			<cfset LvarSiguiente =  1>
		<cfelse>
			<cfset LvarSiguiente =  rsSQL.ultimo + 1>
		</cfif>
		<cfquery name="rsSQL" datasource="tramites">
			insert into WS_Licencia 
				(
					NumeroLicencia,
					TipoLicencia,
					SecuenciaLicencia,
					Nombre,
					TipoIdentificacion,
					Identificacion,
					Fecha_emision,
					Fecha_renovacion,
					Fecha_vencimiento
				)
			values (
					 <cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.NumeroLicencia#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.TipoLicencia#">
					,<cfqueryparam cfsqltype="cf_sql_integer" 		value="#LvarSiguiente#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Nombre#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.TipoIdentificacion#">
					,<cfqueryparam cfsqltype="cf_sql_varchar" 	value="#Arguments.Identificacion#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.Fecha_emision#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.Fecha_renovacion#">
					,<cfqueryparam cfsqltype="cf_sql_date" 		value="#Arguments.Fecha_vencimiento#">
				)
		</cfquery>
	</cffunction>

	<cffunction name="wsThrow" output="false" access="private">
		<cfargument name="Mensaje" 	type="string" required="yes">
		<cfthrow message="WSERRTOC(#Arguments.Mensaje#)WSERRTOC">
	</cffunction>
</cfcomponent>
