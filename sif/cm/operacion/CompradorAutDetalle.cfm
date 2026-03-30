<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cf_templateheader title="Solicitudes de Compra ">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Solicitudes de Compra'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
            <cfinclude template="../../Utiles/sifConcat.cfm">
			<!---Datos de la solicitud---->
			<cfquery name="rsSolicitud" datasource="#session.dsn#">
				select 	a.DSdescripcion,
						coalesce(a.DScant,0) as DScant,
						a.DStotallinest, 
						a.DSlinea, 
						a.DSobservacion, 
						a.DSconsecutivo,
						a.DSdescalterna,
						#LvarOBJ_PrecioU.enSQL_AS("a.DSmontoest")#,
						b.ESidsolicitud,b.ESnumero, b.ESfecha,  b.ESobservacion, 
						b.EStipocambio,b.EStotalest,b.ESidsolicitud, b.ESjustificacion, 
						b.CFid, b.CMElinea, b.CMTScodigo, 
						coalesce(a.DScant,0) * coalesce(a.DSmontoest,0) as Subtotal,
						coalesce(a.DStotallinest,0) + ((coalesce(a.DScant,0)*coalesce(a.DSmontoest,0)*coalesce(j.Iporcentaje,0))/100) as TotalLinea,
						(coalesce(a.DScant,0) * coalesce(a.DSmontoest,0) * coalesce(j.Iporcentaje,0))/100 as Impuesto,						 
						ltrim(rtrim(c.SNnumero))#_Cat#' - '#_Cat#ltrim(rtrim(c.SNnombre)) as SocioNegocio, a.Ucodigo,
						a.DSobservacion, a.DSdescalterna,
						d.CMTScodigo #_Cat#' '#_Cat# d.CMTSdescripcion as CMTSdescripcion,
						e.CFdescripcion,
						e.CFcodigo,
						rtrim(i.Almcodigo) as Almcodigo,
						f.CMCnombre, f.CMCcodigo,
						g.Mnombre,
						h.Ucodigo,
						i.Bdescripcion,
						cf.CFcodigo#_Cat#' - '#_Cat#cf.CFdescripcion as CFuncionalLinea,
						j.Icodigo,j.Iporcentaje,			
						case DStipo 	when 'A' then 'Artículo'
										when 'S' then 'Servicio'
										when 'F' then '' end as TipoBien
						
						,case DStipo 	when 'A' then ltrim(rtrim(Acodigo))
										when 'S' then ltrim(rtrim(n.Ccodigo))
										when 'F' then '' end as CodigoBien,
						case DStipo 	when 'A' then Adescripcion
										when 'S' then Cdescripcion
										when 'F' then k.ACdescripcion end as Item
													 
			
				from  	ESolicitudCompraCM  b
						left outer  join DSolicitudCompraCM  a
						
							left outer join CFuncional cf
								on a.CFid = cf.CFid
								and a.Ecodigo = cf.Ecodigo	
										
							-- Articulos
							left outer join Articulos m
								on a.Aid=m.Aid
								and a.Ecodigo=m.Ecodigo
				  
							-- Conceptos
							left outer join Conceptos n
								on a.Cid=n.Cid
								and a.Ecodigo=n.Ecodigo
			 
							-- Activos
							left outer join ACategoria o
								on a.ACcodigo=o.ACcodigo
								and a.Ecodigo=o.Ecodigo
			 
							left outer join AClasificacion k
								on a.ACcodigo=k.ACcodigo
								and a.ACid=k.ACid
								and a.Ecodigo=k.Ecodigo							
			
							inner join Unidades h
								on a.Ucodigo  = h.Ucodigo
								and a.Ecodigo = h.Ecodigo
			
							left outer join Almacen i
								on a.Alm_Aid = i.Aid
								and a.Ecodigo = i.Ecodigo
			
							inner join Impuestos j
								on j.Icodigo = a.Icodigo
								and j.Ecodigo = a.Ecodigo
								
						on b.ESidsolicitud  = a.ESidsolicitud
						and b.Ecodigo = a.Ecodigo
						
						<!---Para traer las solo las lineas que estan en contratos multiples---->
						inner join DSProvLineasContrato cont
							on a.DSlinea = cont.DSlinea
							and a.Ecodigo = cont.Ecodigo
			
						left outer join SNegocios c
							on b.SNcodigo= c.SNcodigo
							and b.Ecodigo = c.Ecodigo
			
						inner join CMTiposSolicitud d
							on b.CMTScodigo = d.CMTScodigo
							and b.Ecodigo = d.Ecodigo
			
						inner join CFuncional e
							on b.CFid = e.CFid
							and b.Ecodigo = e.Ecodigo
			
						left outer  join CMCompradores f
							on b.CMCid = f.CMCid
							and b.Ecodigo = f.Ecodigo
			
						inner join Monedas g
							on b.Mcodigo = g.Mcodigo
							and b.Ecodigo = g.Ecodigo
				where b.ESidsolicitud = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
					and  b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by a.DSconsecutivo	
			</cfquery>			
			<!----Total, Impuesto, total estimado---->
			<cfquery name="rsTotales" datasource="#session.DSN#">
				select coalesce(sum((Iporcentaje*DSmontoest*DScant)/100),0) as impuesto, coalesce(sum(DScant*DSmontoest),0) as subtotal
				from ESolicitudCompraCM a
				
				inner join DSolicitudCompraCM b
					on a.Ecodigo=b.Ecodigo
					 and a.ESidsolicitud=b.ESidsolicitud
					<!---Para traer las solo las lineas que estan en contratos multiples---->
					inner join DSProvLineasContrato cont
						on b.DSlinea = cont.DSlinea
						and b.Ecodigo = cont.Ecodigo
				
				inner join Impuestos c
				on a.Ecodigo=c.Ecodigo
					 and b.Icodigo=c.Icodigo
				
				where a.ESidsolicitud=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ESidsolicitud#">
					and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>
			
			<cfoutput>
				<form name="form1" action="CompradorAutDetalle-aplicar.cfm" method="post">
					<input type="hidden" name="ESidsolicitud" value="#form.ESidsolicitud#">
					<table width="98%" cellpadding="1" cellspacing="0" align="center" border="0">
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr>
						  <td colspan="6" class="tituloListas" align="center"><strong>Encabezado de la Solicitud de Compra</strong></td>
						</tr>
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr>
							<td align="right" nowrap><strong>No.Solicitud:</strong></td>
							<td>#rsSolicitud.ESnumero#</td>
							<td align="right" nowrap><strong>Fecha:</strong></td>
							<td>#LSDateFormat(rsSolicitud.ESfecha,'dd/mm/yyyy')#</td>
							<td align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
							<td>#rsSolicitud.ESobservacion#</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Ctro Funcional:</strong></td>
							<td>#rsSolicitud.CFcodigo#&nbsp;-&nbsp;#rsSolicitud.CFdescripcion#</td>
							<td align="right" nowrap><strong>Tipo:</strong></td>
							<td>#rsSolicitud.CMTSdescripcion#</td>
							<td align="right" nowrap><strong>Especializaci&oacute;n:</strong></td>
							<td>
								<cfquery name="rsEspecialidad" datasource="#session.DSN#">
									select CMEtipo #_Cat#'-'#_Cat#case 	when CMEtipo = 'A' then Cdescripcion 
																when CMEtipo = 'S' then CCdescripcion 
																when CMEtipo = 'F' then d.ACdescripcion end as descripcion
									from CMEspecializacionTSCF a
									left outer join Clasificaciones b
									on a.Ccodigo=b.Ccodigo
									   and a.Ecodigo=b.Ecodigo
									   and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									left outer join CConceptos c
									on a.CCid=c.CCid
									   and a.Ecodigo=c.Ecodigo
									   and c.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									left outer join AClasificacion d
									on a.ACid=d.ACid
									   and a.Ecodigo=d.Ecodigo
									   and d.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									left outer join ACategoria e
									on a.ACcodigo=e.ACcodigo
									   and a.Ecodigo=e.Ecodigo
									   and e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									  and a.CFid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.CFid#">
									  and a.CMTScodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSolicitud.CMTScodigo#">
									  and a.CMElinea=<cfif len(trim(rsSolicitud.CMElinea))><cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSolicitud.CMElinea#"><cfelse>0</cfif>
									order by CMEtipo
								</cfquery>
								<cfif rsEspecialidad.RecordCount gt 0>
									#rsEspecialidad.descripcion#
								<cfelse>	
									Ninguna
								</cfif>
							</td>
						</tr>
						<tr>
							<td align="right" nowrap><strong>Proveedor:</strong></td>
							<tD>#rsSolicitud.SocioNegocio#</tD>
							<td align="right" nowrap><strong>Moneda:</strong></td>
							<td>#rsSolicitud.Mnombre#</td>
							<td align="right" nowrap><strong>Tipo cambio:</strong></td>
							<td>#rsSolicitud.EStipocambio#</td>
						</tr>
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr><td colspan="6" align="center"><strong>Detalle de la Solicitud de Compra</strong></td></tr>
						<tr><td colspan="6" align="right"><input type="submit" name="btnAplicar" value="Aplicar"></td></tr>					
						<td colspan="6">
							<table width="100%" cellpadding="1" cellspacing="0">
								<tr>
									<td class="tituloListas"><strong>Línea</strong></td>
									<td class="tituloListas"><strong>Tipo</strong></td>
									<td class="tituloListas"><strong>Codigo</strong></td>
									<td class="tituloListas"><strong>Descripcion</strong></td>
									<td class="tituloListas" align="center"><strong>Desc.Detallada</strong></td>
									<td class="tituloListas"><strong>Ctro.Funcional</strong></td>
									<td class="tituloListas"><strong>Cantidad</strong></td>
									<td class="tituloListas"><strong>Unidad</strong></td>
									<td class="tituloListas"><strong>Monto</strong></td>
									<td class="tituloListas"><strong>SubTotal</strong></td>
									<td class="tituloListas"><strong>Impuesto</strong></td>
									<td class="tituloListas"><strong>Total</strong></td>
								</tr>
								<cfloop query="rsSolicitud">
									<tr>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.DSconsecutivo#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.TipoBien#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.CodigoBien#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.Item#</td>
										<td align="center">
											<input type="hidden" name="DSobservacion#rsSolicitud.CurrentRow#" value="#rsSolicitud.DSobservacion#">
											<input type="hidden" name="DSdescalterna#rsSolicitud.CurrentRow#" value="#rsSolicitud.DSdescalterna#"> 
											<a href="javascript: info(#rsSolicitud.currentRow#);"><img border="0" src="../../imagenes/iedit.gif" alt="informac&oacute;n adicional (Descripci&oacute;n alterna, Observaciones)"></a>						
										</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.CFuncionalLinea#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.DScant#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#rsSolicitud.Ucodigo#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#LvarOBJ_PrecioU.enCF_RPT(rsSolicitud.DSmontoest)#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#LSNumberFormat(rsSolicitud.Subtotal,',9.00')#</td>
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#LSNumberFormat(rsSolicitud.Impuesto,',9.00')#</td>	
										<td onClick="javascript: funcDetalleProv(#rsSolicitud.DSlinea#,#rsSolicitud.ESidsolicitud#)" style="cursor: hand;">#LSNumberFormat(rsSolicitud.TotalLinea,',9.00')#</td>
									</tr>							
								</cfloop>
							</table>
						</td>
						</tr>
						<tr><td colspan="6"><hr width="100%" align="center"></td></tr>
						<tr>
							<td colspan="6">
								<table width="100%" cellpadding="0" cellspacing="0">
									<tr>
										<td align="right" colspan="4"><strong>Subtotal:</strong></td>
										<td width="8%" align="right"><input class="cajasinbordeb" type="text" style="text-align:right" readonly id="subtotal" name="subtotal" value="#LSCurrencyFormat(rsTotales.subtotal,'none')#"></td>
									</tr>
									<tr>
										<td align="right" colspan="4"><strong>Impuesto:</strong></td>
										<td width="8%" align="right"><input class="cajasinbordeb" type="text" style="text-align:right" readonly id="impuesto" name="impuesto" value="#LSCurrencyFormat(rsTotales.impuesto,'none')#"></td>
									</tr>
									<tr>
										<td align="right" colspan="4"><strong>Total Estimado:</strong></td>
										<td width="8%" align="right"><input class="cajasinbordeb" type="text" style="text-align:right" readonly id="totalEstimado" name="totalEstimado" value="#LSCurrencyFormat(rsTotales.subtotal+rsTotales.impuesto,'none')#"></td>
									</tr>
								</table>
							</td>
						</tr>
						<tr><td colspan="6">&nbsp;</td></tr>
						<tr><td colspan="6" align="center"><input type="button" name="btnRegresar" value="Regresar" onClick="javascript: funcRegresar()"></td></tr>					
						<tr><td colspan="6">&nbsp;</td></tr>
					</table>
				</form>
			</cfoutput>
			<script type="text/javascript" language="javascript1.2" >
				var popUpWin=0; 
				function popUpWindow(URLStr, left, top, width, height) {
					if(popUpWin) {
						if(!popUpWin.closed) {
							popUpWin.close();
						}
					}
					popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				}
				function info(index){
					//document.lista.nosubmit = true;
					open('../consultas/Solicitudes-info.cfm?index='+index, 'Solicitudes','toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=500,height=490,left=250, top=150,screenX=250,screenY=200');											
					//open('Solicitudes-info.cfm?observaciones=DOobservaciones&descalterna=DOalterna&titulo=Ordenes de Compra&index='+index, 'ordenes', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
				}
				function funcDetalleProv(paramLinea,paramSolic){	
					var parametros = '?DSlinea='+paramLinea+'&ESidsolicitud='+paramSolic;		
					popUpWindow('../operacion/CompradorAutProveedores.cfm'+parametros,95,90,900,500);
				}
				function funcRegresar(){
					location.href = '../operacion/CompradorAutSolicitudes-lista.cfm';
				}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>