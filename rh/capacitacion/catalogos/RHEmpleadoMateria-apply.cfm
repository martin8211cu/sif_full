<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
			table="RHEmpleadoMateria"
			redirect="metadata.code.cfm"
			timestamp="#form.ts_rversion#"
		
			field1="DEid"
			type1="numeric"
			value1="#form.DEid#"
		
			field2="Mcodigo"
			type2="numeric"
			value2="#form.Mcodigo#"	>
	
	<cfquery datasource="#session.dsn#">
		update RHEmpleadoMateria
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		    RHEinicio = <cfif Len(form.RHEinicio)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEinicio)#"><cfelse>null</cfif>,
		    RHEfinal = <cfif Len(form.RHEfinal)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEfinal)#"><cfelse>null</cfif>,
		    RHEnota = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEnota#" null="#Len(form.RHEnota) Is 0#">,
		    BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
		    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" >
		  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >
	</cfquery>

	<cflocation url="RHEmpleadoMateria.cfm?DEid=#URLEncodedFormat(form.DEid)#&Mcodigo=#URLEncodedFormat(form.Mcodigo)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHEmpleadoMateria
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">  
		  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHEmpleadoMateria(	DEid,
										Mcodigo,
										Ecodigo,
										RHEinicio,
										
										RHEfinal,
										RHEnota,
										BMfecha,
										BMUsucodigo )
		values (	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#" >,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#" >,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif Len(form.RHEinicio)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEinicio)#"><cfelse>null</cfif>,
					<cfif Len(form.RHEfinal)><cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.RHEfinal)#"><cfelse>null</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEnota#" null="#Len(form.RHEnota) Is 0#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> )
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHEmpleadoMateria.cfm?DEid=#URLEncodedFormat(form.DEid)#">


