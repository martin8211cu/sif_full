<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset titulo = 'Documentos de CxP Seleccionados para la Generación de Solicitudes de Pago'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" border="0" cellspacing="6">
	  <tr>
		<td width="50%" valign="top">
			<cfquery datasource="#session.dsn#" name="lista">
				select
					 (
					 	select 	case coalesce(TESOPFPtipo,0)
									when 1  then ' (Pagar con TEF)'
									when 2  then ' (Pagar con TEF a ' <cf_dbfunction name="OP_concat"> (select TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
									when 3  then ' (Pagar con Tarjeta de Crédito Empresarial)'
								end
					 	  from TESOPformaPago f
					 	 where TESOPFPtipoId = 4 <!--- -- CxP--->
						   and dp.TESDPtipoDocumento = 1
						   and TESOPFPid	 = dp.TESDPidDocumento
					 ) as PagarCon,
					 TESDPid,
					 TESDPdocumentoOri as numero, TESDPreferenciaOri as Referencia,
					 dp.SNcodigoOri, SNnombre,
					 TESDPfechaVencimiento as FechaVence, TESDPfechaSolicitada as FechaSolicitud,
					 Mnombre, dp.Miso4217Ori,
					 TESDPmontoVencimientoOri as MontoVence, TESDPmontoSolicitadoOri as MontoSolicitud,
					 isnull(o.Odescripcion,'') as Odescripcion
				from TESdetallePago dp
					left outer join Oficinas o
						on o.Ocodigo= dp.OcodigoOri
						and o.Ecodigo=dp.EcodigoOri
					inner join SNegocios sn
						 on sn.SNcodigo	= dp.SNcodigoOri
						and sn.Ecodigo	= dp.EcodigoOri
					inner join Monedas m
						 on m.Miso4217	= dp.Miso4217Ori
						and m.Ecodigo	= dp.EcodigoOri

				where dp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and dp.TESSPid is null
					 and (dp.BMUsucodigo = #session.Usucodigo# or dp.BMUsucodigo is null)
				Order by 1,dp.TESDPfechaSolicitada, dp.SNcodigoOri, dp.Miso4217Ori
			</cfquery>

		<form name="frmDetallePago" method="post" action="solicitudesCP_sql.cfm">
			<input type="hidden" name="btnBorrarSel">
			<input type="hidden" name="btnBorrarTodos">
				<table>
					<tr>
						<td>
							<strong>Centro Funcional:</strong>&nbsp;
						</td>
						<td>
							<cf_cboCFid>
						</td>
						<td>&nbsp;

						</td>
					</tr>
					<tr>
						<td>
							<strong>Cambiar Fecha de Pago a:</strong>&nbsp;
						</td>
						<td>
							<cf_sifcalendario form="frmDetallePago" value="" name="FechaPago" tabindex="1">
						</td>
					</tr>
					<cfif isdefined("lista") AND #lista.recordcount# GT 0>
						<tr>
							<td colspan="2">
								<a href="javascript:  borraLineaAll();">
									<img border="0" src="../../imagenes/Borrar01_S.gif" title="Quitar Todos" alt="Excluir el Documento de la Generación de Solicitudes de Pago">
								</a>
								<label for="chkTodosQuitar"><cf_translate key = LB_SeleccionaTodos>Quitar Todos</cf_translate></label>
						  	</td>
						</tr>
					</cfif>
				</table>
			<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
				<tr>
					<td class="tituloListas" align="left" width="18" height="17" nowrap>&nbsp;</td>
					<td class="tituloListas" align="left"><strong>Num.Documento</strong></td>
					<td class="tituloListas" align="left"><strong>Referencia</strong></td>
					<td class="tituloListas" align="left"><strong>Socio Negocio</strong></td>
					<td class="tituloListas" align="left"><strong>Oficina</strong></td>
					<td class="tituloListas" align="center"><strong>Fecha<BR>Vencimiento</strong></td>
					<td class="tituloListas" align="center"><strong>Fecha Pago<BR>Solicitada</strong></td>
					<td class="tituloListas" align="right"><strong>Moneda</strong></td>
					<td class="tituloListas" align="right"><strong>Saldo Vence</strong></td>
					<td class="tituloListas" align="right"><strong>Monto Pago<BR>Solicitado</strong></td>
				</tr>
			<cfset LvarCorte = "">
			<cfset LvarCantSP = 0>
				<tr><td colspan="10" style="background-color:#999999; font-size:4px">&nbsp;</td></tr>
			<cfset LvarTotal = 0>
			<cfoutput query="lista">
				<cfif LvarCorte NEQ LSDateFormat(fechaSolicitud,"YYMMDD") & '|' & SNcodigoOri & '|' & Miso4217Ori & '|' & PagarCon>
					<cfset LvarCorte = LSDateFormat(fechaSolicitud,"YYMMDD") & '|' & SNcodigoOri & '|' & Miso4217Ori & '|' & PagarCon>
					<cfset sbTotalSP()>
					<cfset LvarFechaSP = LSDateFormat(fechaSolicitud,"DD/MM/YYYY")>
					<cfset LvarMonedaSP = Mnombre>
					<cfset LvarPagarConSP = PagarCon>
					<cfset LvarTotalSP = 0>
					<cfset LvarLista = "ListaPar">
				</cfif>
				<cfset LvarTotalSP = LvarTotalSP + MontoSolicitud>
				<cfset LvarTotal = LvarTotal + MontoSolicitud>
				<cfif LvarLista NEQ "ListaPar">
					<cfset LvarLista = "ListaPar">
				<cfelse>
					<cfset LvarLista = "ListaNon">
				</cfif>
				<tr class="#LvarLista#">
					<td align="left" width="18" height="18" nowrap>
						<input type="hidden" name="TESDPid" value="#TESDPid#">
						<a href="javascript:  borraLinea('#TESDPid#');">
							<img border="0" src="../../imagenes/Borrar01_S.gif" title="Quitar" alt="Excluir el Documento de la Generación de Solicitudes de Pago">
						</a>
					</td>
					<td align="left" nowrap>
						#numero#
					</td>
					<td align="left" nowrap>
						#referencia#
					</td>
					<td align="left" nowrap>
						#SNnombre#
					</td>
					<td align="left" nowrap>
						#Odescripcion#
					</td>
					<td align="center" nowrap>
						#LSDateFormat(fechaVence,"DD/MM/YYYY")#
					</td>
					<td align="center" nowrap>
						<cf_sifcalendario form="frmDetallePago" value="#LSDateFormat(fechaSolicitud,"DD/MM/YYYY")#" name="TESDPfechaSolicitada_#TESDPid#" tabindex="1">
					</td>
					<td align="right" nowrap>
						#Mnombre#
					</td>
					<td align="right" nowrap>
						#NumberFormat(MontoVence,",0.00")#
					</td>
					<td align="right" nowrap>
						<input name="TESDPmontoSolicitadoOri_#TESDPid#" id="TESDPmontoSolicitadoOri_#TESDPid#" tabindex="1"
							value="#NumberFormat(MontoSolicitud,",0.00")#"
							style="text-align:right;"
							onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						>
					</td>
				</tr>
			</cfoutput>
			<cfset sbTotalSP()>
			<tr>
				<td>
				&nbsp;
				</td>
			</tr>
			<cfset sbTotal()>
				<tr><td>&nbsp;</td></tr>
			</table>
			  <input name="PASO" type="hidden" value="0">
			  <cfif isdefined("lista") AND #lista.recordcount# GT 0>
				<input name="btnCambiarSel" 	type="submit" value="Cambiar Documentos Seleccionados" tabindex="1"
			  		onClick="return fnVerificar();">
			  </cfif>

			  <input name="btnSel" 			type="button" value="Seleccionar más Documentos de CxP" tabindex="1"
			  		onClick="location.href='solicitudesCP.cfm?PASO=1';">
			  <cfif isdefined("lista") AND #lista.recordcount# GT 0>
			  <input name="btnGenerarSel" 	type="submit" value="Generar Solicitudes Pago" tabindex="1"
			  		></cfif>
			  <input name="Lista_Solicitudes" type="button" id="btnSelFac" value="Lista Solicitudes" tabindex="1"
			  		onClick="location.href='solicitudesCP.cfm?PASO=0';">
		  </form>
		</td>
	  </tr>
	  <tr>
		<td>&nbsp;</td>
	  </tr>
	</table>
	<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
	function fnVerificar()
	{
	<cfoutput query="lista">
		document.frmDetallePago.TESDPmontoSolicitadoOri_#TESDPid#.value = qf(frmDetallePago.TESDPmontoSolicitadoOri_#TESDPid#.value);
		if (parseFloat(document.frmDetallePago.TESDPmontoSolicitadoOri_#TESDPid#.value) > #montoVence#)
		{
			alert("El monto del Documento #numero# debe ser menor a #NumberFormat(montoVence,',0.00')#");
			document.frmDetallePago.TESDPmontoSolicitadoOri_#TESDPid#.focus();
			return false;
		}
	</cfoutput>
		return true;
	}
	function borraLinea(valor){
		if ( confirm('¿Desea excluir el Documento de la Generación de Solicitudes de Pago?') ){
			document.frmDetallePago.btnBorrarSel.value= valor;
			document.frmDetallePago.submit();
		}
	}
	function borraLineaAll(){
		document.frmDetallePago.btnBorrarTodos.value= "";
		if ( confirm('¿Desea excluir todos los documentos de la Generación de Solicitudes de Pago?') ){
			document.frmDetallePago.btnBorrarTodos.value= "OK";
			document.frmDetallePago.submit();
		}
	}
</script>
<cffunction name="sbTotalSP" output="true">
	<cfif isdefined("LvarTotalSP")>
		<tr>
			<td colspan="5" style="background-color:##D4D4D4; color:##666666; font-weight:bold;">
				&nbsp;TOTAL SOLICITUD DE PAGO<font color="##FF0000">#LvarPagarConSP#</font>
			</td>
			<td style="background-color:##D4D4D4; color: ##666666; font-weight:bold;" align="center">
				#LvarFechaSP#
			</td>
			<td style="background-color:##D4D4D4; color:##666666; font-weight:bold;" align="right">
				#LvarMonedaSP#
			</td>
			<td style="background-color:##D4D4D4; color:##666666; font-weight:bold;">
			</td>
			<td style="background-color:##D4D4D4; color:##666666; font-weight:bold;" align="right">
				#NumberFormat(LvarTotalSP,",0.00")#
			</td>
		</tr>
	</cfif>
</cffunction>

<cffunction name="sbTotal" output="true">
	<cfif isdefined("LvarTotal")>
		<tr>
			<cfset estiloTotal = "background-color:##D4D4D4; color:##666666; font-weight:bold;font-size:12px;">
			<td colspan="9" style="#estiloTotal#" align= "right">
				&nbsp;Total de solicitud(es): <font color="##FF0000"><cfif isdefined("LvarPagarConSP")>#LvarPagarConSP#<cfelse>&nbsp;</cfif></font>
			</td>
			<td style="#estiloTotal#" align="right">
				#NumberFormat(LvarTotal,",0.00")#
			</td>
		</tr>
	</cfif>
</cffunction>
