<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfparam name="form.irA" default="expediente-cons.cfm">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="InsertCarga" datasource="#session.DSN#">
			insert into CargasEmpleado ( DEid, DClinea, CEdesde, CEhasta, CEvalorpat, CEvaloremp  )
			values (
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEdesde)#">,
				<cfif isdefined("form.CEhasta") and  len(trim(form.CEhasta)) gt 0 ><cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEhasta)#"><cfelse>null</cfif>,
				<cfif not isdefined("form.check")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvalorpat#"><cfelse>NULL</cfif>,
				<cfif not isdefined("form.check")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvaloremp#"><cfelse>NULL</cfif>
			)	
		</cfquery>
		<cfset modo="ALTA">	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="DeleteCarga" datasource="#session.DSN#">
			delete from CargasEmpleado
			where DEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>		
		<cfquery name="UpdateCarga" datasource="#session.DSN#">														
			update CargasEmpleado set
				CEdesde	= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEdesde)#">,
				CEhasta	= <cfif isdefined("form.CEhasta") and  len(trim(form.CEhasta)) gt 0 ><cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEhasta)#"><cfelse>null</cfif>,
				CEvalorpat = <cfif not isdefined("form.check")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvalorpat#"><cfelse>NULL</cfif>,
				CEvaloremp = <cfif not isdefined("form.check")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvaloremp#"><cfelse>NULL</cfif>
			where DEid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

	<form action="<cfoutput>#form.irA#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<cfif isdefined("Form.Cambio") >
			<input name="DClinea" type="hidden" value="<cfoutput>#form.DClinea#</cfoutput>">
		</cfif>
		<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">			
		<input name="o" type="hidden" value="7">
		<input name="sel" type="hidden" value="1">			
	</form>
<HTML>
<head></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>