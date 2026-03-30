<cfparam name="form.P2000"	default="">
<cfif isDefined("Form.btnAceptar")>
	<cfset fnGrabaParametro(2000,"", "DSN destino para Cargar Datos al Modelo Multidimensional",
							form.P2000, 
							false
							)>
</cfif>

<cflocation url="Parametros.cfm">

<!--- Graba los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="fnGrabaParametro" returntype="void">
	<cfargument name="Pcodigo"		type="numeric" required="true">	
	<cfargument name="Mcodigo"		type="string" required="true">	
	<cfargument name="Pdescripcion"	type="string" required="true">	
	<cfargument name="Pvalor"		type="string" required="true">	
	<cfargument name="obligatorio"	type="boolean" required="true">
	<cfargument name="Pdefault"		type="string" required="no">

	<cfif Arguments.Pvalor EQ "">
		<cfif Arguments.obligatorio>
			<cf_errorCode	code = "50781"
							msg  = "Debe digitar un valor para el parámetro @errorDat_1@"
							errorDat_1="#Arguments.Pdescripcion#"
			>
		</cfif>
		<cfquery datasource="#Session.DSN#">
			delete Parametros 
			 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			   and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>				
	</cfif>

	<cfif Arguments.Pvalor NEQ "" OR isdefined("Arguments.Pdefault")>
		<cfif Arguments.Pvalor EQ "" AND isdefined("Arguments.Pdefault")>
			<cfset Arguments.Pvalor = Arguments.Pdefault>
		</cfif>
		<cfquery name="rsSQL" datasource="#Session.DSN#">
			select count(1) as cantidad
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">  
			  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfquery datasource="#Session.DSN#">
				insert INTO Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Mcodigo)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pvalor)#"> 
					)
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				update Parametros 
					set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.Pvalor)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Pcodigo#">			
			</cfquery>				
		</cfif>
	</cfif>
</cffunction>


