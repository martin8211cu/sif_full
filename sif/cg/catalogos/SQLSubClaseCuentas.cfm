<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cftry>				
		<!---AREGAR--->
		<cfif isdefined("Form.Alta")>
			<cfquery datasource="#Session.DSN#">		
				insert SubClaseCuentas (Ecodigo, SCtipo, SCdescripcion)
				values (
					#Session.Ecodigo#, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.SCtipo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SCdescripcion#">					
				)
			</cfquery>																				
		  
		  <cfset modo="ALTA">
		<!---ELIMINAR--->		
		<cfelseif isdefined("Form.Baja")>	
			<cfquery datasource="#Session.DSN#">					
				delete from SubClaseCuentas 
				where Ecodigo = #Session.Ecodigo#
				  and SCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SCid#">	
			</cfquery>			  
				<cfset modo="BAJA">
		 <!---MODIFICAR--->
			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="SubClaseCuentas" 
					redirect="SubClaseCuentas.cfm"
					timestamp="#Form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="SCid,numeric,#Form.SCid##">
					
				<cfquery datasource="#Session.DSN#">	
					update SubClaseCuentas set
						SCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SCtipo#">,
						SCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.SCdescripcion#">					
					where Ecodigo =  #Session.Ecodigo# 
					  and SCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SCid#">	
				  <cfquery datasource="#Session.DSN#">			
				<cfset modo="CAMBIO">				  				  
			</cfif>			
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<form action="SubClaseCuentas.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("ABC_SubClaseCuentas.ID")>
	<cfelse>
	   	<input name="SCid" type="hidden" value="<cfif isdefined("Form.SCid") and not isDefined("Form.Baja") and modo NEQ 'ALTA'>#Form.SCid#</cfif>">		
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
</cfoutput>	
</form>

<HTML>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</HTML>