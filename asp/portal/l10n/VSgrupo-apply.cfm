

<cfif IsDefined("form.Cambio")>
	
	
	
	
	
	
	
	
		
		
	
		<cf_dbtimestamp datasource="sifcontrol"
				table="VSgrupo"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="VSgrupo"
				type1="integer"
				value1="#form.VSgrupo#"
			
		>
	
	<cfquery datasource="sifcontrol">
		update VSgrupo
		set VSnombre_grupo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.VSnombre_grupo#" null="#Len(form.VSnombre_grupo) Is 0#">
		
		where VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.VSgrupo#" null="#Len(form.VSgrupo) Is 0#">
	</cfquery>

	<cflocation url="VSgrupo.cfm?VSgrupo=#URLEncodedFormat(form.VSgrupo)#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="sifcontrol">
		delete from VSgrupo
		where VSgrupo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.VSgrupo#" null="#Len(form.VSgrupo) Is 0#">
	</cfquery>
<cfelseif IsDefined("form.Nuevo")>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="sifcontrol">
		insert into VSgrupo (
			
			VSgrupo,
			VSnombre_grupo)
		values (
			
			<cfqueryparam cfsqltype="cf_sql_integer" value="#form.VSgrupo#" null="#Len(form.VSgrupo) Is 0#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.VSnombre_grupo#" null="#Len(form.VSnombre_grupo) Is 0#">)
	</cfquery>
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="VSgrupo.cfm">


