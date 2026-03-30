
<!--- Las Fechas Son Requeridas --->
<cfif isdefined("url.fecha1") and not isdefined("Form.fecha1")>
	<cfparam name="Form.fecha1" default="#url.fecha1#">
</cfif>
<cfif isdefined("url.fecha2") and not isdefined("Form.fecha2")>
	<cfparam name="Form.fecha2" default="#url.fecha2#">
</cfif>
<cfif isdefined("url.tipoC") and not isdefined("Form.tipoC")>
	<cfparam name="Form.tipoC" default="#url.tipoC#">
</cfif>
<cfif isdefined("url.Asociados") and not isdefined("Form.Asociados")>
	<cfparam name="Form.Asociados" default="#url.Asociados#">
</cfif>

<cfset formfecha1 = "#LSDateFormat(Form.fecha1, 'dd/mm/yyyy')#">


<cfif structKeyExists(FORM,"valor")>
    <cfset valor = FORM.valor>
<cfelse>
    <cfset valor = 0>
</cfif>
<cfinclude  template="formDescargaXMLSATD-query.cfm">
<cf_dbfunction name="date_format"	args="a.Dfecha,DD/MM/YYYY" returnvariable="Dfecha">

<style type="text/css">
	.style0 {text-align: center; text-transform: uppercase; font-size: 16px; text-shadow: Black; font-weight: bold; }
	.style1 {text-align: center; text-transform: uppercase; font-size: 14px; text-shadow: Black; font-weight: bold; }
	.style2 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style3 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black; font-weight: bold; }
	.style4 {text-align: center; text-transform: uppercase; font-size: 12px; font-style: italic; text-shadow: Black;}
	#SumTotales{text-align: right;text-transform: uppercase; font-size: 14px; font-weight: bold;padding-left: 0.6em;}
	.tituloListas{padding-left: 0.5em;}
</style>
<br>
<cfoutput>
	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="">
		<tr>
			<td class="style0">#Session.Enombre#</td>
		</tr>
		<tr>
			<td class="style1">Facturas descargadas del SAT</td>
		</tr>
		<tr>
			<td class="style2">
				<cfif isdefined("Form.fecha1") and Len(Trim(Form.fecha1)) NEQ 0>
					Desde: #LSDateFormat(Form.fecha1, 'dd/mm/yyyy')# &nbsp;
				<cfelse>
					Desde: Inicio &nbsp;
				</cfif>
				<cfif isdefined("Form.fecha2") and Len(Trim(Form.fecha2)) NEQ 0>
					Hasta: #LSDateFormat(Form.fecha2, 'dd/mm/yyyy')#
				<cfelse>
					Hasta: #LSdateFormat(Now(),'dd/mm/yyyy')#
				</cfif>
			</td>
			
		</tr>	
		<tr>
			<td class="style2">
				<cfif isdefined("Form.tipoC") and Len(Trim(Form.tipoC)) NEQ 0>
					<cfif #form.tipoC# eq 0>
						<cfset tipoC = "Todos">
						<cfelse>
							<cfset tipoC = #form.tipoC#>
					</cfif>
					Tipo de Comprobantes: #tipoC#
				</cfif>
			</td>	
		</tr>
	</table>
</cfoutput>
<br>

