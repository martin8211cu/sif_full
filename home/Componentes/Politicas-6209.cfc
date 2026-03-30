<cfcomponent>

<cffunction name="QueryToStruct">
	<cfargument name="qry" type="query">
	<cfset var ret = StructNew()>
	<cfloop query="qry">
		<cfset ret[qry.parametro] = qry.valor>
	</cfloop>
	<cfreturn ret>
</cffunction>

<cffunction name="trae_parametro_global" access="public" returntype="string" output="false">
	<cfargument name="parametro" type="string">
	
	<cfset This.trae_parametros_globales()>
	<cfif StructKeyExists(Request.Politicas_PGlobal, Arguments.parametro)>
		<cfreturn Request.Politicas_PGlobal[Arguments.parametro]>
	<cfelse>
		<cflog file="politicas" text="Parametro no existe en políticas del sistema: #Arguments.parametro#">
		<cfreturn 0>
		<cfthrow message="Parametro no existe en políticas del sistema: #Arguments.parametro#">
	</cfif>
</cffunction>

<cffunction name="trae_parametros_globales" access="public" returntype="struct" output="false">
	<cfif Not IsDefined("Request.Politicas_PGlobal")>
		<cfquery datasource="asp" name="PGlobalQuery">
			select l.parametro, coalesce (g.valor, l.predeterminado) as valor
			from PLista l left outer join PGlobal g
			on g.parametro = l.parametro
			where l.es_global = 1
		</cfquery>
		<cfset Request.Politicas_PGlobal = QueryToStruct(PGlobalQuery)>
	</cfif>
	<cfreturn Request.Politicas_PGlobal>
</cffunction>

<cffunction name="modifica_parametro_global" access="public" returntype="string" output="false">
	<cfargument name="parametro" type="string">
	<cfargument name="valor" type="string" required="no" default="">
	
	<cfset valor_anterior = This.trae_parametro_global(Arguments.parametro)>
	<cfif valor_anterior is Arguments.valor><cfreturn></cfif>
	<cfquery datasource="asp" name="valor2">
		select valor
		from PGlobal
		where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
	</cfquery>
	<cfif valor2.RecordCount is 0>
		<cfquery datasource="asp">
			insert into PGlobal (parametro, valor, BMfecha, BMUsucodigo)
			values (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.valor#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>
	<cfelseif valor2.valor neq parametro>
		<cfquery datasource="asp" name="valor">
			update PGlobal
			set valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.valor#">,
				BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="trae_parametro_cuenta" access="public" returntype="string" output="false">
	<cfargument name="parametro" type="string">
	<cfargument name="CEcodigo" type="numeric" default="0">
	
	<cfquery datasource="asp" name="valor">
		select valor
		from PCuenta g
		where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
	</cfquery>
	<cfif valor.RecordCount>
		<cfreturn valor.valor>
	</cfif>
	<cfreturn trae_parametro_global(Arguments.parametro)>
	<cfreturn Arguments.predeterminado>
</cffunction>

<cffunction name="trae_parametros_cuenta" access="public" returntype="struct" output="false">
	<cfargument name="CEcodigo" type="numeric" default="0">
	
	<cfquery datasource="asp" name="PCuentaQuery">
		select  l.parametro, coalesce (c.valor, g.valor, l.predeterminado) as valor
		from PLista l
			left outer join PCuenta c
				on c.parametro = l.parametro
				and c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			left outer join PGlobal g
				on g.parametro = l.parametro
		where l.es_cuenta = 1
	</cfquery>
	<cfreturn QueryToStruct(PCuentaQuery)>
</cffunction>

<cffunction name="modifica_parametro_cuenta" access="public" returntype="string" output="false">
	<cfargument name="CEcodigo" type="numeric" default="0">
	<cfargument name="parametro" type="string">
	<cfargument name="valor" type="string" required="no" default="">
	
	<cfset valor_anterior = This.trae_parametro_cuenta(Arguments.parametro, Arguments.CEcodigo)>
	<cfif valor_anterior is Arguments.valor><cfreturn></cfif>
	<cfset valorDefault = This.trae_parametro_global(Arguments.parametro)>
	<cfquery datasource="asp" name="valor2">
		select valor
		from PCuenta
		where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
	</cfquery>
	<cfif valor2.RecordCount is 0>
		<cfif valorDefault neq Arguments.valor>
			<cfquery datasource="asp">
				insert into PCuenta (CEcodigo, parametro, valor, BMfecha, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.valor#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
	<cfelseif valor2.valor neq parametro>
		<cfif valorDefault neq Arguments.valor>
			<cfquery datasource="asp" name="valor">
				update PCuenta
				set valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.valor#">,
					BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
		<cfelse>
			<cfquery datasource="asp" name="valor">
				delete from PCuenta
				where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
				  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
			</cfquery>
		</cfif>
	</cfif>
</cffunction>

<cffunction name="trae_parametro_usuario" access="public" returntype="string" output="false">
	<cfargument name="parametro" type="string">
	<cfargument name="Usucodigo" type="numeric" default="#session.Usucodigo#">

	<cfquery datasource="asp" name="valor">
		select g.valor, u.CEcodigo
		from Usuario u left outer join PUsuario g
		  on g.Usucodigo = u.Usucodigo
		and  g.parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
		where u.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
	</cfquery>
	<cfif valor.RecordCount is 0>
		<cfthrow message="Usuario invalido: #Arguments.Usucodigo#">
	<cfelseif Len(valor.valor)>
		<cfreturn valor.valor>
	</cfif>
	<cfreturn trae_parametro_cuenta(Arguments.parametro, valor.CEcodigo)>
</cffunction>

</cfcomponent>