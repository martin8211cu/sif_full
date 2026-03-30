<cfif isdefined("url.insertar_default")>
	<cftry>
		<cfquery datasource="asp">
			insert IndicadorUsuario( Usucodigo, Ecodigo, indicador, posicion, BMfecha, BMUsucodigo )
			select #session.Usucodigo#, #session.EcodigoSDC#, indicador, posicion, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, #session.Usucodigo#
			from Indicador
			where es_default = 1
			order by posicion
		</cfquery>
	<cfcatch type="any"></cfcatch>
	</cftry>
<cfelseif isdefined("form.btnEliminar")>
	<cfquery datasource="asp">
		delete IndicadorUsuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
		  and indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">
	</cfquery>
</cfif>

<!--- resecuenciar --->
<cfquery name="data" datasource="asp">
	select indicador, posicion
	from IndicadorUsuario
	where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
	order by posicion  
</cfquery>

<cfset LvarPos = 10 >
<cfoutput query="data">
	<cfif LvarPos neq data.posicion>
		<cfquery datasource="asp">
			update IndicadorUsuario
			set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPos#">
			where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoSDC#">
			  and indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(data.indicador)#">
		</cfquery>
	</cfif>
	<cfset LvarPos = LvarPos + 10 >
</cfoutput>

<cflocation url="personalizar.cfm?redirected=1">