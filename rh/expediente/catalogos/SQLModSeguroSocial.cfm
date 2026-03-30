

<cfif isdefined("Form.Cambio")>

	<!---Validacion del seguro social para mexico (el seguro social puede venir en blanco pero si no viene en 
	blanco el mismo debe contener 11 caracteres, y no sedeb repetirse con ningin numero de seguro para otro empleado) CarolRS--->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2025" default="0" returnvariable="vEsMexico"/>
	<cfif vEsMexico EQ 1>
		<cfquery name="rsRepite" datasource="#Session.DSN#">
			select DEnombre, DEapellido1 ,DEapellido2, DEidentificacion from DatosEmpleado 
			where upper(ltrim(rtrim(DESeguroSocial))) = '#ucase(trim(form.DESeguroSocial))#'
			and Ecodigo = #session.Ecodigo#
			<cfif isdefined('Form.DEid') and len(trim(Form.DEid))>
				and DEid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfif>
		</cfquery>
		
		<cfif rsRepite.RecordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElEmpleadoYaExiste"
				Default="El empleado: #rsRepite.DEidentificacion# - #rsRepite.DEnombre# #rsRepite.DEapellido1# #rsRepite.DEapellido2# ya posees ese numero de seguro social, por favor verifique"
				returnvariable="MSG_ElEmpleadoYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElEmpleadoYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
	</cfif>
	
	<cfif  FORM.DESeguroSocial neq FORM.DESeguroSocialActual>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="DatosEmpleado" 
			redirect="ModSeguroSocial.cfm"
			timestamp="#form.ts_rversion#"
			field1="DEid,numeric,#form.DEid#">
		<cftransaction>
			<cfquery name="ABC_datosEmpl" datasource="#Session.DSN#">
				update DatosEmpleado 
				set	DESeguroSocial	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DESeguroSocial#">
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
			</cfquery>
			<cfset RHRCCSSfecha = CreateDateTime(Form.ANO, Form.MES, 01, 00, 00, 00)>
			<cfquery name="ABC_RHRepCCSS" datasource="#session.DSN#">
				select Aplicado from RHRepCCSS
				where  DEid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
				and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANO#">
				and mes 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MES#">
			</cfquery>
			<cfif ABC_RHRepCCSS.recordCount eq 0  or (ABC_RHRepCCSS.recordCount gt 0 and ABC_RHRepCCSS.Aplicado eq 1)>
				
				
				<cfif not isdefined("form.DESeguroSocialActual") or not len(trim(form.DESeguroSocialActual))>
					<cfset seguro = form.DESeguroSocial>
				<cfelse>
					<cfset seguro = form.DESeguroSocialActual>
				</cfif>	
				
				<cfif len(trim(seguro))>
					<cfquery datasource="#session.DSN#">
						insert into RHRepCCSS (
							DEid,
							Ecodigo,
							RHRCCSStipo,
							RHRCCSSfecha,
							DESegSocial,
							Periodo,
							mes,
							Aplicado,
							BMUsucodigo,
							BMfechaalta
						)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
							1,
							<cfqueryparam value="#RHRCCSSfecha#" cfsqltype="cf_sql_timestamp">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#seguro#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.ANO#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MES#">,
							0,
							<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
							<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
						)
					</cfquery>
				</cfif>
			</cfif>	
		</cftransaction>
	</cfif>
</cfif>

<form action="ModSeguroSocial.cfm" method="get" name="sql">
	<input name="DEid" type="hidden" value="<cfif isdefined("form.DEid")><cfoutput>#form.DEid#</cfoutput></cfif>">	
	<input name="DESeguroSocial" type="hidden" value="<cfif isdefined("form.DESeguroSocial")><cfoutput>#form.DESeguroSocial#</cfoutput></cfif>">	
	<cfif isdefined("Form.Cambio")>
		<input name="aplicado" type="hidden" value="S">	
	</cfif>
</form>
<HTML>
<head></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>