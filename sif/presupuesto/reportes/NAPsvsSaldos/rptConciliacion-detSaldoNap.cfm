<!--- PARAMS --->
<cfif isdefined("url.CPformato")>
	<cfset form.CPformato=url.CPformato>
</cfif>
<cfif isdefined("url.CPCano")>
	<cfset form.CPCano=url.CPCano>
</cfif>
<cfif isdefined("url.CPCmes")>
	<cfset form.CPNAPDtipoMov=url.CPNAPDtipoMov>
</cfif>
<cfif isdefined("url.CPCmes")>
	<cfset form.CPCmes=url.CPCmes>
</cfif>

<!--- <cfoutput>
CPformato: #CPformato#
CPCano: #CPCano#
CPNAPDtipoMov: #CPNAPDtipoMov#
CPCmes: #CPCmes#
</cfoutput> --->

<cfset LvarMeses = arrayNew(1)>
<cfset LvarMeses[1] = "Enero">
<cfset LvarMeses[2] = "Febrero">
<cfset LvarMeses[3] = "Marzo">
<cfset LvarMeses[4] = "Abril">
<cfset LvarMeses[5] = "Mayo">
<cfset LvarMeses[6] = "Junio">
<cfset LvarMeses[7] = "Julio">
<cfset LvarMeses[8] = "Agosto">
<cfset LvarMeses[9] = "Septiembre">
<cfset LvarMeses[10] = "Octubre">
<cfset LvarMeses[11] = "Noviembre">
<cfset LvarMeses[12] = "Diciembre">

<br>
<cf_web_portlet_start titulo="Detalle de saldo NAPS" Width="90%">
	<cfoutput>

	<!--- QUERY DETALLE DE SALDOS NAPS --->
	<cfquery name="rsListDetSaldosNap" datasource="#Session.DSN#">
		SELECT pre.CPformato AS cuenta, det.CPCano as anio, 
		det.CPCmes as mes, det.CPNAPnum as numNap, 
		det.CPNAPDlinea as numLinea, det.CPNAPDmonto as monto, CPNAPDtipoMov
		FROM CPNAPdetalle det, CPresupuesto pre
		WHERE det.Ecodigo = pre.Ecodigo 
		AND det.CPcuenta = pre.CPcuenta
		<cfif isDefined("form.CPformato") AND  #form.CPformato# NEQ "">
		AND pre.CPformato like '%#form.CPformato#%'
		</cfif>
		<cfif isDefined("form.CPCano") AND  #form.CPCano# NEQ "">
		AND CPCano = #form.CPCano#
		</cfif>
		<cfif isDefined("form.CPCmes") AND  #form.CPCmes# NEQ "">
		AND CPCmes <= #form.CPCmes#
		</cfif>
		<cfif isDefined("form.CPNAPDtipoMov") AND  #form.CPNAPDtipoMov# NEQ "">
		AND CPNAPDtipoMov = '#form.CPNAPDtipoMov#'
		</cfif>
		ORDER BY CPCmes
	</cfquery>

	<!--- QUERY TOTAL SALDO NAPS --->
	<cfquery name="rsMontoTotal" datasource="#Session.DSN#">
		SELECT SUM(det.CPNAPDmonto) AS saldoTotal 
		FROM CPNAPdetalle det, CPresupuesto pre
		WHERE det.Ecodigo = pre.Ecodigo 
		AND det.CPcuenta = pre.CPcuenta
		<cfif isDefined("form.CPformato") AND  #form.CPformato# NEQ "">
		AND pre.CPformato like '%#form.CPformato#%'
		</cfif>
		<cfif isDefined("form.CPCano") AND  #form.CPCano# NEQ "">
		AND CPCano = #form.CPCano#
		</cfif>
		<cfif isDefined("form.CPCmes") AND  #form.CPCmes# NEQ "">
		AND CPCmes <= #form.CPCmes#
		</cfif>
		<cfif isDefined("form.CPNAPDtipoMov") AND  #form.CPNAPDtipoMov# NEQ "">
		AND CPNAPDtipoMov = '#form.CPNAPDtipoMov#'
		</cfif>
	</cfquery>

	<!--- DETALLE DE SALDOS --->
	<cfset sbGeneraEstilos()>
	<!--- <cfset Encabezado()> --->
	<cfif #rsListDetSaldosNap.recordcount# GT 0>
		<cfset Creatabla()>
	    <cfset titulos()>
		<!--- <cfflush interval="512"> --->
		<!--- <cfset LvarCtaAnt = ""> --->
		<cfloop query="rsListDetSaldosNap" >
			<tr>
				<td align="center" class="Datos">#rsListDetSaldosNap.cuenta#</td>
				<td align="center" class="Datos">#rsListDetSaldosNap.CPNAPDtipoMov#</td>
				<td align="center" class="Datos">#rsListDetSaldosNap.anio#</td>
				<td align="center" class="Datos">#LvarMeses[rsListDetSaldosNap.mes]#</td>
				<td align="center" class="Datos">#rsListDetSaldosNap.numNap#</td>
				<td align="center" class="Datos">#rsListDetSaldosNap.numLinea#</td>
				<td align="right" class="Datos">#LSNumberFormat(rsListDetSaldosNap.monto,',9.00')#</td>
			</tr>
		</cfloop>
		<tr>
			<td colspan="6" align="right" class="Datos">
				<strong>Monto total:</strong>
			</td>
			<td align="right" class="Datos">
				<strong>#LSNumberFormat(rsMontoTotal.saldoTotal,',9.00')#</strong>
			</td>
		</tr>
		<cfset Cierratabla()>
		</body>
		</html>
	</cfif>
	<cfif #rsListDetSaldosNap.recordcount# EQ 0>
		<br><br><br>
		<div align="center" style="font-size:15px">-- Sin detalle de saldo NAP --</div>
		<br>
	</cfif>
	</cfoutput>
<cf_web_portlet_end>

<!--- ****************** FUNCION TITULOS ******************--->
<cffunction name="titulos" output="true">
	<tr>
		<td align="center" class="ColHeader">Cuenta</td>
		<td align="center" class="ColHeader">TipoMov</td>
		<td align="center" class="ColHeader">A&ntilde;o</td>
		<td align="center" class="ColHeader">Mes</td>
		<td align="center" class="ColHeader">N&uacute;mero NAP</td>
		<td align="center" class="ColHeader">N&uacute;mero L&iacute;nea</td>
		<td align="center" class="ColHeader">Monto</td>
	</tr>
</cffunction>

<cffunction name="sbGeneraEstilos" output="true">
	<style type="text/css">
		H1.Corte_Pagina
		{
		PAGE-BREAK-AFTER: always
		}
		
		.ColHeader 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		9px;
			font-weight: 	bold;
			padding-left: 	0px;
			border:		1px solid ##CCCCCC;
			background-color:##CCCCCC
		}
	
		.Header 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
			text-align:	center;
		}
	
		.Header1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		14px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
		.Corte1 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		12px;
			font-weight: 	bold;
			padding-left: 	0px;
		}
	
	
		.Datos 
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		10px;
			font-weight: 	none;
			white-space:nowrap;
		}
	
		body
		{
			font-family:	Arial, Helvetica, sans-serif;
			font-size: 		11px;
		}
	</style>
</cffunction>

<!--- ************************************************************* --->
<!--- ************************************************************* --->
<cffunction name="Creatabla" output="true">
	<table width="100%" border="0">
</cffunction>


<!--- ****************** FUNCION CIERRE TABLA ******************--->
<cffunction name="Cierratabla" output="true">
	</table>
</cffunction>
