<cfparam name="modo" default="ALTA">

<!---SQL Pruebas --->
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHOEnfasis" datasource="#Session.DSN#">			
					insert INTO RHOEnfasis (CEcodigo, RHOEDescripcion,BMfechaalta, BMUsucodigo)
					values 
					(	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> , 
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOEDescripcion#">)), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> ) 
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="insRHOEnfasis" returnvariable="LvarIdentity">
				<cfset form.RHOEid=LvarIdentity>
				<cf_translatedata name="set" tabla="RHOEnfasis" col="RHOEDescripcion" valor="#Form.RHOEDescripcion#" filtro="RHOEid= #form.RHOEid#">
				<cfset modo="ALTA">
	
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delRHOEnfasis" datasource="#Session.DSN#">
					delete from RHOEnfasis
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOEid#" >
		 		</cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
						table="RHOEnfasis"
						redirect="Enfasis.cfm"
						timestamp="#form.ts_rversion#"
						field1="RHOEid" 
						type1="numeric" 
						value1="#form.RHOEid#">
				<cfquery name="updRHOEnfasis" datasource="#Session.DSN#">
					update RHOEnfasis 
					set	RHOEDescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOEDescripcion#">)) 
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOEid#" >
				</cfquery>
				<cf_translatedata name="set" tabla="RHOEnfasis" col="RHOEDescripcion" valor="#Form.RHOEDescripcion#" filtro="RHOEid= #form.RHOEid#">
				
				<cfset modo="CAMBIO">
			</cfif>
	</cfif>
</cftransaction>

<form action="Enfasis.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHOEid" type="hidden" value="<cfif isdefined("Form.RHOEid")><cfoutput>#Form.RHOEid#</cfoutput></cfif>">
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