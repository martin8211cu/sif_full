<cftransaction>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.CAMBIO")>
		<cf_dbtimestamp datasource="#session.dsn#"
						table="SNegociosCorporativo"
						redirect="SNcorporativo.cfm"
						timestamp="#form.ts_rversion#"
						field1="SNCcodigo" type1="numeric" value1="#form.SNCcodigo#">
		<cfquery name="UpdSNegociosCorporativo" datasource="#session.DSN#">
			update SNegociosCorporativo
			set SNCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCnombre#">,
				SNCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNCidentificacion#">,
				SNCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNCtipo#">,
				SNCdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCdireccion#">,
				Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
				SNCtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCtelefono#">,
				SNCFax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCFax#">,
				SNCemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCemail#">,
				LOCidioma = <cfqueryparam cfsqltype="cf_sql_char" value="#form.LOCidioma#">,
				SNCcertificado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNCcertificado#">,
				SNCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#form.SNCfecha#">

			where SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCcodigo#">
		</cfquery>
		
		<cfquery name="UpdSNegocios" datasource="#session.DSN#">
			update SNegocios
			set SNCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCnombre#">,
				SNCidentificacion = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNCidentificacion#">,
				SNCtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNCtipo#">,
				SNCdireccion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCdireccion#">,
				Ppais = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Ppais#">,
				SNCtelefono =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCtelefono#">,
				SNCFax = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCFax#">,
				SNCemail = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.SNCemail#">,
				LOCidioma = <cfqueryparam cfsqltype="cf_sql_char" value="#form.LOCidioma#">,
				SNCcertificado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNCcertificado#">,
				SNCfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#form.SNCfecha#">
			where SNCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNCcodigo#">
		</cfquery>
	<cfset modo = "CAMBIO">
	
	</cfif>
</cfif>
</cftransaction>


<form action="SNcorporativo.cfm" method="post" name="sql">
	<cfoutput>
		<input type="hidden" name="modo" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input type="hidden" name="SNCcodigo"  value="<cfif isdefined("Form.SNCcodigo")>#Form.SNCcodigo#</cfif>">
	</cfoutput>
</form>


<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
