<cfset modo = "ALTA">

<cfif not isdefined("Form.NuevoP")>
	<cfif isdefined("Form.AltaP") or isdefined("Form.PagarP") or isdefined("Form.botonSelPagos")>
		<cfquery name="new_FactFormaPago" datasource="#Session.DSN#">
			select (isnull(max(FAPsecuencia), 0) + 1) as FAPsecuencia
			from FacturaEduFormaPago 
			where Ecodigo=<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
				and FACcodigo=<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
		</cfquery>
	</cfif>

	<cftry>
		<cfquery name="ABC_tiposCiclos" datasource="#Session.DSN#">
			set nocount on
				<cfif isdefined("Form.AltaP")>
					insert FacturaEduFormaPago 
					(FACcodigo, FAPsecuencia, FAPtipo, FAPorigen, Ecodigo, FAPmonedaISO, FAPtipoCambio, FAPmonto)
					values (
						<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						<cfif isdefined('new_FactFormaPago') and new_FactFormaPago.recordCount GT 0>
							, <cfqueryparam value="#new_FactFormaPago.FAPsecuencia#" cfsqltype="cf_sql_numeric">
						<cfelse>
							, 1
						</cfif>
						, <cfqueryparam value="#form.FAPtipo#" cfsqltype="cf_sql_numeric">
						<cfif isdefined('form.FAPtipo') and form.FAPtipo EQ 1>	<!--- Efectivo --->
							, 'Efectivo'
						<cfelse>
							, <cfqueryparam value="#form.FAPorigen#" cfsqltype="cf_sql_varchar">						
						</cfif>
						, <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
						, 'CRC'
						, 1
						<cfif isdefined('form.vuelto') and form.vuelto NEQ '' and form.vuelto NEQ 0>	<!--- Existe el vuelto --->							
							, <cfqueryparam value="#(form.FAPmonto - form.vuelto)#" cfsqltype="cf_sql_money">)
						<cfelse>
							, <cfqueryparam value="#form.FAPmonto#" cfsqltype="cf_sql_money">)
						</cfif>

					<cfset modo="CAMBIO">
				<cfelseif isdefined("Form.BajaP")>		
					delete FacturaEduFormaPago
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						and FAPsecuencia = <cfqueryparam value="#form.FAPsecuencia#" cfsqltype="cf_sql_integer">
					   
					<cfset modo="ALTA">
				<cfelseif isdefined("Form.CambioP")>
					update FacturaEduFormaPago set
						FAPtipo = <cfqueryparam value="#form.FAPtipo#" cfsqltype="cf_sql_tinyint">,
						<cfif isdefined('form.FAPtipo') and form.FAPtipo EQ 1>	<!--- Efectivo --->
							FAPorigen = 'Efectivo', 
						<cfelse>
							FAPorigen = <cfqueryparam value="#form.FAPorigen#" cfsqltype="cf_sql_varchar">,
						</cfif>	
						<cfif isdefined('form.vuelto') and form.vuelto NEQ '' and form.vuelto NEQ 0>	<!--- Existe el vuelto --->							
							, FAPmonto = <cfqueryparam value="#(form.FAPmonto - form.vuelto)#" cfsqltype="cf_sql_money">)
						<cfelse>
							FAPmonto = <cfqueryparam value="#form.FAPmonto#" cfsqltype="cf_sql_money">
						</cfif>										
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
						and FAPsecuencia = <cfqueryparam value="#form.FAPsecuencia#" cfsqltype="cf_sql_integer">
			  
					<cfset modo="CAMBIO">
				<cfelseif isdefined("Form.PagarP")>
					<cfif isdefined('form.montoFactura') and isdefined('form.sumaPagos')>
						<cfset vuelto = form.montoFactura - form.sumaPagos>					
					<cfelse>
						<cfset vuelto = 0>				
					</cfif>

					<cfif vuelto NEQ 0>
						insert FacturaEduFormaPago 
						(FACcodigo, FAPsecuencia, FAPtipo, FAPorigen, Ecodigo, FAPmonedaISO, FAPtipoCambio, FAPmonto)
						values (
							<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#new_FactFormaPago.FAPsecuencia#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#form.FAPtipo#" cfsqltype="cf_sql_numeric">
							, 'Vuelto'
							, <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							, 'CRC'
							, 1
							, <cfqueryparam value="#vuelto#" cfsqltype="cf_sql_money">)
					</cfif>
					
					<!--- Factura Pagada --->
					update FacturaEdu set
						FACestado = 2
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
					
					<cfset modo="ALTA">					
				<cfelseif isdefined("Form.botonSelPagos") and form.botonSelPagos EQ 'PagarTodo'>
					<cfif isdefined('form.montoFactura') and isdefined('form.sumaPagos')>
						<cfset montoPagar = form.montoFactura - form.sumaPagos>					
					<cfelse>
						<cfset montoPagar = 0>				
					</cfif>

					<cfif montoPagar GT 0>
						insert FacturaEduFormaPago 
						(FACcodigo, FAPsecuencia, FAPtipo, FAPorigen, Ecodigo, FAPmonedaISO, FAPtipoCambio, FAPmonto)
						values (
							<cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#new_FactFormaPago.FAPsecuencia#" cfsqltype="cf_sql_numeric">
							, <cfqueryparam value="#form.FAPtipo#" cfsqltype="cf_sql_numeric">
							, 'Vuelto'
							, <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_numeric">
							, 'CRC'
							, 1
							, <cfqueryparam value="#montoPagar#" cfsqltype="cf_sql_money">)
					</cfif>

					<!--- Factura Pagada --->
					update FacturaEdu set
						FACestado = 2
					where FACcodigo = <cfqueryparam value="#form.FACcodigo#" cfsqltype="cf_sql_numeric">
					
					<cfset modo="ALTA">				
				</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>

<cfif isdefined("Form.AltaP") and isdefined('new_FactFormaPago') and new_FactFormaPago.recordCount GT 0>
	<cfset nuevaFactFormaPago = new_FactFormaPago.FAPsecuencia>
</cfif>

<form action="facturas.cfm" method="post" name="sql">
	<cfoutput>
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="modoP" type="hidden" value="<cfif isdefined("modoP")>#modo#</cfif>">		
		<input name="codApersona" type="hidden" id="codApersona" value="<cfif isdefined("form.codApersona") and form.codApersona NEQ ''>#form.codApersona#</cfif>">	
		<input name="FACcodigo" id="FACcodigo" type="hidden" value="<cfif isdefined("Form.FACcodigo") and form.FACcodigo NEQ ''>#Form.FACcodigo#</cfif>">
		<cfif isdefined('modo') and modo NEQ 'ALTA'>
			<input name="FAPsecuencia" id="FAPsecuencia" type="hidden" value="<cfif isdefined("Form.FAPsecuencia") and modo NEQ 'ALTA'>#Form.FAPsecuencia#<cfelseif isdefined('nuevaFactFormaPago')>#nuevaFactFormaPago#</cfif>">
		</cfif>
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
