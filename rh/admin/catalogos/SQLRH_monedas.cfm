<cfset modo = 'ALTA'>
<cfset action = 'RH_monedas.cfm'>

<cftry>
	<cfif isDefined("form.modo") and form.modo eq "ALTA">
		<cfif isDefined("Session.Ecodigo")>
			<cfquery name="rsMonedas" datasource="#session.DSN#">
				insert into RHMonedas (Ecodigo, Mcodigo, BMUsucodigo, fechaalta,Eliminable)
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Mcodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
						 <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
						 1
						) 
			</cfquery>
			<cfset modo = "ALTA">
		</cfif>
	
	<cfelseif isDefined("form.modo") and form.modo eq "BAJA">	
		<cfif isDefined("Session.Ecodigo") and isDefined("form.MCodigo") and len(trim("form.Mcodigo"))>
			<cfquery name="rsMonedas" datasource="#session.DSN#">
				delete from RHMonedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Trim(Form.Mcodigo)#">
			</cfquery>
			<cfset modo = "ALTA">
		</cfif>
	</cfif>
		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
</cftry>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
	<script language="JavaScript1.2" type="text/javascript">
		document.forms[0].submit();
	</script>	
</body>
</HTML>