<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM009"
				redirect="maquinas.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="FAM09MAQ"
				type1="numeric"
				value1="#form.FAM09MAQ#" >
				
				
	
	<cfquery name="update" datasource="#session.DSN#">
		update FAM009 set
		FAM09DES= <cfqueryparam value="#Form.FAM09DES#" cfsqltype="cf_sql_varchar">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_varchar">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
	 </cfquery> 

	<cflocation url="maquinas.cfm?FAM09MAQ=#form.FAM09MAQ#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM009
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
	</cfquery>
 	


<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM009( Ecodigo,FAM09MAQ,FAM09DES, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">, 
		        <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM09DES#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
</cfif>

<cflocation url="maquinas.cfm">