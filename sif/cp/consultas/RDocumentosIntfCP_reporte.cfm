

	<cfset dataurl = 'consultas/RDocumentosIntfCP_reporte.cfm?&botonSel=btnConsultar&btnConsultar=Consultar&'>
	<cfif isdefined("url.CPTcodigo") and len(trim(url.CPTcodigo))>
		<cfset dataurl = dataurl&'CPTcodigo='&url.CPTcodigo&'&'>

	</cfif>
	<cfif isdefined("url.FechaIni") and len(trim(url.FechaIni))>
		<cfset dataurl = dataurl&'FechaIni='&url.FechaIni&'&'>

	</cfif>
	<cfif isdefined("url.FechaFin") and len(trim(url.FechaFin))>
		<cfset dataurl = dataurl&'FechaFin='&url.FechaFin&'&'>

	</cfif>
	<cfif isdefined("url.fSNcodigo") and len(trim(url.fSNcodigo))>
		<cfset dataurl = dataurl&'fSNcodigo='&url.fSNcodigo&'&'>

	</cfif>
	<cfif isdefined("url.fSNnumero") and len(trim(url.fSNnumero))>
		<cfset dataurl = dataurl&'fSNnumero='&url.fSNnumero&'&'>

	</cfif>


<cfinclude  template="RDocumentosIntfCP_sql.cfm">



<cf_templateheader title="#Tit_ConsDocCxP#">

<!---Estilos de columnas--->
<style type="text/css">
	.tituloListas{padding-left: 0.5em; padding: 4px;font-weight: bold;}
    #SumTotales{text-transform: uppercase; font-size: 14px; font-weight: bold;padding-left: 0.6em;}
	.style1 {font-size: 14px; font-weight: bold; }
    .style2 {padding-left: 0.5em;}
</style>

