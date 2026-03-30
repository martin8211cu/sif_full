<cfparam name="modo" default="ALTA">
<cfparam name="modoD" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_TarifaCalculo" datasource="#session.DSN#">
			set nocount on
			<cfif isdefined("form.Alta")>
				insert TarifaCalculoIndicador 
				( TCnombre, TCtexto, TCtipoCalculo, TCsql, TCcomponente, TCmetodo, modulo, TCmeses)
				values (
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCnombre#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCtexto#">
				, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCtipoCalculo#">
				<cfif form.TCtipoCalculo EQ 'F'>	<!--- FIJO --->
					, null
					, null
					, null
				<cfelseif form.TCtipoCalculo EQ 'S'>	<!--- SQL --->
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCsql#">
					, null
					, null
				<cfelseif form.TCtipoCalculo EQ 'J'>	<!--- JAVA --->				
					, null
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCcomponente#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCmetodo#">
				</cfif>
				<cfif form.modulo NEQ ''>
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#">				
				<cfelse>
					, null
				</cfif>				
					, <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.TCmeses#">				
				)

				declare @newTarifaCalculoIndicador numeric
				
				select @newTarifaCalculoIndicador = @@identity
				
				insert TarifaRangosDefaults 
				(TCcodigo, TRDhasta, TRDtarifaFija, TRDtarifaVariable)
				values (
					@newTarifaCalculoIndicador,
					999999999999999,
					0,
					0)
				
				Select @newTarifaCalculoIndicador as newTarifa				
			<cfelseif isdefined("form.Cambio")>
				update TarifaCalculoIndicador
					set  TCtipoCalculo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCtipoCalculo#">
						<cfif form.TCtipoCalculo EQ 'F'>	<!--- FIJO --->
							, TCsql = null
							, TCcomponente = null
							, TCmetodo = null
						<cfelseif form.TCtipoCalculo EQ 'S'>	<!--- SQL --->
							, TCsql =<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCsql#">
							, TCcomponente = null
							, TCmetodo = null
						<cfelseif form.TCtipoCalculo EQ 'J'>	<!--- JAVA --->				
							, TCsql = null
							, TCcomponente = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCcomponente#">
							, TCmetodo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCmetodo#">
						</cfif>					
						, TCnombre=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCnombre#">
						, TCtexto=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.TCtexto#">
						<cfif form.modulo NEQ ''>
							, modulo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.modulo#">
						<cfelse>
							, modulo = null
						</cfif>
						, TCmeses = <cfqueryparam cfsqltype="cf_sql_tinyint" value="#form.TCmeses#">				
				where TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
				    and timestamp = convert(varbinary,#lcase(Form.timestamp)#)
					
				if not exists(
					select 1
					  from TarifaRangosDefaults
					 where TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">)
				begin
					insert TarifaRangosDefaults 
					(TCcodigo, TRDhasta, TRDtarifaFija, TRDtarifaVariable)
					values (
						<cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">,
						999999999999999,
						0,
						0)
				end
									
				<cfset modo = 'CAMBIO'>
			<cfelseif isdefined("form.Baja")>
				delete TarifaRangosDefaults
				where TCcodigo= <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
		
				delete TarifaCalculoIndicador
				where TCcodigo= <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
			<cfelseif isdefined("form.AltaD")>
				insert TarifaRangosDefaults 
				(TCcodigo, TRDhasta, TRDtarifaFija, TRDtarifaVariable)
				values (
					<cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TRDhasta#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.TRDtarifaFija#" cfsqltype="cf_sql_money">
					, <cfqueryparam value="#form.TRDtarifaVariable#" cfsqltype="cf_sql_money">)
		
				<cfset modo = 'CAMBIO'>
			  	<cfset modoD = 'CAMBIO'>				
			<cfelseif isdefined("form.BajaD")>
				delete TarifaRangosDefaults
				where TCcodigo= <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and TRDhasta= <cfqueryparam value="#form.TRDhasta#" cfsqltype="cf_sql_numeric">
					
				<cfset modo = 'CAMBIO'>
			  	<cfset modoD = 'ALTA'>
			<cfelseif isdefined("form.CambioD")>
				update TarifaRangosDefaults	
					set TRDtarifaFija=<cfqueryparam value="#form.TRDtarifaFija#" cfsqltype="cf_sql_money">
					, TRDtarifaVariable= <cfqueryparam value="#form.TRDtarifaVariable#" cfsqltype="cf_sql_money">
				where TCcodigo = <cfqueryparam value="#form.TCcodigo#" cfsqltype="cf_sql_numeric">
					and TRDhasta= <cfqueryparam value="#form.TRDhasta#" cfsqltype="cf_sql_numeric">	
				    and timestamp = convert(varbinary,#lcase(Form.timestamp)#)
					
				<cfset modo = 'CAMBIO'>	
				<cfset modoD = 'CAMBIO'>								
			<cfelseif isdefined("form.NuevoD")>
				<cfset modo = 'CAMBIO'>
				<cfset modoD = 'ALTA'>
			</cfif>

			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfif isdefined('form.Alta') and not isdefined('form.TCcodigo')>
	<cfset form.TCcodigo = ABC_TarifaCalculo.newTarifa>
	<cfset modo = "CAMBIO">	
</cfif>

<cfoutput>
	<form action="TarifaCalculo.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="modoD"   type="hidden" value="<cfif isdefined("modoD")>#modo#</cfif>">		
		<cfif modo eq 'CAMBIO'><input name="TCcodigo" type="hidden" value="#form.TCcodigo#"></cfif>
		<cfif modoD eq 'CAMBIO'><input name="TRDhasta" type="hidden" value="#form.TRDhasta#"></cfif>		
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
