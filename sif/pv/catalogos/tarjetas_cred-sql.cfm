<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FATarjetas"
		redirect="tarjetas_cred.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FATid"
		type1="numeric"
		value1="#form.FATid#"> 
				
	<cfquery name="update" datasource="#session.DSN#">
		update FATarjetas set
		SNcodigo = <cfqueryparam value="#Form.SNcodigo#" cfsqltype="cf_sql_integer">,
		FATcodigo = <cfqueryparam value="#Form.FATcodigo#" cfsqltype="cf_sql_varchar">,
		FATtipo = <cfqueryparam value="#Form.tc_tipo#" cfsqltype="cf_sql_char">,
		FATtiptarjeta = <cfqueryparam value="#Form.FATtiptarjeta#" cfsqltype="cf_sql_char">,
		FATdescripcion = <cfqueryparam value="#Form.FATdescripcion#" cfsqltype="cf_sql_varchar">,
		<cfif isdefined('form.FATporccom') and len(trim(form.FATporccom))>
			FATporccom = <cfqueryparam value="#Form.FATporccom#" cfsqltype="cf_sql_double">,
		<cfelse>
			FATporccom = null,
		</cfif>
				
		<cfif isdefined('form.CFcuentaCom') and len(trim(form.CFcuentaCom))>
			CFcuentaComision = <cfqueryparam value="#form.CFcuentaCom#" cfsqltype="cf_sql_numeric">,
		<cfelse>
			CFcuentaComision = null,
		</cfif>
		
		<cfif isdefined('form.CFcuentaCobro') and len(trim(form.CFcuentaCobro))>
			CFcuentaCobro = <cfqueryparam value="#Form.CFcuentaCobro#" cfsqltype="cf_sql_numeric">,
		<cfelse>
			CFcuentaCobro = null,
		</cfif>
        <cfif isdefined('form.FATcomplemento') and len(trim(form.FATcomplemento))>
          FATcomplemento=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcomplemento#">,
        <cfelse>
         FATcomplemento= null,
        </cfif>
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FATid = <cfqueryparam value="#form.FATid#" cfsqltype="cf_sql_numeric">
	</cfquery> 

<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
      delete from FATarjetas
	  where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FATid = <cfqueryparam value="#form.FATid#" cfsqltype="cf_sql_numeric">
    </cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FATarjetas ( Ecodigo, SNcodigo, FATcodigo, FATtipo, FATtiptarjeta, FATdescripcion, FATporccom, CFcuentaComision, CFcuentaCobro, BMUsucodigo, fechaalta,FATcomplemento)
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfif isdefined('form.SNcodigo') and form.SNcodigo NEQ ''>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">, 
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.tc_tipo#">, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.FATtiptarjeta#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATdescripcion#">,
				<cfif isdefined('form.FATporccom') and form.FATporccom NEQ ''> 
				<cfqueryparam cfsqltype="cf_sql_double" value="#form.FATporccom#">, 
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.CFcuentaCom') and form.CFcuentaCom NEQ ''> 
		        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaCom#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined('form.CFcuentaCobro') and form.CFcuentaCobro NEQ ''> 
		        	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFcuentaCobro#">,
				<cfelse>
					null,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                <cfif isdefined('form.FATcomplemento') and len(trim(form.FATcomplemento))>
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FATcomplemento#">
                <cfelse>
                    null
                </cfif>    
                 )
	</cfquery>
</cfif>

<form action="tarjetas_cred.cfm" method="post" name="sql">
	<cfoutput>
	<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FATid" type="hidden" value="#form.FATid#"> 	
		</cfif>
							
		<cfif isdefined('form.FATcodigo_F') and len(trim(form.FATcodigo_F))>
			<input type="hidden" name="FATcodigo_F" value="#form.FATcodigo_F#">	
		</cfif>
		
		<cfif isdefined('form.FATdescripcion_F') and len(trim(form.FATdescripcion_F))>
			<input type="hidden" name="FATdescripcion_F" value="#form.FATdescripcion_F#">	
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