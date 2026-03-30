<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="FAD001"
		redirect="documentos.cfm"
		timestamp="#form.ts_rversion#"
	
		field1="FAD01COD"
		type1="varchar"
		value1="#form.FAD01COD#" >
				
	<cfquery name="update" datasource="#session.DSN#">
		update FAD001
		set FAD01DES = <cfqueryparam value="#Form.FAD01DES#" cfsqltype="cf_sql_char">,
		FAD01REF = <cfif isdefined('form.FAD01REF')> 1, <cfelse> 0, </cfif>
		FAD01GEN = <cfif isdefined('form.FAD01GEN')> 1, <cfelse> 0, </cfif>
		FAD01PRE = <cfqueryparam value="#Form.FAD01PRE#" cfsqltype="cf_sql_char">,
		FAD01PRS = <cfqueryparam value="#Form.FAD01PRS#" cfsqltype="cf_sql_char">,
		FAD01INT = <cfif isdefined('form.FAD01INT')> 1, <cfelse> 0, </cfif>
		BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAD01COD = <cfqueryparam value="#Form.FAD01COD#" cfsqltype="cf_sql_varchar">
	</cfquery> 
	


<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
    	delete from FAD001
	  	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	    and FAD01COD = <cfqueryparam value="#Form.FAD01COD#" cfsqltype="cf_sql_varchar">
	</cfquery>
 	
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into FAD001( Ecodigo, FAD01COD, FAD01DES, FAD01REF, FAD01GEN, FAD01PRE, FAD01PRS, FAD01INT, BMUsucodigo, fechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAD01COD#">,
				<cfqueryparam cfsqltype="cf_sql_char" value = "#form.FAD01DES#">,
				<cfif isdefined('form.FAD01REF')> 1,
				<cfelse> 0,
				</cfif>
				<cfif isdefined('form.FAD01GEN')> 1,
				<cfelse> 0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_char" value ="#form.FAD01PRE#">,
				<cfqueryparam cfsqltype="cf_sql_char" value ="#form.FAD01PRS#">,
				<cfif isdefined('form.FAD01INT')> 1,
				<cfelse> 0,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>			
</cfif>

<form action="documentos.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="FAD01COD" type="hidden" value="#form.FAD01COD#"> 
		</cfif>
				
		<cfif isdefined('form.FAD01COD_F') and len(trim(form.FAD01COD_F))>
			<input type="hidden" name="FAD01COD_F" value="#form.FAD01COD_F#">	
		</cfif>
		
		<cfif isdefined('form.FAD01DES_F') and len(trim(form.FAD01DES_F))>
			<input type="hidden" name="FAD01DES_F" value="#form.FAD01DES_F#">	
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


