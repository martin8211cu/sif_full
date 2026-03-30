<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM001D"
		redirect="formatos_tipo_doc.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FAM01COD"
		type1="char"
		value1="#form.FAM01COD#"
		
		
		field2="CCTcodigo"
		type2="char" 
		value2="#form.CCTcodigo#">
		
				
	<cfquery name="update" datasource="#session.DSN#">
		update FAM001D
		set FMT01COD = <cfqueryparam value="#Form.FMT01COD#" cfsqltype="cf_sql_char">,			
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype="cf_sql_char">
		and CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
	</cfquery> 

	
	<cflocation url="formatos_tipo_doc.cfm?FAM01COD=#form.FAM01COD#&CCTcodigo=#form.CCTcodigo#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		 delete from FAM001D
		 where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		 and FAM01COD = <cfqueryparam value="#Form.FAM01COD#" cfsqltype="cf_sql_char">
		 and CCTcodigo = <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
 	
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM001D( Ecodigo, FAM01COD,FMT01COD, CCTcodigo, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM01COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FMT01COD#">,
				<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CCTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>			
</cfif>

<cflocation url="formatos_tipo_doc.cfm">

