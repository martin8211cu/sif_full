<cfset modo = "ALTA">
<cfif isdefined('form.RHPOPdistribucionCF')>
	<cfset form.RHPOPdistribucionCF = 1>
<cfelse>
	<cfset form.RHPOPdistribucionCF = 0>
</cfif>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHPOtrasPartidas(Ecodigo, CPPid, CPformato, CPdescripcion, BMUsucodigo,RHPOPdistribucionCF)
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						 <cfqueryparam value="#Form.CPPid#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#Form.CPformato#" cfsqltype="cf_sql_varchar">,						 
						 <cfqueryparam value="#Form.CPdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#form.RHPOPdistribucionCF#" cfsqltype="cf_sql_bit">)
		</cfquery>
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete RHPOtrasPartidas
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHPOPid = <cfqueryparam value="#Form.RHPOPid#" cfsqltype="cf_sql_numeric">			  
		</cfquery>  
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHPOtrasPartidas"
			 			redirect="RHPOtrasPartidas.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHPOPid" 
						type2="numeric" 
						value2="#form.RHPOPid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHPOtrasPartidas 
			set CPformato = <cfqueryparam value="#form.CPformato#" cfsqltype="cf_sql_varchar">,
				CPdescripcion = <cfqueryparam value="#Form.CPdescripcion#" cfsqltype="cf_sql_varchar">,
				RHPOPdistribucionCF = <cfqueryparam value="#form.RHPOPdistribucionCF#" cfsqltype="cf_sql_bit">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and RHPOPid = <cfqueryparam value="#Form.RHPOPid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="RHPOtrasPartidas.cfm" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="RHPOPid" type="hidden" value="#Form.RHPOPid#">
	</cfif>
	<input type="hidden" name="dummi" value="">
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>


