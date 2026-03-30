<cfparam name="modo" default="ALTA">

<!---SQL Pruebas --->
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHOIndustria" datasource="#Session.DSN#">			
					insert INTO RHOIndustria (CEcodigo, RHOIDescripcion,BMfechaalta, BMUsucodigo)
					values 
					(	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> , 
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOIDescripcion#">)), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> ) 
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="insRHOIndustria" returnvariable="LvarIdentity">
				<cfset form.RHOIid=LvarIdentity>
				<cf_translatedata name="set" tabla="RHOIndustria" col="RHOIDescripcion" valor="#Form.RHOIDescripcion#" filtro="RHOIid= #form.RHOIid#">
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delRHOIndustria" datasource="#Session.DSN#">
					delete from RHOIndustria
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOIid#" >
		 		</cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
						table="RHOIndustria"
						redirect="Industrias.cfm"
						timestamp="#form.ts_rversion#"
						field1="RHOIid" 
						type1="numeric" 
						value1="#form.RHOIid#">
				<cfquery name="updRHOIndustria" datasource="#Session.DSN#">
					update RHOIndustria 
					set	RHOIDescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOIDescripcion#">)) 
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOIid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOIid#" >
				</cfquery>
				<cf_translatedata name="set" tabla="RHOIndustria" col="RHOIDescripcion" valor="#Form.RHOIDescripcion#" filtro="RHOIid= #form.RHOIid#">
				<cfset modo="CAMBIO">
			</cfif>
	</cfif>
</cftransaction>

<form action="Industrias.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHOIid" type="hidden" value="<cfif isdefined("Form.RHOIid")><cfoutput>#Form.RHOIid#</cfoutput></cfif>">
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