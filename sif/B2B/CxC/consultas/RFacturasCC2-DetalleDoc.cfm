
<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 28 de octubre del 2005
	Motivo: Se acomodaron los datos para una mejor presentacion visual.
			Se agregaron variables ocultas para mantener los valores del filtro cuando regresara.
			Se cambio la forma de regresar, ahora se hace por medio de un submit a RFacturasCC2.cfm.
	Modificado por Gustavo Fonseca H.
		Fecha: 15-12-2005.
		Motivo: Se arregla la pantalla por que no estaba encontrando varios valores que venÃ­an por form.
	Modificado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Se agregan los registros de tipo Pago a los querys(rsDoc y rsDetDoc).
	Modificado por Gustavo Fonseca H.
		Fecha: 27-4-2006.
		Motivo: Se agrega el subtotal, IMPUESTO, observaciones y el ASIENTO.

 --->
<cfif isdefined("url.HDid") and not isdefined("form.HDid")>
	<cfset form.HDid = url.HDid>
</cfif>

<cfif isdefined("url.pop")>
	<cfif not isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
		<cfset url.SNcodigo = -1>
	</cfif>
	<cfif not isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
		<cfset url.Ddocumento = -1>
	</cfif>
	<cfif not isdefined("url.tipo") and not isdefined("form.tipo")>
		<cfset url.tipo = -1>
	</cfif>
	<cfif not isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
		<cfset url.SNnumero = -1>
	</cfif>	
	<cfif not isdefined("url.FECHAINI") and not isdefined("form.FECHAINI")>
		<cfset url.FECHAINI = ''>
	</cfif>	
	<cfif not isdefined("url.FECHAFIN") and not isdefined("form.FECHAFIN")>
		<cfset url.FECHAFIN = ''>
	</cfif>
	<cfif not isdefined("url.DOCUMENTO") and not isdefined("form.DOCUMENTO")>
		<cfset url.DOCUMENTO = ''>
	</cfif>
</cfif>	
<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>
<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
	<cfset form.Ddocumento = url.Ddocumento>
</cfif>
<cfif isdefined("url.tipo") and not isdefined("form.tipo")>
	<cfset form.tipo = url.tipo>
</cfif>
<cfif isdefined("url.SNnumero") and not isdefined("form.SNnumero")>
	<cfset form.SNnumero = url.SNnumero>
</cfif>

<cfquery name="rsverDetalle" datasource="#session.DSN#">
	select count(1) as Cantidad
	from HDDocumentos
	where HDid = #form.HDid#
</cfquery>

<cfif rsverDetalle.recordcount GT 0 and rsverDetalle.Cantidad GT 0>
	<cfquery name="rsDoc" datasource="#session.DSN#">
		select 
			(
				select (round(sum(dos.DDtotal) ,2))
				from HDDocumentos dos
				where dos.HDid = d.HDid
			) as subtotal, 
			
			coalesce(d.DEobservacion, 'N/A') as DEobservacion,
			-1 as HDid, d.CCTcodigo as tipo, d.Ddocumento,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
			d.Dfecha , d.Dvencimiento  , s.Mcodigo , d.Dtotal as Monto , round(d.Dtotal, 2) as Dsaldo, 
			o.Oficodigo,
			d.Ccuenta , m.Miso4217 as moneda,
			coalesce((
				select min(dv.Dsaldo)
				from Documentos dv
				where dv.Ecodigo = d.Ecodigo
				  and dv.Ddocumento = d.Ddocumento
				  and dv.CCTcodigo = d.CCTcodigo)
				, 0.00) as SaldoActual
			, Dtref as Dtref
			, Ddocref as Ddocref
			, t.CCTtipo
		from HDocumentos d
			inner join CCTransacciones t
				on  t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			inner join SNegocios s
					on s.SNcodigo = d.SNcodigo
					and s.Ecodigo = d.Ecodigo
			inner join Oficinas o
				  on o.Ecodigo = d.Ecodigo
				 and o.Ocodigo = d.Ocodigo
	
			inner join Monedas m
				  on m.Mcodigo = d.Mcodigo
	
		where d.HDid = #form.HDid#
	</cfquery>
