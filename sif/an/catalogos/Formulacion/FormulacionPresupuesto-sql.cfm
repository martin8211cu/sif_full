<cfset modo = "ALTA">

<cfif not isdefined("Form.Nuevo")>
<!---=================Agregar Formulación======================--->
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into ANformulacion (
				   ANFcodigo,
				   ANFdescripcion,
				   Ecodigo,
				   BMUsucodigo
				  )
			values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANFcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANFdescripcion#">,
					#Session.Ecodigo#,
					#session.Usucodigo#
				) 
		</cfquery>
		<cfset modo = "ALTA">
<!---====================Eliminar  Formulación=======================--->	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from ANformulacion
			  where ANFid =#form.ANFid# 
		</cfquery>
		<cfset modo="ALTA">
<!---====================Modificar Formulación=======================--->
	<cfelseif isdefined("Form.Cambio")>
		 <cf_dbtimestamp
					datasource="#session.dsn#"
					table="ANformulacion" 
					redirect="FormulacionPresupuesto.cfm"
					timestamp="#form.ts_rversion#"
					field1="ANFid,numeric,#form.ANFid# "
					>
		<cfquery name="update" datasource="#Session.DSN#">
			update ANformulacion set 
				   	ANFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.ANFdescripcion#">,
					BMUsucodigo = #session.Usucodigo#
			where ANFid       = #form.ANFid#
		</cfquery> 
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="FormulacionPresupuesto.cfm" method="post" name="sql">
	<input name="modo"  type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="ANFid" type="hidden" value="<cfif isdefined("form.ANFid") and modo neq 'ALTA'><cfoutput>#form.ANFid#</cfoutput></cfif>">
</form>

	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
