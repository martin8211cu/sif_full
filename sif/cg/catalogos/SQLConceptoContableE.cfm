<cfset modo = 'ALTA'>
<cfparam name="form.NoGeneraNap" default="0">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

		<cfif isdefined("form.Cconcepto") and len(form.Cconcepto) gt 0>
			<cfset Var_Concepto = form.Cconcepto>
		<cfelse>

			<cfquery name="rsCont" datasource="#Session.DSN#">
				select coalesce(max(Cconcepto),0)+1 as Cont
				from ConceptoContableE
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			</cfquery>

			<cfset Var_Concepto = rsCont.Cont>
		</cfif>

		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into ConceptoContableE (Ecodigo, Cconcepto, Cdescripcion,Ctiponumeracion,NoGeneraNap,TipoSAT)
			values(
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Var_Concepto#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Cdescripcion#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CTipoNumeracion#">,
                	<cfqueryparam cfsqltype="cf_sql_bit" 	 value="#Form.NoGeneraNap#">,
				<cfif isdefined("Form.TipoSAT") and len(trim(Form.TipoSAT))>
					<cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.TipoSAT#">
				<cfelse>
					null
				</cfif>
			)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from ConceptoContableE
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Cconcepto = <cfqueryparam value="#Form.Cconcepto#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="ConceptoContableE"
			redirect="ConceptoContableE.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo#"
			field2="Cconcepto,integer,#form.Cconcepto#">

		<cfquery name="rsCambio" datasource="#Session.DSN#">
			update ConceptoContableE set
				Cdescripcion    = <cfqueryparam cfsqltype="cf_sql_varchar"	value="#Form.Cdescripcion#">,
				Ctiponumeracion = <cfqueryparam cfsqltype="cf_sql_integer" 	value="#Form.CTipoNumeracion#">,
                NoGeneraNap     = <cfqueryparam cfsqltype="cf_sql_bit" 	 	value="#Form.NoGeneraNap#">,
			<cfif isdefined("Form.TipoSAT") and len(trim(Form.TipoSAT))>
				TipoSAT			= <cfqueryparam cfsqltype="cf_sql_varchar" 	 value="#Form.TipoSAT#">
			<cfelse>
				TipoSAT			= null
			</cfif>
			where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer"		value="#Session.Ecodigo#" >
			  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_integer" 		value="#Form.Cconcepto#">
		</cfquery>

		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="ConceptoContableE.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Cconcepto" type="hidden" value="<cfif isdefined("Form.Cconcepto") and modo NEQ 'ALTA'>#Form.Cconcepto#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</cfoutput>
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>
