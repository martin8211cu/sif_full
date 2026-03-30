

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHGrupoMateriaCF"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="CFid"
				type1="numeric"
				value1="#form.CFid#"
			
				field2="RHGMid"
				type2="numeric"
				value2="#form.RHGMid#"
			
		>
	
	<cfquery datasource="#session.dsn#">
		update RHGrupoMateriaCF
		set Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#Len(form.CFid) Is 0#">
		  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" null="#Len(form.RHGMid) Is 0#">
	</cfquery>

	<cflocation url="RHGrupoMateriaCF.cfm?CFid=#URLEncodedFormat(form.CFid)#&RHGMid=#URLEncodedFormat(form.RHGMid)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete RHGrupoMateriaCF
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#Len(form.CFid) Is 0#">  and RHGMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" null="#Len(form.RHGMid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHGrupoMateriaCF (
			
			CFid,
			RHGMid,
			Ecodigo,
			BMfecha,
			
			BMUsucodigo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#" null="#Len(form.CFid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHGMid#" null="#Len(form.RHGMid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHGrupoMateriaCF.cfm">


