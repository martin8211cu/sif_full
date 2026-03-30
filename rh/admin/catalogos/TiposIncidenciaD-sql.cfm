<cfparam name="session.Ecodigo" type="numeric">
<cfparam name="form.CIid" default="-1" type="numeric">

<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

<cftransaction>
	<cfset presets_text = RH_Calculadora.get_presets( )>
	<cfset values = RH_Calculadora.calculate ( presets_text & ";" & form.formulas)>
	<cfif IsDefined("values")>
		<cfset RH_Calculadora.validate_result ( values )>
	</cfif>
</cftransaction>

<cfif IsDefined("form.Boton")and form.Boton eq 'GUARDAR' and Len(RH_Calculadora.getCalc_error()) EQ 0>
	
	<cfquery name="ConsultaCIncidentesD" datasource="#session.DSN#">
		Select 1 
		From CIncidentesD
		Where CIid = #form.CIid#
	</cfquery>

	<cfif isdefined("ConsultaCIncidentesD") and (ConsultaCIncidentesD.RecordCount GT 0)>
		<cfquery name="UpdateCIncidentesD" datasource="#session.DSN#">
			update CIncidentesD
				set CIcalculo = <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.formulas#">,
				  <cfif isdefined("form.LIMITAR")>
						CIcantidad = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIcantidad#">,
				  <cfelse>
						CIcantidad = -1,
				  </cfif>
				  CIrango = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIrango#" null="#Len(form.CIrango) EQ 0 OR form.rango EQ '1'#">,
				  CItipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CItipo#">,
				<cfif IsDefined("form.AjustarDiaMes")>
				  CIdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIdia#">,
				  CImes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CImes#">,
				<cfelse>
				  CIdia = <cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
				  CImes = <cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
				</cfif>
				<cfif IsDefined("form.mesesoperiodos") and LEN(TRIM(form.mesesoperiodos))>
					CIsprango 		= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.mesesoperiodos#">,
					CIspcantidad 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SPDPeriodos#">,
				<cfelse>
					CIsprango 		= <cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
					CIspcantidad 	= <cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
				</cfif>
				<cfif IsDefined("form.MesCompleto")>
					CImescompleto = 1
				<cfelse>
					CImescompleto = 0
				</cfif>
				
				
				
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">
			</cfquery>
			
	<cfelse>
		<cfquery name="InsertCIncidentesD" datasource="#session.DSN#">
			insert into CIncidentesD (CIid, CIcantidad, CIrango, CItipo, CIdia, CImes, CIcalculo, CIsprango, CIspcantidad, CImescompleto)
			values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
				<cfif isdefined("form.LIMITAR")>
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIcantidad#">,
				<cfelse>
					 -1,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIrango#" null="#Len(form.CIrango) EQ 0 OR form.rango EQ '1'#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.CItipo#">,
				<cfif IsDefined("form.AjustarDiaMes")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CIdia#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CImes#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
					<cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#form.formulas#">,
				
				<cfif IsDefined("form.CIsprango")>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.mesesoperiodos#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SPDPeriodos#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
					<cfqueryparam cfsqltype="cf_sql_integer" null="yes">,
				</cfif>
				<cfif IsDefined("form.MesCompleto")>
					1
				<cfelse>
					0
				</cfif>
					)
				
		</cfquery>
	</cfif>
</cfif>

<cfset params = 'CIid=' & form.CIid>
<cfif isdefined('form.Regresar')>
	<cfset params = params & '&Regresar=' & form.Regresar>
</cfif>
<cflocation url="TiposIncidencia-formular.cfm?#params#">
