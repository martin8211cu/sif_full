<cfset parametros = "">

<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
	<cfset orden = 2 >
	<cfif not len(trim(form.ETorden))>
		<cfquery datasource="sifpublica" name="rsOrden">
			select max(ETorden) as ETorden from EstadosTracking where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsOrden.RecordCount gt 0 and len(trim(rsOrden.ETorden))>
			<cfset orden = rsOrden.ETorden + 1 >
		</cfif>
	<cfelse>
		<cfset orden = form.ETorden >
	</cfif>
</cfif>

<cfif isdefined("form.Alta")>
	<cfquery datasource="sifpublica">
		insert into EstadosTracking (Ecodigo, ETcodigo, EcodigoASP, CEcodigo, ETdescripcion, Usucodigo, fechaalta, ETorden )
		values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">,	
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETdescripcion#">,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#orden#"> )
	</cfquery>
<cfelseif isdefined("form.Cambio")>
	<cf_dbtimestamp datasource="sifpublica"
					table="EstadosTracking"
					redirect="trackingEstados.cfm"
					timestamp="#form.timestamp#"
					field1="ETcodigo" 
					type1="integer" 
					value1="#form.ETcodigo#"
					field2="Ecodigo" 
					type2="integer" 
					value2="#session.Ecodigo#" >

	<cfquery datasource="sifpublica">
		update EstadosTracking 
		set ETcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">,
		    ETdescripcion=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ETdescripcion#">, 
			ETorden=<cfqueryparam cfsqltype="cf_sql_integer" value="#orden#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">
	</cfquery>
	<cfset parametros = "?ETcodigo=#form.ETcodigo#">
	
<cfelseif isdefined("form.Baja")>
	<cfquery datasource="sifpublica">
		delete from EstadosTracking 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and ETcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.ETcodigo#">
	</cfquery>
</cfif>

<cflocation url="trackingEstados.cfm#parametros#">