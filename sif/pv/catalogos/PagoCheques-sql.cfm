 <cfif IsDefined("form.Cambio")>
 
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM017"
				redirect="PagoCheques.cfm"
				timestamp="#form.ts_rversion#"
				field1="FAM16NUM"
				type1="char"
				value1="#form.FAM16NUM#"
				
				field2="Bid"
				type2="numeric"
				value2="#form.Bid#"
				
				field3 = "CDCcodigo"
				type3 = "numeric"
				value3 = "#form.CDCcodigo#">
				
	<cfset monto = #replace(Form.FAM17MAX,",","","all")#>				
	<cfquery name="update" datasource="#session.DSN#">
		update FAM017 
		set
			FAM17MAX = <cfqueryparam value="#monto#" cfsqltype="cf_sql_money">,
			BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	      and Bid = <cfqueryparam value="#Form.Bid#" cfsqltype= "cf_sql_numeric">
		  and FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">
		  and CDCcodigo = <cfqueryparam value="#Form.CDCcodigo#" cfsqltype="cf_sql_numeric">
		
	</cfquery> 

	

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM017
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and Bid = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.Bid#">
	  and FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">
	  and CDCcodigo = <cfqueryparam value="#Form.CDCcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>
 	
	<!--- suma 1 al max de cod identity char --->
	<cfelseif IsDefined("form.Alta")>

		<!--- Verifica la 15 y 16, si llos datos no existen los incluye de una vez --->
		<cfquery datasource="#session.dsn#" name="Rev_16">
		Select FAM16NUM
		from FAM016		
		where FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">
		  and Bid      = <cfqueryparam value="#Form.Bid#" cfsqltype="cf_sql_numeric">
		  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>

		<cfif Rev_16.recordcount eq 0>
		
			<cfquery datasource="#session.dsn#">
			Insert into FAM016(Ecodigo, FAM16NUM, Bid, FAM16AUT, FAM16MAX, BMUsucodigo, fechaalta)
			values(
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">,
					<cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.Bid#">,
					<cfqueryparam cfsqltype= "cf_sql_bit" value="1">,
					<cfqueryparam cfsqltype= "cf_sql_money" value="0">,
				    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				  )
			</cfquery>
		
		</cfif>

		<cfset monto = #replace(Form.FAM17MAX,",","","all")#>
		<!--- Form.FAM16NUM --->
		<cfquery datasource="#session.dsn#">
		   insert into FAM017 ( Ecodigo,  FAM16NUM, Bid, CDCcodigo, FAM17MAX, BMUsucodigo,  fechaalta)
		   values(	
		   		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">,
				<cfqueryparam value="#Form.Bid#" cfsqltype="cf_sql_numeric">,
				<cfqueryparam cfsqltype= "cf_sql_numeric" value="#form.CDCcodigo#">,
				<cfqueryparam cfsqltype= "cf_sql_money" value="#monto#">,
			    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
		</cfquery>
	
</cfif>


<form action="PagoCheques.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="CDCcodigo" type="hidden" value="#form.CDCcodigo#"> 
			<input name="FAM16NUM"	Type="hidden" value="#form.FAM16NUM#">
			<input name="Bid"	Type="hidden" value="#form.Bid#">
			
		</cfif>
		
		<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F)) and not isdefined ('form.Alta')>
			<input type="hidden" name="CDCcodigo_F" value="#form.CDCcodigo_F#">	
			
		</cfif>
		
		<cfif isdefined('form.FAM16NUM_F') and len(trim(form.FAM16NUM_F)) and not isdefined ('form.Alta')>
			<input type="hidden" name="FAM16NUM_F" value="#form.FAM16NUM_F#">	
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
