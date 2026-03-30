
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cftransaction>
				<cfquery name="EmpEncuestadoras" datasource="sifpublica">
					insert into EncuestaEmpresa (EEcodigo, EEnombre, Ppais,BMfechaalta, BMUsucodigo)
					values (
						<cfqueryparam cfsqltype="cf_sql_char" value="#Form.EEcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EEnombre#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Ppais#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					)
					<cf_dbidentity1 datasource="sifpublica">
				</cfquery>
				<cf_dbidentity2 datasource="sifpublica" name="EmpEncuestadoras">
			</cftransaction>
		
			<cfset modo="ALTA">
		<cfelseif isdefined("Form.Baja")>			
			<cfquery datasource="sifpublica">
				delete from EncuestaPuesto
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>
			<cfquery datasource="sifpublica">
				delete from EmpresaArea
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>				
			<cfquery datasource="sifpublica">
				delete from EmpresaOrganizacion
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>			
			
			<cfquery datasource="sifpublica">
				delete from Encuesta
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>			
			<cfquery datasource="sifpublica">
				delete from EncuestaSalarios
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>			
			<cfquery datasource="sifpublica">
				delete from EncuestaEmpresa
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
					BMUsucodigo	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				where EEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EEid#">
			</cfquery>
			<cfset modo="CAMBIO">				  				  
		</cfif>			
</cfif>

<form action="TEncuestadoras.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<cfif isdefined("Form.EEid") and len(trim(form.EEid)) and not isDefined("Form.Baja") and not isDefined("Form.Nuevo")>
			<input name="EEid" type="hidden" value="#Form.EEid#">
		<cfelseif isDefined("Form.Alta") and isdefined('EmpEncuestadoras')>
			<input name="EEid" type="hidden" value="#EmpEncuestadoras.identity#">
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>		
</form>

<html>
	<head>
	</head>
	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>