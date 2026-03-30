 <cfif IsDefined("form.Cambio")>
 
		<cf_dbtimestamp datasource="#session.dsn#"
				table="FAM015"
				redirect="PagoChequesAutChk.cfm"
				timestamp="#form.ts_rversion#"
				field1="CDCcodigo"
				type1="numeric"
				value1="#form.CDCcodigo#">
				
	<cfset monto = #replace(Form.FAM15MAX,",","","all")#>
	<cfquery name="update" datasource="#session.DSN#">
		update FAM015
		set
			FAM15AUT = <cfif isdefined('form.FAM15AUT')> 1, <cfelse> 0, </cfif>
			FAM15MAX = <cfqueryparam value="#monto#" cfsqltype="cf_sql_money">,
			BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		  and CDCcodigo = <cfqueryparam value="#Form.CDCcodigo#" cfsqltype="cf_sql_numeric">
		
	</cfquery> 

	

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FAM015
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and CDCcodigo = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CDCcodigo#">
	</cfquery>
 	
	<!--- suma 1 al max de cod identity char --->
	<cfelseif IsDefined("form.Alta")>

		<cfquery name="rsVerificacion" datasource="#session.dsn#">
			Select CDCcodigo
			from FAM015
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
			  and CDCcodigo = <cfqueryparam cfsqltype= "cf_sql_numeric" value="#Form.CDCcodigo#">			  
		</cfquery> 
		
		<cfif rsVerificacion.recordcount eq 0>

			<cfset monto = #replace(Form.FAM15MAX,",","","all")#>
			<cfquery datasource="#session.dsn#">
			   insert into FAM015 ( Ecodigo, CDCcodigo, FAM15AUT, FAM15MAX, BMUsucodigo,  fechaalta)
			   values(	
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam value="#Form.CDCcodigo#" cfsqltype="cf_sql_numeric">,
					<cfif isdefined("FAM15AUT")>
						<cfqueryparam cfsqltype= "cf_sql_bit" value="1">,
					<cfelse>
						<cfqueryparam cfsqltype= "cf_sql_bit" value="0">,
					</cfif>
					<cfqueryparam value="#monto#" cfsqltype="cf_sql_money">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">)
			</cfquery>
			
		</cfif>
	
</cfif>

<!---<cflocation url="PagoChequesAutChk.cfm">
<cflocation url="PagoChequesAutChk.cfm?CDCcodigo=#form.CDCcodigo#">--->

<form action="PagoChequesAutChk.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="CDCcodigo" type="hidden" value="#form.CDCcodigo#"> 	
		</cfif>
		
		<cfif isdefined('form.CDCcodigo_F') and len(trim(form.CDCcodigo_F)) and not isdefined ('form.Alta')>
			<input type="hidden" name="CDCcodigo_F" value="#form.CDCcodigo_F#">	
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