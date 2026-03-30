<cfset navegacion = "">
<cfif isdefined("url.modo") and len(trim(url.modo)) >
	<cfset navegacion = navegacion & "modo=#url.modo#">
</cfif>
<cfif isdefined("url.periodo") and len(trim(url.periodo)) >
	<cfset navegacion = navegacion & "&periodo=#url.periodo#">
	<cfset Anio = "#url.periodo#">
</cfif>
<cfif isdefined("url.mes") >
	<cfset navegacion = navegacion & "&mes=#url.mes#">
</cfif>
<cfif isdefined("url.sinsaldoscero") >
	<cfset navegacion = navegacion & "&sinsaldoscero=true">
</cfif>
<cfif isdefined("url.fechaIni")>
	<cfset navegacion = navegacion & "&fechaIni=#url.fechaIni#">
</cfif>
<cfif isdefined("url.fechaFin")>
	<cfset navegacion = navegacion & "&fechaFin=#url.fechaFin#">
</cfif>
<cfif isdefined("url.cuentaID")>
	<cfset navegacion = navegacion & "&cuentaID=#url.cuentaID#">
</cfif>

<cfquery name="rsConsulta" datasource="#session.DSN#">
    SELECT cc.Ccuenta,
	       cc.Cformato as cuenta,
	       (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)) as NumUnIdenPol,
	       CONVERT(VARCHAR(10),he.Efecha,126) as Fecha,
	       cc.Cdescripcion as DescCuenta,
	       det.SLinicial as saldoInicial,
	       (det.SLinicial + det.DLdebitos - det.CLcreditos) as saldoFinal,
	       det.CEBperiodo,
	       det.CEBmes,
	       he.ECfechacreacion,
	       cce.Cdescripcion,
	       hd.IDcontable,
	       he.Cconcepto,
	       isnull(C,0) as Debe,
	       isnull(D,0) as Haber
	FROM CContables cc,
	     CEBalanzaSAT ba,
	     CEBalanzaDetSAT det,
	     HEContables he,
	     HDContables hd,
	     ConceptoContableE cce,
	     (SELECT Ccuenta,IDcontable,[C], [D]
		  FROM (select Ccuenta,IDcontable,Dmovimiento,isnull(Dlocal,0)Dlocal
		  FROM HDContables
		 ) AS SourceTable
		 PIVOT
		 (
		 SUM(Dlocal)
		 FOR Dmovimiento IN ([C], [D])
		 ) AS PivotTable
		) saldo
	WHERE cc.Ccuenta = det.Ccuenta
	  AND cc.Ccuenta = hd.Ccuenta
	  AND hd.IDcontable = he.IDcontable
	  AND det.CEBalanzaId = ba.CEBalanzaId
	  AND cce.Cconcepto = hd.Cconcepto
	  AND saldo.Ccuenta = cc.Ccuenta
	  AND saldo.IDcontable = hd.IDcontable
	  AND ba.CEBperiodo = det.CEBperiodo
	  AND ba.CEBmes = det.CEBmes
	  AND ba.CEBperiodo = he.Eperiodo
	  AND ba.CEBmes = he.Emes
	  AND ba.CEBperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Anio#">
	  AND ba.CEBmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#mes#">
	  and ba.GEid = -1
	<cfif isDefined("url.cuentaID") AND #url.cuentaID# NEQ "">
		AND cc.Ccuenta = #trim(url.cuentaID)#
	</cfif>
	<cfif isDefined("url.sinsaldoscero") AND #url.sinsaldoscero# EQ "true">
	  	AND det.SLinicial != 0 AND (det.SLinicial + det.DLdebitos - det.CLcreditos) != 0
	</cfif>
	<cfif isDefined("url.fechaIni") AND #url.fechaIni# NEQ "">
	  	AND he.ECfechacreacion >= <cfqueryparam value="#url.fechaIni#" cfsqltype="cf_sql_date">
	</cfif>
	<cfif isDefined("url.fechaFin") AND #url.fechaFin# NEQ "">
	  	AND he.ECfechacreacion <= <cfqueryparam value="#url.fechaFin#" cfsqltype="cf_sql_date">
	</cfif>
	GROUP BY cc.Ccuenta,
	         cc.Cformato,
	         (CONVERT(varchar(5),he.Cconcepto)+'-'+CONVERT(varchar,he.Edocumento)),
	         CONVERT(VARCHAR(10),he.Efecha,126),
	         cc.Cdescripcion,
	         det.SLinicial,
	         (det.SLinicial + det.DLdebitos - det.CLcreditos),
	         det.CEBperiodo,
	         det.CEBmes,
	         he.ECfechacreacion,
	         cce.Cdescripcion,
	         hd.IDcontable,
	         he.Cconcepto,
	         saldo.C,
	         saldo.D
	ORDER BY cc.Ccuenta
</cfquery>

<div style="font-family: Arial, Helvetica, sans-serif;">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle de polizas">
	<cfform action="generarXML.cfm" method="post" name="formXML" style="margin:0;" onSubmit="return sinbotones()">
		<br>


		<table width="90%"  border="0" cellspacing="1" cellpadding="1"  align="center" class="AreaFiltro">
			<cfoutput>
			<!--- <tr><td colspan="3" align="center"><strong>DETALLE DE POLIZAS</strong></td></tr> --->
			<tr><td colspan="5" align="center"><strong>Cuenta: #rsConsulta.cuenta#</strong></td></tr>
			<tr><td colspan="5" style="font-size:15;" align="center"><strong>#rsConsulta.DescCuenta#</strong></td></tr>
			<cfif isDefined("url.fechaIni") AND #url.fechaIni# NEQ "">
				<tr style="font-size:15;"><td colspan="5" align="center"><strong>FECHA INICIAL: #url.fechaIni#</strong></td></tr>
			</cfif>
			<cfif isDefined("url.fechaFin") AND #url.fechaFin# NEQ "">
			  	<tr style="font-size:15;"><td colspan="5" align="center"><strong>FECHA FINAL: #url.fechaFin#</strong></td></tr>
			</cfif>
			</cfoutput>
			<tr><td colspan="5">&nbsp;</td></tr>
			<tr style="font-size:15;background-color:E8E8E8;">
				<td align="center"><strong>Poliza</strong></td>
				<td align="center"><strong>Fecha</strong></td>
				<td align="center"><strong>Concepto</strong></td>
				<td align="center"><strong>Debe</strong></td>
				<td align="center"><strong>Haber</strong></td>
			</tr>
			<cfset varX = 0>
			<cfset styleTr = "">
			<cfloop query="rsConsulta">
				<cfoutput>
					<cfset varX = varX + 1>
					<cfif varX mod 2 EQ 0>
						<cfset styleTr = "font-size:14;background-color:F5F5F5">
						<cfelse>
							<cfset styleTr = "font-size:14;background-color:FFFFFF">
					</cfif>
						<tr style="#styleTr#">
							<td width="15%" align="center">#rsConsulta.NumUnIdenPol#</td>
							<td width="17%" align="center">#rsConsulta.Fecha#</td>
							<td width="20%" align="center">#rsConsulta.Cdescripcion#</td>
							<td width="20%" align="right">#Trim(numberFormat(rsConsulta.Debe,"0.00"))#</td>
							<td width="20%" align="right">#Trim(numberFormat(rsConsulta.Haber,"0.00"))#</td>
						</tr>
				</cfoutput>
			</cfloop>
		</table>
	</cfform>
<cf_web_portlet_end>
</div>
