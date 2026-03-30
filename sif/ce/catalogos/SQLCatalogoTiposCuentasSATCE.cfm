<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select top 1 Codigo from CEClasificacionCuentasSAT
			where Codigo = <cfqueryparam value="#Form.Codigo#" cfsqltype="cf_sql_char">
		</cfquery>

	<cfif rsExiste.recordcount neq 0>
		<cfthrow message ="El C&oacute;digo #Form.Codigo# ya existe.">
	</cfif>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into CEClasificacionCuentasSAT (Codigo, Descripcion)
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.Codigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.Descripcion)#">
					)
			    <cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
				<cfset Form.Id_CCS = rsInsert.identity>
				<cfset modo = 'ALTA' >

		<cfquery name="rsPagina" datasource="#session.DSN#">
		 	select Codigo
			from CEClasificacionCuentasSAT
			order by Codigo
		</cfquery>

			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Codigo EQ form.Codigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&Codigo="&form.Codigo>
	</cfif>

	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CEClasificacionCuentasSAT set
				  Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.Descripcion)#">
			where Id_CCS = <cfqueryparam value="#Form.Id_CCS#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo = 'ALTA' >
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select Codigo
				from CEClasificacionCuentasSAT
				order by Codigo
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Codigo EQ form.Codigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&Codigo="&form.Codigo>
	<cfelseif isdefined("Form.Buscar")>
		<cfset modo = 'ALTA' >
	</cfif>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>

<cfoutput>
<form action="CatalogoTiposCuentasSATCE.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="Id_CCS" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.Id_CCS)#</cfoutput></cfif>">
<cfif isdefined("Form.Buscar")>
	<input name="filtros" type="hidden" value="1">
	<cfif isdefined('form.Codigo') and  form.Codigo neq ''>
		 	<input name="Codigo" type="hidden" tabindex="-1" value="#Form.Codigo#">
	</cfif>

	<cfif isdefined('form.Descripcion') and form.Descripcion neq ''>
		 	<input name="Descripcion" type="hidden" tabindex="-1" value="#Form.Descripcion#">
	</cfif>
</cfif>

</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>