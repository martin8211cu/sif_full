
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cftransaction>
			<cfquery datasource="#session.dsn#" name="rsValidar">
				select count(1) as valor
				from EFormato
				where upper(rtrim(ltrim(EFcodigo))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(rtrim(Form.EFcodigo))#">
				and Ecodigo in (select Ecodigo from Empresas where cliente_empresarial=#session.cecodigo#)
			</cfquery>
			<cfif rsValidar.valor>
				<cf_errorCode code="50019" msg="El código del registro ya existe">
			</cfif>
			<cfquery name="rsFormatCorreos" datasource="#Session.DSN#">
				insert INTO EFormato (EFcodigo, Ecodigo, EFdescripcion, TFid, Usucodigo, Ulocalizacion, EFfecha, EFpautogestion, EFdescalterna, EFCorreoNotificar, EFDiasAntesVencimiento)
				values (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFdescripcion#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
					<cfif isdefined("form.EFpautogestion")>1<cfelse>0</cfif>,
					null,
					<cfif isdefined("form.EFcorreo") and len(trim(form.EFcorreo)) gt 0>
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EFcorreo#">,
					<cfelse>
						null,
					</cfif>
					<cfif isdefined("form.EFdiasVen") and len(trim(form.EFdiasVen)) gt 0>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFdiasVen#">
					<cfelse>
						null
					</cfif>
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="rsFormatCorreos">
		</cftransaction>		
		<cf_translatedata name="set" tabla="EFormato" col="EFdescripcion" valor="#Form.EFdescripcion#" filtro="EFid = #rsFormatCorreos.identity#">


		<cfif isdefined('rsFormatCorreos.identity') and rsFormatCorreos.identity NEQ ''>
			<cfset vDFtexto = form.DFtexto >
			<cfquery datasource="#Session.DSN#">
				insert INTO DFormato(EFid, DFtexto)
				values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFormatCorreos.identity#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDFtexto)#">
					)
			</cfquery>
			<cf_translatedata name="set" tabla="DFormato" col="DFtexto" valor="#PreserveSingleQuotes(vDFtexto)#" filtro="EFid = #rsFormatCorreos.identity#">
		</cfif>

		<cfset modo = "Alta">
	<cfelseif isdefined("Form.Baja")>
		<cfquery datasource="#Session.DSN#">
			delete from DFormato
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#"> 
				and DFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DFlinea#">
		</cfquery>
		
		<cfquery datasource="#Session.DSN#">			
			delete from EFormato
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#"> 
		</cfquery>				
		
		<cfset modo = "Baja">
	<cfelseif isdefined("Form.Cambio")>	
		<cfquery datasource="#session.dsn#" name="rsValidar">
			select count(1) as valor
			from EFormato
			where upper(rtrim(ltrim(EFcodigo))) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(rtrim(Form.EFcodigo))#">
			and Ecodigo in (select Ecodigo from Empresas where cliente_empresarial=#session.cecodigo#)
			and EFid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
		</cfquery>
		<cfif rsValidar.valor>
			<cf_errorCode code="50019" msg="El código del registro ya existe">
		</cfif>
		<cfquery datasource="#Session.DSN#">
			update EFormato
			   set EFcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFcodigo#">,
				   EFdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.EFdescripcion#">,
				   TFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TFid#">,
				   EFfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#now()#">,
				   	<cfif isdefined("form.EFcorreo") and len(trim(form.EFcorreo)) gt 0>
						EFCorreoNotificar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EFcorreo#">,
					</cfif>
					<cfif isdefined("form.EFdiasVen") and len(trim(form.EFdiasVen)) gt 0>
						EFDiasAntesVencimiento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EFdiasVen#">,
					</cfif>
					EFpautogestion = <cfif isdefined("form.EFpautogestion")>1<cfelse>0</cfif>
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#">
		</cfquery>
		<cf_translatedata name="set" tabla="EFormato" col="EFdescripcion" valor="#Form.EFdescripcion#" filtro="EFid = #Form.EFid#">

		<cfset vDFtexto = form.DFtexto >
		<cfquery datasource="#Session.DSN#">
			update DFormato
			   set DFtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(vDFtexto)#">
			where EFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EFid#"> 
				and DFlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DFlinea#"> 
		</cfquery>
		<cf_translatedata name="set" tabla="DFormato" col="DFtexto" valor="#PreserveSingleQuotes(vDFtexto)#" filtro="DFlinea = #Form.DFlinea#">
		
		<cfset modo = "Cambio">
	</cfif>			
</cfif>	

<cfoutput>
	<cfset param = ''>
	<cfif isdefined("form.Cambio") and isdefined("form.EFid") and len(trim(form.EFid))>
		<cfset param = param & "?EFid=#form.EFid#">
	<cfelseif isdefined("Form.Alta") and isdefined("rsFormatCorreos.identity") and len(trim(rsFormatCorreos.identity))>
		<cfset param = param & "?EFid=#rsFormatCorreos.identity#">
	</cfif>
	<cflocation url="FormatosCorreo-form.cfm#param#">
</cfoutput>