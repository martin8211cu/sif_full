<cfparam name="modo" default="ALTA">
<cfparam name="modoDR" default="ALTA">

<!--- <cfdump var="#form#">
<cfabort> --->

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_PaqTarifa" datasource="#session.DSN#">
			set nocount on

			<cfif isdefined("form.Alta")>
				insert PaqueteTarifas 
				(PAcodigo, TCcodigo, PTmeses)
				values (
					<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.PTmeses#" cfsqltype="cf_sql_integer">)
					
				insert PaqueteRangoDefault 
					(PAcodigo, TCcodigo, PRDhasta, PRDtarifaFija, PRDtarifaVariable)
				Select <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric"> as PAcodigo
					, TCcodigo
					, TRDhasta
					, TRDtarifaFija
					, TRDtarifaVariable
				from TarifaRangosDefaults
				where TCcodigo=<cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					
				<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Cambio")>
				update PaqueteTarifas set 
					 	PTmeses = <cfqueryparam value="#form.PTmeses#" cfsqltype="cf_sql_integer">
				where PAcodigo = <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					
				if not exists(
						select 1
						from PaqueteRangoDefault
						where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
							and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">					 
					 )					 
				begin
					insert PaqueteRangoDefault 
					(PAcodigo, TCcodigo, PRDhasta, PRDtarifaFija, PRDtarifaVariable)
					values (
						<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
						, 999999999999999
						, 0
						, 0)				
				end					
				  
				<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete PaqueteRangoDefault
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">		
					
				delete PaqueteTarifas
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
			<cfelseif isdefined("form.AltaDR")>
				insert PaqueteRangoDefault 
				(PAcodigo, TCcodigo, PRDhasta, PRDtarifaFija, PRDtarifaVariable)
				values (
					<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.PRDhasta#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.PRDtarifaFija#" cfsqltype="cf_sql_money">
					, <cfqueryparam value="#form.PRDtarifaVariable#" cfsqltype="cf_sql_money">)
				
				<cfset modo = 'CAMBIO'>
			  	<cfset modoDR = 'CAMBIO'>
			<cfelseif isdefined("form.BajaDR")>
				delete PaqueteRangoDefault
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo= <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and PRDhasta= <cfqueryparam value="#form.PRDhasta#" cfsqltype="cf_sql_numeric">
		
			  	<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.CambioDR")>
				update PaqueteRangoDefault	
					set PRDtarifaFija=<cfqueryparam value="#form.PRDtarifaFija#" cfsqltype="cf_sql_money">
					, PRDtarifaVariable= <cfqueryparam value="#form.PRDtarifaVariable#" cfsqltype="cf_sql_money">
				where PAcodigo = <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and PRDhasta= <cfqueryparam value="#form.PRDhasta#" cfsqltype="cf_sql_numeric">	
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
	<form action="paquete.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="PAcodigo" type="hidden" value="#form.PAcodigo#">		
		<cfif modo eq 'CAMBIO'>
			<input name="TCcodigo" type="hidden" value="#form.TCcodigo#">			
			<cfif modoDR eq 'CAMBIO'><input name="PRDhasta" type="hidden" value="#form.PRDhasta#"></cfif>
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
