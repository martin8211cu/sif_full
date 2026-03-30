<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHEncuestaPuesto"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="RHPcodigo"
				type1="char"
				value1="#form.RHPcodigo#"
			
				field2="Ecodigo"
				type2="integer"
				value2="#session.Ecodigo#"
			
				field3="EEid"
				type3="numeric"
				value3="#form.EEid#"
		>
	<cfquery datasource="#session.dsn#">
		update RHEncuestaPuesto
		set EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPid#" null="#Len(form.EPid) Is 0#">
		
		, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#Len(form.RHPcodigo) Is 0#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">
	</cfquery>
	<cflocation url="RHEncuestaPuesto.cfm?RHPcodigo=#URLEncodedFormat(form.RHPcodigo)#&EEid=#URLEncodedFormat(form.EEid)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHEncuestaPuesto
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#Len(form.RHPcodigo) Is 0#">  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHEncuestaPuesto (
			RHPcodigo,
			Ecodigo,
			EEid,
			EPid,
			BMfecha,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#Len(form.RHPcodigo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPid#" null="#Len(form.EPid) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHEncuestaPuesto.cfm?EEid=#URLEncodedFormat(form.EEid)#">


