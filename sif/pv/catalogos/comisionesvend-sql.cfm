<cfif IsDefined("form.CambioD")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAM022"
		redirect="comisionesvend.cfm"
		timestamp="#form.ts_rversion#"
		
		field1="FAM22RVI"
		type1="numeric"
		value1="#form.FAM22RVI#"
		
		
		field2="FAX04CVD"
		type2="varchar"
		value2="#form.FAX04CVD#">
				
	<cfquery name="update" datasource="#session.DSN#">
		update FAM022 set			
		FAM22RVS	= <cfqueryparam value="#FAM22RVS#" cfsqltype="cf_sql_money">,
		FAM22PCO	= <cfqueryparam value="#FAM22PCO#" cfsqltype="cf_sql_money">,			
		FAM22MON	= <cfqueryparam value="#FAM22MON#" cfsqltype="cf_sql_varchar">,
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
		and FAM22RVI = <cfqueryparam value="#form.FAM22RVI#" cfsqltype= "cf_sql_money">
	</cfquery> 

<cfelseif IsDefined("form.BajaD")>
	<cfquery datasource="#session.dsn#">
      delete from FAM022
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAX04CVD = <cfqueryparam value="#form.FAX04CVD#" cfsqltype= "cf_sql_varchar">
	    and FAM22RVI = <cfqueryparam value="#form.FAM22RVI#" cfsqltype= "cf_sql_money">		
	</cfquery>
 	
<cfelseif IsDefined("form.AltaD")>
	<cfquery datasource="#session.dsn#">
		insert into FAM022 ( Ecodigo, FAX04CVD, FAM22RVI, FAM22RVS,  FAM22PCO, FAM22MON,
							BMUsucodigo, fechaalta)
		values(	
		   		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.FAX04CVD#">,
			    <cfqueryparam cfsqltype="cf_sql_money" value="#FAM22RVI#">,
			    <cfqueryparam cfsqltype="cf_sql_money" value="#FAM22RVS#">,
			    <cfqueryparam cfsqltype="cf_sql_money" value="#FAM22PCO#">,
			    <cfqueryparam cfsqltype="cf_sql_money" value="#FAM22MON#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
	</cfquery>
</cfif>

<form action="vendedores.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.CambioD')>
			<input name="FAM22RVI" type="hidden" value="#form.FAM22RVI#">	
		</cfif>
		
		<input name="FAX04CVD" type="hidden" value="#form.FAX04CVD#"> 
		
		<cfif isdefined('form.FAM21CED_F') and len(trim(form.FAM21CED_F))>
			<input type="hidden" name="FAM21CED_F" value="#form.FAM21CED_F#">	
		</cfif>
		<cfif isdefined('form.FAM21NOM_F') and len(trim(form.FAM21NOM_F))>
			<input type="hidden" name="FAM21NOM_F" value="#form.FAM21NOM_F#">	
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

