<cfparam name="modo" default="ALTA">
<!---SQL Pruebas --->

<cftransaction>
	<cfif not isdefined("Form.Nuevo")>
			<cfif isdefined("Form.Alta")>
				<cfquery name="insRHOTitulo" datasource="#Session.DSN#">			
					insert INTO RHOTitulo (CEcodigo, RHOTDescripcion,BMfechaalta, BMUsucodigo, RHOTnf)
					values 
					(	 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> , 
						 rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOTDescripcion#">)), 
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> 
						<cfif isdefined("Form.RHOTnf")>
						 ,1
						 <cfelse>
						 ,0
						</cfif>
						 ) 
				<cf_dbidentity1>
				</cfquery>
				<cf_dbidentity2 name="insRHOTitulo" returnvariable="LvarIdentity">
				<cfset form.RHOTid=LvarIdentity>
				<cf_translatedata name="set" tabla="RHOTitulo" col="RHOTDescripcion" valor="#Form.RHOTDescripcion#" filtro="RHOTid= #form.RHOTid#">
				<cfset modo="ALTA">
	
			<cfelseif isdefined("Form.Baja")>
				<cfquery name="delRHOTitulo" datasource="#Session.DSN#">
					delete from RHOTitulo
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOTid#" >
		 		</cfquery>
				<cfset modo="ALTA">

			<cfelseif isdefined("Form.Cambio")>
				<cf_dbtimestamp datasource="#session.dsn#"
						table="RHOTitulo"
						redirect="Titulos.cfm"
						timestamp="#form.ts_rversion#"
						field1="RHOTid" 
						type1="numeric" 
						value1="#form.RHOTid#">
				<cfquery name="updRHOTitulo" datasource="#Session.DSN#">
					update RHOTitulo 
					set	RHOTDescripcion = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.RHOTDescripcion#">)) 
						<cfif isdefined("Form.RHOTnf")>
							, RHOTnf=<cfqueryparam value="1" cfsqltype="cf_sql_bit">
						<cfelse>
							, RHOTnf=<cfqueryparam value="0" cfsqltype="cf_sql_bit">
						</cfif>
						
					where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
  				    and RHOTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHOTid#" >
  				    <cf_dbidentity1>
				</cfquery>
				<cf_translatedata name="set" tabla="RHOTitulo" col="RHOTDescripcion" valor="#Form.RHOTDescripcion#" filtro="RHOTid= #form.RHOTid#">
				<cfset modo="CAMBIO">
			</cfif>
	</cfif>
</cftransaction>

<form action="Titulos.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif modo neq 'ALTA'>
		<input name="RHOTid" type="hidden" value="<cfif isdefined("Form.RHOTid")><cfoutput>#Form.RHOTid#</cfoutput></cfif>">
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