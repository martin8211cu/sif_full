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
<cfset TIT_ImpHist = t.Translate('TIT_ImpHist','Impresion Hístorico de Documentos por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset TIT_Rep = t.Translate('TIT_Rep','Reporte H&iacute;storico de Documentos por Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_DelSocio = t.Translate('LB_DelSocio','Del Socio','/sif/cc/consultas/RFacturas-SQL.xml')>
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
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>

<cfset LB_Documento = t.Translate('LB_Documento','Documento','/sif/cc/consultas/RFacturas-SQL.xml')>
<cfset LB_Tipo = t.Translate('LB_Tipo','Tipo','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Oficina = t.Translate('LB_Oficina','Oficina','/sif/generales.xml')>

<cfif isdefined("form.SNnombre") and len(trim(form.SNnombre))>
	<cfset LvarSocio = form.SNnombre>
<cfelse>
	<cfset LvarSocio = '#LB_Todos#'>
</cfif>

<cfif isdefined("form.CCTdescripcion") and len(trim(form.CCTdescripcion))>
	<cfset LvarCCTdescripcion = form.CCTcodigo & ' ' & form.CCTdescripcion>
<cfelse>
	<cfset LvarCCTdescripcion = '#LB_Todas#'>
</cfif>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select count(1) as Cantidad
	from HDocumentos b
		inner join CCTransacciones c
			on c.Ecodigo = b.Ecodigo
			and c.CCTcodigo = b.CCTcodigo
			and c.CCTpago = 0
	where b.Ecodigo = #session.Ecodigo#
	  and b.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaIni,'dd/mm/yyyy')#">
	  and b.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaFin,'dd/mm/yyyy')#">
	<cfif isdefined('Form.SNcodigo') and len(Form.SNcodigo) GT 0>
	  and b.SNcodigo = #Form.SNcodigo#
	</cfif>
	<cfif isdefined('Form.CCTcodigo') and len(Form.CCTcodigo) GT 0>
	  and b.CCTcodigo = '#form.CCTcodigo#'
	</cfif>
</cfquery>

<cfif rsReporte.Cantidad gt 20000>
	<cfoutput>
	<table width="50%" cellpadding="0" cellspacing="0" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<p>#MSG_CantDoc#<br />
				#MSG_AGenerar# #numberformat(rsReporte.Cantidad, ',')# #MSG_RegFiltro# <br />
				<br />
				#MSG_RangoFiltro#<br />
				#MSG_ProcCanc#</p>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
	</table>
    </cfoutput>
	<cfabort>
</cfif>

<cfquery name="rsReporte" datasource="#session.dsn#">
	select 
		b.CCTcodigo, 
		coalesce(c.CCTdescripcion,'N/A') as descripcion, 
		case when c.CCTtipo = 'D' then '#LB_Debito#' when c.CCTtipo = 'C' then '#LB_Credito#' else 'N/A' end as Tipo, 
		b.Ddocumento as Documento, 
		<cf_dbfunction name="to_sdatedmy" args="b.Dfecha"> as Fecha, 
		o.Odescripcion as Oficina, 
		b.SNcodigo, 
		s.SNnombre as nombre, 
		b.Mcodigo, 
		m.Mnombre, 
		b.Dtotal as Total
	from HDocumentos b
		inner join CCTransacciones c
			on c.Ecodigo = b.Ecodigo
			and c.CCTcodigo = b.CCTcodigo
			and c.CCTpago = 0
		inner join Oficinas o
			on o.Ecodigo = b.Ecodigo
			and o.Ocodigo = b.Ocodigo	
		inner join SNegocios s
			on s.SNcodigo = b.SNcodigo
			and s.Ecodigo = b.Ecodigo
		inner join Monedas m
			on m.Mcodigo = b.Mcodigo
	where b.Ecodigo = #session.Ecodigo#
	  and b.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaIni,'dd/mm/yyyy')#">
	  and b.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaFin,'dd/mm/yyyy')#">
	<cfif isdefined('Form.SNcodigo') and len(Form.SNcodigo) GT 0>
	  and b.SNcodigo = #Form.SNcodigo#
	</cfif>
	<cfif isdefined('Form.CCTcodigo') and len(Form.CCTcodigo) GT 0>
	  and b.CCTcodigo = '#form.CCTcodigo#'
	</cfif>
	order by b.Mcodigo, b.SNcodigo, b.CCTcodigo, b.Dfecha desc