<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">

	<tr>
		<cfif rsData.RecordCount GT 0>
			<td></td>	
			<td align="right" colspan="19">
				<form name = "DescargaZIP" action="DescargaXMLSATDZip.cfm" method="POST">
					<input type="hidden" name="fecha1" value="<cfoutput>#LSDateFormat(Form.fecha1, 'dd/mm/yyyy')#</cfoutput>">
					<input type="hidden" name="fecha2" value="<cfoutput>#LSDateFormat(Form.fecha2, 'dd/mm/yyyy')#</cfoutput>">
					<input type="hidden" name="tipoC" value="<cfoutput>#Form.tipoC#</cfoutput>">
					<input type="hidden" name="Asociados" value="<cfoutput>#form.Asociados#</cfoutput>">
					<a onClick="fnIrZip()">		<img src="/cfmx/sif/imagenes/Download.png"	border="0" style="cursor:pointer" class="noprint" title="Descargar XML"></a>
				</form>	
			</td>	
		</cfif>
	</tr>
  	<tr>
    	<td class="tituloListas">UUID</td>
		<td class="tituloListas" align="right">Fecha Emision</td>
    	<td class="tituloListas" align="right">Fecha Timbrado</td>
		<td class="tituloListas" align="center">Version</td>
    	<td class="tituloListas" align="left">RFC Receptor</td>
		<td class="tituloListas" align="left">|</td>
    	<td class="tituloListas" align="left">RFC Emisor</td>
		<td class="tituloListas" align="left">Razón Social Emisor</td>
		<td class="tituloListas" align="right">Estatus</td>
		<td class="tituloListas" align="right">Tipo de Comprobante</td>
		<td class="tituloListas" align="right">Serie</td>
		<td class="tituloListas" align="right">Folio</td>
		<td class="tituloListas" align="right">Total Trasladado IVA</td>
		<td class="tituloListas" align="right">Total Trasladado IEPS</td>
		<td class="tituloListas" align="right">Total Impuestos Trasladados</td>
		<td class="tituloListas" align="right">Subtotal</td>
		<td class="tituloListas" align="right">Importe</td>
		<td class="tituloListas" align="right">XML</td>
		<td class="tituloListas" align="right">PDF</td>
		<td class="tituloListas" align="right">Asociado</td>
  	</tr>
  	<cfset LvarListaNon = false>
	<cfoutput query="rsData">
	<cfset LvarListaNon = not LvarListaNon>
	<tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif>>			
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif>>#rsData.UUID#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSDateFormat(rsData.FechaEmision,'dd/mm/yyyy')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSDateFormat(rsData.FechaTimbrado,'dd/mm/yyyy')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="center">#rsData.Version#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left">#rsData.RFCReceptor#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left">|</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left">#rsData.RFCEmisor#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="left">#rsData.RazonSocialEmisor#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#rsData.Estatus#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#rsData.TipoDeComprobante#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#rsData.Serie#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#rsData.Folio#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(rsData.TotalTrasladadoIVA,'none')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(rsData.TotalTrasladadoIEPS,'none')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(rsData.TotalImpuestosTrasladados,'none')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(rsData.Subtotal,'none')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right">#LSCurrencyFormat(rsData.Importe,'none')#</td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right"><a target="_blank" href="GeneraPDFdeXML.cfm?uuid=#rsData.UUID#&xml=SI">#rsData.verXML#</a></td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right"><a target="_blank" href="GeneraPDFdeXML.cfm?uuid=#rsData.UUID#">#rsData.descargarPDF#</a></td>
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="center">#rsData.Relacionado#</td>
		<!---<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right"><a href="FEPlantilla_RDF.cfm"><img src="/cfmx/sif/imagenes/View.png" alt="Ver XML" border=0 height=20 width=20></img></a></td>
		
		<td class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> align="right"><img src="/cfmx/sif/imagenes/Download.png" alt="Descargar PDF" border=0 height=20 width=20></img></td>--->
	</tr>
		
 
	</cfoutput>	
		<cfoutput query="rsSumTotales">
			<tr>
				<td class="style1" colspan="2"> DOCUMENTOS: </td>
				<td id="SumTotales">#rsSumTotales.TotalDocumentos#</td>
				<td colspan="6"></td>
				<td class="style1" colspan="3"> TOTALES: </td>
				<td id="SumTotales" >#LSCurrencyFormat(rsSumTotales.SumTrasladadosIVA,'none')#</td>
				<td id="SumTotales" >#LSCurrencyFormat(rsSumTotales.SumTrasladadoIEPS,'none')#</td>
				<td id="SumTotales" >#LSCurrencyFormat(rsSumTotales.SumImpuestosTrasladados,'none')#</td>
				<td id="SumTotales" >#LSCurrencyFormat(rsSumTotales.SumSubtotal,'none')#</td>
				<td id="SumTotales" >#LSCurrencyFormat(rsSumTotales.SumImporte,'none')# </td>
			</tr>
	</cfoutput>
</table>

<br>
<br>
<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td class="style4"> ------------------ Fin del Reporte ------------------ </td>
	</tr>
</table>

	<script language="javascript">
		function fnIrZip()
			{
				document.DescargaZIP.action = "DescargaXMLSATDZip.cfm";
				document.DescargaZIP.submit();
			}
	</script>		


	


















