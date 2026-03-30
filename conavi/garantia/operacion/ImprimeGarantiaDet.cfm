<style type="text/css">
<!--
.style17 {font-size: 22px; font-weight: bold; }
.style18 {font-size: 20px}
.style19 {font-size: 18px}
.style20 {font-size: 18}
-->
</style>

<cf_rhimprime datos="/conavi/garantia/operacion/ImprimeGarantiaDet.cfm" regresar="/cfmx/conavi/garantia/operacion/ReimpresionReciboDevolucion.cfm">
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
<cfif isdefined( 'form.COEGid' )>
	<cfset LvarCOEGid = #form.COEGid#>
</cfif>
<cfif isdefined( 'url.COEGid' )>
	<cfset LvarCOEGid = #url.COEGid#>
</cfif>
<cfif isdefined( 'form.COEGVersion' )>
	<cfset LvarCOEGVersion = #form.COEGVersion#>
</cfif>
<cfif isdefined( 'url.COEGVersion' )>
	<cfset LvarCOEGVersion = #url.COEGVersion#>
</cfif>

<!--- Encabezado de la Garantia--->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
	select eg.COEGReciboGarantia, eg.COEGFechaDevOEjec, eg.COEGTipoGarantia,
		eg.COEGVersion, coalesce(p.CMPProceso,'-- NO ASIGNADO --') as ProcesoID, 
		s.SNnombre as SocioDeNegocio, m.Msimbolo, cl.COLGnumeroControl,cl.COLGObservacion,
		sum(case when eg.Mcodigo = dg.CODGMcodigo then CODGMonto else CODGMonto * dg.CODGTipoCambio / coalesce(tc.TCventa,1) end) as MontoTotal,
		eg.COEGNumeroControl
		from COHEGarantia eg
			inner join COHDGarantia  dg
				on dg.COEGid = eg.COEGid and eg.COEGVersion = dg.COEGVersion
			inner join COLiberaGarantia   cl
			    on eg.COEGid = cl.COEGid 	
			left outer join CMProceso p 
				on p.CMPid = eg.CMPid	
			inner join SNegocios s
				on s.SNid = eg.SNid  
			inner join Monedas m
				on m.Mcodigo = eg.Mcodigo
			left outer join Htipocambio tc
				on tc.Mcodigo = eg.Mcodigo and tc.Hfecha <= eg.COEGFechaRecibe and tc.Hfechah > eg.COEGFechaRecibe
		where eg.COEGid = #LvarCOEGid# and eg.COEGVersion = #LvarCOEGVersion# 
		group by eg.COEGReciboGarantia, eg.COEGFechaDevOEjec, eg.COEGTipoGarantia,
		eg.COEGVersion, p.CMPProceso, s.SNnombre, m.Msimbolo,cl.COLGnumeroControl,cl.COLGObservacion,eg.COEGNumeroControl
</cfquery>
<!---Detalles de la garantia--->
<cfquery name="rsDetalles" datasource="#session.dsn#">
	select dg.CODGNumeroGarantia, dg.CODGid, dg.CODGMonto,
		tr.COTRDescripcion, b.Bdescripcion, m.Miso4217
		from COHDGarantia  dg
			inner join COTipoRendicion tr
				on tr.COTRid = dg.COTRid
			inner join Bancos b
				on b.Bid= dg.Bid
			inner join Monedas m
				on m.Mcodigo = dg.CODGMcodigo
		where dg.COEGid = #LvarCOEGid# and dg.COEGVersion = #LvarCOEGVersion# 
</cfquery>

<!---para mostrar el logo de la empresa--->
<cfquery name="rsData" datasource="asp">
	select SSlogo,SScodigo,  ts_rversion as SStimestamp from SSistemas
		where SScodigo='#session.monitoreo.sscodigo#'
</cfquery>