<!---Inicia Tabla--->
<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
	<tr><td colspan="12" align="center" style="font:bold; padding:4px;" bgcolor="#CCCCCC"><cfoutput><h2>#Tit_ConsDocCxP#</h2></cfoutput></td></tr>

	<cfif isdefined("url.btnConsultar")>
		<cfif rsIntF10.RecordCount GT 0>
			<tr><td colspan="12" align="right">
					<cfoutput>						
						<a
							href="javascript:fnImgDownload('#url.fSNnumero#','#url.fSNcodigo#','#url.FechaIni#','#url.FechaFin#','#url.CPTcodigo#');" style="cursor:pointer;" >Descarga</a>
						<a href="javascript:fnImgDownload('#url.fSNnumero#','#url.fSNcodigo#','#url.FechaIni#','#url.FechaFin#','#url.CPTcodigo#');">	
							<img src="/cfmx/sif/imagenes/Cfinclude.gif" style="cursor:pointer" class="noprint" title="Download" border="0">
						</a>
					</cfoutput>
			    </td>
    		</tr>
			<tr>
				<td colspan="12" align="right">
 					<cfset params = dataurl>
					<cfif isdefined("url.CPTcodigo")>
						<cfset params = params & '&CPTcodigo=#url.CPTcodigo#'>
					</cfif>
					<cfif isdefined("url.fSNnumero")>
						<cfset params = params & '&fSNnumero=#url.fSNnumero#'>
					</cfif>
					<cfif isdefined("url.fSNcodigo")>
						<cfset params = params & '&fSNcodigo=#url.fSNcodigo#'>
					</cfif>
					<cfif isdefined("url.FechaIni")>
						<cfset params = params & '&FechaIni=#url.FechaIni#'>
					</cfif>
					<cfif isdefined("url.FechaFin")>
						<cfset params = params & '&FechaFin=#url.FechaFin#'>
					</cfif>
					<cf_rhimprime datos="/sif/cp/consultas/RDocumentosIntfCP_reporte.cfm" paramsuri="#params#">
					<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe>
				</td>
			</tr>
    		<tr><td>&nbsp;</td></tr>


               <cfoutput>
                    <tr>
                        <td class="tituloListas">#LB_SNnumero#</td>
                        <td class="tituloListas" align="center">#LB_SNRFC#</td>
                        <td class="tituloListas" align="left">#LB_SNnombre#</td>
                        <td class="tituloListas" align="left">#LB_Transaccion#</td>
                        <td class="tituloListas" align="center">#LB_Documento#</td>
                        <td class="tituloListas" align="center">#LB_NumBoleta#</td>
                        <td class="tituloListas" align="left">#LB_Oficina#</td>
                    	<td class="tituloListas" align="center">#LB_FecDoc#</td>
                    	<td class="tituloListas" align="center">#LB_iva#</td>
                    	<td class="tituloListas" align="center">#LB_ieps#</td>
                    	<td class="tituloListas" align="center">#LB_subtotal#</td>
                    	<td class="tituloListas" align="center">#LB_Monto#</td>
                    </tr>
                </cfoutput>
                <cfoutput query="rsIntF10">
                    <tr>			
		                <td class="style2" align="left">#rsIntF10.NumeroSocio#</td>
		                <td class="style2" align="left">#rsIntF10.SNRFC#</td>
		                <td class="style2" align="left">#rsIntF10.SNnombre#</td> 
 		                <td class="style2" align="center">#rsIntF10.CodigoTransacion#</td>
                        <td class="style2" align="left">#rsIntF10.Documento#</td>
		                <td class="style2" align="center">#rsIntF10.NumeroBOL#</td>
		                <td class="style2" align="left">#rsIntF10.Oficina#</td>                     
		                <td class="style2" align="center">#LSDateFormat(rsIntF10.FechaDocumento,'dd/mm/yyyy')#</td>
		                <td class="style2" align="left">$#LSCurrencyFormat(rsIntF10.IVA,'none')#</td>
		                <td class="style2" align="left">$#LSCurrencyFormat(rsIntF10.IEPS,'none')#</td>
		                <td class="style2" align="left">$#LSCurrencyFormat(rsIntF10.SubTotal,'none')#</td>
		                <td class="style2" align="left">$#LSCurrencyFormat(rsIntF10.MontoTotal,'none')#</td>
	                </tr>
                </cfoutput>
				<tr><td>&nbsp;</td></tr>
					<cfoutput query="rsIntF10Sum">
						<tr>
							<td class="style1" align="center"> DOCUMENTOS: </td>
							<td id="SumTotales" align="left">#rsIntF10Sum.TotalRegistros#</td>
							<td colspan=""></td>
                            <td colspan=""></td>
                            <td colspan=""></td>
							<td class="style1" colspan="3" align="center"> TOTALES: </td>
							<td id="SumTotales" align="left">$#LSCurrencyFormat(rsIntF10Sum.SumIVA,'none')#</td>
							<td id="SumTotales" align="left">$#LSCurrencyFormat(rsIntF10Sum.SumIEPS,'none')#</td>
							<td id="SumTotales" align="left">$#LSCurrencyFormat(rsIntF10Sum.SumSubTotal,'none')#</td>
							<td id="SumTotales" align="left">$#LSCurrencyFormat(rsIntF10Sum.SumMontoTotal,'none')#</td>
						</tr>
				    </cfoutput>
                <tr><td>&nbsp;</td></tr>
                <cfoutput>
				<tr valign="top" align="center"><td colspan="12">***************************** #LB_FinCons# ***************************** </td></tr>
                </cfoutput>
			<cfelse>
			    <tr><td>&nbsp;</td></tr>
				<tr><td>&nbsp;</td></tr>
				<tr valign="top" align="center">
					<td colspan="12"   bgcolor="#CCCCCC" align="center">
                    	<cfoutput>
						<span style="font-size: 16px"><strong>*** #LB_NoDatRel# ***</strong></span>
                        </cfoutput>
					</td>
				</tr>
		    </cfif>
			<tr><td>&nbsp;</td></tr>
		</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="12">
			<form style="margin:0;" action="RDocumentosIntfCP.cfm" method="post">
				<input type="hidden" name="CPTcodigo" value="<cfoutput>#url.CPTcodigo#</cfoutput>">
				<input type="hidden" name="fSNnumero" value="<cfoutput>#url.fSNnumero#</cfoutput>">
				<input type="hidden" name="fSNcodigo" value="<cfoutput>#url.fSNcodigo#</cfoutput>">
				<input type="hidden" name="FechaIni" value="<cfoutput>#url.FechaIni#</cfoutput>">
				<input type="hidden" name="FechaFin" value="<cfoutput>#url.FechaFin#</cfoutput>">
				<cf_botones exclude="Alta,Limpiar" include="Regresar">
			</form>
		</td></tr>
	</table>
<cf_templatefooter >

<script language="javascript" type="text/javascript">
	function fnImgDownload(fsnnum,fsncod,fIni,fFin,cptcod){
		location.href="RDocumentosIntfCP_Excel.cfm?"+
		"fSNnumero=" + fsnnum +
		"&fSNcodigo=" + fsncod +
		"&fechaIni=" + fIni +
		"&fechaFin=" + fFin +
		"&CPTcodigo=" + cptcod;
	}
</script>
