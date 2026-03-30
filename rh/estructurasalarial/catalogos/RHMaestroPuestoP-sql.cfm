<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into RHMaestroPuestoP(Ecodigo, RHCid, RHMPPcodigo, Complemento, RHMPPdescripcion, BMfecha, BMUsucodigo)
				values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfif isdefined("Form.RHCid") and len(trim(Form.RHCid))><cfqueryparam value="#Form.RHCid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
						 <cfqueryparam value="#Form.RHMPPcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#Form.Complemento#" cfsqltype="cf_sql_varchar" null="#len(trim(Form.Complemento)) is 0#">,
						 <cfqueryparam value="#Form.RHMPPdescripcion#" cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
						 <cfqueryparam value="#Session.Usucodigo#" cfsqltype="cf_sql_numeric">)
			<cf_dbidentity1>	
		</cfquery>
		<cf_dbidentity2 name="insert">
		<cf_translatedata name="set" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" valor="#Form.RHMPPdescripcion#" filtro="RHMPPid=#insert.identity#">
		<cfset modo="ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cftry>
			<cfquery name="delete" datasource="#Session.DSN#">
				delete RHMaestroPuestoP
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHMPPid = <cfqueryparam value="#Form.RHMPPid#" cfsqltype="cf_sql_numeric">			  
			</cfquery>  
			<cfcatch type="database">
				<cf_errorCode code="51822" msg="Este Elemento Posee Dependencias">
			</cfcatch>
		</cftry>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="RHMaestroPuestoP"
			 			redirect="RHMaestroPuestos.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="RHMPPid" 
						type2="numeric" 
						value2="#form.RHMPPid#">

		<cfquery name="update" datasource="#Session.DSN#">
			update RHMaestroPuestoP 
			set RHMPPcodigo = <cfqueryparam value="#form.RHMPPcodigo#" cfsqltype="cf_sql_char">,
				RHMPPdescripcion = <cfqueryparam value="#Form.RHMPPdescripcion#" cfsqltype="cf_sql_varchar">,
				RHCid = <cfif isdefined("Form.RHCid") and len(trim(Form.RHCid))><cfqueryparam value="#Form.RHCid#" cfsqltype="cf_sql_numeric"><cfelse>null</cfif>,
				Complemento = <cfqueryparam value="#Form.Complemento#" cfsqltype="cf_sql_varchar" null="#len(trim(Form.Complemento)) is 0#">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		   	  and RHMPPid = <cfqueryparam value="#Form.RHMPPid#" cfsqltype="cf_sql_numeric">	
		</cfquery> 
		<cf_translatedata name="set" tabla="RHMaestroPuestoP" col="RHMPPdescripcion" valor="#Form.RHMPPdescripcion#" filtro="RHMPPid=#Form.RHMPPid#">

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfoutput>
<form action="<cfif isdefined("form.Baja")>RMaestroPuestoP-lista.cfm<cfelse>RHMaestroPuestos.cfm</cfif>" method="post" name="sql">
	<cfif isdefined("form.Cambio")>
		<input name="RHMPPid" type="hidden" value="#Form.RHMPPid#">
	</cfif>
</form>
</cfoutput>	
<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>