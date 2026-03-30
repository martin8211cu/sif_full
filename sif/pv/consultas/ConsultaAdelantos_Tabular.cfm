<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t" />
<cfset LvarFileName = "Consulta_Adelantos#Session.Usucodigo#-#DateFormat(Now(),'yyyymmdd')#-#TimeFormat(Now(),'hhmmss')#.xls">
<style type="text/css">
	* { font-size:11px; font-family:Verdana, Arial, Helvetica, sans-serif }
	.niv1 { font-size: 18px; }
	.niv2 { font-size: 16px; }
	.niv3 { font-size: 12px; }
	.niv4 { font-size: 10px; }
</style>	
<cfif not isdefined("url.download")>
	<table cellpadding="0" cellspacing="0" border="0" width="100%">
		<tr>
			<td colspan="11" align="right" style="width:100%">
				<cf_htmlreportsheaders
					title="Consulta de Adelantos y Notas de Cr&eacute;dito Generadas" 
					filename="#LvarFileName#" 
					ira="ConsultaAdelantos.cfm">
			</td>
		</tr>
	</table>
</cfif>
<cfset LvarTotalLinea = 0>
<cfset LvarAplicado = 0>
<cfset LvarSaldo = 0>
<cfflush interval="64">
<table cellpadding="0" cellspacing="0" border="0" width="100%">
	<cfoutput>
	<tr>
		<td colspan="1" style="width:10%"> #DateFormat(Now(),'dd-mm-yyyy')#</td>
		<td colspan="9" align="center" style="font-size:18px">#HTMLEditFormat(session.Enombre)#</td>
		<td align="right">#TimeFormat(Now(), 'HH:mm:ss')#</td>
	</tr>
	<tr>
		<td colspan="1">&nbsp;</td>
		<td colspan="9" align="center" style="font-size:16px">Consulta de Adelantos y Notas de Cr&eacute;dito Generadas</td>
		<td>&nbsp;</td>
	</tr>
    <tr>
		<td colspan="11" align="center" style="font-size:12px">Fecha Inicial:&nbsp;#FAX14FEC_ini#&nbsp;fecha final:&nbsp;#FAX14FEC_fin#</td>
	</tr>
    <tr>
		<cfif isdefined("Ocodigo") and len(trim(Ocodigo))>
            <cfquery name="rsOficina" datasource="#session.DSN#">
                select Odescripcion
                from Oficinas
                where Ecodigo = #session.Ecodigo#
                and Ocodigo = #Ocodigo#
            </cfquery>
            <td colspan="11" align="center" style="font-size:12px">Oficina:&nbsp;#rsOficina.Odescripcion#</td>
        <cfelse>
	        <td colspan="11" align="center" style="font-size:12px">Oficina:&nbsp;Todas</td>
        </cfif>
    </tr>
    <tr>
		<cfif isdefined("CDCcodigo") and len(trim(CDCcodigo))>
            <cfquery name="rsClienteDet" datasource="#session.DSN#">
                select CDCnombre 
                from ClientesDetallistasCorp 
                where CDCcodigo = #CDCcodigo#
            </cfquery>
            <td colspan="11" align="center" style="font-size:12px">Cliente:&nbsp;<cfif rsClienteDet.recordcount gt 0>#rsClienteDet.CDCnombre#<cfelse>Todos</cfif></td>
        <cfelse>
        	<td colspan="11" align="center" style="font-size:12px">Cliente:&nbsp;Todos</td>
        </cfif>
	</tr>
    <tr>
        <td colspan="11" align="center" style="font-size:12px">Caja:&nbsp;<cfif isdefined("FAM01CODD") and len(trim(FAM01CODD))>#FAM01CODD#<cfelse>Todas</cfif></td>
    </tr>
    <tr>
        <td colspan="11" align="center" style="font-size:12px">Documento:&nbsp;<cfif isdefined("FAX14DOC") and len(trim(FAX14DOC))>#FAX14DOC#<cfelse>Todos</cfif></td>
    </tr>
    </cfoutput>
	<tr>
		<td colspan="11">&nbsp;</td>
	</tr>
	<tr>
		<td><strong>CEDULA</strong></td>
		<td><strong>CLIENTE</strong></td>
		<td><strong>MONEDA</strong></td>
		<td><strong>DOCUMENTO</strong></td>
		<td><strong>TIPO</strong></td>
		<td><strong>FECHA</strong></td>
		<td><strong>OFICINA</strong></td>
		<td><strong>CAJA</strong></td>
		<td align="right" nowrap="nowrap"><strong>TOTAL</strong></td>
		<td align="right" nowrap="nowrap"><strong>APLICADO</strong></td>
		<td align="right" nowrap="nowrap"><strong>SALDO</strong></td>
	</tr>
	<cfloop query="rsReporte">
		<cfset LvarTotalLinea = LvarTotalLinea + rsReporte.TotalLinea>
		<cfset LvarAplicado = LvarAplicado + rsReporte.Aplicado>
		<cfset LvarSaldo = LvarSaldo + rsReporte.Saldo>
		<cfoutput>
		<tr>
			<td>#rsReporte.Cedula#</td>
			<td>#rsReporte.Cliente#</td>
			<td>#rsReporte.CodigoMoneda#</td>
			<td>#rsReporte.Documento#</td>
			<td>#rsReporte.TipoDoc#</td>
			<td>#dateformat(rsReporte.FechaFactura, "DD/MM/YYYY")#</td>
			<td>#rsReporte.Oficina#</td>
			<td>#rsReporte.CodigoCaja#</td>
			<td align="right" nowrap="nowrap">#numberformat(rsReporte.TotalLinea, ",9.00")#</td>
			<td align="right" nowrap="nowrap">#numberformat(rsReporte.Aplicado, ",9.00")#</td>
			<td align="right" nowrap="nowrap">#numberformat(rsReporte.Saldo, ",9.00")#</td>
		</tr>
		</cfoutput>
	</cfloop>
	<tr>
		<td colspan="11">&nbsp;</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan="7" align="left"><strong>Totales</strong></td>
		<td align="right"><strong><cfoutput>#NumberFormat(LvarTotalLinea, ",_.__")#</cfoutput></strong></td>
		<td align="right"><strong><cfoutput>#NumberFormat(LvarAplicado, ",_.__")#</cfoutput></strong></td>
		<td align="right"><strong><cfoutput>#NumberFormat(LvarSaldo, ",_.__")#</cfoutput></strong></td>
	</tr>
</table>


