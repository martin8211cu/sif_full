<cfif isdefined("form.ALTA")>
	<cfquery name="rsExiste" datasource="#session.DSN#">
		select 1
		from CFExcepcionCuenta
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
		  and valor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor1#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif rsExiste.recordcount eq 0 >
		<cfquery datasource="#session.DSN#">
			insert into CFExcepcionCuenta( CFid, valor1, valor2, Ecodigo, BMUsucodigo, BMfechaalta )
			values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor1#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor2#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update CFExcepcionCuenta
			set valor2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor2#">
			where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
			  and valor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor1#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete from CFExcepcionCuenta
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFpk#">
		  and valor1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.valor1#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<cflocation url="excepciones-cf.cfm">