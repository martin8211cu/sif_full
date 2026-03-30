<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select top 1 CTPCcodigo from CTProcedimientoContratacion
			where Ecodigo = #Session.Ecodigo#
			  and CTPCcodigo = <cfqueryparam value="#Form.CTPCcodigo#" cfsqltype="cf_sql_char">
		</cfquery>

	<cfif rsExiste.recordcount neq 0>
		<cfthrow message ="El C�digo #Form.CTPCcodigo# ya existe.">
	</cfif>

	<cfif rsExiste.RecordCount eq 0>
		<cfquery name="rsInsert" datasource="#Session.DSN#">
			insert into CTProcedimientoContratacion (CTPCcodigo, CTPCdescripcion, Ecodigo, BMUsucodigo,Usucodigo)
			values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CTPCcodigo)#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CTPCdescripcion)#">,
					 #session.Ecodigo#,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
			    <cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
				<cfset Form.CPVid = rsInsert.identity>
				<cfset modo = 'ALTA' >

		<cfquery name="rsPagina" datasource="#session.DSN#">
		 	select CTPCcodigo
			from CTProcedimientoContratacion
			where Ecodigo =  #session.Ecodigo#
			order by CTPCcodigo
		</cfquery>

			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.CTPCcodigo EQ form.CTPCcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&CTPCcodigo="&form.CTPCcodigo>
	</cfif>
	<cfelseif isdefined("Form.Baja")>
	<!--- valida que no este en un contrato --->
			<cfquery name ="consultaContrato" datasource="#Session.DSN#">
				select 1
				from CTContrato
				where CTPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTPCid#">
			</cfquery>
	<cfif consultaContrato.recordcount eq 0>
		<cfquery name="rsDelete" datasource="#Session.DSN#">
			delete from CTProcedimientoContratacion
			where Ecodigo = #Session.Ecodigo#
			and CTPCid  = <cfqueryparam value="#Form.CTPCid#" cfsqltype="cf_sql_numeric">
		</cfquery>
	<cfelse>
			<cfthrow message ="El Procedimiento que se desea eliminar se encuentra asignado a un Contrato.">
	</cfif>

		<cfset modo = 'ALTA' >
		<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select CTPCcodigo
				from CTProcedimientoContratacion
				where Ecodigo =  #session.Ecodigo#
				order by CTPCcodigo
		</cfquery>
		<cfset pag = Ceiling(rsPagina.RecordCount / form.MaxRows)>
		<cfif form.Pagina GT pag>
			<cfset form.Pagina = pag>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CTProcedimientoContratacion set
				  CTPCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTPCdescripcion)#">
			where Ecodigo = #Session.Ecodigo#
			  and CTPCid = <cfqueryparam value="#Form.CTPCid#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfset modo = 'ALTA' >
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select CTPCcodigo
				from CTProcedimientoContratacion
				where Ecodigo =  #session.Ecodigo#
				order by CTPCcodigo
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.CTPCcodigo EQ form.CTPCcodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&CTPCcodigo="&form.CTPCcodigo>
	<cfelseif isdefined("Form.Buscar")>
		<cfset modo = 'ALTA' >
	</cfif>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>

<cfoutput>
<form action="ProcedimientoDContratacion.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CTPCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTPCid)#</cfoutput></cfif>">
<cfif isdefined("Form.Buscar")>
	<input name="filtros" type="hidden" value="1">
	<cfif isdefined('form.CTPCcodigo') and  form.CTPCcodigo neq ''>
		 	<input name="CTPCcodigo" type="hidden" tabindex="-1" value="#Form.CTPCcodigo#">
	</cfif>

	<cfif isdefined('form.CTPCdescripcion') and form.CTPCdescripcion neq ''>
		 	<input name="CTPCdescripcion" type="hidden" tabindex="-1" value="#Form.CTPCdescripcion#">
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