<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM012"
		redirect="impresoras.cfm"
		timestamp="#form.ts_rversion#"
			
		field1="FAM12COD"
		type1="numeric"
		value1="#form.FAM12COD#" >
	
	<cfquery name="update" datasource="#session.DSN#">
		update FAM012 set
		FAM12CODD= <cfqueryparam value="#Form.FAM12CODD#" cfsqltype="cf_sql_integer">,
		FAM12DES= <cfqueryparam value="#Form.FAM12DES#" cfsqltype="cf_sql_varchar">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_varchar">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM12COD = <cfqueryparam value="#form.FAM12COD#" cfsqltype="cf_sql_numeric">
	 </cfquery> 

	<cflocation url="impresoras.cfm?FAM12COD=#form.FAM12COD#">
	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM012
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and FAM12COD = <cfqueryparam value="#form.FAM12COD#" cfsqltype="cf_sql_numeric">
	</cfquery>
 	

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM012( Ecodigo, FAM12CODD, FAM12DES, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAM12CODD#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM12DES#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>

<cflocation url="impresoras.cfm">