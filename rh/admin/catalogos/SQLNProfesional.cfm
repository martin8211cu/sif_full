
<cfparam name="action" default="NivelProfesional.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo")>
	<cfif isdefined("form.Alta")>
		<cfquery name="ABC_NProfesional_in" datasource="#session.DSN#">
			insert into NProfesional ( Ecodigo, NPcodigo, NPdescripcion )
			 values ( <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">,
					  <cfqueryparam value="#form.NPcodigo#"       cfsqltype="cf_sql_varchar">,
					  <cfqueryparam value="#form.NPdescripcion#"   cfsqltype="cf_sql_varchar">
					)
		</cfquery>

				
	<cfelseif isdefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="NProfesional"
				redirect="formNivelProfesional.cfm"
				timestamp="#form.ts_rversion#"
				field1="Ecodigo" 
				type1="numeric" 
				value1="#Session.Ecodigo#"
				field2="NPcodigo" 
				type2="varchar" 
				value2="#form.NPcodigo#"
		>
		
		<cfquery name="ABC_NProfesional_up" datasource="#session.DSN#">
			update NProfesional 
			set NPdescripcion = <cfqueryparam value="#form.NPdescripcion#" cfsqltype="cf_sql_varchar">
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and rtrim(NPcodigo) =  <cfqueryparam  value="#trim(form.NPcodigo)#" cfsqltype="cf_sql_varchar">
		</cfquery> 				<!--- muy raro el rtrim , pero si no se hace asi no agarra el update porque 'xx' != 'xx ' en oracle 9.2.0.1.0 --->

				  
	<cfelseif isdefined("form.Baja")>
		<cfquery name="ABC_NProfesional_de" datasource="#session.DSN#">
			delete from NProfesional
			where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and rtrim(NPcodigo) =  <cfqueryparam  value="#trim(form.NPcodigo)#" cfsqltype="cf_sql_varchar">
<!---			  and NPcodigo =  <cfqueryparam value="#form.NPcodigo#" cfsqltype="cf_sql_char">--->
		</cfquery>

			  
	</cfif>
</cfif>	

<cfoutput>
<form action="NivelProfesional.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>