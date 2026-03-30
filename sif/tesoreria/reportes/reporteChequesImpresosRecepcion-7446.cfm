<cfif isdefined("url.inicio") and not len(trim(url.inicio))>
	<cfquery name="rsinicio" datasource="#session.DSN#">
		select min(f.TESCFDnumFormulario) as consecutivo 
		from TEScontrolFormulariosD f
			inner join CuentasBancos cb
			on cb.CBid=f.CBid
			and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif len(trim(rsinicio.consecutivo))>
		<cfset url.inicio = rsinicio.consecutivo >
	</cfif>
</cfif>

<cfif isdefined("url.final") and not len(trim(url.final))>
	<cfquery name="rsFinal" datasource="#session.DSN#">
		select max(f.TESCFDnumFormulario) as consecutivo 
		from TEScontrolFormulariosD f
			inner join CuentasBancos cb
			on cb.CBid=f.CBid
			and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	<cfif len(trim(rsFinal.consecutivo))>
		<cfset url.final = rsFinal.consecutivo >
	</cfif>
</cfif>

<cfif url.inicio gt url.final>
	<cfset tmp = url.inicio >
	<cfset url.inicio = url.final >
	<cfset url.final = tmp >
</cfif> 

<cfset vInicio = LSParsedateTime(url.finicio) >
<cfset vFinal = LSParsedateTime(url.ffinal) >
<cfif vInicio gt vFinal>
	<cfset tmp = vInicio >
	<cfset vInicio = vFinal >
	<cfset vFinal = tmp >
	<cfset tmp = url.finicio >
	<cfset vInicio = url.ffinal >
	<cfset vFinal = tmp >
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#"  >
	select cb.CBcodigo,
		   cb.CBdescripcion,
		   <!--- sn.SNnumero,
		   sn.SNnombre, --->
		   op.TESOPbeneficiario || ' ' || op.TESOPbeneficiarioSuf as Beneficiario,
		   f.TESCFDnumFormulario as consecutivo,
		   f.TESCFDfechaEmision as fecha, 
		   op.TESOPtotalPago as monto,
		   cb.Mcodigo,
		   m.Mnombre,
		   op.Miso4217Pago
	
	from TEScontrolFormulariosD f
	
	inner join CuentasBancos cb
	on cb.CBid=f.CBid
	and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<!--- <cfif isdefined("url.CBid") and len(trim(url.CBid)) >
		and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
	</cfif> --->
	
	inner join Monedas m
	on m.Mcodigo=cb.Mcodigo
	and m.Ecodigo=cb.Ecodigo
		
	inner join Bancos b
	on b.Bid=cb.Bid
	and b.Ecodigo=cb.Ecodigo
		
	inner join TESordenPago op
	on op.TESOPid=f.TESOPid
	
	inner join SNegocios sn
	on sn.SNid= op.SNid
	<!--- <cfif isdefined("url.socio") and len(trim(url.socio))>
		and sn.SNnumero = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.socio#">
	</cfif> --->
	
	where f.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
	and f.TESCFDnumFormulario between <cfqueryparam cfsqltype="cf_sql_integer" value="#url.inicio#"> and <cfqueryparam cfsqltype="cf_sql_integer" value="#url.final#">
	and f.TESCFDestado=1
	and f.TESCFDfechaEmision between <cfqueryparam cfsqltype="cf_sql_date" value="#vInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#vFinal#">
	
	order by cb.CBcodigo, op.Miso4217Pago, f.TESCFDnumFormulario
</cfquery>

<!--- <cfdump var="#form#">
<cfdump var="#url#">
<cf_dump var="#rsReporte#"> --->

<cfif rsReporte.recordcount gt 0>
    <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif url.formato EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "tesoreria.reportes.reporteChequesImpresosRecepcion"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "reporteChequesImpresosRecepcion.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.Enombre#">
			<cfreportparam name="inicio" value="#url.finicio#">
			<cfreportparam name="ffinal" value="#url.ffinal#">
			<cfif isdefined("url.inicio") and len(trim(url.inicio))>
				<cfreportparam name="ConsecutivoInicio" value="#url.inicio#">
			</cfif>
			<cfif isdefined("url.final") and len(trim(url.final))>
				<cfreportparam name="ConsecutivoFinal" value="#url.final#">
			</cfif>
		</cfreport>
	</cfif>
<cfelse>
	<cfquery name="tesoreria" datasource="#session.DSN#">
		select TEScodigo, TESdescripcion
		from Tesoreria
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
	</cfquery>
	<cf_template template="#session.sitio.template#">
		<cf_templatearea name="title">
		  Tesorer&iacute;a
		</cf_templatearea>
		
		<cf_templatearea name="body">
		<cf_templatecss>
			<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte Entrega de Cheques a Recepción'>
				<cfinclude template="../../portlets/pNavegacion.cfm">
				<cfoutput>
				<table align="center" width="100%" cellpadding="3" cellspacing="0">
					<tr><td>&nbsp;</td></tr>
					<tr><td align="center"><strong>Reporte de Cheques Impresos Resumido</strong></td></tr>
					<tr><td align="center"><strong>Tesorer&iacute;a:</strong> #trim(tesoreria.TEScodigo)# - #trim(tesoreria.TESdescripcion)#</td></tr>
					<tr><td align="center"><strong>Fechas:</strong> #url.finicio# - #url.ffinal#</td></tr>
					<tr><td align="center">----- No se encontraron registros -----</td></tr>
					<tr><td>&nbsp;</td></tr>
					<tr><td><cf_botones tabindex="1" regresar="reporteChequesImpresosRecepcion-filtro.cfm" exclude="Alta,Limpiar"></td></tr>
				</table>
				</cfoutput>
			</cf_web_portlet>
		</cf_templatearea>
	</cf_template>
</cfif>