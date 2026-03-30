<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM024"
		redirect="den_monedas.cfm"
		timestamp="#form.ts_rversion#"
			
		field1="FAM24TIP"
		type1="char"
		value1="#form.FAM24TIP#"
		
		field2="FAM24VAL"
		type2="char"
		value2="#form.FAM24VAL#"
		
		field3="Mcodigo"
		type3="numeric"
		value3="#form.Mcodigo#" >
		
	<cfquery name="update" datasource="#session.DSN#">
		update FAM024
		set FAM24DES = <cfqueryparam value="#Form.FAM24DES#" cfsqltype="cf_sql_char">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM24TIP = <cfqueryparam value="#Form.FAM24TIP#" cfsqltype="cf_sql_char">
		and FAM24VAL = <cfqueryparam value="#Form.FAM24VAL#" cfsqltype="cf_sql_char">
		and Mcodigo= <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	 </cfquery> 

	
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM024
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAM24TIP = <cfqueryparam value="#Form.FAM24TIP#" cfsqltype="cf_sql_char">
		and FAM24VAL = <cfqueryparam value="#Form.FAM24VAL#" cfsqltype="cf_sql_char">
		and Mcodigo= <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
 	
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAM024( Ecodigo, FAM24TIP, FAM24VAL, Mcodigo, FAM24DES, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM24TIP#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM24VAL#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAM24DES#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>			
</cfif>

<!---<cflocation url="den_monedas.cfm">
<cflocation url="den_monedas.cfm?FAM24TIP=#form.FAM24TIP#&FAM24VAL=#form.FAM24VAL#&Mcodigo=#form.Mcodigo# ">
--->

<form action="den_monedas.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAM24TIP" type="hidden" value="#form.FAM24TIP#"> 
			<input name="FAM24VAL" type="hidden" value="#form.FAM24VAL#"> 
			<input name="Mcodigo" type="hidden" value="#form.Mcodigo#"> 
		</cfif>
						
		<cfif isdefined('form.Mcodigo_F') and len(trim(form.Mcodigo_F))>
        	<input type="hidden" name="Mcodigo_F" value="#form.Mcodigo_F#">
      	</cfif>
		<cfif isdefined('form.FAM24DES_F') and len(trim(form.FAM24DES_F))>
        	<input type="hidden" name="FAM24DES_F" value="#form.FAM24DES_F#">
      	</cfif>
									
	</cfoutput>
</form>

<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>