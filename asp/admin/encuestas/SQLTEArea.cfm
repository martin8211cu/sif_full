
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Area" datasource="sifpublica">
				insert into EmpresaArea (EEid, EAdescripcion,BMfechaalta, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EAdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="Area" datasource="sifpublica">
				delete EmpresaOrganizacion
				where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Area" datasource="sifpublica">
				update EmpresaArea set 
					EEid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEid#">, 
					EAdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EAdescripcion#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where EAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">
			</cfquery>
			<cfset modo="CAMBIO">				
		</cfif>			
</cfif>

<form action="TEArea.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.EAid") and not isDefined("Form.Baja")>
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