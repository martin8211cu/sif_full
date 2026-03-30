
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="TipoOrganizacion" datasource="sifpublica">
				insert into EmpresaOrganizacion (EEid, ETdescripcion,BMfechaalta, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="TipoOrganizacion" datasource="sifpublica">
				delete from EmpresaOrganizacion
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="TipoOrganizacion" datasource="sifpublica">
				update EmpresaOrganizacion set 
					EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					ETdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.ETdescripcion#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where ETid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETid#">
			</cfquery>
			<cfset modo="CAMBIO">				
		</cfif>			
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<input name="EEid" type="hidden" value="<cfoutput>#Form.EEid#</cfoutput>">
	<cfif isdefined("Form.ETid") and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
		<input name="ETid" type="hidden" value="<cfoutput>#Form.ETid#</cfoutput>">
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