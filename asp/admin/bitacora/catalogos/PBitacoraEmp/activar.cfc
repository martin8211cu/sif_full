<cfcomponent>

<!---
	usado desde
		(*) este directorio,
		(*) el mantenimiento de empresas /asp/catalogos/Empresas*
--->

<cffunction name="registroActual" output="false" access="public" returntype="query">
	<cfargument name="Ecodigo" type="numeric" required="yes">

	<cfquery datasource="asp" name="ret">
		select a.Ecodigo, coalesce (a.Ereferencia, -1) as Ereferencia, a.Enombre, b.PBinactivo,
			b.Ecodigo as existe, c.Ccache
		from Empresa a
			left join PBitacoraEmp b
				on b.Ecodigo = a.Ecodigo
			left join Caches c
				on c.Cid = a.Cid
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	</cfquery>
	<cfif ret.RecordCount is 0>
		<cfthrow message="Empresa incorrecta: #Arguments.Ecodigo#">
	</cfif>
	<cfreturn ret>

</cffunction>


<cffunction name="activarEmpresa" output="false" access="public">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfset var reg = registroActual(Arguments.Ecodigo)>
	<cfif reg.PBinactivo eq 1>
		<cfif Len(Trim(reg.Ccache))>
			<cfquery datasource="asp">
				<!--- si no existe no importa, porque de todos modos se regeneraría --->
				update PBitacoraTrg
				set regenerar = 1
				where cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(reg.Ccache)#">
			</cfquery>
		</cfif>
		<cfquery datasource="asp">
			update PBitacoraEmp
			set Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#reg.Ereferencia#">
			  , PBinactivo = 0
			  , BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#reg.Ecodigo#">
		</cfquery>
	</cfif>
</cffunction>

<cffunction name="inactivarEmpresa" output="false" access="public">
	<cfargument name="Ecodigo" type="numeric" required="yes">
	<cfset var reg = registroActual(Arguments.Ecodigo)>
	
	<cfif reg.PBinactivo neq 1>
		<cfif Len(Trim(reg.Ccache))>
			<cfquery datasource="asp">
				<!--- si no existe no importa, porque de todos modos se regeneraría --->
				update PBitacoraTrg
				set regenerar = 1
				where cache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(reg.Ccache)#">
			</cfquery>
		</cfif>
		<cfif Len(reg.existe)>
			<cfquery datasource="asp">
				update PBitacoraEmp
				set Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#reg.Ereferencia#">
				  , PBinactivo = 1
				  , BMfechamod = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				  , BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#reg.Ecodigo#">
			</cfquery>
		<cfelse>
			<cfquery datasource="asp">
				insert into PBitacoraEmp (
					Ecodigo, Ereferencia, PBinactivo,
					BMfechamod, BMUsucodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#reg.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#reg.Ereferencia#">, 1,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
			</cfquery>
		</cfif>
	</cfif>
</cffunction>


</cfcomponent>
