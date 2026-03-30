
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="EmpEncuestadoras" datasource="sifpublica">
				insert into EncuestaEmpresa (EEcodigo, EEnombre, Ppais,BMfechaalta, BMUsucodigo,EEcache)
				values (
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EEcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEnombre#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEcache#">
				)
			</cfquery>
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery name="EmpEncuestadoras" datasource="sifpublica">
				delete EncuestaEmpresa
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>
			<cfset modo="BAJA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="ABC_Idiomas" datasource="sifpublica">
				update EncuestaEmpresa set 
					EEcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.EEcodigo#">, 
					EEnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEnombre#">, 
					Ppais = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">,
					BMfechaalta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					EEcache = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEcache#">
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<cfif isdefined("Form.Nuevo")>
		<input name="Nuevo" type="hidden" value="Nuevo"> 
	</cfif>	
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<cfif isdefined("Form.EEid") and not isDefined("Form.Baja")>
		<input name="EEid" type="hidden" value="<cfoutput>#Form.EEid#</cfoutput>">
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