<cfelse>
	<cfquery name="rsDoc" datasource="#session.DSN#">
		select 
			d.Dtotal as subtotal, 
			coalesce(d.DEobservacion, 'N/A') as DEobservacion,
			-1 as HDid, d.CCTcodigo as tipo, d.Ddocumento,
			s.SNcodigo,  s.SNnumero, s.SNidentificacion, s.SNnombre, 
			d.Dfecha , d.Dvencimiento  , s.Mcodigo , d.Dtotal as Monto , round(d.Dtotal, 2) as Dsaldo, o.Oficodigo,
			d.Ccuenta , m.Miso4217 as moneda,
			coalesce((
				select min(dv.Dsaldo)
				from Documentos dv
				where dv.Ecodigo = d.Ecodigo
				  and dv.Ddocumento = d.Ddocumento
				  and dv.CCTcodigo = d.CCTcodigo)
				, 0.00) as SaldoActual
			, Dtref as Dtref
			, Ddocref as Ddocref
			, t.CCTtipo
		from HDocumentos d
			inner join CCTransacciones t
				on  t.CCTcodigo = d.CCTcodigo
				and t.Ecodigo = d.Ecodigo
			inner join SNegocios s
					on s.SNcodigo = d.SNcodigo
					and s.Ecodigo = d.Ecodigo
			inner join Oficinas o
				  on o.Ecodigo = d.Ecodigo
				 and o.Ocodigo = d.Ocodigo
	
			inner join Monedas m
				  on m.Mcodigo = d.Mcodigo
	
		where d.HDid = #form.HDid#
	</cfquery>

</cfif>

<cfif trim(rsDoc.Dtref) NEQ "">
	<cfquery name="rsAsiento" datasource="#Session.DSN#">
		select he.Cconcepto, he.Edocumento as Asiento, he.Eperiodo, he.Emes
		from BMovimientos bm
			inner join HEContables he
				on he.IDcontable = bm.IDcontable
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
		  and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Dtref#">
		  and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocref#">
	</cfquery>
<cfelse>
	<cfquery name="rsAsiento" datasource="#Session.DSN#">
		select he.Cconcepto, he.Edocumento as Asiento, he.Eperiodo, he.Emes
		from BMovimientos bm
			inner join HEContables he
				on he.IDcontable = bm.IDcontable
		where bm.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and bm.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
		  and bm.CCTRcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.tipo#">
		  and bm.DRdocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDoc.Ddocumento#">
	</cfquery>
</cfif>

<cfquery name="rsDetDoc" datasource="#session.DSN#">
	select 
		hdd.DDcantidad as cantidad, 
		hdd.DDpreciou as preciou, 
		hdd.DDtotal as total, 
		hdd.DDtipo,
		case when  hdd.DDtipo = 'A' then 'Articulo'  else 'Servicio' end  as tipo, 
		substring(coalesce(hdd.DDdescalterna, hdd.DDescripcion),1,27) as descItem
	from HDocumentos hd
		inner join HDDocumentos hdd
		  on hd.HDid = hdd.HDid
	Where hd.HDid = #form.HDid#
</cfquery> 


<cfif rsDoc.CCTtipo EQ "D">
	<cfquery name="rsHistorialPagos" datasource="#session.DSN#">
		select 
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha, 
			bm.CCTcodigo as CCTcodigo, 
			bm.Ddocumento as Documento, 
			m.Miso4217, 
			round(bm.Dtotalref, 2) as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.DRdocumento = hd.Ddocumento
				and bm.CCTRcodigo = hd.CCTcodigo
				and bm.Ecodigo = hd.Ecodigo
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		order by 1
	</cfquery> 
