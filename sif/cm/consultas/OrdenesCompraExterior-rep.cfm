<!---<cfif 1 eq 1 >--->
<cfparam name="url.Formato" default="html">
<cfif #url.Formato# eq 'html'>
	<cfif rsReporte.iden  eq '815646-8'>	<!---815646-8 2PINOS    305-414-68335 D.V. 49  SOIN--->
    	<cfset LvarHTML = "OrdenCompraExterior2pg-html.cfm">
    <cfelse>
    	<cfset LvarHTML = "OrdenCompraExterior-html.cfm">
    </cfif>
	<cfif isdefined("url.conImpresion") and url.conImpresion EQ 'N' >
		<cfinclude template="#LvarHTML#">
	<cfelse>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfinclude template="#LvarHTML#">
	</cfif>
<cfelseif #url.Formato# eq 'pdf' or #url.Formato# eq 'fla'>
	<cfinclude template="OCExterior.cfm">
</cfif>
	<!---<cfif not isdefined("form.formato") >
		<cfset tipoformato = "html">
	<cfelse>
		<cfset tipoformato = #form.formato#>
	</cfif>--->
	<!--- Asignacion de Valores a variables globales --->
<!---	<cfset fecha_hoy = DateFormat(now(),'dd/mm/yyyy')>
	<cfset Hora_hoy = TimeFormat(now())>
			
	<cfquery name="rsLineasOrden" datasource="#session.dsn#">
		select count(DOlinea) as lineas 
		from DOrdenCM 
		where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer"  value="#session.ecodigo#">
			and EOnumero=<cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.EOnumero#">  
	</cfquery>
		
	<cfif rsLineasOrden.lineas GE 4>
		<CF_JasperReport DATASOURCE="#session.dsn#" 
						 OUTPUT_FORMAT="#tipoformato#"
						 JASPER_FILE="/sif/cm/consultas/OCExterior.jasper">
							
			<!--- ****************  Envia nombre y codigo de la empresa ********************** --->	
			<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">
			<CF_JasperParam name="enombre"   value="#session.enombre#">
			
			<!--- ****************  Envia fecha y hora del sistema ************************** --->	
			<CF_JasperParam name="Fecha"   value="#fecha_hoy#">
			<CF_JasperParam name="Hora"   value="#hora_hoy#">
					
			<!--- ****************  Envia el numero de la orden ************************** --->		
			<cfif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) NEQ 0>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
			<cfelseif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) EQ 0>
				<CF_JasperParam name="EOnumero"   value="-1"> 
			</cfif>
				
			<!----
			<cfif isdefined("form.EOnumero") and len(trim(form.EOnumero)) and isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH))>
				<cfif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) NEQ 0>
					<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
				<cfelseif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) EQ 0>
					<CF_JasperParam name="EOnumero"   value="-1"> 
				</cfif>	
					
				<cfif isDefined("Form.EOnumeroH") and len(trim(form.EOnumeroH)) NEQ 0>
					<CF_JasperParam name="EOnumeroH"   value="#form.EOnumeroH#">
				<cfelseif isDefined("Form.EOnumeroH") and len(trim(form.EOnumeroH)) EQ 0>
					<CF_JasperParam name="EOnumeroH"   value="-1"> 
				</cfif>
				
			<cfelseif isdefined("form.EOnumero") and len(trim(form.EOnumero)) and not (isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH)))>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
				<CF_JasperParam name="EOnumeroH"   value="#form.EOnumero#">
			<cfelseif isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH)) and not (isdefined("form.EOnumero") and len(trim(form.EOnumero)))>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumeroH#">
				<CF_JasperParam name="EOnumeroH"   value="#form.EOnumeroH#">
			</cfif>		
			--->
		</CF_JasperReport>--->
		
	<!---<cfelse>
		<CF_JasperReport DATASOURCE="#session.dsn#" 
						 OUTPUT_FORMAT="#tipoformato#"
						 JASPER_FILE="/sif/cm/consultas/OCExteriorC.jasper">
							
			<!--- ****************  Envia nombre y codigo de la empresa ********************** --->	
			<CF_JasperParam name="Ecodigo"   value="#session.Ecodigo#">
			<CF_JasperParam name="enombre"   value="#session.enombre#">
			
			<!--- ****************  Envia fecha y hora del sistema ************************** --->	
			<CF_JasperParam name="Fecha"   value="#fecha_hoy#">
			<CF_JasperParam name="Hora"   value="#hora_hoy#">
					
			<!--- ****************  Envia el numero de la orden ************************** --->		
			<cfif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) NEQ 0>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
			<cfelseif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) EQ 0>
				<CF_JasperParam name="EOnumero"   value="-1"> 
			</cfif>				
				
			<!---
			<cfif isdefined("form.EOnumero") and len(trim(form.EOnumero)) and isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH))>
				<cfif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) NEQ 0>
					<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
				<cfelseif isDefined("Form.EOnumero") and len(trim(form.EOnumero)) EQ 0>
					<CF_JasperParam name="EOnumero"   value="-1"> 
				</cfif>	
				
				<cfif isDefined("Form.EOnumeroH") and len(trim(form.EOnumeroH)) NEQ 0>
					<CF_JasperParam name="EOnumeroH"   value="#form.EOnumeroH#">
				<cfelseif isDefined("Form.EOnumeroH") and len(trim(form.EOnumeroH)) EQ 0>
					<CF_JasperParam name="EOnumeroH"   value="-1"> 
				</cfif>
			
			<cfelseif isdefined("form.EOnumero") and len(trim(form.EOnumero)) and not (isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH)))>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumero#">
				<CF_JasperParam name="EOnumeroH"   value="#form.EOnumero#">
			<cfelseif isdefined("form.EOnumeroH") and len(trim(form.EOnumeroH)) and not (isdefined("form.EOnumero") and len(trim(form.EOnumero)))>
				<CF_JasperParam name="EOnumero"   value="#form.EOnumeroH#">
				<CF_JasperParam name="EOnumeroH"   value="#form.EOnumeroH#">
			</cfif>
			---->		
		</CF_JasperReport>
	</cfif>
</cfif>--->

