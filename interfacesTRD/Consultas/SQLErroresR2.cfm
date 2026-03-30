<!---
<cf_PleaseWait SERVER_NAME="/cfmx/interfacesTRD/consultas/SQLErroresR2.cfm" > --->
<cfsetting requesttimeout="3600"> 

<cfparam name="url.formato" default="HTML">

<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa=" ">
</cfif>

<cfif url.Regresa EQ 'ProcFutuAbie.cfm'>
	<cfquery name="rsErrores" datasource="sifinterfaces">
		select creation_date as fechaproceso, market_day as fechadocumento, 'FC' as tipodocumento,
		' ' as usuarioproceso, mensajeerror,
		Documento, Modulo,
		mtm_pl as monto, trade_num, order_num, item_num
		from #session.Dsource#futurosabiertosPMI
		where sessionid=#session.monitoreo.sessionid#
		  and mensajeerror is not null
	</cfquery>
<cfelseif url.Regresa EQ 'ProcFutuCerr.cfm'>
	<cfquery name="rsErrores" datasource="sifinterfaces">
		select creation_date as fechaproceso, market_day as fechadocumento, 'FC' as tipodocumento,
		' ' as usuarioproceso, mensajeerror,
		Documento, Modulo,
		mtm_pl as monto, trade_num, order_num, item_num
		from #session.Dsource#futuroscerradosPMI
		where sessionid=#session.monitoreo.sessionid#
		  and mensajeerror is not null
	</cfquery>
<cfelseif url.Regresa EQ 'ProcSeguros.cfm'>
	<cfquery name="rsErrores" datasource="sifinterfaces">
		select fecharegistro as fechaproceso, fecha_creacion as fechadocumento, 'FC' as tipodocumento,
		' ' as usuarioproceso, mensajeerror,
		Documento, 'Seguros' as Modulo,
		prima_cargo as monto, trade_num, order_num, item_num
		from #session.Dsource#segurosPMI
		where sessionid=#session.monitoreo.sessionid#
		  and mensajeerror is not null
	</cfquery>
<cfelse>
	<cfquery name="rsErrores" datasource="sifinterfaces">
		select *
		from #session.Dsource#ErroresPMI where sessionid=#session.monitoreo.sessionid#
	</cfquery>
</cfif>

<cfif isdefined("rsErrores") and rsErrores.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Errores del Proceso de Extracción" 
			filename="Errores del Proceso de Extracción-#Session.Usucodigo#.xls" 
			ira="/cfmx/interfacesTRD/componentesInterfaz/#url.regresa#">
		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="100%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="2">&nbsp;</td>
						<td align="right">#DateFormat(now(),"DD/MM/YYYY")#</td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"P.M.I. TRADING"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Errores del Proceso</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="100%">
					<tr>
						<td nowrap><strong>Fecha Proc.</strong></td>
						<td nowrap><strong>Fecha Doc.</strong></td>
						<td nowrap align="left"><strong>Tipo Doc.</strong></td>
						<td nowrap align="left"><strong>Usuario</strong></td>
						<td nowrap align="left"><strong>Mensaje</strong></td>
						<td nowrap align="right"><strong>Documento</strong></td>
						<td nowrap align="right"><strong>Modulo</strong></td>
						<td nowrap align="right"><strong>Monto</strong></td>
						<td nowrap align="left"><strong>Trade</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsErrores">
						<tr>
							<td nowrap >#dateformat(rsErrores.fechaproceso,"dd/mm/yyyy")#</td>
							<td nowrap >#dateformat(rsErrores.fechadocumento,"dd/mm/yyyy")#</td>
							<td nowrap >#rsErrores.tipodocumento#</td>
							<td nowrap >#rsErrores.usuarioproceso#</td>
							<td >#rsErrores.mensajeerror#</td>
							<td nowrap >#rsErrores.documento#</td>
							<td nowrap >#rsErrores.modulo#</td>
							<td nowrap align="right">#numberformat(rsErrores.monto, ",9.00")#</td>
							<td nowrap >#rsErrores.trade_num#,#rsErrores.order_num#,#rsErrores.item_num#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


