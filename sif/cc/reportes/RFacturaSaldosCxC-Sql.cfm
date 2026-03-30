<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todos','Todas','/sif/generales.xml')>
<cfset MSG_CantDoc = t.Translate('MSG_CantDoc','La cantidad de Documentos a presentar sobrepasa los 20,000 registros.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_AGenerar = t.Translate('MSG_AGenerar','Se van a generar','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_RegFiltro = t.Translate('MSG_RegFiltro','registros con los filtros actuales','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_RangoFiltro = t.Translate('MSG_RangoFiltro','Reduzca el rango utilizando los filtros.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset MSG_ProcCanc = t.Translate('MSG_ProcCanc','Proceso Cancelado.','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Debito = t.Translate('LB_Debito','Débito','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Credito = t.Translate('LB_Credito','Crédito','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset TIT_ImpHist = t.Translate('TIT_ImpHist','Reporte de saldos de documentos de CxC por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset TIT_Rep = t.Translate('TIT_Rep','Reporte de saldos de documentos de CxC por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocio = t.Translate('LB_DelSocio','Socio de negocio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocioIND = t.Translate('LB_DelSocioIND','Identificaci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocioc = t.Translate('LB_DelSocioc','C&oacute;digo Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DesdeFec = t.Translate('LB_DesdeFec','Desde la fecha','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_HastaFec = t.Translate('LB_HastaFec','Hasta la fecha','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TipoTr = t.Translate('LB_TipoTr','Tipo de la Transacci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_FechaCons = t.Translate('LB_FechaCons','Fecha de la Consulta','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Hora = t.Translate('LB_Hora','Hora','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotTr = t.Translate('LB_TotTr','Totales por Transacci&oacute;n','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotSoc = t.Translate('LB_TotSoc','Totales por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_TotMon = t.Translate('LB_TotMon','Totales por Moneda','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Total = t.Translate('LB_Total','Saldo','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha Documento','/sif/generales.xml')>
<cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','/sif/generales.xml')>



<!---<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
	<cfset LvarSocio = form.SNnombre>
<cfelse>
	<cfset LvarSocio = '#LB_Todos#'>
</cfif> --->

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfparam name="Saldo" default="0">
<cfif  val(Saldo)>
	<cfset Saldo = 1>
<cfelse>
	<cfset Saldo= 0>
</cfif>


<cfif isdefined("form.Documento") and len(trim(form.Documento))>
	<cfset LvarDocumento = form.Documento>
<cfelse>
	<cfset LvarDocumento = "">
</cfif>

	<cfquery name="rsProc" datasource="#session.DSN#">
	select
			(
				select sum(bb.Dtotal)
				from HDocumentos bb
				where bb.HDid = he.HDid
			) as MontoOrigen,
			(
				select sum(bb.Dtotal * bb.Dtipocambio)
				from HDocumentos bb
				where bb.HDid = he.HDid
			) as MontoLocal,
			he.Dtipocambio as TC,
			m.Mcodigo,
			m.Mnombre,
			s.SNcodigo, s.SNnombre, substring(s.SNnumero,1,9) as SNnumero, s.SNidentificacion,
			he.HDid,
			he.Ddocumento as Recibo,
			he.CCTcodigo,
			he.Ecodigo,
			s.SNnombre,
			convert(varchar,he.Dfecha,103) as Fecha,
			he.Dusuario as EDusuario,
			o.Odescripcion as OficinaDes,
			o.Oficodigo as Oficina,
			coalesce(
				(select min(h.Edocumento)
				from HEContables h
				where h.IDcontable = bm.IDcontable)
				,
				(select min(h.Edocumento)
				from EContables h
				where h.IDcontable = bm.IDcontable)
			) as Asiento,
			coalesce(ed.Dsaldo, 0.00) as EDsaldo,
			convert(varchar,he.Dvencimiento, 103) as FechaDocumentoVencimiento,
			coalesce(ds.direccion1, ds.direccion2, 'N/A') as direccion

		from HDocumentos he
			inner join SNegocios s
			on s.SNcodigo = he.SNcodigo
			and s.Ecodigo = he.Ecodigo

			inner join CCTransacciones b
			on b.Ecodigo = he.Ecodigo
			and b.CCTcodigo =he.CCTcodigo

			inner join Monedas m
			on m.Mcodigo = he.Mcodigo

			inner join Oficinas o
			on o.Ecodigo = he.Ecodigo
			and o.Ocodigo = he.Ocodigo

			left outer join SNDirecciones sd
			on sd.id_direccion = he.id_direccionFact
			and sd.SNid = s.SNid

			left outer join DireccionesSIF ds
			on ds.id_direccion = sd.id_direccion

			left outer join BMovimientos bm
			on bm.SNcodigo = he.SNcodigo
			and bm.Ddocumento = he.Ddocumento
			and bm.CCTcodigo = he.CCTcodigo
			and bm.Ecodigo = he.Ecodigo
			and bm.CCTRcodigo = he.CCTcodigo
			and bm.DRdocumento = he.Ddocumento
			<cfif Saldo eq 1>
				inner join Documentos ed
			<cfelse>
				left outer join Documentos ed
			</cfif>
				on ed.Ecodigo     = he.Ecodigo
				and ed.CCTcodigo  = he.CCTcodigo
				and ed.Ddocumento = he.Ddocumento
				and ed.SNcodigo   = he.SNcodigo
		where he.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and he.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
		  and he.Dfecha between #lsparsedatetime(form.fechaIni)# and #lsparsedatetime(form.fechaFin)#
		  and he.CCTcodigo ='FC'
		  <cfif isdefined("form.Documento") and len(Trim(form.Documento))>
			and he.Ddocumento like '%#form.Documento#%'
		  </cfif>
</cfquery>

<!--<cfdump var="#rsProc#">-->

<cfset HoraReporte = Now()>

<style type="text/css">
<!--
.style1 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 14px;
	font-weight: bold;
}
.style2 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
}
.style3 {font-family: Arial, Helvetica, sans-serif; font-size: 18px; font-weight: bold; }

.style4 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 10px;
	font-weight: bold;
}
.style5 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 11px;
	font-weight: bold;
}
.style6 {
	font-family: Arial, Helvetica, sans-serif;
	font-size: 7px;
	font-weight: bold;
}
-->
</style>

<cf_htmlReportsHeaders
	title="#TIT_ImpHist#"
	filename="RepPagosRealizadosCC.xls"
	irA="RFacturasSaldosCxC.cfm"
	download="yes"
	preview="no">


<table border="0" cellspacing="0" cellpadding="0" width="92%" align="center">
	<tr>
		<td colspan="8" align="center" bgcolor="#E4E4E4">
			<cfoutput>
			<span class="style3">#Session.Enombre#</span>
			</cfoutput>
		</td>
	</tr>
	<tr>
		<td colspan="10" align="center">&nbsp;</td>
	</tr>
	<tr>
		<cfoutput><td colspan="8" align="center"><span class="style1">#TIT_Rep#</span></td></cfoutput>
	</tr>

	<tr>
		<cfoutput>
		<td colspan="8" align="center">
			<span class="style1">#LB_DesdeFec#: #dateformat(form.fechaIni,'dd/mm/yyyy')#&nbsp;&nbsp;#LB_HastaFec#:
			#dateformat(form.fechaFin,'dd/mm/yyyy')#
		</cfoutput>
			</span>
		</td>
	</tr>
	<tr>
		<td colspan="8" align="center">
			<cfoutput>
				<font size="2"><strong>#LB_FechaCons#:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>#LB_Hora#:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#
				</font>
			</cfoutput>
		</td>
	</tr>
	<tr class="style5" bgcolor="#E4E4E4" colspan="8" >
		 <td colspan="2" align="center">
		<span class="style1"><cfoutput>#LB_DelSocioc#:</cfoutput></span>&nbsp;&nbsp;
		<span class="style2"><cfoutput>#rsProc.SNnumero#</cfoutput></span>&nbsp;&nbsp;
		</td>
		<td colspan="3" align="center">
		<span class="style1"><cfoutput>#LB_DelSocio#:</cfoutput></span>
		<span class="style2"><cfoutput>#rsProc.SNnombre#</cfoutput></span>&nbsp;&nbsp;
		</td>
		<td colspan="3" align="center">
		<span class="style1"><cfoutput>#LB_DelSocioIND#:</cfoutput></span>
		<span class="style2"><cfoutput>	#rsProc.SNidentificacion#</cfoutput></span>
		</td>

	</tr>
	<tr  class="style5" bgcolor="#E4E4E4">
			<td colspan="8" align="left"  style="width:20% font-size: 12px;">
				<cfoutput>
					<font size="2">Docs con Saldo:</font>
				</cfoutput>
			</td>
	</tr>
	<cfset px = 12>
	<tr class="style5" bgcolor="#E4E4E4">
		<td colspan="8" align="left"  style="text-indent:<cfoutput>#px#</cfoutput>px">
			<cfoutput>
				<font size="2">Moneda:#rsProc.Mnombre#</font>
			</cfoutput>
		</td>
	</tr>
	<tr class="style5" bgcolor="#E4E4E4">
		<cfoutput>
			<td nowrap="nowrap" align="left" style="width: 13%;">#LB_TipoTr#</td>
			<td nowrap="nowrap" align="left" style="width: 15%;">#LB_Documento#</td>
			<td nowrap="nowrap" align="left" style="width: 18%;">#LB_Oficina#</td>
			<td nowrap="nowrap" align="left" style="width: 10%;">#LB_Fecha#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_FechaVencimiento#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_Moneda#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">#LB_Monto#</td>
			<td nowrap="nowrap" align="left" style="width: 12%;">&nbsp;</td>
		</cfoutput>
	</tr>
		<cfflush interval="128">
	<cfloop query="rsProc">
		<cfset SaldoFinal = 0>
			<cfset saldotemp  = 0>
			<cfoutput>
		<cfquery name="rsReporteDet" datasource="#session.DSN#">
				select
				bm.Ddocumento as Recibo,
				convert(varchar,bm.Dfecha, 103) as Dfecha2,
			    coalesce(
			        (select min(h.Edocumento)
			        from HEContables h
					where h.IDcontable = bm.IDcontable)
			        ,
			        (select min(h.Edocumento)
			        from EContables h
					where h.IDcontable = bm.IDcontable)
			    ) as Asiento,
				bm.Dtipocambio,
				(
				  select sum(b.Dtotal)
				  	from BMovimientos b
				   	where b.Ecodigo = bm.Ecodigo
						and b.CCTcodigo = bm.CCTcodigo
						and b.Ddocumento = bm.Ddocumento
						and b.CCTRcodigo = bm.CCTRcodigo
						and b.DRdocumento = bm.DRdocumento
						and b.BMfecha = bm.BMfecha
				) as MontoOrigen,
				convert(varchar,bm.Dvencimiento, 103) as FechaDocumentoVencimiento,
				(
				  select sum(bb.Dtotal * bb.Dtipocambio)
					from BMovimientos bb
				   	where bb.Ecodigo = bm.Ecodigo
						and bb.CCTcodigo = bm.CCTcodigo
						and bb.Ddocumento = bm.Ddocumento
						and bb.CCTRcodigo = bm.CCTRcodigo
						and bb.DRdocumento = bm.DRdocumento
						and bb.BMfecha = bm.BMfecha
				) as MontoLocal,
				(select cc.Cformato
						from CContables cc
						where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
				bm.Mcodigo,
				m.Mnombre,
				bm.BMmontoref,
				bm.CCTcodigo,
				bm.Ocodigo as Oficina,
				convert(varchar,hd.Dfecha, 103) as Dfecha,
				bm.DRdocumento,
				bm.SNcodigo,
				o.Odescripcion as OficinaDes


			from HDocumentos hd
				inner join BMovimientos bm on bm.Ecodigo = hd.Ecodigo
						and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				inner join Monedas m
					on m.Mcodigo = bm.Mcodigo
				inner join Oficinas o
					on o.Ecodigo = bm.Ecodigo
					and o.Ocodigo = bm.Ocodigo
			where
				bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<!---and bm.CCTcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value='#rsProc.CCTcodigo#'> --->
				<!---and bm.Ddocumento <> <cfqueryparam cfsqltype="cf_sql_char" value="#rsProc.Recibo#"> --->
			<!---and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#url.CCTcodigo#"> --->
				and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#rsProc.Recibo#">
				and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and hd.HDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.HDid#">
			union
				select
				bm.Ddocumento as Recibo,
				convert(varchar,bm.Dfecha, 103) as Dfecha2,
				hc.Edocumento as Asiento,
				bm.Dtipocambio,
				(
				  select sum(b.Dtotal)
				  	from BMovimientos b
				   	where b.Ecodigo = bm.Ecodigo
						and b.CCTcodigo = bm.CCTcodigo
						and b.Ddocumento = bm.Ddocumento
						and b.CCTRcodigo = bm.CCTRcodigo
						and b.DRdocumento = bm.DRdocumento
						and b.BMfecha = bm.BMfecha
				) as MontoOrigen,
				convert(varchar,bm.Dvencimiento, 103) as FechaDocumentoVencimiento,
				(
				  select sum(bb.Dtotal * bb.Dtipocambio)
					from BMovimientos bb
				   	where bb.Ecodigo = bm.Ecodigo
						and bb.CCTcodigo = bm.CCTcodigo
						and bb.Ddocumento = bm.Ddocumento
						and bb.CCTRcodigo = bm.CCTRcodigo
						and bb.DRdocumento = bm.DRdocumento
						and bb.BMfecha = bm.BMfecha
				) as MontoLocal,
				(select cc.Cformato
						from CContables cc
						where cc.Ccuenta = bm.Ccuenta) as CuentaDelDetalle,
				bm.Mcodigo,
				m.Mnombre,
				bm.BMmontoref,
				bm.CCTcodigo,
				bm.Ocodigo as Oficina,
				convert(varchar,hd.Dfecha, 103) as Dfecha,
				bm.DRdocumento,
				bm.SNcodigo,
				o.Odescripcion as OficinaDes

				from HDocumentos hd
				inner join BMovimientos bm on bm.Ecodigo = hd.Ecodigo
						and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				inner join Monedas m
					on m.Mcodigo = bm.Mcodigo
				inner join EContables hc
					on hc.IDcontable = bm.IDcontable
				inner join Oficinas o
					on o.Ecodigo = bm.Ecodigo
					and o.Ocodigo = bm.Ocodigo
			where
				bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<!---and bm.CCTcodigo <> <cfqueryparam cfsqltype="cf_sql_char" value='#rsProc.CCTcodigo#'> --->
			<!---and bm.Ddocumento <> <cfqueryparam cfsqltype="cf_sql_char" value="#rsProc.Recibo#"> --->
			<!---and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" maxlength="2" value="#url.CCTcodigo#"> --->
				and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" maxlength="20" value="#rsProc.Recibo#">
				and bm.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				and hd.HDid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProc.HDid#">
			order by CCTcodigo
	</cfquery>

<!--<cfdump var = "#rsReporteDet#">-->

	<!--- cabecera --->
		<tr class="style2">
			<td nowrap="nowrap" align="left">#CCTcodigo#</td>
			<td nowrap="nowrap"  align="left">#rsProc.Recibo#</td>
			<td nowrap="nowrap" align="left">#rsProc.OficinaDes#</td>
			<td nowrap="nowrap" align="left">#rsProc.Fecha#</td>
			<td nowrap="nowrap" align="left">#rsProc.FechaDocumentoVencimiento#</td>
			<td nowrap="nowrap" align="left">#rsProc.Mnombre#</td>
			<td nowrap="nowrap" align="center">#NumberFormat(rsProc.MontoLocal,',_.__')#</td>
			<td nowrap="nowrap" align="center"></td>
		</tr>
		</cfoutput>

		<cfif rsProc.recordCount GT 0>
			<cfset SaldoFinal = (#rsProc.MontoLocal#)>
		<cfelse>
			<cfset SaldoFinal = -1>
		</cfif>

	<!--- loop del detalle --->
		<cfloop query="rsReporteDet">
			<cfoutput>
			<cfset px = 0>
				<cfif rsReporteDet.CCTcodigo Neq 'FC'>
					<cfset px = 10>
			 	</cfif>
			<tr nowrap="nowrap" class="style2">
				<td style="text-indent: <cfoutput>#px#</cfoutput>px" nowrap="nowrap" align="left">&nbsp;&nbsp;#rsReporteDet.CCTcodigo#</td>
				<td nowrap="nowrap" align="left">#rsReporteDet.Recibo#</td>
				<td nowrap="nowrap" align="left">#rsReporteDet.OficinaDes#</td>

				<!-- query inecesaria -->
				<!--<cfquery name="rsReporteFecha" datasource="#session.DSN#">
					select convert(varchar,Dfecha, 103) as Dfecha, * from BMovimientos
					 where DRdocumento = '#rsReporteDet.Recibo#'
				</cfquery>-->

				<!--<td nowrap="nowrap" align="left">#rsReporteFecha.Dfecha#</td>-->
				<td nowrap="nowrap" align="left">#rsReporteDet.Dfecha2#</td>
				<td nowrap="nowrap" align="left">N/A</td>
				<td nowrap="nowrap" align="left">#rsReporteDet.Mnombre#</td>
				<td nowrap="nowrap" align="center">#NumberFormat(rsReporteDet.MontoLocal,',_.__')#</td>

				<cfset SaldoFinal -= rsReporteDet.MontoLocal>

			</cfoutput>
			</tr>
		</cfloop>
			<tr class="style5" bgcolor="#E4E4E4">
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<td align="left" nowrap="nowrap">&nbsp;</td>
				<cfoutput>
				<td align="left">Saldo Final:</td>
				<td align="center" class="Totales">#NumberFormat(SaldoFinal,',_.__')#</td>
				</cfoutput>
				</td>
			</tr>
   </cfloop>
</table>
