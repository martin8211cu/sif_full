<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">
<cfparam name="form.irA" default="CargaOficina.cfm">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="InsertCarga" datasource="#session.DSN#">
			insert into CargasOficina ( Ecodigo, Ocodigo, DClinea, CEdesde, CEhasta, CEvalorpat, CEvaloremp, BMUsucodigo  )
			values (
            	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ocodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEdesde)#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime('01/01/6100')#">,
				<cfif isdefined("form.CEvalorpat")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvalorpat#"><cfelse>NULL</cfif>,
				<cfif isdefined("form.CEvaloremp")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvaloremp#"><cfelse>NULL</cfif>,
                <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)	
		</cfquery>
		<cfset modo="ALTA">	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="DeleteCarga" datasource="#session.DSN#">
			delete from CargasOficina
			where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>		
		<cfquery name="UpdateCarga" datasource="#session.DSN#">														
			update CargasOficina set
				CEdesde	= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEdesde)#">,
				CEhasta	= <cfif isdefined("form.CEhasta") and  len(trim(form.CEhasta)) gt 0 ><cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CEhasta)#"><cfelse>null</cfif>,
				CEvalorpat = <cfif isdefined("form.CEvalorpat")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvalorpat#"><cfelse>NULL</cfif>,
				CEvaloremp = <cfif isdefined("form.CEvaloremp")><cfqueryparam cfsqltype="cf_sql_float" value="#form.CEvaloremp#"><cfelse>NULL</cfif>
			where Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			  and DClinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DClinea#">
              and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>
	<form action="<cfoutput>#form.irA#</cfoutput>" method="post" name="sql">
		<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
		<cfif isdefined("Form.Cambio") >
			<input name="DClinea" type="hidden" value="<cfoutput>#form.DClinea#</cfoutput>">
		</cfif>
		<input name="Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo")><cfoutput>#form.Ocodigo#</cfoutput></cfif>">		
		<input name="Odescripcion" type="hidden" value="<cfif isdefined("form.Odescripcion")><cfoutput>#form.Odescripcion#</cfoutput></cfif>">	
		<input name="Oficodigo" type="hidden" value="<cfif isdefined("form.Oficodigo")><cfoutput>#form.Oficodigo#</cfoutput></cfif>">		
	</form>
<HTML>
<head></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>