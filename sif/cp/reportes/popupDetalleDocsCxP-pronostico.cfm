<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo = t.Translate('LB_Titulo','Detalle de Documentos CxP por Socio de Negocio y Semana de vencimiento','rptPronosticosPagos.xml')>
<cfset LB_NombreSN = t.Translate('LB_NombreSN','Socio de Negocio','rptPronosticosPagos.xml')>
<cfset LB_Semana = t.Translate('LB_Semana','Semana','rptPronosticosPagos.xml')>
<cfset LB_SemanaVen = t.Translate('LB_SemanaVen','Semanas Vencidas','rptPronosticosPagos.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','rptPronosticosPagos.xml')>

<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','rptPronosticosPagos.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento','rptPronosticosPagos.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','rptPronosticosPagos.xml')>
<cfset LB_FechaVencimiento = t.Translate('LB_FechaVencimiento','Fecha Vencimiento','rptPronosticosPagos.xml')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','rptPronosticosPagos.xml')>
<cfset LB_Saldo = t.Translate('LB_Saldo','Saldo','rptPronosticosPagos.xml')>

<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 5px;
		padding-bottom: 5px;
		padding-left: 5px;
		padding-right: 5px;
	}

	.tbline {
		border-width: 1px;
		border-style: solid;
		border-color: #CCCCCC;
	}
</style>

<cfif isDefined("url.TipoSem") AND #url.TipoSem# EQ 1>
	<!--- Configurables --->
	<cfquery name="rsGetInfoSemana" datasource="#Session.DSN#">
		SELECT FechaInicio,
		       FechaFin
		FROM CPSemanaPronostico
		WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  AND Anio = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Periodo#">
		  <cfif isDefined("url.modo") AND url.modo EQ "Res">
			  AND NoSemana < <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  <cfelse>
			  AND NoSemana = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  </cfif>
	</cfquery>
	<cfif rsGetInfoSemana.recordcount GT 0>
		<cfset fechaInicio = #DateFormat(rsGetInfoSemana.FechaInicio,'dd/mm/yyyy')#>
		<cfset fechaFin = #DateFormat(rsGetInfoSemana.FechaFin,'dd/mm/yyyy')#>
	</cfif>
<cfelse>
	<!--- Naturales --->
	<cfquery name="rsGetInfoSemana" datasource="#Session.DSN#">
		DECLARE @WeekNum int, @YearNum char(4);
		SELECT @WeekNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">,
		       @YearNum = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Periodo#">;
		SELECT DATEADD(wk, DATEDIFF(wk, 7, '1/1/' + @YearNum) + (@WeekNum - 1), 7) AS FechaInicio,
		       DATEADD(wk, DATEDIFF(wk, 5, '1/1/' + @YearNum) + (@WeekNum - 1), 6) AS FechaFin;
	</cfquery>
	<cfif rsGetInfoSemana.recordcount GT 0>
		<cfset fechaInicio = #DateFormat(rsGetInfoSemana.FechaInicio,'dd/mm/yyyy')#>
		<cfset fechaFin = #DateFormat(rsGetInfoSemana.FechaFin,'dd/mm/yyyy')#>
	</cfif>
</cfif>

<cfquery name="rsInfoMoneda" datasource="#Session.DSN#">
	SELECT Mnombre,
	       Miso4217
	FROM Monedas
	WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  AND Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Moneda#">
</cfquery>

<cfquery name="rsSocioDatos" datasource="#Session.DSN#">
	select coalesce(SNnombre,'') as SNnombre,
		   coalesce(SNidentificacion, '') as SNidentificacion
	from SNegocios
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and SNtiposocio in ('A', 'P')
	and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SN#">
	order by SNnombre
</cfquery>

<cfquery name="rsGetInfoDocs" datasource="#Session.DSN#">
	SELECT a.IDdocumento,
	       a.CPTcodigo AS Transaccion,
	       a.Ddocumento AS Documento,
	       a.Dfecha AS Fecha,
	       a.Dfechavenc AS FechaVencimiento,
	       a.Dtotal AS Monto,
	       a.EDsaldo AS Saldo
	FROM EDocumentosCP a
	INNER JOIN SNegocios sn ON a.SNcodigo = sn.SNcodigo
	AND a.Ecodigo = sn.Ecodigo
	INNER JOIN CPTransacciones ct ON ct.CPTcodigo = a.CPTcodigo
	AND ct.Ecodigo = a.Ecodigo
	INNER JOIN Monedas m ON m.Mcodigo = a.Mcodigo
	AND m.Ecodigo = a.Ecodigo
	INNER JOIN Oficinas o ON o.Ocodigo = a.Ocodigo
	AND o.Ecodigo = a.Ecodigo
	<cfif isDefined("url.TipoSem") AND #url.TipoSem# EQ 1>
		<!--- Semanas configurables --->
		INNER JOIN CPSemanaPronostico spr ON spr.Ecodigo = a.Ecodigo
	</cfif>
	WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
	  AND ct.CPTtipo = 'C'
	  AND a.EDsaldo > 0
	  <cfif isDefined("url.periodo") AND #url.periodo# NEQ "">
		  AND DATEPART(YEAR, a.Dfechavenc) = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
	  </cfif>
	  <cfif isDefined("url.TipoSem") AND #url.TipoSem# EQ 1>
		  <cfif isDefined("url.modo") AND url.modo EQ "Res">
			  AND a.Dfechavenc BETWEEN spr.FechaInicio AND spr.FechaFin AND spr.Anio = DATEPART(YEAR, a.Dfechavenc) AND spr.NoSemana < <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  <cfelse>
			  AND a.Dfechavenc BETWEEN spr.FechaInicio AND spr.FechaFin AND spr.Anio = DATEPART(YEAR, a.Dfechavenc) AND spr.NoSemana = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  </cfif>
	  <cfelse>
	  	  <cfif isDefined("url.modo") AND url.modo EQ "Res">
			  AND DATEPART(WEEK, a.Dfechavenc) < <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  <cfelse>
			  AND DATEPART(WEEK, a.Dfechavenc) = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.Sem#">
		  </cfif>
	  </cfif>
	  AND sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.SN#">
