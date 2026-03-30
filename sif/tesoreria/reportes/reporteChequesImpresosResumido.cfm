<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfset vInicio = LSParsedateTime(url.inicio) >
<cfset vFinal = LSParsedateTime(url.ffinal) >
<cfif vInicio gt vFinal>
	<cfset tmp = vInicio >
	<cfset vInicio = vFinal >
	<cfset vFinal = tmp >
	<cfset tmp = url.inicio >
	<cfset vInicio = url.ffinal >
	<cfset vFinal = tmp >
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#"  >
	select cb.CBcodigo,
		   cb.CBdescripcion,
		   TESOPbeneficiarioId as SNnumero,
		   TESOPbeneficiario #LvarCNCT# ' ' #LvarCNCT# TESOPbeneficiarioSuf as SNnombre,
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
	<cfif isdefined("url.CBid") and len(trim(url.CBid)) >
		and cb.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
	</cfif>
    	
	inner join Monedas m
	on m.Mcodigo=cb.Mcodigo
	and m.Ecodigo=cb.Ecodigo
		
	inner join Bancos b
	on b.Bid=cb.Bid
	and b.Ecodigo=cb.Ecodigo
		
	inner join TESordenPago op
	on op.TESOPid=f.TESOPid
	
	<cfif isdefined("url.TESOPbeneficiarioId_F") and len(trim(url.TESOPbeneficiarioId_F))>
		<cfelseif isdefined("url.TESOPbeneficiario_F") and len(trim(url.TESOPbeneficiario_F))>
		
		<cfelseif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F))>
			left outer join SNegocios sn
			  on sn.SNid		= op.SNid
		
		<cfelseif isdefined("url.TESBid_F") and len(trim(url.TESBid_F))>
			left outer join TESbeneficiario tb
			  on tb.TESBid	= op.TESBid
		<cfelseif isdefined("url.CDCcodigo_F") and  len(trim(url.CDCcodigo_F))>
			left outer join ClientesDetallistasCorp cd
			  on cd.CDCcodigo	= op.CDCcodigo
	</cfif>
	
	where f.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
	and f.TESCFDestado=1
	and f.TESCFDfechaEmision between <cfqueryparam cfsqltype="cf_sql_date" value="#vInicio#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#vFinal#">
	and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	<cfif isdefined("url.TESOPbeneficiarioId_F") and len(trim(url.TESOPbeneficiarioId_F))>
		and op.TESOPbeneficiarioId=<cfqueryparam cfsqltype="cf_sql_varchar"	value="#url.TESOPbeneficiarioId_F#">
	<cfelseif isdefined("url.TESOPbeneficiario_F") and len(trim(url.TESOPbeneficiario_F))>
		and op.TESOPbeneficiario #LvarCNCT# ' ' #LvarCNCT# op.TESOPbeneficiarioSuf like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#url.TESOPbeneficiario_F#%">				
	<cfelseif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F))>
		and sn.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo_F#">				
	<cfelseif isdefined("url.TESBid_F") and len(trim(url.TESBid_F))>
		and op.TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESBid_F#">				
	<cfelseif isdefined("url.CDCcodigo_F") and  len(trim(url.CDCcodigo_F))>
		and op.CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo_F#">				
	</cfif>
	
	order by cb.CBcodigo, op.Miso4217Pago, f.TESCFDnumFormulario
</cfquery>
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
		fileName = "tesoreria.reportes.reporteChequesImpresosResumido"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "reporteChequesImpresosResumido.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.Enombre#">
			<cfreportparam name="inicio" value="#url.inicio#">
			<cfreportparam name="ffinal" value="#url.ffinal#">
		</cfreport>
	</cfif>
<cfelse>
	<cfquery name="tesoreria" datasource="#session.DSN#">
		select TEScodigo, TESdescripcion
		from Tesoreria
		where TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
	</cfquery>
	<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Cheques Impresos Resumido'>
			<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfoutput>
			<table align="center" width="100%" cellpadding="3" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>Reporte de Cheques Impresos Resumido</strong></td></tr>
				<tr><td align="center"><strong>Tesorer&iacute;a:</strong> #trim(tesoreria.TEScodigo)# - #trim(tesoreria.TESdescripcion)#</td></tr>
				<tr><td align="center"><strong>Fechas:</strong> #url.inicio# - #url.ffinal#</td></tr>
				<tr><td align="center">----- No se encontraron registros -----</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cf_botones tabindex="1" regresar="reporteChequesImpresosResumido-filtro.cfm" exclude="Alta,Limpiar"></td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
</cfif>