<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0" border="0">
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
						<img src="#imagesrc#" name="logo_preview" width="245" height="76" border="0" align="top" id="logo_preview">
					</td>
				  </tr>
			  </table>
			  <table width="67%" align="left" border="0" height="25px">
				  <tr>
					<td  width="40%" align="center"><strong><span class="style17">CONSEJO NACIONAL DE VIALIDAD</span></strong></td>
					<td  width="27%" align="left" valign="top"><span class="style18">Fecha: #LSDateFormat(now(), 'dd/mm/yyyy')#</span></td>
				  </tr>
				  <tr>
					<td  align="center"><strong><span class="style17">TESORERIA</span></strong></td>
				  </tr> 
				  <tr>
					<td  align="center"><strong><span class="style17">SISTEMA CONTROL DE GARANTIAS</span></strong></td>
				  </tr>
			  </table>
		  	</td>
		</tr>
		<tr>
		  <td align="center"><strong><span class="style18">Reimpresión del Recibo de Devolución n° #rsEncabezado.COLGnumeroControl#, de la Garantía: #rsEncabezado.COEGReciboGarantia#-#rsEncabezado.COEGVersion# &nbsp; No. Control: #rsEncabezado.COEGNumeroControl#</span></strong></td>
		</tr>
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="47%"   align="left"><span class="style18">HORA OFICIAL CONAVI:</span></td>
							<td width="53%"   align="left"><span class="style18">#TimeFormat(now(),"hh:mm:ss")#</span></td>
					  </tr>
					  <tr>
							<td  align="left"><span class="style18">FECHA DE DEVOLUCION:</span></td>
							<td  align="left"><span class="style18">#LSDateFormat(rsEncabezado.COEGFechaDevOEjec, 'dd/mm/yyyy')#</span></td>
					  </tr> 
				</table>
			</td>
		</tr>		
		<tr>
		  <td align="left"><span class="style18">En esta fecha he recibido del</span> <strong><span class="style18">Consejo Nacional de Vialidad</span></strong> <span class="style18">la suma de #rsEncabezado.Msimbolo##LSNumberFormat(rsEncabezado.MontoTotal, ',9.00')#</span> </td></tr>
		<tr>
			<td align="left"><strong><span class="style18"> Mediante:Devolución de Garantía</span></strong></td>
		</tr>
		<tr>	
			<td align="left"><span class="style18">Tipo Garantía:</span> <strong><span class="style18"><cfif #rsEncabezado.COEGTipoGarantia# eq 1> Participación <cfelseif #rsEncabezado.COEGTipoGarantia# eq 2> Cumplimiento </cfif></span></strong> </td>
		</tr>
		<tr>	
			<td align="left"><span class="style18">Proceso:</span> <strong><span class="style18">#rsEncabezado.ProcesoID# </span></strong></td>
		</tr>
		<tr>	
			<td align="left"><strong><span class="style18">Proveedor: #rsEncabezado.SocioDeNegocio# </span></strong></td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td>	
				<table width="100%" align="left" border="1" height="25px">
					<tr>
						<td width="18%" bgcolor="CCCCCC" align="left"><span class="style18">Numero</span></td>
						<td width="13%" bgcolor="CCCCCC" align="left"><span class="style18">Monto</span></td>
						<td width="11%" bgcolor="CCCCCC" align="left"><span class="style18">Banco Emisor</span></td>
						<td width="17%" bgcolor="CCCCCC" align="left"><span class="style18">Moneda</span></td>
						<td width="28%" bgcolor="CCCCCC" align="left"><span class="style18">Tipo de Rendición</span></td>
					</tr>
					<cfloop query="rsDetalles">
						<tr>
							<td height="57" nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.CODGNumeroGarantia#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#LSNumberFormat(rsDetalles.CODGMonto, ',9.00')#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.Bdescripcion#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.Miso4217#</span></td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px"><span class="style20">#rsDetalles.COTRDescripcion#</span></td>
						</tr>
					 </cfloop>
				</table>
			</td>	
		</tr>
		<tr><td align="left"><span class="style20">Nota:</span> <strong><span class="style18"> #rsEncabezado.COLGObservacion#</span></strong></td></tr>
		<tr><td align="center">**********************************************************************************************************************************</td></tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="50%"  align="left"><span class="style20">Entregado por: #session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2#</span> </td> 
							<td width="50%"  align="left"><br />
						    <span class="style20">Recibida por:</span></td>
					  </tr>
					  <tr>
							<td  align="left"><span class="style20">Cédula: #session.datos_personales.id#</span></td>
							<td  align="left"><br />
						    <span class="style20">Cédula:</span><br /></td>
					  </tr> 
					  <tr>
							<td  align="left"><span class="style20">Firma:</span></td>
							<td  align="left"><br />
						    <span class="style20">Firma:</span><br /></td>
					  </tr> 
				</table>
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>	
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td align="left"><span class="style20">CC: ORIGINAL INTERESADO, CC: SUMINISTROS/CONTABILIDAD/TESORERIA/EJECUCION PRESUPUESTARIA</span></td>
		</tr>
		<tr><td align="left">_____________________________________________________________________________________</td></tr>
		<tr><td align="left"><span class="style20">Consejo Nacional de Vialidad. Tel:(506)2225-4425 ó 2283-9717 Apto. 616-2010 San José, Costa Rica</span></td></tr>

</table>
</cfoutput>