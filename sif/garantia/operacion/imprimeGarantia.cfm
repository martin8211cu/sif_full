<style type="text/css">
<!--
.style17 {font-size: 14px; font-weight: bold; }
.style18 {font-size: 12px}
.style19 {font-size: 10px}
.style20 {font-size: 10}
-->
</style>
<cf_rhimprime datos="/sif/garantia/operacion/imprimeGarantia.cfm" regresar="/cfmx/sif/garantia/operacion/Garantia.cfm">
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
<cfif isdefined( 'form.COEGid' )>
	<cfset LvarCOEGid = #form.COEGid#>
</cfif>
<cfif isdefined( 'url.COEGid' )>
	<cfset LvarCOEGid = #url.COEGid#>
</cfif>
<!--- Encabezado de la Garantia--->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
		select eg.COEGReciboGarantia, eg.COEGPersonaEntrega, eg.COEGIdentificacion, eg.COEGTipoGarantia,
			eg.COEGVersion, eg.COEGFechaRecibe, coalesce(p.CMPProceso,'-- NO ASIGNADO --') as ProcesoID, s.SNnombre as SocioDeNegocio,
			m.Mnombre, m.Msimbolo, m.Miso4217,
			sum(case when eg.Mcodigo = dg.CODGMcodigo then CODGMonto else CODGMonto * dg.CODGTipoCambio / coalesce(tc.TCventa,1) end) as MontoTotal,
			eg.COEGNumeroControl
			from COEGarantia eg
				inner join CODGarantia  dg
					on dg.COEGid = eg.COEGid
				left outer join CMProceso p 
					on p.CMPid = eg.CMPid	
				inner join SNegocios s
					on s.SNid = eg.SNid  
				inner join Monedas m
					on m.Mcodigo = eg.Mcodigo
				left outer join Htipocambio tc
           			on tc.Mcodigo = eg.Mcodigo and tc.Hfecha <= eg.COEGFechaRecibe and tc.Hfechah > eg.COEGFechaRecibe
			where eg.COEGid = #LvarCOEGid#
			group by eg.COEGReciboGarantia, eg.COEGPersonaEntrega, eg.COEGIdentificacion, eg.COEGTipoGarantia,
			eg.COEGVersion, eg.COEGFechaRecibe, p.CMPProceso, s.SNnombre,
			m.Mnombre, m.Msimbolo, m.Miso4217, eg.COEGNumeroControl
</cfquery>
<!---Detalles de la garantia--->
<cfquery name="rsDetalles" datasource="#session.dsn#">
	select dg.CODGNumeroGarantia, dg.CODGFechaIni, dg.CODGFechaFin, dg.CODGid, dg.CODGObservacion, dg.CODGMonto,
		tr.COTRDescripcion, b.Bdescripcion, m.Miso4217
		from CODGarantia  dg
			inner join COTipoRendicion tr
				on tr.COTRid = dg.COTRid
			inner join Bancos b
				on b.Bid= dg.Bid
			inner join Monedas m
				on m.Mcodigo = dg.CODGMcodigo
		where dg.COEGid = #LvarCOEGid#
</cfquery>

<!---para mostrar el logo de la empresa--->
<cfquery name="rsData" datasource="asp">
	select SSlogo,SScodigo,  ts_rversion as SStimestamp from SSistemas
		where SScodigo='#session.monitoreo.sscodigo#'
