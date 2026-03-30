<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHTTablaSalarial(Ecodigo, RHTTcodigo, RHTTdescripcion, Mcodigo, BMfalta, BMfmod, BMUsucodigo)
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.RHTTcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.RHTTdescripcion#" cfsqltype="cf_sql_varchar">,						 
						 <cfif isdefined("Form.Mcodigo") and len(trim(Form.Mcodigo))><cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,						 
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">)
				<cf_dbidentity1>
		</cfquery>
		<cf_dbidentity2 name="insert">
		<cf_translatedata name="set" valor="#Form.RHTTdescripcion#" col="RHTTdescripcion" tabla="RHTTablaSalarial"	filtro="RHTTid = #insert.identity#">
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHTTablaSalarial
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHTTid = <cfqueryparam value="#Form.RHTTid#" cfsqltype="cf_sql_numeric">			  
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHTTablaSalarial"
			 			redirect="RHTTablaSalarial.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHTTid" 
						type2="numeric" 
						value2="#form.RHTTid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHTTablaSalarial 
			set RHTTcodigo = <cfqueryparam value="#form.RHTTcodigo#" cfsqltype="cf_sql_char">,
				RHTTdescripcion = <cfqueryparam value="#Form.RHTTdescripcion#" cfsqltype="cf_sql_varchar">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and RHTTid = <cfqueryparam value="#Form.RHTTid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cf_translatedata name="set" valor="#Form.RHTTdescripcion#" col="RHTTdescripcion" tabla="RHTTablaSalarial"	filtro="RHTTid = #form.RHTTid#">
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="RHTTablaSalarial.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="RHTTid" type="hidden" value="#Form.RHTTid#">
	</cfif>
	<input type="hidden" name="dummi" value="">
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