</cfquery>
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
	filename="RepHistDocsSocio.xls"
	irA="RFacturasCC.cfm"
	download="yes"
	preview="no">
				
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="6" align="center" bgcolor="#E4E4E4"><cfoutput><span class="style3">#Session.Enombre#</span></cfoutput></td>
	</tr>			
	<tr>
		<td colspan="6" align="center">&nbsp;</td>
	</tr>				  
	<tr>
		<cfoutput><td colspan="6" align="center"><span class="style1">#TIT_Rep#</span></td></cfoutput>
	</tr>
	
	<tr>
		<cfoutput><td colspan="6" align="center"><span class="style1">#LB_DelSocio#: #LvarSocio#</cfoutput></span></td>
	</tr>
	<tr>
		<cfoutput><td colspan="6" align="center"><span class="style1">#LB_DesdeFec#: #dateformat(form.fechaIni,'yyyy/mm/dd')#&nbsp;&nbsp;#LB_HastaFec#: #dateformat(form.fechaFin,'yyyy/mm/dd')#</cfoutput></span></td>
	</tr>
	<tr>
		<cfoutput><td colspan="6" align="center"><span class="style1">#LB_TipoTr#:&nbsp;#LvarCCTdescripcion#</cfoutput></span></td>
	</tr>		
	
	<tr>
		<td colspan="6" align="center"><cfoutput><font size="2"><strong>#LB_FechaCons#:&nbsp;</strong>#LSDateFormat(HoraReporte,'dd/mm/yyyy')#&nbsp;<strong>#LB_Hora#:&nbsp;</strong>#TimeFormat(HoraReporte,'medium')#</font></cfoutput></td>
	</tr>
	<tr class="style5" bgcolor="#E4E4E4">
	<cfoutput>
		<td align="left" style="width:50%">#LB_Documento#</td>
		<td align="left">#LB_Tipo#</td>
		<td align="left">#LB_Fecha#</td>
		<td align="left" style="width:5%">#LB_Oficina#</td>
		<td align="right">#LB_Monto#</td>
		<td align="right">#LB_Total#</td>
	</cfoutput>
	</tr>	
	<cfflush interval="128">
	<cfoutput query="rsReporte" group="Mcodigo">
		<tr class="style6" bgcolor="##E4E4E4"><td colspan="6">&nbsp;</td></tr>
		<tr bgcolor="##E4E4E4">
			<td align="left" colspan="6" nowrap="nowrap" class="style5">#LB_Moneda#:&nbsp;#Mnombre#</td>
		</tr>
		<cfset LvarTotalC3 = 0>
		<cfoutput group="SNcodigo">
			<tr class="style6" bgcolor="##E4E4E4"><td colspan="6">&nbsp;</td></tr>
			<tr bgcolor="##E4E4E4">
				<td align="left" colspan="6" nowrap="nowrap" class="style5">#LB_Socio#:&nbsp;#nombre#</td>
			</tr>
			<tr class="style6"><td colspan="6">&nbsp;</td></tr>
			<cfset LvarTotalC2 = 0>
			<cfoutput group="CCTcodigo">
				<tr class="style6" bgcolor="##E4E4E4"><td colspan="6" >&nbsp;</td></tr>
				<tr bgcolor="##E4E4E4">
					<td align="left" colspan="6" nowrap="nowrap" class="style5">#LB_Transaccion#:&nbsp;#descripcion#</td>
				</tr>
				
				<cfset LvarTotalC1 = 0>
				<cfoutput>
					<tr nowrap="nowrap" class="style2">
						<td nowrap="nowrap" align="left">&nbsp;&nbsp;&nbsp;#Documento#</td>
						<td align="left">#Tipo#</td>
						<td align="left">#Fecha#</td>
						<td align="left">#Oficina#</td>
						<td align="right">#NumberFormat(Total,',_.__')#</td>
						<td align="right">&nbsp;</td>

					</tr>
					<cfset LvarTotalC1 = LvarTotalC1 + Total>
				</cfoutput>
				<tr nowrap="nowrap">
					<td align="left" colspan="5" class="style5" bgcolor="##E4E4E4"><strong>#LB_TotTr#: #descripcion#</strong></td>
					<td align="right" class="style5" bgcolor="##E4E4E4">#NumberFormat(LvarTotalC1,',_.__')#</td>
					
				</tr>
				<tr class="style6"><td colspan="6">&nbsp;</td></tr>
				<cfset LvarTotalC2 = LvarTotalC2 + LvarTotalC1>
			</cfoutput>
			<tr nowrap="nowrap">
				<td align="left" colspan="5" class="style5" bgcolor="##E4E4E4">#LB_TotSoc#: #nombre#</td>
				<td align="right" class="style5" bgcolor="##E4E4E4">#NumberFormat(LvarTotalC2,',_.__')#</td>
			</tr>
			<cfset LvarTotalC3 = LvarTotalC3 + LvarTotalC2>
		</cfoutput>
		<tr nowrap="nowrap">
			<td align="left" colspan="5" nowrap="nowrap" class="style5" bgcolor="##E4E4E4">#LB_TotMon#: #Mnombre#</td>
			<td align="right" class="style5" bgcolor="##E4E4E4">#NumberFormat(LvarTotalC3,',_.__')#</td>
		</tr>
	</cfoutput>
</table>