<cfelse>
	<cfquery name="rsHistorialPagos" datasource="#session.DSN#">
		select 
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha,
			bm.CCTRcodigo as CCTcodigo, 
			bm.DRdocumento as Documento, 
			m.Miso4217, 
			bm.Dtotalref as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.Ecodigo = hd.Ecodigo
				and bm.CCTcodigo = hd.CCTcodigo
				and bm.Ddocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				and (bm.CCTRcodigo <> '#rsDoc.Dtref#' or bm.DRdocumento <> '#rsDoc.Ddocref#')
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		union
		select 
			<cf_dbfunction name="to_sdate" args="bm.Dfecha"> as Fecha, 
			bm.CCTcodigo as CCTcodigo, 
			bm.Ddocumento as Documento, 
			m.Miso4217, 
			bm.Dtotalref as Aplicado
		from HDocumentos hd
			inner join BMovimientos bm
				 on bm.Ecodigo = hd.Ecodigo
				and bm.CCTRcodigo = hd.CCTcodigo
				and bm.DRdocumento = hd.Ddocumento
				and bm.Dfecha >= hd.Dfecha
				and (bm.CCTRcodigo <> bm.CCTcodigo or bm.DRdocumento <> bm.Ddocumento)
				and (bm.CCTRcodigo <> '#rsDoc.Dtref#' or bm.DRdocumento <> '#rsDoc.Ddocref#')
			inner join Monedas m
				on m.Mcodigo = bm.Mcodigo
				and m.Ecodigo = bm.Ecodigo
		where hd.HDid = #form.HDid#
		order by 1
	</cfquery> 
</cfif>	

