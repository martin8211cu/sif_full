<cf_rhimprime datos="/conavi/garantia/operacion/popUpDevolucionGarantia.cfm" regresar="/cfmx/conavi/garantia/operacion/listaDevolucionGarantia.cfm">
	<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 

<cfif isdefined( 'rsGarantia.COEGid' )>
	<cfset LvarCOEGid = #rsGarantia.COEGid#>
</cfif>
<cfif isdefined( 'url.COEGid' )>
	<cfset LvarCOEGid = #url.COEGid#>
</cfif>
<cfif isdefined( 'rsGarantia.COEGVersion' )>
	<cfset LvarCOEGVersion= #rsGarantia.COEGVersion#>
</cfif>
<cfif isdefined( 'url.COEGVersion' )>
	<cfset LvarCOEGVersion = #url.COEGVersion#>
</cfif>

<!--- Encabezado de la Garantia--->
<cfquery name="rsEncabezado" datasource="#session.dsn#">
	select eg.COEGReciboGarantia, eg.COEGFechaDevOEjec, eg.COEGTipoGarantia,
		eg.COEGVersion, coalesce(p.CMPProceso,'-- NO ASIGNADO --') as ProcesoID, 
		s.SNnombre as SocioDeNegocio, m.Msimbolo, cl.COLGnumeroControl,cl.COLGObservacion,
		sum(case when eg.Mcodigo = dg.CODGMcodigo then CODGMonto else CODGMonto * dg.CODGTipoCambio / coalesce(tc.TCventa,1) end) as MontoTotal
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
		eg.COEGVersion, p.CMPProceso, s.SNnombre, m.Msimbolo,cl.COLGnumeroControl,cl.COLGObservacion
</cfquery>
<!---Detalles de la garantia--->
<cfquery name="rsDetalles" datasource="#session.dsn#">
	select dg.CODGNumeroGarantia, dg.CODGid, dg.CODGMonto,
		tr.COTRDescripcion, b.Bdescripcion, m.Miso4217
		from CODGarantia  dg
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
					<td  align="center"><strong>CONSEJO NACIONAL DE VIALIDAD</strong></td>
					<td height="21" align="left" valign="top">Fecha:  #LSDateFormat(now(), 'dd/mm/yyyy')#</td>
				  </tr>
				  <tr>
					<td  align="center"><strong>TESORERIA</strong></td>
				  </tr> 
				  <tr>
					<td  align="center"><strong>SISTEMA CONTROL DE GARANTIAS</strong></td>
				  </tr>
			  </table>
		  	</td>
		</tr>
		<tr>
		  <td align="center"><strong>Devolución n° #rsEncabezado.COLGnumeroControl#, de la Garantía: #rsEncabezado.COEGReciboGarantia#-#rsEncabezado.COEGVersion#</strong></td>
		</tr>
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="40%"  align="left">HORA OFICIAL CONAVI:</td>
							<td width="60%"  align="left">#TimeFormat(now(),"hh:mm:ss")#</td>
					  </tr>
					  <tr>
							<td  align="left">FECHA DE DEVOLUCION:</td>
							<td  align="left">#LSDateFormat(rsEncabezado.COEGFechaDevOEjec, 'dd/mm/yyyy')#</td>
					  </tr> 
				</table>
			</td>
		</tr>		
		<tr>
		  <td align="left">En esta fecha he recibido del <strong>Consejo Nacional de Vialidad</strong> la suma de #rsEncabezado.Msimbolo##LSNumberFormat(rsEncabezado.MontoTotal, ',9.00')# </td></tr>
		<tr>
			<td align="left">Mediante:<strong> Devolución de Garantía</strong></td>
		</tr>
		<tr>	
			<td align="left">Tipo Garantía: <strong><cfif #rsEncabezado.COEGTipoGarantia# eq 1> Participación <cfelseif #rsEncabezado.COEGTipoGarantia# eq 2> Cumplimiento </cfif></strong> </td>
		</tr>
		<tr>	
			<td align="left">Proceso: <strong>#rsEncabezado.ProcesoID# </strong></td>
		</tr>
		<tr>	
			<td align="left">Proveedor: <strong>#rsEncabezado.SocioDeNegocio# </strong></td>
		</tr>		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
		  <td>	
				<table width="100%" align="left" border="1" height="25px">
					<tr>
						<td width="16%" bgcolor="CCCCCC" align="left">Numero</td>
						<td width="16%" bgcolor="CCCCCC" align="left">Monto</td>
						<td width="27%" bgcolor="CCCCCC" align="left">Banco Emisor</td>
						<td width="15%" bgcolor="CCCCCC" align="left">Moneda</td>
						<td width="26%" bgcolor="CCCCCC" align="left">Tipo de Rendición</td>
					</tr>
					<cfloop query="rsDetalles">
						<tr>
							<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.CODGNumeroGarantia#</td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px">#LSNumberFormat(rsDetalles.CODGMonto, ',9.00')#</td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.Bdescripcion#</td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.Miso4217#</td>
							<td nowrap="nowrap" style="padding:3px;font-size:12px">#rsDetalles.COTRDescripcion#</td>
						</tr>
					 </cfloop>
				</table>
			</td>	
		</tr>
		<tr><td align="left">Nota: <strong> #rsEncabezado.COLGObservacion#</strong></td></tr>
		<tr><td align="center">**********************************************************************************************************************************</td></tr>

		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr>
			<td>
				<table width="100%" align="left" border="1" height="25px">
					  <tr>
							<td width="40%"  align="left">Entregado por: #session.datos_personales.nombre# #session.datos_personales.apellido1# #session.datos_personales.apellido2# </td> 
							<td width="60%"  align="left">Recibida por:</td>
					  </tr>
					  <tr>
							<td  align="left">Cédula: #session.datos_personales.id#</td>
							<td  align="left"><br />
						    Cédula:</td>
					  </tr> 
					  <tr>
							<td  align="left">Firma:</td>
							<td  align="left">						    <br />
						    Firma:</td>
					  </tr> 
				</table>
			</td>
		</tr>	
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>	
		
		<tr>
		  <td align="left">CC: ORIGINAL INTERESADO, CC: SUMINISTROS/CONTABILIDAD/TESORERIA/EJECUCION PRESUPUESTARIA</td>
		</tr>
		<tr><td align="left">_____________________________________________________________________________________</td></tr>
		<tr><td align="left">Consejo Nacional de Vialidad. Tel:(506)2225-4425 ó 2283-9717 Apto. 616-2010 San José, Costa Rica</td></tr>

</table>
</cfoutput>
