<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
<cfif url.Bdescripcion_inicio gt url.Bdescripcion_final  >
	<cfset tmp = url.Bdescripcion_inicio >
	<cfset url.Bdescripcion_inicio = url.Bdescripcion_final >
	<cfset url.Bdescripcion_final = tmp >
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#"  >
	select b.Bdescripcion,
		cb.CBcodigo,
		cb.CBdescripcion,
		TESOPbeneficiarioId as SNnumero,
		TESOPbeneficiario #LvarCNCT# ' ' #LvarCNCT# TESOPbeneficiarioSuf as SNnombre,
		op.TESOPtotalPago as monto,
		f.TESCFDnumFormulario as consecutivo,

		/*  Detalles */
		dop.TESDPdocumentoOri as documento,
		cf.CFformato,
		dop.TESDPmontoPago as montoDocumento,
		dop.TESDPtipoDocumento,
		 (coalesce((	select sum(TESDPmontoPago ) 
					from TESdetallePago 
					where TESDPmontoPago < 0
			      	  and TESOPid = dop.TESOPid ), 0))*-1 as creditos

	
	from TEScontrolFormulariosD f
	
	inner join CuentasBancos cb
	on cb.CBid=f.CBid
	and cb.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    
	inner join Monedas m
	on m.Mcodigo=cb.Mcodigo
	and m.Ecodigo=cb.Ecodigo
		
	inner join Bancos b
	on b.Bid=cb.Bid
	and b.Ecodigo=cb.Ecodigo
	and b.Bdescripcion between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Bdescripcion_inicio#"> and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.Bdescripcion_final#">
		
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
	
	inner join TESdetallePago dop
	on dop.TESOPid=op.TESOPid
	and dop.TESDPmontoPago > 0

	inner join CFinanciera cf
	on cf.CFcuenta=dop.CFcuentaDB

	
	
	where f.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESid#">
    and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	<cfif isdefined("url.CBid") and len(trim(url.CBid))>
		and f.CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CBid#">
	</cfif>
	
	and f.TESCFDestado=1
	and f.TESCFDfechaEmision >= <cfqueryparam cfsqltype="cf_sql_date" value="#url.dia#">
	
	<cfif isdefined("url.TESOPbeneficiarioId_F") and len(trim(url.TESOPbeneficiarioId_F))>
		and op.TESOPbeneficiarioId=<cfqueryparam cfsqltype="cf_sql_varchar"	value="#url.TESOPbeneficiarioId_F#">
	<cfelseif isdefined("url.TESOPbeneficiario_F") and len(trim(url.TESOPbeneficiario_F))>
		and upper(op.TESOPbeneficiario) #LvarCNCT# ' ' #LvarCNCT# upper(op.TESOPbeneficiarioSuf) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(url.TESOPbeneficiario_F)#%">				
	<cfelseif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F))>
		and sn.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#url.SNcodigo_F#">				
	<cfelseif isdefined("url.TESBid_F") and len(trim(url.TESBid_F))>
		and op.TESBid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.TESBid_F#">				
	<cfelseif isdefined("url.CDCcodigo_F") and  len(trim(url.CDCcodigo_F))>
		and op.CDCcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CDCcodigo_F#">				
	</cfif>
	
	order by b.Bdescripcion, cb.CBcodigo, f.TESCFDnumFormulario, dop.TESDPdocumentoOri 
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
			fileName = "tesoreria.reportes.reporteChequesImpresosDetalle"
			headers = "empresa:#session.Enombre#"/>
	<cfelse>
		<cfreport format="#url.formato#" template= "reporteChequesImpresosDetalle.cfr" query="rsReporte">
			<cfreportparam name="empresa" value="#session.Enombre#">
			<cfreportparam name="fecha" value="#url.dia#">
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
				<tr><td align="center"><strong>Reporte de Cheques Impresos Detallado</strong></td></tr>
				<tr><td align="center"><strong>Tesorer&iacute;a:</strong> #trim(tesoreria.TEScodigo)# - #trim(tesoreria.TESdescripcion)#</td></tr>
				<tr><td align="center"><strong>Bancos:</strong> #url.Bdescripcion_inicio# a #url.Bdescripcion_final#</td></tr>
				<tr><td align="center"><strong>Fecha:</strong> #url.dia#</td></tr>
				<tr><td align="center">----- No se encontraron registros -----</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr><td><cf_botones tabindex="1" regresar="reporteChequesImpresosDetalle-filtro.cfm" exclude="Alta,Limpiar"></td></tr>
			</table>
			</cfoutput>
		<cf_web_portlet_end>
	<cf_templatefooter>	
</cfif>