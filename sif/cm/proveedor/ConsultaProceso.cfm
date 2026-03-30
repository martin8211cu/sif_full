<cf_templateheader title="	Consulta de Proceso de Compra">
		<cf_web_portlet_start titulo="Consulta de Proceso de Compra">
			<cfinclude template="pNavegacion.cfm">
            <cfinclude template="../../Utiles/sifConcat.cfm">

			<cfquery name="rsProcesoCompra" datasource="sifpublica">
				select a.PCPid, a.CMPid, a.CMPdescripcion, a.CEcodigo, 
						 a.Ecodigo, a.EcodigoASP, a.UsucodigoC, a.CMPfechapublica, 
						 a.CMPfmaxofertas, a.cncache, a.Usucodigo, a.fechaalta, a.PCPestado,
						 a.CMFPid, a.CMIid, a.CMPnumero
				from ProcesoCompraProveedor a, InvitadosProcesoCompra b
				where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
				and a.PCPid = b.PCPid
				and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
				and a.CMPfmaxofertas >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			</cfquery>
			
			<cfquery name="rsEmpresaSolicitante" datasource="asp">
				select Enombre
				from Empresa
				where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoCompra.CEcodigo#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoCompra.EcodigoASP#">
			</cfquery>
			
			<cfquery name="rsUsuarioComprador" datasource="asp">
				select b.Pnombre #_Cat# ' ' #_Cat# b.Papellido1 #_Cat# ' ' #_Cat# b.Papellido2 as NombreCompleto
				from Usuario a, DatosPersonales b
				where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoCompra.UsucodigoC#">
				and a.datos_personales = b.datos_personales
			</cfquery>
			
			<cfquery name="rsDetalleProcesoCompra" datasource="sifpublica">
				select  a.LPCid, a.PCPid, a.CEcodigo, 
						a.Ecodigo, a.EcodigoASP, a.cncache, 
						a.DSlinea, a.ESidsolicitud, a.DScant, 
						a.Unidad, a.DSdescripcion, a.DSdescalterna, 
						a.DSobservacion
				from LineasProcesoCompras a, InvitadosProcesoCompra b
				where a.PCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.PCPid#">
				and a.PCPid = b.PCPid
				and b.UsuarioP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			</cfquery>
			
			<cfif isdefined("rsProcesoCompra.CMFPid") and Len(Trim(rsProcesoCompra.CMFPid))>
				<cfquery name="rsFormaPago" datasource="#rsProcesoCompra.cncache#">
					select rtrim(CMFPcodigo) #_Cat# ' - ' #_Cat# CMFPdescripcion as FormaPago
					from CMFormasPago
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
					and CMFPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoCompra.CMFPid#">
				</cfquery>
			</cfif>

			<cfif isdefined("rsProcesoCompra.CMIid") and Len(Trim(rsProcesoCompra.CMIid))>
				<cfquery name="rsIncoterm" datasource="#rsProcesoCompra.cncache#">
					select rtrim(CMIcodigo) #_Cat# ' - ' #_Cat# CMIdescripcion as Incoterm
					from CMIncoterm
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
					and CMIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsProcesoCompra.CMIid#">
				</cfquery>
			</cfif>

		<cfoutput>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				</tr>
				<tr>
				<td colspan="2">
					<table width="98%"  border="0" cellspacing="0" cellpadding="0" align="center">
						<tr>
						<td colspan="2" class="tituloListas"><strong>Datos del Proceso de Compra</strong></td>
						</tr>
						<tr>
						<td nowrap valign="top">
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
									<td align="right" nowrap class="fileLabel">Empresa:</td>
									<td nowrap>#rsEmpresaSolicitante.Enombre#</td>
									<td align="right" nowrap class="fileLabel">No. Proceso Compra: </td>
									<td nowrap> #rsProcesoCompra.CMPnumero# </td>
									<td align="right" nowrap class="fileLabel">Descripci&oacute;n:</td>
									<td nowrap> #rsProcesoCompra.CMPdescripcion# </td>
								</tr>
								<tr>
									<td align="right" nowrap class="fileLabel">Comprador:</td>
									<td nowrap>#rsUsuarioComprador.NombreCompleto#</td>
									<td align="right" nowrap class="fileLabel">Fecha de Publicaci&oacute;n:</td>
									<td nowrap> #LSDateFormat(rsProcesoCompra.CMPfechapublica, 'dd/mm/yyyy')# </td>
									<td align="right" nowrap class="fileLabel">Fecha M&aacute;xima Cotizaci&oacute;n:</td>
								    <td nowrap> #LSDateFormat(rsProcesoCompra.CMPfmaxofertas, 'dd/mm/yyyy')# #LSTimeFormat(rsProcesoCompra.CMPfmaxofertas, 'hh:mm tt')# </td>
								</tr>
								<tr>
									<td align="right" nowrap class="fileLabel">Forma Pago: </td>
									<td nowrap>
										<cfif isdefined("rsProcesoCompra.CMFPid") and Len(Trim(rsProcesoCompra.CMFPid))>
											#rsFormaPago.FormaPago#
										</cfif>
									</td>
									<td align="right" nowrap class="fileLabel">Incoterm:</td>
									<td colspan="2" nowrap>
										<cfif isdefined("rsProcesoCompra.CMIid") and Len(Trim(rsProcesoCompra.CMIid))>
											#rsIncoterm.Incoterm#
										</cfif>
									</td>
									<td align="right">
										<table cellpadding="0" cellspacing="0" align="right">
											<tr>
												<td><a href="javascript:notas()" style="cursor:hand;" title="Ver Notas asociadas al Proceso de Compra"><strong>Ver Notas</strong></a></td>
												<td><a href="javascript:notas()" style="cursor:hand;" title="Ver Notas asociadas al Proceso de Compra">&nbsp;<img border="0" src="../../imagenes/iedit.gif"></a></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>			
						</td>
						</tr>
					</table>
				</td>
				</tr>
				<tr>
				<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
				<td colspan="2">
					<table width="98%"  border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
						<td colspan="6"><strong>Lista de Itemes de Compra</strong></td>
						</tr>
						<tr>
						<td colspan="6" nowrap>
							<table width="100%"  border="0" cellspacing="0" cellpadding="2">
								<tr>
								<td style="padding-right: 5px; border-bottom: 1px solid black; " class="tituloListas" nowrap>Item</td>
								<td style="padding-right: 5px; border-bottom: 1px solid black; " align="right" nowrap class="tituloListas">Cantidad</td>
								<td style="border-bottom: 1px solid black; " class="tituloListas" nowrap>Unidad</td>
									<td width="65%" style="border-bottom: 1px solid black; " class="tituloListas" nowrap>Observaciones</td>
								</tr>
							<cfloop query="rsDetalleProcesoCompra">
								<cfquery name="rsUnidad" datasource="#rsProcesoCompra.cncache#">
									select rtrim(Ucodigo) #_Cat# ' - ' #_Cat# Udescripcion as Unidad
									from Unidades
									where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsProcesoCompra.Ecodigo#">
									and Ucodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsDetalleProcesoCompra.Unidad#">
								</cfquery>
								
								<tr class=<cfif (currentRow MOD 2)>"listaNon"<cfelse>"listaPar"</cfif>>
								<td style="padding-right: 5px; border-bottom: 1px solid black;" nowrap>#rsDetalleProcesoCompra.DSdescripcion#</td>
								<td style="padding-right: 5px; border-bottom: 1px solid black;" align="right" nowrap>#rsDetalleProcesoCompra.DScant#</td>
								<td style="border-bottom: 1px solid black; " nowrap>#rsUnidad.Unidad#</td>
									<td style="border-bottom: 1px solid black; ">#rsDetalleProcesoCompra.DSobservacion#&nbsp;</td>
								</tr>
							</cfloop>
							</table>
						</td>
						</tr>
					</table>
				</td>
				</tr>
				<tr align="center">
				<td colspan="2">&nbsp;</td>
				</tr>
				<tr align="center">
				<td colspan="2">
					<input type="button" name="btnRegresar" value="Regresar" onClick="javascript: history.back();">
				</td>
				</tr>
				<tr align="center">
				<td colspan="2">&nbsp;</td>
				</tr>
			</table>
		</cfoutput>
		<cf_web_portlet_end>
		<script type="text/javascript" language="javascript1.2">
			var popUpWin=0;

			function popUpWindow(URLStr, left, top, width, height){
				if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
				}
				popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
				window.onfocus = closePopUp;
			}

			function closePopUp(){
				if(popUpWin) {
					if(!popUpWin.closed) popUpWin.close();
					popUpWin=null;
				}
			}	

			function notas(){
				popUpWindow('proceso-notas.cfm?PCPid=<cfoutput>#PCPid#</cfoutput>', 250,200,600,420);
			}
		</script>
	<cf_templatefooter>