</cfquery>
<cfoutput>
<table width="100%" border="0" align="left" cellpadding="2" cellspacing="0">
		<tr>
			<td align="right">
			  <table width="16%" align="left" border="0" height="25px">
				  <tr>
				  	<td> 
						<cfset imagesrc = "blank.gif">
						<cfif Len(rsData.SSlogo) GT 1>
							<cfinvoke 
							component="sif.Componentes.DButils"
							method="toTimeStamp"
							returnvariable="tsurl">
							<cfinvokeargument name="arTimeStamp" value="#rsData.SStimestamp#"/>
							</cfinvoke>
							<cfset imagesrc = "/cfmx/home/public/logo_sistema.cfm?s="&URLEncodedFormat(rsData.SScodigo)&"&ts="&tsurl>
						</cfif>
						<img src="#imagesrc#" name="logo_preview" width="220" height="76" border="0" align="top" id="logo_preview">					</td>
				  </tr>
			  </table>
			  <table width="100%" align="left" border="0" height="74">
				  <tr>
					<td width="75%"  align="center"><span class="style17"><cfoutput>#session.enombre#</cfoutput></span></td>
					<td width="25%" height="21" align="left" valign="top"><span class="style18">Fecha:  #LSDateFormat(now(), 'dd/mm/yyyy')#</span></td>
				  </tr>
				  <tr>
					<td  align="center"><span class="style17">TESORERIA</span></td>
				  </tr> 
				  <tr>
					<td  align="center"><span class="style17">SISTEMA CONTROL DE GARANTIAS</span></td>
				  </tr>
			  </table>		  	</td>
		</tr>
		<tr>
		  <td align="center"><span class="style18"><strong>Recibo de Garantía: #rsEncabezado.COEGReciboGarantia#-#rsEncabezado.COEGVersion#</strong></span></td>
		</tr>
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="47%"  align="left"><span class="style18">HORA OFICIAL:</span></td>
							<td width="53%"  align="left"><span class="style18">#LSDateFormat(now(), 'dd/mm/yyyy hh:mm:ss')#</span></td>
					  </tr>
					  <tr>
							<td  align="left"><span class="style18">FECHA DE RECEPCION:</span></td>
							<td  align="left"><span class="style18">#LSDateFormat(rsEncabezado.COEGFechaRecibe, 'dd/mm/yyyy hh:mm:ss')#</span></td>
					  </tr> 
			  </table>			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="50%"  align="left"><span class="style18">Hemos recibido de: #rsEncabezado.COEGPersonaEntrega#</span></td>
							<td width="50%"  align="left"><span class="style18">Cédula: #rsEncabezado.COEGIdentificacion#</span></td>
					  </tr>
					  <tr>
							<td colspan="2"  align="left"><span class="style18">En representación de: #rsEncabezado.SocioDeNegocio#</span></td>
					  </tr> 
		    </table>			</td>
		</tr>			
		<tr>
		  <td align="left"><span class="style18">La suma de #rsEncabezado.Msimbolo# #LSNumberFormat(rsEncabezado.MontoTotal, ',9.00')#  </span></td>
		</tr>
		<tr>	
			<td align="left"><span class="style18">Por concepto de Garantía: <strong>
			<cfif #rsEncabezado.COEGTipoGarantia# eq 1> 
			Participación 
			  <cfelseif #rsEncabezado.COEGTipoGarantia# eq 2> 
			  Cumplimiento 
			</cfif>
			</strong></span> </td>
		</tr>
		<tr>
		  <td align="left"><span class="style18">Número Control:  <strong>#rsEncabezado.COEGNumeroControl# </strong>
		  </td>
		</tr>
		<tr>	
			<td align="left"><span class="style18">Proceso de Compra: <strong>#rsEncabezado.ProcesoID# </strong></span></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>	
				<table width="100%" align="left" border="1" height="113">
					<tr>
						<td width="18%" bgcolor="CCCCCC" align="left">Numero</td>
						<td width="13%" bgcolor="CCCCCC" align="left"><span class="style18">Monto</span></td>
						<td width="11%" bgcolor="CCCCCC" align="left"><span class="style18">Moneda</span></td>
						<td width="13%" bgcolor="CCCCCC" align="left"><span class="style18">Banco Emisor</span></td>
						<td width="17%" bgcolor="CCCCCC" align="left"><span class="style18">Tipo de Rendición</span></td>
						<td width="28%" bgcolor="CCCCCC" align="left"><span class="style18">Vigencia</span></td>						
					</tr>					
					<cfloop query="rsDetalles">
						<tr>
							<td height="57" nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.CODGNumeroGarantia#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#LSNumberFormat(rsDetalles.CODGMonto, ',9.00')#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.Miso4217#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.Bdescripcion#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.COTRDescripcion#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"> <span class="style20">Del: #LSDateFormat(rsDetalles.CODGFechaIni,'dd/mm/yyyy')# <br />
							Al: #LSDateFormat(rsDetalles.CODGFechaFin,'dd/mm/yyyy')# </span></td>
						</tr>
						<tr>
						   <td style="padding:3px;font-siza:12px" bgcolor="CCCCCC" align="left"><span class="style18">Observación: </span></td>
						   <td colspan="5" style="padding:3px;font-siza:12px"> <span class="style18">#rsDetalles.CODGObservacion#</span></td>
						</tr>
				  </cfloop>
			  </table>			</td>	
		</tr>
		<tr><td>&nbsp;</td></tr>		
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="50%"  align="left"><span class="style18"><br />
						    Entregado por: #rsEncabezado.COEGPersonaEntrega#<br />
							</span></td> 
							<td width="50%"  align="left"><span class="style18">Recibida por: #session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#</span></td>
					  </tr>
					  <tr>
						<td  align="left"><br />
					      <span class="style18">Cédula: #rsEncabezado.COEGIdentificacion#</span></td>
							<td  align="left"><span class="style18">Cédula: #session.datos_personales.id#</span></td>
					  </tr> 
					  <tr>
							<td  align="left"><br />
						      <span class="style18">Firma:</span></td>
							<td  align="left"><span class="style18">Firma:</span></td>
					  </tr> 
			  </table>			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>	
		
		<tr>
		  <td align="left"><span class="style19">CC: ORIGINAL INTERESADO, CC: SUMINISTROS/CONTABILIDAD/TESORERIA/EJECUCION PRESUPUESTARIA</span></td>
		</tr>
		<tr><td align="left"><span class="style19">_____________________________________________________________________________________</span></td>
		</tr>
		<tr><td align="left"><span class="style19"><cfoutput>#session.enombre#</cfoutput>. Tel:(506)2225-4425 ó 2283-9717 Apto. 616-2010 San José, Costa Rica</span></td>
		</tr>
</table>
</cfoutput>
