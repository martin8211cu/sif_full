<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="validaCodigo" datasource="sifpublica">
				select EACodigo from EmpresaArea
				where EACodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EACodigo#">
			</cfquery>
			<cfif validaCodigo.recordCount GT 0>
					<cfset msg = "El código ya existe para otras área">
					<cfthrow message="#msg#">
					<cfabort>
			<cfelse>
					<cfquery name="Area" datasource="sifpublica">
					insert into EmpresaArea (EEid,EACodigo,EAdescripcion,BMfechaalta, BMUsucodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EACodigo#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EAdescripcion#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
				</cfquery>
				<cfset modo="ALTA">
			</cfif>
			
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="Area" datasource="sifpublica">
				delete from EmpresaArea
				where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="validaCodigo" datasource="sifpublica">
				select EACodigo from EmpresaArea
				where EACodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EACodigo#">
				and EAid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
			</cfquery>
			<cfif validaCodigo.recordCount GT 0>
					<cfset msg = "El código ya existe para otras área">
					<cfthrow message="#msg#">
					<cfabort>
			<cfelse>
				<cfquery name="Area" datasource="sifpublica">
					update EmpresaArea set 
						EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">,
						EACodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EACodigo#">,
						EAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EAdescripcion#">,
						BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
				</cfquery>
				<cfset modo="CAMBIO">	
			</cfif>				
		</cfif>			
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<input name="EEid" type="hidden" value="<cfoutput>#Form.EEid#</cfoutput>"> 
	<input name="tab" type="hidden" value="2"> 
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.EAid") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
		<input name="EAid" type="hidden" value="<cfoutput>#Form.EAid#</cfoutput>">
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