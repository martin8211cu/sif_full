<cfif IsDefined("form.Cambio")>
	<cfquery datasource="sifcontrol">
		update FMT000
		set FMT00DES = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT00DES#" null="#Len(form.FMT00DES) Is 0#">

		, FMT01SQL = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SQL#" null="#Len(form.FMT01SQL) Is 0#">
		
		, FMT01SP2 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SP2#" null="#Len(form.FMT01SP2) Is 0#">
		, FMT01SP1 = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SP1#" null="#Len(form.FMT01SP1) Is 0#">
		
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#" null="#Len(form.FMT00COD) Is 0#">
	</cfquery>
	<!--- 		, ts_rversion = <cfqueryparam cfsqltype="cf_sql_binary" value="#form.ts_rversion#" null="#Len(form.ts_rversion) Is 0#"> --->
	<cflocation url="FMT000.cfm?FMT00COD=#URLEncodedFormat(form.FMT00COD)#">

<cfelseif IsDefined("form.Baja")>
	<cftransaction>
	<cfquery datasource="sifcontrol">
		delete from FMT010
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#" null="#Len(form.FMT00COD) Is 0#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete from FMT011
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#" null="#Len(form.FMT00COD) Is 0#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete from FMT000
		where FMT00COD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#" null="#Len(form.FMT00COD) Is 0#">
	</cfquery></cftransaction>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="sifcontrol">
		insert into FMT000 (
			
			FMT00COD,
			FMT00DES,
			FMT01SQL,
			
			FMT01SP2,
			FMT01SP1)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.FMT00COD#" null="#Len(form.FMT00COD) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT00DES#" null="#Len(form.FMT00DES) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SQL#" null="#Len(form.FMT01SQL) Is 0#">,
			
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SP2#" null="#Len(form.FMT01SP2) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.FMT01SP1#" null="#Len(form.FMT01SP1) Is 0#">)
	</cfquery>
	<cflocation url="FMT000.cfm?FMT00COD=#URLEncodedFormat(form.FMT00COD)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>
<!---  Para el ts_rversion
	<cfqueryparam cfsqltype="cf_sql_binary" value="#form.ts_rversion#" null="#Len(form.ts_rversion) Is 0#"> --->
<cflocation url="FMT000.cfm">


