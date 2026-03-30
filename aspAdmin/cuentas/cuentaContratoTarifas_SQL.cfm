<cfparam name="modo" default="ALTA">
<cfparam name="modoDR" default="ALTA">

<!--- <cfdump var="#form#">
<cfabort> --->

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_PaqTarifa" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert ClienteContratoTarifas 
				(COcodigo, TCcodigo, COTmeses)
				values (
					<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.COTmeses#" cfsqltype="cf_sql_integer">
				)

				insert ClienteContratoRangos 
					(COcodigo, TCcodigo, CORhasta, CORdesde, CORtarifaFija, CORtarifaVariable)	
				Select <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric"> as COcodigo
					, TCcodigo
					, TRDhasta
					, 1
					, TRDtarifaFija
					, TRDtarifaVariable
				from TarifaRangosDefaults
				where TCcodigo=<cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					
				<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Cambio")>
				update ClienteContratoTarifas set 
					 	COTmeses = <cfqueryparam value="#form.COTmeses#" cfsqltype="cf_sql_integer">
				where COcodigo= <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					
				if not exists(
						select 1
						from ClienteContratoRangos
						where COcodigo= <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
							and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">					 
					 )					 
				begin
					insert ClienteContratoRangos 
					(COcodigo, TCcodigo, CORhasta, CORdesde, CORtarifaFija, CORtarifaVariable)
					values (
						<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
						, 999999999999999
						, 0
						, 0
						, 0
					)				
				end					
									  
				  <cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete ClienteContratoRangos
				where COcodigo= <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
										
				delete ClienteContratoTarifas
				where COcodigo= <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
			<cfelseif isdefined("form.AltaDR")>
				insert ClienteContratoRangos 
					(COcodigo, TCcodigo, CORhasta, CORdesde, CORtarifaFija, CORtarifaVariable)
					values (
						<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.CORhasta#" cfsqltype="cf_sql_numeric">
						, 1
						, <cfqueryparam value="#form.CORtarifaFija#" cfsqltype="cf_sql_money">
						, <cfqueryparam value="#form.CORtarifaVariable#" cfsqltype="cf_sql_money">
					)
			
				<cfset modo = 'CAMBIO'>
			  	<cfset modoDR = 'CAMBIO'>
			<cfelseif isdefined("form.BajaDR")>
				delete ClienteContratoRangos
				where COcodigo= <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo= <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and CORhasta= <cfqueryparam value="#form.CORhasta#" cfsqltype="cf_sql_numeric">
		
			  	<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.CambioDR")>
				update ClienteContratoRangos	
					set CORtarifaFija=<cfqueryparam value="#form.CORtarifaFija#" cfsqltype="cf_sql_money">
					, CORtarifaVariable= <cfqueryparam value="#form.CORtarifaVariable#" cfsqltype="cf_sql_money">
				where COcodigo = <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and CORhasta= <cfqueryparam value="#form.CORhasta#" cfsqltype="cf_sql_numeric">	
<!--- 				    and timestamp = convert(varbinary,#lcase(Form.timestamp)#) --->
					
				<cfset modo = 'CAMBIO'>	
				<cfset modoDR = 'CAMBIO'>								
			<cfelseif isdefined("form.NuevoDR")>
			  	<cfset modo = 'CAMBIO'>				
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
	<form action="CuentaPrincipal_tabs.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="cliente_empresarial"   type="hidden" value="<cfif isdefined("form.cliente_empresarial")>#form.cliente_empresarial#</cfif>">		
		<input name="COcodigo" type="hidden" value="<cfif isdefined("form.cliente_empresarial")>#form.COcodigo#</cfif>">
		<cfif modo eq 'CAMBIO'>
			<input name="TCcodigo" type="hidden" value="#form.TCcodigo#">			
			<cfif modoDR eq 'CAMBIO'><input name="CORhasta" type="hidden" value="#form.CORhasta#"></cfif>
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
