 <cfif IsDefined("form.Cambio")>

		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM016"
				redirect="PagoChequesAut.cfm"
				timestamp="#form.ts_rversion#"
				field1="FAM16NUM"
				type1="char"
				value1="#form.FAM16NUM#"
				
				field2="Bid"
				type2="numeric"
				value2="#form.Bid#"	>
	
	<cfset monto = #replace(Form.FAM16MAX,",","","all")#>			
	<cfquery name="update" datasource="#session.DSN#">
		update FAM016
		set
			<cfif isdefined("form.FAM16AUT")>
				FAM16AUT = <cfqueryparam value="1" cfsqltype="cf_sql_bit">,				
			<cfelse>
				FAM16AUT = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
			</cfif>
			FAM16MAX = <cfqueryparam value="#monto#" cfsqltype="cf_sql_money">,
			BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	      and Bid = <cfqueryparam value="#Form.Bid#" cfsqltype= "cf_sql_numeric">
		  and FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">
		
	</cfquery> 

	

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM016
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and Bid = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.Bid#">
	  and FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">
	</cfquery>
 	
	<!--- suma 1 al max de cod identity char --->
	<cfelseif IsDefined("form.Alta")>

		<cfquery name="rsVerificacion" datasource="#session.dsn#">
			Select FAM16NUM
			from FAM016
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
			  and Bid = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.Bid#">
			  and FAM16NUM = <cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">			
		</cfquery> 
		
		<cfif rsVerificacion.recordcount eq 0>

			<cfset monto = #replace(Form.FAM16MAX,",","","all")#>
			<cfquery datasource="#session.dsn#">
			   insert into FAM016 ( Ecodigo,  FAM16NUM, Bid, FAM16AUT, FAM16MAX, BMUsucodigo,  fechaalta)
			   values(	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam value="#Form.FAM16NUM#" cfsqltype="cf_sql_char">,
					<cfqueryparam value="#Form.Bid#" cfsqltype="cf_sql_numeric">,				
					<cfif isdefined("FAM16AUT")>
						<cfqueryparam cfsqltype= "cf_sql_bit" value="1">,
					<cfelse>
						<cfqueryparam cfsqltype= "cf_sql_bit" value="0">,
					</cfif>
					<cfqueryparam cfsqltype= "cf_sql_money" value="#monto#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
			
		</cfif>
	
</cfif>

<!---<cflocation url="PagoChequesAut.cfm">
      <cflocation url="PagoChequesAut.cfm?Bid=#form.Bid#&FAM16NUM=#form.FAM16NUM#">--->

<form action="PagoChequesAut.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAM16NUM"	Type="hidden" value="#form.FAM16NUM#">
			<input name="Bid"	Type="hidden" value="#form.Bid#">
			
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