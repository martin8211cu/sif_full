<cfif IsDefined("form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
				table="RHEncuestaPuesto"
				redirect="metadata.code.cfm"
				timestamp="#form.ts_rversion#"
			
				field1="RHPcodigo"
				type1="char"
				value1="#form.RHPcodigo#"
			
				field2="Ecodigo"
				type2="integer"
				value2="#session.Ecodigo#"
			
				field3="EEid"
				type3="numeric"
				value3="#form.EEid#"
		>
	<cfquery datasource="#session.dsn#">
		update RHEncuestaPuesto
			set EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPid#">
			, BMfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			, BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">
	</cfquery>
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#">
		delete from RHEncuestaPuesto
		where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#" null="#Len(form.RHPcodigo) Is 0#">  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#" null="#Len(form.EEid) Is 0#">		
	</cfquery>
<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#">
		insert into RHEncuestaPuesto (
				RHPcodigo,
				Ecodigo,
				EEid,
				EPid,
				BMfecha,
				BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EEid#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EPid#">,
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
	</cfquery>
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<input name="EEid" type="hidden" value="<cfoutput>#Form.EEid#</cfoutput>"> 
	<input name="tab" type="hidden" value="5"> 
	<cfif isdefined("Form.RHPcodigo") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
		<input name="RHPcodigo" type="hidden" value="<cfoutput>#Form.RHPcodigo#</cfoutput>">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">	
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>
