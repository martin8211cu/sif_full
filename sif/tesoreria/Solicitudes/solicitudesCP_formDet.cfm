<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset LvarDeConsulta = isdefined("form.chkCancelados") OR isdefined("LvarAprobacion")>

	<!---JARR (Rmonto)Se tomo el monto de retencion de la linea generada si la linea original tiene retencion  
		anteriormente se calculaba en TESafectaciones.cfc lin.375 se comento ya que modificaba el pagado
		--->
	<cfquery datasource="#session.dsn#" name="lista">
		select
			 TESDPid, 
			 TESDPmoduloOri as origen, TESDPdocumentoOri as numero, TESDPreferenciaOri as Referencia, 
			 TESDPdescripcion,
			 dp.SNcodigoOri, SNnombre,
			 TESDPfechaVencimiento as FechaVence, TESDPfechaSolicitada as FechaSolicitud,
			 Mnombre, dp.Miso4217Ori, p3.TESRPTCcodigo,
			 TESDPmontoVencimientoOri as MontoVence, TESDPmontoSolicitadoOri as MontoSolicitud
			 , Rcodigo, 
			 (select sum(rdp.TESDPmontoSolicitadoOri)  from TESdetallePago rdp
				where rdp.RlineaId=dp.TESDPid) as Rmonto,
			 RlineaId
			 , CPCid
		  from TESdetallePago dp
			inner join SNegocios sn
				 on sn.SNcodigo	= dp.SNcodigoOri
				and sn.Ecodigo	= dp.EcodigoOri
			inner join Monedas m
				 on m.Miso4217	= dp.Miso4217Ori
				and m.Ecodigo	= dp.EcodigoOri
			left join TESRPTconcepto p3
				 on p3.TESRPTCid = dp.TESRPTCid
		 where dp.EcodigoOri=#session.Ecodigo#
		   and dp.TESSPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPid#">
		order by TESDPdocumentoOri, TESDPreferenciaOri, TESDPid
	</cfquery>	

	<input type="hidden" name="btnBorrarDet">
	<cfset titulo = "">
	<cfset titulo = 'Detalle de Documentos de CxP de la Solicitud de Pago'>

	<cfif isdefined("GvarDetalleGrande") AND GvarDetalleGrande>
		<table 	align="center" border="0" 
				style="border:1px solid #666666"
				cellspacing="0" cellpadding="0" width="100%">
			<tr>
				<td height="18" align="center"
					 style="font-weight:bold; color:#FFFFFF"
					 bgcolor="#3D648B"
				>
					<cfoutput>#titulo#</cfoutput>
				</td>
			</tr>
			<tr>
				<td>
					<cfset sbPoneDetalle()>
				</td>
			</tr>
		</table>
	<cfelse>
		<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
			<cfset sbPoneDetalle()>
		<cf_web_portlet_end>
	</cfif>

<cffunction name="sbPoneDetalle" output="true" returntype="void">
	<script language="javascript" type="text/javascript">
		function fnVerificarDet()
		{
		<cfoutput query="lista">
			document.form1.TESDPmontoSolicitadoOri_#TESDPid#.value = qf(form1.TESDPmontoSolicitadoOri_#TESDPid#.value);
			if (parseFloat(document.form1.TESDPmontoSolicitadoOri_#TESDPid#.value) <= 0)
			{
				alert("El monto de la factura #numero# debe ser mayor que cero");
				return false;
			}
			else if (parseFloat(document.form1.TESDPmontoSolicitadoOri_#TESDPid#.value) > #montoVence#)
			{
				alert("El monto de la factura #numero# debe ser menor a #NumberFormat(montoVence,',0.00')#");
				return false;
			}
		</cfoutput>
			return true;
		}	
	</script>
	
	<table 	align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap>&nbsp;</td>
			<td class="tituloListas" align="left"><strong>Origen</strong></td>
			<td class="tituloListas" align="left"><strong>Num.Documento</strong></td>
			<td class="tituloListas" align="left"><strong>Referencia</strong></td>
			<td class="tituloListas" align="left"><strong>Pago<BR>Terceros</strong></td>
			<td class="tituloListas" align="center"><strong>Fecha<BR>Vencimiento</strong></td>
			<td class="tituloListas" align="right"><strong>Moneda</strong></td>
			<td class="tituloListas" align="right"><strong>Saldo Vence</strong></td>
			<td class="tituloListas" align="right"><strong>Monto Pago<BR>Solicitado</strong></td>
			<td class="tituloListas" align="right"><strong>Retención</strong></td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">

		<cfoutput query="lista">
			<cfif lista.RlineaId EQ "">
				<cfset LvarTotalSP = LvarTotalSP + MontoSolicitud>
				<cfif LvarLista NEQ "ListaPar">
					<cfset LvarLista = "ListaPar">
				<cfelse>
					<cfset LvarLista = "ListaNon">
				</cfif>
			<tr class="#LvarLista#">
				<td align="left" width="18" height="18" nowrap >
					<input type="hidden" name="TESDPid" value="#TESDPid#">
				<cfif NOT LvarDeConsulta AND lista.CPCid EQ "">
					<a href="javascript: document.form1.btnBorrarDet.value='#TESDPid#'; document.form1.submit();">
						<img border="0" src="../../imagenes/Borrar01_S.gif" alt="Eliminar línea de Factura">
					</a>
				</cfif>
				</td>
				<cfif lista.CPCid EQ "">
				<td align="center" nowrap>
					#origen#
				</td>
				<td align="left" nowrap>
					#numero#
				</td>
				<td align="left" nowrap>
					#referencia#
				</td>
				<cfelseif lista.CPCid NEQ "">
					<td></td>
					<td colspan="8">
						<strong>#TESDPdescripcion#</strong>
					</td>
				</tr>
				<tr>
					<td colspan="4"></td>
				<cfelseif MontoSolicitud LT 0>
					<td>
						<strong>Crédito:</strong>
					</td>
					<td colspan="5">
						#TESDPdescripcion#
					</td>
				</tr>
				<tr>
					<td colspan="4"></td>
				</cfif>
				<td align="left" nowrap>
					#TESRPTCcodigo#
				</td>
				<td align="center" nowrap>
					#LSDateFormat(fechaVence,"DD/MM/YYYY")#
				</td>
				<td align="right" nowrap>
					#Mnombre#
				</td>
				<td align="right" nowrap>
					#NumberFormat(MontoVence,",0.00")#
				</td>
				<td align="right" nowrap>
					<cfif LvarDeConsulta or MontoSolicitud LT 0 OR lista.CPCid NEQ "">
						<strong>#NumberFormat(MontoSolicitud,",0.00")#</strong>
					<cfelse>
					<input name="TESDPmontoSolicitadoOri_#TESDPid#" id="TESDPmontoSolicitadoOri_#TESDPid#" tabindex="1"
						value="#NumberFormat(MontoSolicitud,",0.00")#"
						style="text-align:right;"
						size="15" 
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2);" 
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
					>
					</cfif>
				</td>
				<td align="right" nowrap>
					#NumberFormat(Rmonto,",0.00")#
				</td>
			</tr>
		</cfif>
	</cfoutput>
		<tr><td>&nbsp;</td></tr>
	</table>
</cffunction>
