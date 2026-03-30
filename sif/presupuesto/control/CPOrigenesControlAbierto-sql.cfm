<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
			insert INTO CPOrigenesControlAbierto (Ecodigo, Oorigen, 
											CPOdesde, CPOhasta, 
											CPOfecha, Usucodigo, CPOborrado)
			values (
				#Session.Ecodigo#, 
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.Oorigen#">, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPOdesde)#">, 
				<cfif form.CPOhasta EQ ''>
				null,
				<cfelse>
				<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.CPOhasta)#" null="#form.CPOhasta EQ ''#">, 
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
				#session.usucodigo#,
				0
			)
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CPOrigenesControlAbierto" 
			redirect="CPOrigenesControlAbierto-.cfm"
			timestamp="#form.ts_rversion#"
			field1="Ecodigo,integer,#session.Ecodigo#"		
			field2="CPOid,numeric,#form.CPOid#">		
	
		<cfquery name="ABC_PeriodosPresupuesto" datasource="#Session.DSN#">
			update 	CPOrigenesControlAbierto 
			   set 	CPOborrado = 1, 
					UsucodigoBorrado = #session.Usucodigo#,
					CPOfechaBorrado = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			where Ecodigo  = #Session.Ecodigo#
			  and CPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPOid#">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
		<cfset modo="ALTA">  				  
	</cfif>			
</cfif>

<cfoutput>
<form action="CPOrigenesControlAbierto-.cfm" method="post" name="sql">
	<cfif modo EQ "CAMBIO">
	   	<input name="Oorigen" type="hidden" value="#form.Oorigen#">
	   	<input name="CPOdesde" type="hidden" value="#form.CPOdesde#">
	</cfif>
	<input name="PageNum" type="hidden" value="<cfif isdefined("Form.PageNum")><cfoutput>#Form.PageNum#</cfoutput></cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
