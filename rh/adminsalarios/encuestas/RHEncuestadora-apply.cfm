

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHEncuestadora"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="Ecodigo"
				type1="integer"
				value1="#form.Ecodigo#"
			
				field2="EEid"
				type2="numeric"
				value2="#form.EEid#"
			
		>
	
	<cfquery datasource="#session.dsn#">
		update RHEncuestadora
		set Eid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#" null="#Len(form.Eid) Is 0#">
		, RHEdefault = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEdefault')#">
		
		, RHEinactiva = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEinactiva')#">
		, RHEconfigurada = <cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEconfigurada')#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">
	</cfquery>

	<cflocation url="RHEncuestadora.cfm?Ecodigo=#URLEncodedFormat(form.Ecodigo)#&EEid=#URLEncodedFormat(form.EEid)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHEncuestadora
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHEncuestadora (
			
			Ecodigo,
			EEid,
			Eid,
			RHEdefault,
			
			RHEinactiva,
			RHEconfigurada,
			BMfecha,
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Eid#" null="#Len(form.Eid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEdefault')#">,
			
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEinactiva')#">,
			<cfqueryparam cfsqltype="cf_sql_bit" value="#IsDefined('form.RHEconfigurada')#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHEncuestadora.cfm">


