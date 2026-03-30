<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM014"
				redirect="maq_imp.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="FAM09MAQ"
				type1="tinyint"
				value1="#form.FAM09MAQ#" 
				
				field2="CCTcodigo"
				type2="char"
				value2="#form.CCTcodigo#" >
				
	
	<cfquery name="update" datasource="#session.DSN#">
		update FAM014 set
		FAM09MAQ = <cfqueryparam value="#Form.FAM09MAQ#" cfsqltype="cf_sql_numeric">,
		FAM12COD = <cfqueryparam value="#Form.FAM12COD#" cfsqltype="cf_sql_numeric">,
		CCTcodigo= <cfqueryparam value="#Form.CCTcodigo#" cfsqltype="cf_sql_char">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_varchar">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
		and CCTcodigo = <cfqueryparam value="#form.CCTcodigo#" cfsqltype="cf_sql_char">
	</cfquery> 

	<cflocation url="maq_imp.cfm?FAM014=#form.FAM09MAQ#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM014
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
	  and CCTcodigo = <cfqueryparam value="#form.CCTcodigo#" cfsqltype="cf_sql_char">
	</cfquery>
 	


<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM014( Ecodigo,FAM09MAQ,FAM12COD, CCTcodigo, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
		        <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">, 
		        <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAM12COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>

<cflocation url="maq_imp.cfm">