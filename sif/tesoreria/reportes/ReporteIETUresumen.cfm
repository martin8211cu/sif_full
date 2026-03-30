<cfquery name="rsReporte" datasource="#session.DSN#"  >
	select 
			a.Eperiodo, 
			a.Emes,
			convert(varchar, a.Eperiodo) + ' - ' + convert(varchar, a.Emes) as periodoMes,
			(select Edescripcion  from Empresas where Ecodigo = #session.Ecodigo#) as Empresa,
			case b.IETUDorigen
				when 1 then 'CUENTAS X COBRAR'
				when 2 then 'CUENTAS X PAGAR' 
				when 3 then 'VENTA DE CONTADO' 
				when 4 then 'COMPRAS DE CONTADO' 
				else 'Otros'
			end as IETUPorigen,
			sum(b.IETUDmontoBaseLocal) as total_montoBaseLocal,
			coalesce(case 
				when sum(b.IETUDsigno * b.IETUDmonto) > 0 
					then null 
					else -sum(b.IETUDsigno * b.IETUDmonto) 
			end, 0) as Debito,
			coalesce(case 
				when sum(b.IETUDsigno * b.IETUDmonto) > 0 
					then sum(b.IETUDsigno * b.IETUDmonto) 
					else null 	
			end, 0) as Credito,
			avg(b.TESRPTCietuP) as TESRPTCietuP
	from  IETUpago a
		inner join IETUdoc b
			on a.IETUPid=b.IETUPid
		inner join Empresas d
			on a.EcodigoPago=d.Ecodigo
			and d.Ecodigo=#session.Ecodigo#
	where a.EcodigoPago=#session.Ecodigo#
	and a.Eperiodo between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ainicial#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Afinal#">
	and a.Emes between <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mincial#"> and <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Mfinal#">
	group by a.Eperiodo, a.Emes, b.IETUDorigen
	
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
		fileName = "tesoreria.reportes.ReporteResumidoIETU"
		headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "ReporteResumidoIETU.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.Enombre#">
		</cfreport>
	</cfif>
<cfelse>
	<cf_templateheader title="Tesorer&iacute;a">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte Resumido IETU'>
			<cfoutput>
			<table align="center" width="100%" cellpadding="3" cellspacing="0">
				<tr><td>&nbsp;</td></tr>
				<tr><td align="center"><strong>Reporte Resumido IETU</strong></td></tr>
				<tr><td align="center">----- No se encontraron registros -----</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cf_botones tabindex="1" regresar="ReporteIETUresumenFiltro.cfm" exclude="Alta,Limpiar"></td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
</cfif>
