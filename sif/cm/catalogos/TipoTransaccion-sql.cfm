<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into TTransaccionI (Ecodigo, CPcodigo, CPdescripcion, Usucodigo, fechaalta)
				values (<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				) 
		</cfquery>
		<cfset modo = "ALTA">
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from TTransaccionI
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">
		</cfquery>
		<cfset modo="ALTA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="TTransaccionI"
			 			redirect="TipoTransaccion.cfm"
			 			timestamp="#form.ts_rversion#"				
						field1="Ecodigo" 
						type1="integer" 
						value1="#session.Ecodigo#"
						field2="CPcodigo" 
						type2="char" 
						value2="#trim(form.CPcodigo)#">

		<cfquery name="update" datasource="#Session.DSN#">
			update TTransaccionI set 
				CPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CPdescripcion#" >
			where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and CPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CPcodigo#">
		</cfquery> 
		<cfset modo="CAMBIO">
		
	</cfif>
</cfif>

<cfoutput>
<form action="TipoTransaccion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CPcodigo" type="hidden" value="<cfif isdefined("form.CPcodigo") and modo neq 'ALTA'>#form.CPcodigo#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
