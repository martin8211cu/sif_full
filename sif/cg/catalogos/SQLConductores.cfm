<cfset modo = "ALTA">

<cftry>
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
	
			<cftransaction>
				<cfquery name="rsInserta" datasource="#Session.DSN#">
					insert into CGConductores(Ecodigo, CGCcodigo, CGCdescripcion, CGCtipo, CGCmodo, CGCidc)
					values( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,							
							<cfqueryparam value="#Form.CGCcodigo#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.CGCdescripcion#" cfsqltype="cf_sql_varchar">,
							<cfqueryparam value="#Form.cboTipo#" cfsqltype="cf_sql_integer">,
							<cfqueryparam value="#Form.cboModo#" cfsqltype="cf_sql_integer">,							
							<cfif isdefined("F_PCEcatid") and Form.cboModo eq 1>
								<cfqueryparam value="#Form.F_PCEcatid#" cfsqltype="cf_sql_numeric">
						  	<cfelse>
								<cfqueryparam value="#Form.F_PCCEclaid#" cfsqltype="cf_sql_numeric">
							</cfif>
						  )
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInserta">
			</cftransaction>  
			<cfset Form.CGCid = rsInserta.identity>
			
			<cfset modo="CAMBIO">
	
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="delete_cdt" datasource="#Session.DSN#">
				delete from CGConductores
				where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and CGCid = <cfqueryparam value="#Form.CGCid#"   cfsqltype="cf_sql_integer">
			</cfquery> 
			
		<cfelseif isdefined("Form.Cambio")>	
			<cf_dbtimestamp datasource="#session.dsn#"
							table="CGConductores"
							redirect="Conductores.cfm"
							timestamp="#form.ts_rversion#"
							field1="CGCid" 
							type1="integer" 
							value1="#form.CGCid#"
							field2="Ecodigo" 
							type2="integer" 
							value2="#session.Ecodigo#"
							>
		
			<cfquery name="update" datasource="#Session.DSN#">
				update CGConductores 
				set CGCcodigo = <cfqueryparam value="#Form.CGCcodigo#" cfsqltype="cf_sql_varchar">,
				    CGCdescripcion = <cfqueryparam value="#Form.CGCdescripcion#" cfsqltype="cf_sql_varchar">,
					CGCtipo = <cfqueryparam value="#Form.cboTipo#" cfsqltype="cf_sql_integer">,
					CGCmodo = <cfqueryparam value="#Form.cboModo#" cfsqltype="cf_sql_integer">,
					
					<cfif isdefined("F_PCEcatid") and Form.cboModo eq 1>
						CGCidc	= <cfqueryparam value="#Form.F_PCEcatid#" cfsqltype="cf_sql_numeric">
					<cfelse>
						CGCidc	= <cfqueryparam value="#Form.F_PCCEclaid#" cfsqltype="cf_sql_numeric">
					</cfif>					
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and CGCid   = <cfqueryparam value="#Form.CGCid#" cfsqltype="cf_sql_integer">
			</cfquery> 
			<cfset modo="CAMBIO">

		</cfif>	

	</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="Conductores.cfm" method="post" name="sql">
	<cfif not isdefined("Form.Nuevo") and (modo neq 'BAJA')>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="CGCid" type="hidden" value="<cfif isdefined("Form.CGCid") and modo neq 'ALTA'>#Form.CGCid#</cfif>">
		<input name="F_Catalogo" type="hidden" value="<cfif isdefined("Form.F_PCEcatid") and isdefined("Form.cboModo") and Form.cboModo eq 1 and modo neq 'ALTA'>#Form.F_PCEcatid#<cfelseif isdefined("Form.F_PCCEclaid") and modo neq 'ALTA'>#Form.F_PCCEclaid#</cfif>">
		
		<input name="CGCTipo" type="hidden" value="<cfif isdefined("Form.cboTipo") and modo neq 'ALTA'>#Form.cboTipo#</cfif>">		
		<input name="CGCmodo" type="hidden" value="<cfif isdefined("Form.cboModo") and modo neq 'ALTA'>#Form.cboModo#</cfif>">
	</cfif>	
	<input name="Pagina1" type="hidden" value="<cfif isdefined("Form.Pagina") and len(trim(Form.Pagina)) and not isDefined("form.Baja")>#Form.Pagina#<cfelse>1</cfif>">
</form>
</cfoutput>	

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>