<cfif not isdefined("url.pop")>
	<cf_templateheader title="SIF - Cuentas por Cobrar">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Detalle del Documento">
	<form name="form1" method="post" action="RFacturasCC2.cfm">
		<table width="100%" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td valign="top" width="50%">
						<cfinclude template="/sif/portlets/pNavegacionCC.cfm">
						<cfinclude template="AREA_HEADER.cfm">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
						<tr>
							<td>&nbsp;</td>
							<td colspan="8" align="right">
								<cfset params = ''>
								<cfset params = "&SNcodigo=#url.SNcodigo#&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#">
								
								<cfif isdefined("url.CCTcodigo")>
									<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
								</cfif>
													
								<cf_rhimprime datos="/sif/cc/consultas/RFacturasCC2-DetalleDoc.cfm" paramsuri="#params#">
								<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
							</td>
						</tr>
						<tr><td colspan="4"><strong>&nbsp;Datos del Documento:</strong><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDoc.Tipo#&nbsp;-&nbsp;#rsDoc.Ddocumento#</cfoutput></span></td></tr>
						<tr>
							<td colspan="2" align="center">
								<cfoutput>
									<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center"> 
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
											<td align="right"><strong>Socio:&nbsp;</strong></td>
										  	<td >#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
										  	<td align="right"><strong>Fecha:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
									 	</tr>
										<tr>
											<td align="right"><strong>Identificaci&oacute;n:&nbsp;</strong></td>
										  	<td>#rsDoc.SNidentificacion#</td>
										  	<td align="right"><strong>Vencimiento:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.DVencimiento,"dd/mm/yyyy")# </td>
									  	</tr>
										<tr>
											<td align="right"><strong>Tipo Transacci&oacute;n:&nbsp;</strong></td>
											<td>#rsDoc.Tipo#</td>
											<td align="right"><strong>Moneda:&nbsp;</strong></td>
											<td>#rsDoc.Moneda#</td>
										</tr>
										<tr>
										  	<td align="right"><strong>Oficina:&nbsp;</strong></td>
										  	<td>#rsDoc.Oficodigo#</td>
											<td align="right"><strong>Subtotal:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td align="right"><strong>Asiento:&nbsp;</strong></td>
											<td>#rsAsiento.Cconcepto# - #rsAsiento.Asiento#</td>
											<td align="right"><strong>Impuesto:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.monto - rsDoc.subtotal,"none")#</td>
										</tr>
                                        
										<tr>
											<td align="right"><cfif len(trim(rsAsiento.Eperiodo))><strong>Peri&oacute;do Contable:&nbsp;</strong><cfelse>&nbsp;</cfif></td>
                                            <td><cfif len(trim(rsAsiento.Eperiodo))>#rsAsiento.Eperiodo#/#rsAsiento.Emes#<cfelse>&nbsp;</cfif></td>
											<td align="right"><strong>Monto:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td align="right"><strong>Saldo Actual:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.SaldoActual,"none")#</td>
										</tr>

									</table>
									<cfset saldo = rsDoc.Dsaldo>
									<cfset listaSNnumero = ListtoArray(form.SNnumero)>
									<cfset listaSNcodigo = ListtoArray(form.SNcodigo)>
									<cfif ArrayLen(listaSNnumero) GT 1>
									<input name="SNnumero" type="hidden" value="#listaSNnumero[1]#">
									<input name="SNcodigo" type="hidden" value="#listaSNcodigo[1]#">
									</cfif>
									<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
										<input name="CCTcodigo" type="hidden" value="#form.CCTcodigo#">
									</cfif>
									<cfif isdefined("form.Documento") and len(trim(form.Documento))>
										<input name="Documento" type="hidden" value="#form.Documento#">
									</cfif>
									<cfif isdefined("form.fechaIni") and len(trim(form.fechaIni))>
										<input name="fechaIni" type="hidden" value="#form.fechaIni#">
									</cfif>
									<cfif isdefined("form.fechaFin") and len(trim(form.fechaFin))>
										<input name="fechaFin" type="hidden" value="#form.fechaFin#">
									</cfif>
									<cfif isdefined("form.Documento") and len(trim(form.Documento))>
										<input name="consultar" type="hidden" value="#form.Documento#">
									</cfif>
							</td>
						</tr>
						<tr>
							<td align="left"><strong>Observaciones:</strong>&nbsp; #rsDoc.DEobservacion#</td>
						</tr>
						</cfoutput>
					</table>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Historial de Pagos/Aplicaciones</strong></td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
									<tr>
										<td nowrap align="center"><strong>Cant</strong></td>
										<td nowrap align="center"><strong>Tip</strong></td>
										<td nowrap><strong>Desc Item</strong></td>
										<td nowrap align="right"><strong>Precio Unitario</strong></td>
										<td nowrap align="right"><strong>Total Linea</strong></td>
									</tr>
									<cfoutput query="rsDetDoc">
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
												<td align="center">#rsDetDoc.cantidad#</td>
												<td>#rsDetDoc.DDtipo#</td>
												<td>#rsDetDoc.descItem#</td>
												<td align="right">#LScurrencyFormat(rsDetDoc.preciou,"none")# &nbsp;&nbsp;</td>
												<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
											</tr>
										</tr>
									</cfoutput>
									<td colspan="5" nowrap align="center">***** Fin de Detalle *****</td>
							  </table>
							</td>
							<td width="50%" valign="top">
								<cfif not len(trim(saldo))>
									<cfset nuevoSaldo = 0.00>
								<cfelse>
									<cfset nuevoSaldo = saldo> 
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
									  <td nowrap><strong>&nbsp;Fecha Pago</strong></td>
										<td nowrap><strong>Tipo</strong></td>
										<td nowrap ><strong>Num. Pago</strong></td>
										<td nowrap align="right"><strong>Monto</strong></td>
										<td nowrap align="right"><strong>Saldo</strong></td></tr>
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#lsdateformat(CreateDate(left(rsHistorialPagos.Fecha,4),mid(rsHistorialPagos.Fecha,5,2),mid(rsHistorialPagos.Fecha,7,2)),'dd/mm/yyyy')#</td>
											<td  nowrap>#rsHistorialPagos.CCTcodigo#</td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">
												#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")# 
											</td>
											<cfif len(trim(rsHistorialPagos.Aplicado))>
												<cfset nuevoSaldo = (round(nuevoSaldo * 100) - round(rsHistorialPagos.Aplicado * 100)) / 100>
											</cfif>
											<td  nowrap align="right">
													#LScurrencyFormat(nuevoSaldo,"none")#
											</td>
										</tr>
									</cfoutput>
									<tr><td colspan="5" nowrap align="center">***** Fin de Historial *****</td></tr>
								</table>
							</td>
						</tr>
						<!--- <tr align="center" valign="top"><td colspan="2">&nbsp;</td></tr> --->
					</table>
				</td>	
			</tr>
			<tr><td align="center" class="noprint"><input type="button"  value="Regresar" name="btnConsultar" onclick="Regresar();"></td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>	
		</form>
			<cfoutput>
				<cfset params=''>
				<cfset params = "SNcodigo=#url.SNcodigo#&FechaIni=#url.FechaIni#&FechaFin=#url.FechaFin#&Documento=#url.Documento#&btnConsultar=true">
				
				<cfif isdefined("url.CCTcodigo")>
					<cfset params = params & '&CCTcodigo=#url.CCTcodigo#'>
				</cfif>	
				<script language="javascript" type="text/javascript">
					function Regresar(){
					 document.form1.action='RFacturasCC2-reporte.cfm?#params#';
					 document.form1.submit();
					}
					
				</script>
			</cfoutput>
			<cf_web_portlet_end>
	<cf_templatefooter>
