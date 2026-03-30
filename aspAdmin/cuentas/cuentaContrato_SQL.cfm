<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.Nuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on
						
					insert ClienteContrato 
					(cliente_empresarial, COnombre, COinicio, COfinal, COtexto)
					values (
					<cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
					, <cfqueryparam value="#form.COnombre#" cfsqltype="cf_sql_varchar">
					, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COinicio#">,103)
					, convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COfinal#">,103)				
					, <cfqueryparam value="#form.COtexto#" cfsqltype="cf_sql_varchar">)
		
					select @@identity as newContrato
					
				set nocount off				
			</cfquery>					
		<cfelseif isdefined("form.Cambio")>
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on		
					update ClienteContrato
						set COnombre = <cfqueryparam value="#form.COnombre#" cfsqltype="cf_sql_varchar">
						,	COinicio = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COinicio#">,103)
						,	COfinal = convert(datetime, <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.COfinal#">,103)
						,	COtexto = <cfqueryparam value="#form.COtexto#" cfsqltype="cf_sql_varchar">					
					where cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
						and COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
				set nocount off				
			</cfquery>					  
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on				
					if exists(	select * from ClienteContratoPaquetes
								 where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
								) Begin
									raiserror 50000 'El contrato posee Paquetes asignados'
					end else begin
		<!--- 					delete ClienteContratoRangos
						where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
		
						delete ClienteContratoTarifas
						where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
						
						delete ClienteContratoPaquetes
						where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">				
						 --->
						delete ClienteContrato
						where cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
							and COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">				
					end
					
				set nocount off				
			</cfquery>					
		<cfset modo = 'ALTA'>
		<cfelseif isdefined("form.chk") and isdefined("btnEliminar")>
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on
					<cfloop index="dato" list="#form.chk#">
						<cfset datos = ListToArray(dato,'|')>
							if exists(	select * from ClienteContratoPaquetes
										 where COcodigo=<cfqueryparam value="#datos[1]#" cfsqltype="cf_sql_numeric">
										) Begin
											raiserror 50000 'El contrato posee Paquetes asignados'
							end else begin
								delete ClienteContrato
								where cliente_empresarial = <cfqueryparam value="#form.cliente_empresarial#" cfsqltype="cf_sql_numeric">
									and COcodigo=<cfqueryparam value="#datos[1]#" cfsqltype="cf_sql_numeric">				
							end
					</cfloop>
				set nocount off				
			</cfquery>	
		<cfelseif isdefined("form.modoCuentaContr") AND form.modoCuentaContr EQ "ALTA">
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on		
					insert ClienteContratoPaquetes (COcodigo,PAcodigo)
					values(
						<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">,				
						<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					)
				set nocount off				
			</cfquery>
			
			<cfquery name="rsPaqTarifas" datasource="#session.DSN#">
				Select *
				from PaqueteTarifas
				where PAcodigo= <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					and TCcodigo not in (
						select TCcodigo
						from ClienteContratoTarifas
						where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
					)
			</cfquery>

			<cfif isdefined('rsPaqTarifas') and rsPaqTarifas.recordCount GT 0>
				<cfquery name="rsInsertClienteContrTar" datasource="#session.DSN#">
					<cfloop query="rsPaqTarifas">
						insert ClienteContratoTarifas (COcodigo, TCcodigo, COTmeses)				
						values(
								<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#rsPaqTarifas.TCcodigo#" cfsqltype="cf_sql_numeric">
								, <cfqueryparam value="#rsPaqTarifas.PTmeses#" cfsqltype="cf_sql_numeric">
							)
					</cfloop>
					
					insert ClienteContratoRangos 
					(COcodigo, TCcodigo, CORhasta, CORdesde, CORtarifaFija, CORtarifaVariable)
					Select <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
						, TCcodigo
						, PRDhasta
						, 1
						, PRDtarifaFija
						, PRDtarifaVariable
				   	from PaqueteRangoDefault
				   	where TCcodigo in (#ValueList(rsPaqTarifas.TCcodigo)#)
						 and PAcodigo = <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">					
				</cfquery>						 				
			</cfif>
	
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.modoCuentaContr") AND form.modoCuentaContr EQ "BAJA">
			<cfquery name="ABC_CContrato" datasource="#session.DSN#">
				set nocount on
					if exists(
						select 1
						  from ClienteContratoTarifas CCT, TarifaCalculoIndicador TCI
						 where CCT.COcodigo = <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
						   and CCT.TCcodigo = TCI.TCcodigo
						   and exists  (
									select 1
									  from PaqueteModulo PM
									 where PM.PAcodigo = <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
									   and PM.modulo = TCI.modulo
								  )
						   and not exists (
									select 1
									  from PaqueteModulo PM, ClienteContratoPaquetes CCP
									 where CCP.COcodigo = <cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
									   and CCP.PAcodigo <> <cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
									   and PM.PAcodigo = CCP.PAcodigo
									   and PM.modulo   = TCI.modulo
								  )
						  )
					begin
						raiserror 50000 'El Paquete no se puede borrar porque el Contrato tiene
											definidas Tarifas de módulos del paquete'
					end else begin 
						delete ClienteContratoPaquetes
						where COcodigo=<cfqueryparam value="#form.COcodigo#" cfsqltype="cf_sql_numeric">
							and PAcodigo=<cfqueryparam value="#form.PAcodigo#" cfsqltype="cf_sql_numeric">
					end
				set nocount off				
			</cfquery>			
			<cfset modo = 'CAMBIO'>				
		</cfif>
	<cfcatch type="any">
		<cfinclude template="../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset modo = 'ALTA'>
</cfif>	

<cfif isdefined('form.Alta') and not isdefined('form.COcodigo')>
	<cfset form.COcodigo = ABC_CContrato.newContrato>
	<cfset modo = "CAMBIO">	
</cfif>

<cfoutput> 
	<form action="CuentaPrincipal_tabs.cfm" method="post" name="sql">
		<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="cliente_empresarial"   type="hidden" value="<cfif isdefined("form.cliente_empresarial")>#form.cliente_empresarial#</cfif>">
		<cfif modo EQ 'CAMBIO'><input name="COcodigo" type="hidden" value="#form.COcodigo#"></cfif>
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
