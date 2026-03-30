<!--- <cf_dump var="#Form#"> --->
<cfset params = "">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsExiste" datasource="#session.DSN#">
			select top 1 Codigo from CPValidacionValores  
			where Ecodigo = #Session.Ecodigo#
			  and Codigo = <cfqueryparam value="#Form.CPCodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		
		<cfif rsExiste.RecordCount eq 0>
			<cfquery name="rsInsert" datasource="#Session.DSN#">
				insert into CPValidacionValores (Codigo, Descripcion, Ecodigo, BMUsucodigo)
				values ( <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Form.CPCodigo)#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CPDescripcion)#">, 
						 #session.Ecodigo#, 
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
			<cfset Form.CPVid = rsInsert.identity>
			<cfset modo = 'ALTA' >
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select Codigo
				from CPValidacionValores 
				where Ecodigo =  #session.Ecodigo#
				order by Codigo 
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Codigo EQ form.CPCodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&CPCodigo="&form.CPCodigo>	
		</cfif>
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsDelete" datasource="#Session.DSN#">
			delete from CPValidacionConfiguracion
			where Ecodigo = #Session.Ecodigo#
			  and CPVid  = <cfqueryparam value="#Form.CPVid#" cfsqltype="cf_sql_numeric">
			delete from CPValidacionValores
			where Ecodigo = #Session.Ecodigo#
			  and Codigo  = <cfqueryparam value="#Form.CPCodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfset modo = 'ALTA' >			
		<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select Codigo
				from CPValidacionValores 
				where Ecodigo =  #session.Ecodigo#
				order by Codigo 
		</cfquery>
		<cfset pag = Ceiling(rsPagina.RecordCount / form.MaxRows)>
		<cfif form.Pagina GT pag>
			<cfset form.Pagina = pag>
		</cfif>
	<cfelseif isdefined("Form.Cambio")>
		<cfquery name="Transacciones" datasource="#Session.DSN#">
			update CPValidacionValores set 
				  Descripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CPDescripcion)#">
			where Ecodigo = #Session.Ecodigo#
			  and Codigo = <cfqueryparam value="#Form.CPCodigo#" cfsqltype="cf_sql_char">
		</cfquery>
		<cfset modo = 'ALTA' >
			<cfquery name="rsPagina" datasource="#session.DSN#">
			 	select Codigo
				from CPValidacionValores 
				where Ecodigo =  #session.Ecodigo#
				order by Codigo 
			</cfquery>
			<cfset row = 1>
			<cfif rsPagina.RecordCount LT 500>
				<cfloop query="rsPagina">
					<cfif rsPagina.Codigo EQ form.CPCodigo>
						<cfset row = rsPagina.currentrow>
						<cfbreak>
					</cfif>
				</cfloop>
			</cfif>
			<cfset form.pagina = Ceiling(row / form.MaxRows)>
			<cfset params=params&"&CPCodigo="&form.CPCodigo>	
	</cfif>
<cfelse>
	<cfset modo = 'ALTA' >
</cfif>

<cfoutput>
<form action="CPValidacionValores.cfm" method="post" name="sql">
    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CPVid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CPVid)#</cfoutput></cfif>">
</form>
</cfoutput>	
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>