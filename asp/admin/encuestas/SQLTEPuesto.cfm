
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="Puesto" datasource="sifpublica">
				insert into EncuestaPuesto (EAid, EEid, EPcodigo, EPdescripcion, BMfechaalta, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EAid#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="Area" datasource="sifpublica">
				delete EncuestaPuesto
				where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Area" datasource="sifpublica">
				update EncuestaPuesto set 
					EAid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EAid#">, 
					EEid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEid#">, 
					EPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPcodigo#">, 
					EPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EPdescripcion#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where EPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EPid#">
			</cfquery>
			<cfset modo="CAMBIO">				
		</cfif>			
</cfif>

<form action="TEPuesto.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.EPcodigo") and not isDefined("Form.Baja")>
		<input name="EPcodigo" type="hidden" value="<cfoutput>#Form.EPcodigo#</cfoutput>">
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