<cfelse>
	<title>Detalle del Documento</title>
	<cf_templatecss>
	<fieldset><legend>Detalle del Documento</legend>
		<table width="100%" cellpadding="2" cellspacing="0" align="center">
			<tr>
				<td valign="top" width="50%">
					<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">	
						<tr><td colspan="4"><strong>&nbsp;Datos del Documento:</strong><span style="font-size: 18px"> <cfoutput>&nbsp;#rsDoc.Tipo#&nbsp;-&nbsp;#rsDoc.Ddocumento#</cfoutput></span></td></tr>
						<tr>
							<td colspan="2" align="center">
								<cfoutput>
									<table width="60%" border="0" cellspacing="0" cellpadding="0" align="center"> 
										<tr><td colspan="4">&nbsp;</td></tr>
										<tr>
											<td align="right"><strong>Socio:&nbsp;</strong></td>
										  	<td >#rsDoc.SNnumero#- #rsDoc.SNnombre#</td>
										  	<td align="right"><strong>Fecha:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.Dfecha,"dd/mm/yyyy")#</td>
									 	</tr>
										<tr>
											<td align="right"><strong>Identificaci&oacute;n:&nbsp;</strong></td>
										  	<td>#rsDoc.SNidentificacion#</td>
										  	<td align="right"><strong>Vencimiento:&nbsp;</strong></td>
										  	<td>#LSDateformat(rsDoc.DVencimiento,"dd/mm/yyyy")# </td>
									  	</tr>
										<tr>
											<td align="right"><strong>Tipo Transacci&oacute;n:&nbsp;</strong></td>
											<td>#rsDoc.Tipo#</td>
											<td align="right"><strong>Moneda:&nbsp;</strong></td>
											<td>#rsDoc.Moneda#</td>
										</tr>
										<tr>
										  	<td align="right"><strong>Oficina:&nbsp;</strong></td>
										  	<td>#rsDoc.Oficodigo#</td>
											<td align="right"><strong>Subtotal:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td align="right"><strong>Asiento:&nbsp;</strong></td>
											<td>#rsAsiento.Cconcepto# - #rsAsiento.Asiento#</td>
											<td align="right"><strong>Impuesto:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.monto - rsDoc.subtotal,"none")#</td>
										</tr>
										<tr>
											<td align="right"><cfif len(trim(rsAsiento.Eperiodo))><strong>Peri&oacute;do Contable:&nbsp;</strong><cfelse>&nbsp;</cfif></td>
                                            <td><cfif len(trim(rsAsiento.Eperiodo))>#rsAsiento.Eperiodo#/#rsAsiento.Emes#<cfelse>&nbsp;</cfif></td>
											<td align="right"><strong>Monto:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.monto,"none")#</td>
										</tr>
										<tr>
											<td colspan="2">&nbsp;</td>
											<td align="right"><strong>Saldo Actual:&nbsp;</strong></td>
										  	<td>#LScurrencyFormat(rsDoc.SaldoActual,"none")#</td>
										</tr>

									</table>
									<cfset saldo = rsDoc.Dsaldo>
							</td>
						</tr>
						<tr>
							<td align="left"><strong>Observaciones:</strong>&nbsp; #rsDoc.DEobservacion#</td>
						</tr>
						</cfoutput>
					</table>
					<table width="100%" border="1" cellspacing="0" cellpadding="0" align="center">
						<tr>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Detalles de L&iacute;nea(s) del Documento</strong></td>
							<td class="tituloListas" style="border-bottom: 1px solid black;" ><strong>Historial de Pagos/Aplicaciones</strong></td>
						</tr>
						<tr>
							<td width="50%" valign="top">
								<table width="100%" border="0" cellspacing="0" cellpadding="0"> 
									<tr>
										<td nowrap align="center"><strong>Cant</strong></td>
										<td nowrap align="center"><strong>Tip</strong></td>
										<td nowrap><strong>Desc Item</strong></td>
										<td nowrap align="right"><strong>Precio Unitario</strong></td>
										<td nowrap align="right"><strong>Total Linea</strong></td>
									</tr>
									<cfoutput query="rsDetDoc">
										<tr class ="<cfif rsDetDoc.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>" >
											<td align="center">#rsDetDoc.cantidad#</td>
											<td>#rsDetDoc.DDtipo#</td>
											<td>#rsDetDoc.descItem#</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.preciou,"none")# &nbsp;&nbsp;</td>
											<td align="right">#LScurrencyFormat(rsDetDoc.total,"none")#</td>
										</tr>
									</cfoutput>
									<td colspan="5" nowrap align="center">***** Fin de Detalle *****</td>
							  </table>
							</td>
							<td width="50%" valign="top">
								<cfif not len(trim(saldo))>
									<cfset nuevoSaldo = 0.00>
								<cfelse>
									<cfset nuevoSaldo = saldo> 
								</cfif>
								<table width="100%" border="0" cellspacing="0" cellpadding="0">
									<tr>
									  <td nowrap><strong>&nbsp;Fecha Pago</strong></td>
										<td nowrap><strong>Tipo</strong></td>
										<td nowrap ><strong>Num. Pago</strong></td>
										<td nowrap align="right"><strong>Monto</strong></td>
										<td nowrap align="right"><strong>Saldo</strong></td></tr>
									<cfoutput query="rsHistorialPagos">
										<tr class="<cfif rsHistorialPagos.CurrentRow MOD 2>listaNon<cfelse>listaPar</cfif>">
											<td  nowrap >#lsdateformat(CreateDate(left(rsHistorialPagos.Fecha,4),mid(rsHistorialPagos.Fecha,5,2),mid(rsHistorialPagos.Fecha,7,2)),'dd/mm/yyyy')#</td>
											<td  nowrap>#rsHistorialPagos.CCTcodigo#</td>
											<td  nowrap>#rsHistorialPagos.Documento#</td>
											<td  nowrap align="right">
												#LScurrencyFormat(rsHistorialPagos.Aplicado,"none")# 
											</td>
											<cfif len(trim(rsHistorialPagos.Aplicado))>
												<cfset nuevoSaldo = (round(nuevoSaldo * 100) - round(rsHistorialPagos.Aplicado * 100)) / 100>
											</cfif>
											<td  nowrap align="right">
													#LScurrencyFormat(nuevoSaldo,"none")#
											</td>
										</tr>
									</cfoutput>
									<tr><td colspan="5" nowrap align="center">***** Fin de Historial *****</td></tr>
								</table>
							</td>
						</tr>
					</table>
				</td>	
			</tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	</fieldset>		
</cfif>		

