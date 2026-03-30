<cfparam name="modo" default="ALTA">

<!---SQL Pruebas --->
<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHOPuesto" datasource="#Session.DSN#">			
					insert INTO RHOPuesto (CEcodigo, RHOPDescripcion,BMfechaalta, BMUsucodigo)
					values 
					(	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> , 
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOPDescripcion#">)), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> ) 
					<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="insRHOPuesto" returnvariable="LvarIdentity">
				<cfset form.RHOPid=LvarIdentity>
				<cf_translatedata name="set" tabla="RHOPuesto" col="RHOPDescripcion" valor="#Form.RHOPDescripcion#" filtro="RHOPid= #form.RHOPid#">
				<cfset modo="ALTA">
	
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delRHOPuesto" datasource="#Session.DSN#">
					delete from RHOPuesto
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOPid#" >
		 		</cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
						table="RHOPuesto"
						redirect="Profesion.cfm"
						timestamp="#form.ts_rversion#"
						field1="RHOPid" 
						type1="numeric" 
						value1="#form.RHOPid#">
				<cfquery name="updRHOPuesto" datasource="#Session.DSN#">
					update RHOPuesto 
					set	RHOPDescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOPDescripcion#">)) 
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOPid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOPid#" >
				</cfquery>
				<cf_translatedata name="set" tabla="RHOPuesto" col="RHOPDescripcion" valor="#Form.RHOPDescripcion#" filtro="RHOPid= #form.RHOPid#">
				
				<cfset modo="CAMBIO">
			</cfif>
	</cfif>
</cftransaction>

<form action="Profesion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHOPid" type="hidden" value="<cfif isdefined("Form.RHOPid")><cfoutput>#Form.RHOPid#</cfoutput></cfif>">
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