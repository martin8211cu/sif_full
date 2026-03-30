	<cfif isdefined("Form.Accion")>
		<cfif Form.Accion eq 'Alta'>
			<cfquery name="insert" datasource="#session.DSN#">
				insert into AResponsables(Aid, Usucodigo, Ulocalizacion, Ecodigo, Ocodigo, ARactivo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="00">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">,
						1
						<!---<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ARactivo#">---->)
			</cfquery>
			
		<cfelseif Form.Accion eq 'Cambio'>
			<cfquery name="update" datasource="#session.DSN#">
				Update AResponsables
					set ARactivo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ARactivo#">
				where Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
			</cfquery>		
		<cfelseif Form.Accion eq 'Baja'>
			<cfquery name="delete" datasource="#session.DSN#">
				Delete from AResponsables
				where Aid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Aid#">
					and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usucodigo#">
			</cfquery>
		</cfif>
	<cfelse>
		<cfset modo = 'ALTA'>
	</cfif>
<form action="Almacen.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="Aid" type="hidden" value="#Form.Aid#">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>