<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_ConceptoContable" datasource="#Session.DSN#">
			insert into ConceptoContable (Ecodigo, Oorigen, Cconcepto, Cdescripcion, Resumir, Chknoreglas, Chknovalmayor, Chknovaloficinas)
			values(
					<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Form.Cconcepto#" cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Form.Cdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfif isDefined("Form.Resumir")>
					<cfqueryparam value="#form.Resumir#" cfsqltype="cf_sql_integer">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_integer">,
				</cfif>
				<cfif isDefined("Form.Chknoreglas")>
					<cfqueryparam value="#form.Chknoreglas#" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif isDefined("Form.Chknovalmayor")>
					<cfqueryparam value="#form.Chknovalmayor#" cfsqltype="cf_sql_bit">,
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif isDefined("Form.Chknovaloficinas")>
					<cfqueryparam value="#form.Chknovaloficinas#" cfsqltype="cf_sql_bit">
				<cfelse>
					<cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfif>
			)
		</cfquery>
				<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="ABC_ConceptoContable" datasource="#Session.DSN#">
				delete from ConceptoContable
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_varchar">	
		</cfquery>			  
				  <cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp datasource="#session.DSN#"
				table="ConceptoContable"
				redirect="ConceptoContable.cfm"
				timestamp="#form.ts_rversion#"
				
				field1="Ecodigo"
				type1="integer"
				value1="#Session.Ecodigo#"
				
				field2="Oorigen"
				type2="varchar"
				value2="#Form.Oorigen#">
			<cfquery name="ABC_ConceptoContable" datasource="#Session.DSN#">
				update ConceptoContable set
					Cdescripcion = <cfqueryparam value="#Form.Cdescripcion#" cfsqltype="cf_sql_varchar">,
					Cconcepto = <cfqueryparam value="#Form.Cconcepto#" cfsqltype="cf_sql_integer">,							
				<cfif isDefined("Form.Resumir")>
					Resumir = <cfqueryparam value="#form.Resumir#" cfsqltype="cf_sql_integer">,
				<cfelse>
					Resumir = <cfqueryparam value="0" cfsqltype="cf_sql_integer">,
				</cfif>
				<cfif isDefined("Form.Chknoreglas")>
					Chknoreglas = <cfqueryparam value="#form.Chknoreglas#" cfsqltype="cf_sql_bit">,
				<cfelse>
					Chknoreglas = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif isDefined("Form.Chknovalmayor")>
					Chknovalmayor = <cfqueryparam value="#form.Chknovalmayor#" cfsqltype="cf_sql_bit">,
				<cfelse>
					Chknovalmayor = <cfqueryparam value="0" cfsqltype="cf_sql_bit">,
				</cfif>
				<cfif isDefined("Form.Chknovaloficinas")>
					Chknovaloficinas = <cfqueryparam value="#form.Chknovaloficinas#" cfsqltype="cf_sql_bit">
				<cfelse>
					Chknovaloficinas = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
				</cfif>	
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_varchar">
			</cfquery>
					  <cfset modo="CAMBIO">
	</cfif>
</cfif>
<form action="ConceptoContable.cfm" method="post" name="sql">
	<cfoutput>
			<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif modo neq "ALTA" >
			<input name="Oorigen" type="hidden" value="<cfif isdefined("Form.Oorigen") >#Form.Oorigen#</cfif>">
		</cfif>
		<cfif isdefined("form.PageNum")>
			<input type="hidden" name="PageNum" value="#form.PageNum#">
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