</cfquery>

<link href="/cfmx/plantillas/erp/css/erp.css " rel="stylesheet" type="text/css">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
	<cfoutput>
		<table id="tbl-popupDetalleDocsCxP" align="center" width="97%" border="0" style="font-family:arial;font-size:14px;" cellspacing="0" cellpadding="0">
			<tr>
				<td width="20%" align="right"><strong>#LB_NombreSN#:&nbsp;</strong></td>
				<td align="left">#rsSocioDatos.SNidentificacion#&nbsp;-&nbsp;#rsSocioDatos.SNnombre#:&nbsp;</td>
			</tr>
			<cfif isDefined("url.modo") AND url.modo EQ "Res">
				<tr>
					<td width="20%" align="right"><strong>#LB_SemanaVen#:&nbsp;</strong></td>
					<td align="left">&nbsp;1&nbsp;&nbsp;a&nbsp;&nbsp;#url.Sem#</td>
				</tr>
			<cfelse>
				<tr>
					<td width="15%" align="right"><strong>#LB_Semana#:&nbsp;</strong></td>
					<td align="left">&nbsp;#url.Sem#&nbsp;&nbsp;(#fechaInicio#&nbsp;-&nbsp;#fechaFin#)</td>
				</tr>
			</cfif>
			<tr>
				<td width="15%" align="right"><strong>#LB_Moneda#:&nbsp;</strong></td>
				<td align="left">#rsInfoMoneda.Mnombre#&nbsp;(#rsInfoMoneda.Miso4217#)</td>
			</tr>
		</table>
		<br>

		<table id="tbl-popupDetalleDocsCxP" align="center" width="97%" border="0" style="font-family:arial;font-size:14px;" cellspacing="0" cellpadding="0">
			<tr class="encabReporte">
				<td align="center"><strong>#LB_Transaccion#</strong></td>
				<td align="center"><strong>#LB_Documento#</strong></td>
				<td align="center"><strong>#LB_Fecha#</strong></td>
				<td align="center"><strong>#LB_FechaVencimiento#</strong></td>
				<td align="center"><strong>#LB_Monto#</strong></td>
				<td align="center"><strong>#LB_Saldo#</strong></td>
			</tr>
			<cfset lVarMonto = 0>
			<cfset lVarSaldo = 0>
			<cfloop query="rsGetInfoDocs">
				<tr <cfif #rsGetInfoDocs.CurrentRow# MOD 2>class="listaPar"<cfelse>class="listaNon"</cfif>>
					<td align="center">#Transaccion#</td>
					<td align="center" style="cursor: pointer;" title="Ver" onclick="return openDocumento('#url.SN#', '#Documento#', '#Transaccion#', '#IDdocumento#');">#Documento#</td>
					<td align="center">#DateFormat(Fecha,'dd/mm/yyyy')#</td>
					<td align="center">#DateFormat(FechaVencimiento,'dd/mm/yyyy')#</td>
					<td align="right">#LSNumberFormat(Monto,',9.00')#</td>
					<td align="right">#LSNumberFormat(Saldo,',9.00')#</td>
				</tr>
				<cfset lVarMonto = lVarMonto + Monto>
				<cfset lVarSaldo = lVarSaldo + Saldo>
			</cfloop>
			<tr>
				<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right" colspan="4">Total Documentos:&nbsp;</td>
				<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#LSNumberFormat(lVarMonto,',9.00')#</td>
				<td class="topline" style="background-color: ##F5F5F5; font-weight: bold" align="right">#LSNumberFormat(lVarSaldo,',9.00')#</td>
			</tr>
		</table>
		<br><br>
	</cfoutput>
<cf_web_portlet_end>

<script language="javascript1.2" type="text/javascript">
	<!--- Abre popup ... --->
	function openDocumento(SNcodigo,Ddocumento,CPTcodigo,IDdocumento){
		var PARAM  = "../../cp/consultas/RFacturasCP2-DetalleDoc.cfm?pop=true&SNcodigo="+ SNcodigo +"&Ddocumento="+Ddocumento+"&CPTcodigo="+CPTcodigo+"&IDdocumento="+IDdocumento;
		open(PARAM,'V1','left=210,top=170,scrollbars=yes,resizable=yes,width=950,height=500')
		return false;
	}
</script>