<cfcomponent>
	<cffunction name="QueryToStruct">
		<cfargument name="qry" type="query">
		<cfset var ret = StructNew()>

		<cfloop query="qry">
			<cfif SERVER.ColdFusion.ProductName EQ "Railo">
				<cfset N = ListLen(qry.parametro,".")>
				<cfloop index="i" from="1" to="#N#">
					<cfset LvarPar = listGetAt(qry.parametro,i,".")>
					<cfif i EQ 1>
						<cfset ret2 = ret>
					</cfif>
					<cfif i EQ N>
						<cfset ret2[LvarPar] = qry.valor>
					<cfelse>
						<cfparam name="ret2.#LvarPar#" default="#structnew()#">
						<cfset ret2 = ret2[LvarPar]>
					</cfif>
				</cfloop>
			<cfelse>
				<cfset ret[qry.parametro] = qry.valor>
			</cfif>
		</cfloop>
		<cfreturn ret>
	</cffunction>

	<cffunction name="trae_parametro_global" access="public" returntype="string" output="false">
		<cfargument name="parametro" type="string">
		<cfargument name="valor_default" type="string" default="0">
        <cfargument name="Conexion" type="string" default="asp" required="no">
        
        <cfif Arguments.Conexion EQ 'minisif'>
        	<cfset lvarPLista = 'aspPLista'>
        <cfelse>
        	<cfset lvarPLista = 'PLista'>
        </cfif>
        
	
		<cfif Not IsDefined("Application.Politicas_PGlobal") or Not IsDefined("Application.Politicas_PGlobal.#Arguments.parametro#")>
			<cfset This.trae_parametros_globales(Arguments.Conexion)>
		</cfif>
	
		<cfif IsDefined("Application.Politicas_PGlobal.#Arguments.parametro#")>
			<cfreturn evaluate("Application.Politicas_PGlobal.#Arguments.parametro#")>
		<cfelse>
			<cflog file="politicas" text="Parametro no existe en políticas del sistema: #Arguments.parametro#">
			<cfreturn Arguments.valor_default>
		</cfif>
	</cffunction>

	<cffunction name="trae_parametros_globales" access="public" returntype="struct" output="false">
     	<cfargument name="Conexion" type="string" default="asp" required="no">
        
		<cflock name="Politicas_CFC_Trae_Parametros_Globales" type="exclusive" timeout="3">
			<cfif Not IsDefined("Application.Politicas_PGlobal") or not isdefined("Application.Politicas_PGlobal.pass.mail.cambiar")>
				<cfquery datasource="#Arguments.Conexion#" name="rsSQL">
					select count(1) as cantidad
					  from #lvarPLista#
					 where parametro = 'pass.mail.cambiar'
				</cfquery>
				<cfif rsSQL.cantidad EQ 0>
					<cfquery datasource="#Arguments.Conexion#">
						insert into PLista (parametro, pnombre, es_global, es_cuenta, es_usuario, predeterminado,BMfecha,BMUsucodigo)
						values('pass.mail.cambiar', 'Cambio obligatorio de passwords enviados por mail',1,1,1,'0', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> ,1)
					</cfquery>
					<cfquery datasource="#Arguments.Conexion#">
						insert into PGlobal (parametro, valor, BMfecha,BMUsucodigo)
						values('pass.mail.cambiar', '0', <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> ,1)
					</cfquery>
				</cfif>
		
                <cfquery datasource="#Arguments.Conexion#" name="PGlobalQuery">
                    select l.parametro, coalesce (g.valor, l.predeterminado) as valor
                    from #lvarPLista# l 
                        left outer join PGlobal g
                        on g.parametro = l.parametro
                    where l.es_global = 1
                </cfquery>
                <cfset Application.Politicas_PGlobal = QueryToStruct(PGlobalQuery)>
			</cfif>
		</cflock>
		<cfreturn Application.Politicas_PGlobal>
	</cffunction>

	<cffunction name="modifica_parametro_global" access="public" returntype="string" output="false">
		<cfargument name="parametro" type="string">
		<cfargument name="valor" type="string" required="no" default="">
		
		<cfset valor_anterior = This.trae_parametro_global(Arguments.parametro)>
		<cfif valor_anterior is Arguments.valor><cfreturn></cfif>
		
		<cflock name="Politicas_CFC_Trae_Parametros_Globales" type="exclusive" timeout="3">
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
				<cfquery datasource="asp">
					update PGlobal
					set valor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.valor#">,
						BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
				</cfquery>
			</cfif>
			<cfif isdefined("Application.Politicas_PGlobal.#Arguments.parametro#")>
				<cfset Application.Politicas_PGlobal[Arguments.parametro] = Arguments.valor>
			</cfif>
		</cflock>
	</cffunction>

	<cffunction name="trae_parametro_cuenta" access="public" returntype="string" output="false">
		<cfargument name="parametro" type="string">
		<cfargument name="CEcodigo" type="numeric" default="0">
		<cfset LvarParametro = Arguments.Parametro & "_" & CEcodigo>
		<cfif IsDefined("Application.Politicas_PCuenta") and isdefined("Application.Politicas_PCuenta.#Lvarparametro#")>
			<cfreturn Application.Politicas_PCuenta[Lvarparametro]>
		</cfif>
		
		<cfquery datasource="asp" name="valor">
			select valor
			from PCuenta g
			where parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.parametro#">
			  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CEcodigo#">
		</cfquery>
		<cfif valor.RecordCount GT 0>
			<cfset Application.Politicas_PCuenta[Lvarparametro] = valor.valor>
			<cfreturn valor.valor>
		</cfif>
		<cfreturn trae_parametro_global(Arguments.parametro)>
	</cffunction>

	<cffunction name="trae_parametros_cuenta" access="public" returntype="struct" output="false">
		<cfargument name="CEcodigo" type="numeric" default="0">
		
		<cfquery datasource="asp" name="PCuentaQuery">
			select  l.parametro, coalesce (c.valor, g.valor, l.predeterminado) as valor
			from PLista l
				left outer join PCuenta c
					on c.parametro = l.parametro
					and c.CEcodigo = #Arguments.CEcodigo#
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
			where parametro = '#Arguments.parametro#'
			  and CEcodigo = #Arguments.CEcodigo#
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
					where parametro = '#Arguments.parametro#'
					  and CEcodigo = #Arguments.CEcodigo#
				</cfquery>
			<cfelse>
				<cfquery datasource="asp" name="valor">
					delete from PCuenta
					where parametro = '#Arguments.parametro#'
					  and CEcodigo = #Arguments.CEcodigo#
				</cfquery>
			</cfif>
		</cfif>
		<cfset LvarParametro = Arguments.parametro & "_" & Arguments.CEcodigo>
		<cfset Application.Politicas_PCuenta[Lvarparametro] = Arguments.valor>
	</cffunction>

	<cffunction name="trae_parametro_usuario" access="public" returntype="string" output="false">
		<cfargument name="parametro" type="string">
		<cfargument name="Usucodigo" type="numeric" default="#session.Usucodigo#">

		<cfset LvarCEcodigo = 0>	
		<cfif not isdefined("session.CEcodigo") or Arguments.Usucodigo NEQ Session.Usucodigo>
			<cfquery datasource="asp" name="valor">
				select CEcodigo
				from Usuario u
				where u.Usucodigo = #Arguments.Usucodigo#
			</cfquery>
			<cfif valor.recordcount NEQ 0>
				<cfset LvarCEcodigo = valor.CEcodigo>
			</cfif>
		<cfelse>
			<cfset LvarCEcodigo = session.CEcodigo>
		</cfif>
	
		<cfquery datasource="asp" name="valor">
			select g.valor
			from PUsuario g
			where g.Usucodigo = #Arguments.Usucodigo#
			  and g.parametro = '#Arguments.parametro#'
		</cfquery>
		<cfif valor.RecordCount NEQ 0>
			<cfreturn valor.valor>
		</cfif>
		<cfreturn trae_parametro_cuenta(Arguments.parametro, LvarCEcodigo)>
	</cffunction>
</cfcomponent>