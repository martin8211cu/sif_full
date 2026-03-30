<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cffunction name="contenidoCorreoCompradorRecepcion" returntype="string">
	<cfargument name="EDRid" type="numeric" required="yes">			<!--- id del Documento --->
	<cfargument name="CMCid" type="numeric" required="yes">			<!--- id del Comprador al que se le envía el correo --->
	<cfargument name="Pnombre" type="string" required="yes">		<!--- Nombre del Resposable --->
	<cfargument name="Usucodigo" type="numeric" required="yes">		<!--- id del Usuario al que se le envía el correo --->
	<cfargument name="CEcodigo" type="numeric" required="yes">

	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfsavecontent variable="_mail_body">
		<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
		<html>
			<head>
				<title>Notificación</title>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
			</head>
			<body>
			
			<cfquery name="dataCorreoDetalle" datasource="#session.dsn#">
				select  
						ed.EPDid,
						ed.EDRestado,
						DDRlinea,
						dd.Icodigo,
						coalesce(i.Iporcentaje,0) as Iporcentaje, 			<!----Porcentaje de impuesto del documento de recepcion---->
						i.Idescripcion,		
						o.Icodigo as IcodigoOC,
						coalesce(imp.Iporcentaje,0) as IporcentajeOC,		<!----Porcentaje de impuesto de la OC---->
						imp.Idescripcion as IdescripcionOC,
						o.DOcantidad - o.DOcantsurtida as DOcantsaldo,					<!--- Cantidad del saldo en la linea de la orden de compra --->
						dd.Aid,
						Acodigo,
						Adescripcion,
						dd.DDRtipoitem,
						dd.Cid,
						c.Ccodigo,
						c.Cdescripcion,
						dd.DOlinea,
						ed.EDRnumero,
						EDRfecharec,
						EDRobs,
						ed.SNcodigo,
						SNnumero,
						SNnombre,
						SNidentificacion,
						coalesce(DDRcantorigen,0) as DDRcantorigen,
						coalesce(DDRcantrec,0) as DDRcantrec,
						#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRpreciou,0)", "DDRpreciou")#,
						#LvarOBJ_PrecioU.enSQL_AS("coalesce(DDRprecioorig,0)", "DDRprecioorig")#,
						coalesce(DDRcantreclamo,0) as DDRcantreclamo,
						dd.DOlinea, 
						p.EOnumero,
						coalesce(o.DOcantidad,0) as DOcantidad,
						coalesce(o.DOcantsurtida,0) as DOcantsurtida,
						dd.DDRobsreclamo,
						coalesce(o.DOmontodesc,0) as DOmontodesc,
						coalesce(o.DOporcdesc,0) as DOporcdesc,
						case 
							when dd.DDRaprobtolerancia = 10 then 1
							else 0
						end DDRaprobtolerancia,			
						coalesce(dd.DDRdescporclin,0) as DDRdescporclin,
						case 
							when (dd.DDRgenreclamo = 1)  and 
								(dd.DDRaprobtolerancia is null or
								dd.DDRaprobtolerancia = 5 or
								dd.DDRaprobtolerancia=20)
														then ((coalesce(clas.Ctolerancia, 0) / 100) * o.DOcantidad)
							else 0
						end Ctolerancia,				<!--- Tolerancia del articulo --->
						case when clas.Ctolerancia is null then 'F'
							 else 'V'
						end as ArticuloTieneTolerancia,
						coalesce(dd.DDRdesclinea,0) as DDRdesclinea,
						o.DOconsecutivo,
						o.DOdescripcion,
						ed.Mcodigo,
						p.Mcodigo as McodigoOC,
						ed.EDRtc,
						p.EOtc,
						case when o.Ucodigo = dd.Ucodigo then 1
							 when cu.CUfactor is not null then cu.CUfactor
							 when cua.CUAfactor is not null then cua.CUAfactor
							 else case when dd.DDRcantorigen = 0 then 0
									   else dd.DDRcantordenconv / dd.DDRcantorigen
									   end
							 end as factorConversionU,									<!--- Factor de conversion (factura a orden) --->	
						mon.Mnombre,
						dd.DDRgenreclamo,
						floor(((o.DOcantidad - o.DOcantsurtida) + (o.DOcantidad * coalesce(clas.Ctolerancia, 0.00) / 100.00))) as CantidadPermitida,
						
						dd.Ucodigo as UcodigoFac,
						o.Ucodigo as UcodigoOC,
						dp.Pnombre #_Cat# dp.Papellido1 #_Cat# dp.Papellido2 as Pnombre,
						sn.SNnombre

				from DDocumentosRecepcion dd
					inner join EDocumentosRecepcion ed
						on ed.EDRid = dd.EDRid
						and ed.Ecodigo = dd.Ecodigo

					left outer join Monedas mon
						on ed.Mcodigo = mon.Mcodigo
						and ed.Ecodigo = mon.Ecodigo
						
						inner join Usuario usu
							on usu.Usucodigo = ed.Usucodigo
							
							inner join DatosPersonales dp
								on dp.datos_personales = usu.datos_personales
								
						inner join SNegocios sn
							on sn.SNcodigo = ed.SNcodigo
							and sn.Ecodigo = ed.Ecodigo
						
						inner join DOrdenCM o
							on o.Ecodigo=dd.Ecodigo
							and o.DOlinea=dd.DOlinea
							
							inner join EOrdenCM p
								on o.EOidorden = p.EOidorden
								and o.Ecodigo = p.Ecodigo
				
							<!---Impuestos de la orden de compra---->
							left outer join Impuestos imp
								on imp.Ecodigo=o.Ecodigo
								and imp.Icodigo=o.Icodigo
				
							left outer join Articulos a
								on a.Ecodigo=dd.Ecodigo
								and a.Aid=dd.Aid
				
								left outer join Clasificaciones clas
									on clas.Ccodigo = a.Ccodigo
									and clas.Ecodigo = a.Ecodigo
							
								<!--- Factor de conversion de factura a orden si no estaba definido en la tabla ConversionUnidades --->			
								left outer join ConversionUnidadesArt cua
									on cua.Aid = a.Aid
									and a.Ucodigo = dd.Ucodigo
									and cua.Ucodigo = o.Ucodigo
									and cua.Ecodigo = dd.Ecodigo
									
						<!--- Factor de conversion de factura a orden --->
						left outer join ConversionUnidades cu
							on cu.Ecodigo = dd.Ecodigo
							and cu.Ucodigo = dd.Ucodigo
							and cu.Ucodigoref = o.Ucodigo					
				
						 left outer join Conceptos c
							on c.Ecodigo=dd.Ecodigo
							and c.Cid=dd.Cid
				
						<!---Impuestos del documento de recepcion--->
						left outer join Impuestos i
							on i.Ecodigo=dd.Ecodigo
							and i.Icodigo=dd.Icodigo
							
				where dd.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and dd.EDRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.EDRid#">
					and p.CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CMCid#">
					and dd.DDRaprobtolerancia = 5
				order by a.Acodigo
			</cfquery>
			
			<table border="0" width="100%" cellpadding="4" cellspacing="0" style="border:2px solid ##999999;">
				
				<!--- Encabezado del correo --->
				<tr bgcolor="##003399">
					<td colspan="2" height="24"></td>
				</tr>
				<tr bgcolor="##999999">
					<td colspan="2"><strong>Informaci&oacute;n sobre notificaci&oacute;n en Sistema de Compras</strong></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td><span class="style2"><strong>De</strong></span></td>
					<td><span class="style7">Sistema de Compras</span></td>
				</tr>
				<tr>
					<td><span class="style7"><strong>Para</strong></span></td>
					<td><span class="style7"><cfoutput>#arguments.Pnombre#</cfoutput></span></td>
				</tr>
				<tr>
					<td><span class="style8"></span></td>
					<td><span class="style8"></span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td><span class="style7">Informaci&oacute;n sobre notificaci&oacute;n de Sistema de Compras.</span></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td>
						<table border="0" width="100%" cellpadding="2" cellspacing="0" style="border:1px solid ##999999;">
							<tr>
								<td nowrap><span class="style8"><strong>N&uacute;mero de Recepci&oacute;n:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#dataCorreoDetalle.EDRnumero#</cfoutput></span></td>
							</tr>
							<tr>
								<td nowrap><span class="style8"><strong>Fecha de Recepci&oacute;n:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#LSDateFormat(dataCorreoDetalle.EDRfecharec, "dd/mm/yyyy")#</cfoutput></span></td>
							</tr>
							<tr>
								<td nowrap><span class="style8"><strong>Proveedor:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#dataCorreoDetalle.SNnombre#</cfoutput></span></td>
							</tr>
							<tr>
								<td nowrap><span class="style8"><strong>Usuario que registra:&nbsp;</strong></span></td>
								<td align="left"><span class="style8"><cfoutput>#dataCorreoDetalle.Pnombre#</cfoutput></span></td>
							</tr>
							<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
							<tr>
								<td colspan="2" nowrap>
									<table width="100%" cellpadding="0" cellspacing="0">
										<tr>
											<td>
												<span class="style8">
												Sr(a)/Srta. <cfoutput>#arguments.Pnombre#</cfoutput> la siguiente lista de artículos <br>
												excedieron la tolerancia, por lo que requieren de su aprobación
												</span>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr><td colspan="2">&nbsp;<hr size="1" color="##999999"></td></tr>
							<tr>
								<td nowrap valign="top"><span class="style8"><strong>Detalle de las Líneas por Aprobar</strong></span></td>
							</tr>
							<tr>
								<td colspan="2">
									<table width="100%" cellpadding="2" cellspacing="0">
										<tr bgcolor="##F5F5F5">
											<td nowrap align="left"><span class="style9"><strong>O. C.&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Línea&nbsp;</strong></span></td>
											<td align="left"><span class="style9"><strong>Articulo&nbsp;</strong></span></td>
											<td align="left"><span class="style9"><strong>Descripci&oacute;n&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>%Tolerancia&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Saldo O.C.&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Cantidad Permitida&nbsp;</strong></span></td>
											<td nowrap align="left"><span class="style9"><strong>Unidad <br> O.C.&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Cantidad Factura&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Cantidad Recibida&nbsp;</strong></span></td>
											<td nowrap align="left"><span class="style9"><strong>Unidad <br> Factura&nbsp;</strong></span></td>
											<td align="right"><span class="style9"><strong>Exceso en unidades <br> de la O.C.&nbsp;</strong></span></td>
											<td nowrap align="left"><span class="style9"><strong>Genera <br> reclamo&nbsp;</strong></span></td>
										</tr>
										<cfloop query="dataCorreoDetalle">
										
											<cfset lineaReclamo = 0>
											<cfset idPoliza = 0>
								
											<cfif dataCorreoDetalle.EDRestado eq 10 and dataCorreoDetalle.DOcantsaldo gt 0>
																
												<cfset lineaReclamo = calcularReclamo(dataCorreoDetalle.DDRcantorigen, dataCorreoDetalle.DDRpreciou, dataCorreoDetalle.DDRdescporclin,
																									  dataCorreoDetalle.Iporcentaje, dataCorreoDetalle.DOcantsaldo, dataCorreoDetalle.DDRprecioorig,
																									  dataCorreoDetalle.DOporcdesc, dataCorreoDetalle.IporcentajeOC, dataCorreoDetalle.DDRcantrec,
																									  dataCorreoDetalle.Ctolerancia, dataCorreoDetalle.Mcodigo, dataCorreoDetalle.McodigoOC,
																									  dataCorreoDetalle.EDRtc, dataCorreoDetalle.EOtc, dataCorreoDetalle.factorConversionU, 
																									  dataCorreoDetalle.DDRtipoitem, dataCorreoDetalle.ArticuloTieneTolerancia,idPoliza,dataCorreoDetalle.DDRaprobtolerancia)>
											<cfelseif dataCorreoDetalle.EDRestado eq 10 and dataCorreoDetalle.DOcantsaldo lte 0>
												
												<cfset lineaReclamo = calcularReclamo(dataCorreoDetalle.DDRcantorigen, dataCorreoDetalle.DDRpreciou, dataCorreoDetalle.DDRdescporclin,
																									  dataCorreoDetalle.Iporcentaje, dataCorreoDetalle.DOcantidad, dataCorreoDetalle.DDRprecioorig,
																									  dataCorreoDetalle.DOporcdesc, dataCorreoDetalle.IporcentajeOC, dataCorreoDetalle.DDRcantrec,
																									  dataCorreoDetalle.Ctolerancia, dataCorreoDetalle.Mcodigo, dataCorreoDetalle.McodigoOC,
																									  dataCorreoDetalle.EDRtc, dataCorreoDetalle.EOtc, dataCorreoDetalle.factorConversionU, 
																									  dataCorreoDetalle.DDRtipoitem, dataCorreoDetalle.ArticuloTieneTolerancia,idPoliza,dataCorreoDetalle.DDRaprobtolerancia)>														 
											<cfelse>
												
												<cfset lineaReclamo = calcularReclamo(dataCorreoDetalle.DDRcantorigen, dataCorreoDetalle.DDRpreciou, dataCorreoDetalle.DDRdescporclin,
																									  dataCorreoDetalle.Iporcentaje, dataCorreoDetalle.DOcantsaldo, dataCorreoDetalle.DDRprecioorig,
																									  dataCorreoDetalle.DOporcdesc, dataCorreoDetalle.IporcentajeOC, dataCorreoDetalle.DDRcantrec,
																									  dataCorreoDetalle.Ctolerancia, dataCorreoDetalle.Mcodigo, dataCorreoDetalle.McodigoOC,
																									  dataCorreoDetalle.EDRtc, dataCorreoDetalle.EOtc, dataCorreoDetalle.factorConversionU, 
																									  dataCorreoDetalle.DDRtipoitem, dataCorreoDetalle.ArticuloTieneTolerancia,idPoliza,dataCorreoDetalle.DDRaprobtolerancia)>
											
											</cfif>
											<cfset LvarlineaReclamo = lineaReclamo[1]>
											<cfset LvarlineaUnidadesNoRecibidas = lineaReclamo[5]>
											<cfset LvarlineaUnidadesReclamo = lineaReclamo[4]>
											<cfoutput>
											<tr bgcolor="<cfif not dataCorreoDetalle.CurrentRow mod 2>##FAFAFA</cfif>">
												<td align="left"><span class="style9">#dataCorreoDetalle.EOnumero#&nbsp;</span></td>
												<td align="right"><span class="style9">#dataCorreoDetalle.DOconsecutivo#&nbsp;</span></td>
												<td align="left"><span class="style9">#dataCorreoDetalle.Acodigo#&nbsp;</span></td>
												<td align="left"><span class="style9">#dataCorreoDetalle.DOdescripcion#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(dataCorreoDetalle.Ctolerancia, ',9.00')#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(dataCorreoDetalle.DOcantsaldo, ',9.00')#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(dataCorreoDetalle.CantidadPermitida, ',9.00')#&nbsp;</span></td>
												<td align="left"><span class="style9">#dataCorreoDetalle.UcodigoOC#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(dataCorreoDetalle.DDRcantorigen, ',9.00')#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(dataCorreoDetalle.DDRcantrec, ',9.00')#&nbsp;</span></td>
												<td align="left"><span class="style9">#dataCorreoDetalle.UcodigoFac#&nbsp;</span></td>
												<td align="right"><span class="style9">#LSNumberFormat(LvarlineaUnidadesReclamo, ',9.00')#&nbsp;</span></td>
												<cfif dataCorreoDetalle.DDRgenreclamo eq 1>
													<td align="left"><span class="style9">Sí&nbsp;</span></td>
												<cfelse>
													<td align="left"><span class="style9">No&nbsp;</span></td>
												</cfif>
											</tr>
											</cfoutput>
										</cfloop> 
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td><span class="style8"></span></td>
					<td><span class="style8"></span></td>
				</tr>
				<cfset hostname = session.sitio.host>
				<cfset Usucodigo = arguments.Usucodigo>
				<cfset CEcodigo = arguments.CEcodigo>
				<cfoutput>
					<!---<tr>
						<td>&nbsp;</td>
						<td align="center"><span class="style1">Nota: En #hostname# respetamos su privacidad. <br>
						  Si usted considera que este correo le lleg&oacute; por equivocaci&oacute;n, o si no desea recibir m&aacute;s informaci&oacute;n de nosotros, haga click <a href="http://#hostname#/cfmx/home/public/optout.cfm?a=#Usucodigo#&amp;b=#CEcodigo#&amp;c=#hostname#&amp;#Hash(Usucodigo & 'please let me out of ' & hostname)#">aqu&iacute;</a>. </span>
						</td>
					</tr>--->
				</cfoutput>	
			</table>
			
			</body>
		</html>
 	</cfsavecontent>
	<cfreturn _mail_body> 
</cffunction>
