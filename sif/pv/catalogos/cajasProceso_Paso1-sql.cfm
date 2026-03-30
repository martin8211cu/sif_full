<cfset params="">
<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM009"
		redirect="cajasProceso.cfm"
		timestamp="#form.ts_rversion#"
		
		field1="FAM09MAQ"
		type1="numeric"
		value1="#form.FAM09MAQ#" >
	<cfquery name="update" datasource="#session.DSN#">
		update FAM009 set
		FAM09DES      = <cfqueryparam value="#Form.FAM09DES#" cfsqltype="cf_sql_varchar">,
		BMUsucodigo   = #session.Usucodigo#
		where Ecodigo = #session.Ecodigo#
	    and FAM09MAQ  = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
	 </cfquery> 
	 
	<cfset params="&FAM09MAQ=#form.FAM09MAQ#">

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
    	delete from FAM009
	  	where Ecodigo = #session.Ecodigo#
	  	and FAM09MAQ = <cfqueryparam value="#form.FAM09MAQ#" cfsqltype="cf_sql_tinyint">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM009( Ecodigo,FAM09MAQ, FAM09DES, BMUsucodigo, fechaalta )
		values(	#session.Ecodigo#,
			<cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.FAM09MAQ#">, 
		    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM09DES#">,
			#session.Usucodigo#,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>
</cfif>
<cflocation url="cajasProceso.cfm?Paso=1#params#">