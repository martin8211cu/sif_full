<cfparam name="modo" default="ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery datasource="#Session.DSN#">
			insert INTO CGIC_Mapeo (CGICMcodigo, CGICMnombre)
			values(
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CGICMcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICMnombre#">)
		</cfquery>
		<cfset modo="ALTA">
		
	<cfelseif isdefined("Form.Baja")>
		<cftransaction>
			<cfquery datasource="#session.DSN#">
				delete from CGIC_Cuentas
				where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
			</cfquery>

			
			<cfquery datasource="#session.DSN#">
				delete from CGIC_Catalogo
				where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
			</cfquery>
			<cfquery datasource="#session.DSN#">
				delete from CGIC_Layout
				where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
			</cfquery>
	
			<cfquery datasource="#session.DSN#">
				delete from CGIC_Mapeo
				where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
			</cfquery>
		</cftransaction>
	  	<cfset modo="ALTA">
	  
	<cfelseif isdefined("Form.Cambio")>
		<cfquery datasource="#session.DSN#">
			update CGIC_Mapeo set
				CGICMcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CGICMcodigo#">,
				CGICMnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CGICMnombre#">
			where CGICMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CGICMid#">
		</cfquery>
	  	<cfset modo="CAMBIO">
	</cfif>
</cfif>

<cfif isdefined("LvarInfo")>
	<cfset LvarAction = 'TipoMapeoCuentasINFO.cfm'>
<cfelse>
	<cfset LvarAction = 'TipoMapeoCuentas.cfm'>
</cfif>

<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="CGICMid" type="hidden" value="<cfif isdefined("Form.CGICMid")>#Form.CGICMid#</cfif>">
	</cfif>
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>