
	<cfparam name="modo" default="ALTA">

<!---SQL Pruebas --->
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
		<cftry>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHPruebas" datasource="#Session.DSN#">			
					insert INTO RHPruebas (Ecodigo, RHPcodigopr, RHPdescripcionpr, fechaalta, BMUsucodigo)
					values 
					(	 <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> , 
						 rtrim(<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigopr#">),
						 rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPdescripcionpr#">), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> ) 
				</cfquery>
                <cf_translatedata name="set" tabla="RHPruebas" col="RHPdescripcionpr" valor="#Form.RHPdescripcionpr#" filtro=" Ecodigo=#session.Ecodigo# and ltrim(rtrim(RHPcodigopr)) = '#trim(Form.RHPcodigopr)#'">
				<cfset modo="ALTA">
	
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delRHPruebas" datasource="#Session.DSN#">
					delete from RHPruebas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and rtrim(RHPcodigopr) = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.ORHPcodigopr)#">
				</cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cfquery name="updRHPruebas" datasource="#Session.DSN#">
					update RHPruebas 
					set	RHPcodigopr	= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigopr#">,
						RHPdescripcionpr = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHPdescripcionpr#">)) 
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
						and RHPcodigopr = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.ORHPcodigopr#">
				</cfquery>
                <cf_translatedata name="set" tabla="RHPruebas" col="RHPdescripcionpr" valor="#Form.RHPdescripcionpr#" filtro=" Ecodigo=#session.Ecodigo# and ltrim(rtrim(RHPcodigopr)) = '#trim(Form.RHPcodigopr)#'">
				<cfset modo="CAMBIO">
			</cfif>
			<cfcatch type="database">
			<cfinclude template="../../errorPages/BDerror.cfm">
			<cfabort>
		</cfcatch>
		</cftry>
	</cfif>
</cftransaction>

<form action="Pruebas.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHPcodigopr" type="hidden" value="<cfif isdefined("Form.RHPcodigopr")><cfoutput>#Form.RHPcodigopr#</cfoutput></cfif>">
	</cfif>
    <input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
</form>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>