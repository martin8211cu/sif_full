<cfinvoke key="LB_TitDetalle" default="Detalle de la Orden de Pago"	returnvariable="LB_TitDetalle"	method="Translate" 
component="sif.Componentes.Translate"  xmlfile="ordenesPago_form.xml"/> 


<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript">
	var LvarValueOri = "";
</script>
<cfset titulo = "">
<cfset titulo = "#LB_TitDetalle#">
	<cfif GvarDetalleGrande>
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
	<cfquery datasource="#session.dsn#" name="lista">
		select 
			sp.TESOPid,
			sp.TESSPid,
			dp.TESDPid,
			op.CBidPago,
			mp.Mnombre, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago,
			sp.TESSPnumero,
			sp.TESSPfechaPagar,
			e.Edescripcion,
			dp.TESDPmoduloOri,
			dp.TESDPdocumentoOri, 
			dp.TESDPreferenciaOri,
			dp.Miso4217Ori,
			dp.TESDPmontoAprobadoOri,
			case when coalesce(op.TESOPtipoCambioPago, 0) 	= 0 then 1 else op.TESOPtipoCambioPago 		end as TESOPtipoCambioPago,
			case when coalesce(dp.TESDPtipoCambioOri, 0) 	= 0 then 1 else dp.TESDPtipoCambioOri 		end as TESDPtipoCambioOri,
			case when coalesce(dp.TESDPfactorConversion, 0) = 0	then 1 else dp.TESDPfactorConversion	end as TESDPfactorConversion,
			coalesce(dp.TESDPmontoPago, 0) as TESDPmontoPago,
			case sp.TESSPtipoDocumento
				when 0 		then 'Manual'
				when 5 		then 'ManualCF' 
				when 1 		then 'CxP' 
				when 2 		then 'Antic.CxP' 
				when 3 		then 'Antic.CxC' 
				when 4 		then 'Antic.POS' 
				when 6 		then 'Antic.GE' 
				when 7 		then 'Liqui.GE' 
				when 8		then 'Fondo.CCh' 
				when 9 		then 'Reint.CCh' 
				when 10		then 'TEF Bcos' 
				when 100 	then 'Interfaz' 
				else 'Otro'
			end as TIPO,
			dp.TESDPmontoPagoLocal,
			cpc.CPCid, cpc.TESDPmontoSolicitadoOri as CPCoriginal, cpc.CPClocal
		from TESordenPago op
			left join TESdetallePago dp
				inner join Empresas e
				  on e.Ecodigo = dp.EcodigoOri
				inner join Monedas me
					 on me.Miso4217	= dp.Miso4217Ori
					and me.Ecodigo	= dp.EcodigoOri
				inner join Monedas m
					 on m.Miso4217	= dp.Miso4217Ori
					and m.Ecodigo	= dp.EcodigoOri
				inner join TESsolicitudPago sp
				  on sp.TESid 	= dp.TESid
				 and sp.TESSPid = dp.TESSPid
				inner join CFinanciera cf
					 on cf.Ecodigo  = dp.EcodigoOri
					and cf.CFcuenta = dp.CFcuentaDB
			  on dp.TESid 	= op.TESid
			 and dp.TESOPid = op.TESOPid
			left join TESdetallePagoCPC cpc
				inner join CPCesion c on c.CPCid = cpc.CPCid
				inner join Monedas mc on mc.Mcodigo = c.Mcodigo
			   on TESDPidNew		= dp.TESDPid
			  and mc.Miso4217		<> dp.Miso4217Ori
			  and me.Miso4217		in (dp.Miso4217Ori,mc.Miso4217)
			  and op.Miso4217Pago	in (dp.Miso4217Ori,mc.Miso4217)
			left join Empresas ep
				inner join Monedas mep
				   on mep.Mcodigo = ep.Mcodigo
				  and mep.Ecodigo = ep.Ecodigo
			  on ep.Ecodigo = op.EcodigoPago
			left join Monedas mp
			  on mp.Miso4217	= op.Miso4217Pago
			 and mp.Ecodigo		= op.EcodigoPago
		where op.TESid = #session.tesoreria.TESid#
		  and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.TESOPid#" null="#rsform.TESOPid EQ ""#">
		  and op.TESOPestado in (10,11)
	</cfquery>	
	
	<input type="hidden" name="btnBorrarDet" >
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
		<tr>
			<td class="tituloListas" align="left" width="18" height="17" nowrap>&nbsp;</td>
			<td class="tituloListas" align="left"><strong><cf_translate key=LB_NumSolicitud>Num.<BR>Solicitud</cf_translate></strong></td>
			<td class="tituloListas" align="center"><strong><cf_translate key=LB_FecSolicitud>Fecha Pago<BR>Solicitada</cf_translate></strong></td>
			<td class="tituloListas" align="left"><strong><cf_translate key=LB_Origen>Origen</cf_translate></strong></td>
			<td class="tituloListas" align="left"><strong><cf_translate key=LB_Documento>Documento</cf_translate></strong></td>
			<td class="tituloListas" align="left"><strong><cf_translate key=LB_Referencia>Referencia</cf_translate></strong></td>
			<td class="tituloListas" align="right"><strong><cf_translate key=LB_MontoDoc>Monto<BR>Documento</cf_translate></strong></td>
			<td class="tituloListas" align="center"><strong><cf_translate key=LB_TCDoc>Tipo&nbsp;Cambio<BR>Documento</cf_translate></strong></td>
			<td class="tituloListas" align="center"><strong><cf_translate key=LB_FactorConver>Factor<BR>Conversion</cf_translate></strong></td>
			<td class="tituloListas" align="right"><strong><cf_translate key=LB_FactorConver>Monto Pago</cf_translate><cfif lista.CBidPago NEQ ""><BR><cfoutput>#lista.Mnombre#<BR>(#lista.Miso4217Pago#)</cfoutput></cfif></strong></td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">
		<cfset LvarSolicitud = "">
	<cfif lista.TESSPid EQ "">
		<tr><td>&nbsp;</td></tr>
	<cfelse>
		<cfoutput query="lista">
			<cfset LvarTotalSP = LvarTotalSP + TESDPmontoPago>
			<cfif LvarLista NEQ "ListaPar">
				<cfset LvarLista = "ListaPar">
			<cfelse>
				<cfset LvarLista = "ListaNon">
			</cfif>
			<cfif LvarSolicitud NEQ lista.TESSPid>
				<cfset LvarSolicitud = lista.TESSPid>
				<tr class="#LvarLista#">
					<td align="left" width="18" height="18" nowrap >
						<cfparam name="rsForm.TESOPmsgRechazo" default="">
						<cfif not GvarTEFbcos and rsForm.TESOPmsgRechazo NEQ "">
						<a href="javascript: document.form1.btnBorrarDet.value='#TESSPid#'; document.form1.submit();">
							<img border="0" src="../../imagenes/Borrar01_S.gif" alt="Eliminar Solicitud de la Orden">
						</a>				
						</cfif>
					</td>
					<td align="left" nowrap>
						#TESSPnumero#
					</td>
					<td align="left" nowrap>
						#LSDateFormat(TESSPfechaPagar,"DD/MM/YYYY")#
					</td>
					<td align="center" nowrap>
						#TIPO#&nbsp;
					</td>
					<td align="left" nowrap colspan="7">
						<strong>Empresa que solicita: #Edescripcion#</strong>
					</td>
					<cfif LvarLista NEQ "ListaPar">
						<cfset LvarLista = "ListaPar">
					<cfelse>
						<cfset LvarLista = "ListaNon">
					</cfif>
				</tr>
			</cfif>
		
			<tr class="#LvarLista#">
				<td colspan="3">&nbsp;</td>
				<td align="center" nowrap>
					#TESDPmoduloOri#
				</td>
				<td align="left" nowrap>
					#TESDPdocumentoOri#
				</td>
				<td align="left" nowrap>
					#TESDPreferenciaOri#
				</td>
				<td align="right" nowrap>
					<input type="hidden" name="TESDPid" value="#TESDPid#">
					<input name="TESDPmontoAprobadoOri_#TESDPid#" id="TESDPmontoAprobadoOri_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Ori#
				</td>
	
				<td align="CENTER" nowrap>
<cfif CBidPago EQ "">
	<cfset LvarTC = 0>
	<cfset LvarFC = 0>
	<cfset LvarMP = 0>
<cfelseif CPCid NEQ "">
	<cfset LvarTC = TESDPtipoCambioOri>
	<cfset LvarFC = TESDPfactorConversion>
	<cfset LvarMP = TESDPmontoAprobadoOri>
<cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
	<cfset LvarTC = 1>
	<cfset LvarFC = 1/TESOPtipoCambioPago>
	<cfset LvarMP = TESDPmontoAprobadoOri/TESOPtipoCambioPago>
<cfelseif Miso4217Ori EQ Miso4217Pago>
	<cfset LvarTC = TESOPtipoCambioPago>
	<cfset LvarFC = 1>
	<cfset LvarMP = TESDPmontoAprobadoOri>
<cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
	<cfset LvarTC = TESOPtipoCambioPago>
	<cfset LvarFC = TESDPfactorConversion>
	<cfset LvarMP = TESDPmontoPago>
<cfelse>
	<cfset LvarTC = TESOPtipoCambioPago>
	<cfset LvarFC = TESDPfactorConversion>
	<cfset LvarMP = TESDPmontoPago>
</cfif>

			<cfif CBidPago EQ "">
					<input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
						value="0"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> 
			<cfelseif CPCid NEQ "">
					<input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
						value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217EmpresaPago#s/#Miso4217Ori#
			<cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
					<input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
						value="1.0000"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> n/a
			<cfelseif Miso4217Ori EQ Miso4217Pago>
					<input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
						value="#NumberFormat(TESOPtipoCambioPago,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217EmpresaPago#s/#Miso4217Ori#
			<cfelse>
					<input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
						value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
						size="8"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select(); LvarValueOri = this.value;" 
						onBlur="if (LvarValueOri != this.value) {sbCambioTC(this); GvarCambiado = true;} fm(this,4);" 
						onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					> #Miso4217EmpresaPago#s/#Miso4217Ori#
			</cfif>
				</td>
	
				<td align="CENTER" nowrap>
			<cfif CBidPago EQ "">
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
			<cfelseif CPCid NEQ "">
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Pago#s/#Miso4217Ori#
			<cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#NumberFormat(1/TESOPtipoCambioPago,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Pago#s/#Miso4217Ori#
			<cfelseif Miso4217Ori EQ Miso4217Pago>
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#1.0000#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px; display:none;"
						readonly="yes"
						tabindex="-1"
					> n/a
			<cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Pago#s/#Miso4217Ori#
			<cfelse>
					<input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select();" 
						onChange="javascript: sbCambioFC(this); fm(this,4); GvarCambiado = true;" 
						onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					> #Miso4217Pago#s/#Miso4217Ori#
			</cfif>
					
				</td>
			<cfif CBidPago EQ "">
				<td align="right" nowrap>
					<input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
						value="0.00"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Pago#
				</td>
			<cfelseif CPCid NEQ "">
				<td align="right" nowrap>
					<input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Pago#
				</td>
			<cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
				<td align="right" nowrap>
					<input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri/TESOPtipoCambioPago,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Pago#
				</td>
			<cfelseif Miso4217Ori EQ Miso4217Pago>
				<td align="right" nowrap>
					<input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Pago#
				</td>
			<cfelse>
				<td align="right" nowrap>
					<input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
						value="#NumberFormat(TESDPmontoPago,",0.00")#"
						size="17"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: sbCambioMonto(this); fm(this,2);" 
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						onChange="GvarCambiado = true;"
					>
					#Miso4217Pago#
				</td>
			</cfif>
			</tr>

<!---
<cfset CBidDst = "1">
<cfset Miso4217Dst = "USD">
			<cfset LvarNoDestino = CBidDst EQ "" OR Miso4217Dst EQ Miso4217EmpresaPago OR CPCid NEQ "" OR Miso4217Dst EQ Miso4217Pago>
			<tr class="#LvarLista#">
				<td colspan="7">&nbsp;</td>
				<td align="CENTER" nowrap>
			<cfif CBidDst EQ "">
					<input name="TESDPtipoCambioDst_#TESDPid#" id="TESDPtipoCambioDst_#TESDPid#"
						value="0"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> 
			<cfelseif Miso4217Dst EQ Miso4217EmpresaPago>
					<input name="TESDPtipoCambioDst_#TESDPid#" id="TESDPtipoCambioDst_#TESDPid#"
						value="1.0000"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> n/a
			<cfelseif CPCid NEQ "">
					<input name="TESDPtipoCambioDst_#TESDPid#" id="TESDPtipoCambioDst_#TESDPid#"
						value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217EmpresaPago#s/#Miso4217Dst#
			<cfelseif Miso4217Dst EQ Miso4217Pago>
					<input name="TESDPtipoCambioDst_#TESDPid#" id="TESDPtipoCambioDst_#TESDPid#"
						value="#NumberFormat(TESOPtipoCambioPago,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217EmpresaPago#s/#Miso4217Dst#
			<cfelse>
					<input name="TESDPtipoCambioDst_#TESDPid#" id="TESDPtipoCambioDst_#TESDPid#"
						value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
						size="8"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select(); LvarValueOri = this.value;" 
						onBlur="if (LvarValueOri != this.value) {sbCambioTC(this); GvarCambiado = true;} fm(this,4);" 
						onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					> #Miso4217EmpresaPago#s/#Miso4217Dst#
			</cfif>
				</td>
	
				<td align="CENTER" nowrap>
			<cfif CBidDst EQ "">
					<input name="TESDPfactorConversionDst_#TESDPid#" id="TESDPfactorConversionDst_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; display:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
			<cfelseif Miso4217Dst EQ Miso4217Pago>
					<input name="TESDPfactorConversionDst_#TESDPid#" id="TESDPfactorConversionDst_#TESDPid#"
						value="#1.0000#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px; display:none;"
						readonly="yes"
						tabindex="-1"
					> n/a
			<cfelseif Miso4217Dst EQ Miso4217EmpresaPago>
					<input name="TESDPfactorConversionDst_#TESDPid#" id="TESDPfactorConversionDst_#TESDPid#"
						value="#NumberFormat(1/TESDPtipoCambioOri,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Dst#s/#Miso4217Ori#
			<cfelseif Miso4217Pago EQ Miso4217EmpresaPago OR CPCid NEQ "">
					<input name="TESDPfactorConversionDst_#TESDPid#" id="TESDPfactorConversionDst_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Dst#s/#Miso4217Ori#

			<cfelse>
					<input name="TESDPfactorConversionDst_#TESDPid#" id="TESDPfactorConversionDst_#TESDPid#"
						value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
						size="8"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select();" 
						onChange="javascript: sbCambioFC(this); fm(this,4); GvarCambiado = true;" 
						onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
					> #Miso4217Dst#s/#Miso4217Ori#
			</cfif>
					
				</td>
			<cfif CBidDst EQ "">
				<td align="right" nowrap>
					<input name="TESDPmontoPagoDst_#TESDPid#" id="TESDPmontoPagoDst_#TESDPid#"
						value="0.00"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Dst#
				</td>
			<cfelseif Miso4217EmpresaPago EQ Miso4217Dst>
				<td align="right" nowrap>
					<input name="TESDPmontoPagoDst_#TESDPid#" id="TESDPmontoPagoDst_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri*TESDPtipoCambioOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Dst#
				</td>
			<cfelseif Miso4217Dst EQ Miso4217Pago OR Miso4217EmpresaPago EQ Miso4217Dst OR CPCid NEQ "">
				<td align="right" nowrap>
					<input name="TESDPmontoPagoDst_#TESDPid#" id="TESDPmontoPagoDst_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					>
					#Miso4217Dst#
				</td>
			<cfelse>
				<td align="right" nowrap>
					<input name="TESDPmontoPagoDst_#TESDPid#" id="TESDPmontoPagoDst_#TESDPid#"
						value="#NumberFormat(TESDPmontoPago,",0.00")#"
						size="17"
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: sbCambioMonto(this); fm(this,2);" 
						onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
						onChange="GvarCambiado = true;"
					>
					#Miso4217Dst#
				</td>
			</cfif>
			</tr>
--->
		</cfoutput>
	</cfif>
		<tr><td>&nbsp;</td></tr>
	</table>

<script language="javascript" type="text/javascript">
	function fnVerificarDet()
	{
<cfif CBidPago NEQ "">
	<cfoutput query="lista">
		document.form1.TESDPtipoCambioOri_#TESDPid#.value 	= qf(form1.TESDPtipoCambioOri_#TESDPid#.value);
		document.form1.TESDPmontoPago_#TESDPid#.value 		= qf(form1.TESDPmontoPago_#TESDPid#.value);
		document.form1.TESDPfactorConversion_#TESDPid#.value= qf(form1.TESDPfactorConversion_#TESDPid#.value);
		if (parseFloat(document.form1.TESDPtipoCambioOri_#TESDPid#.value) == 0)
		{
			alert("Faltan digitar tipos de cambio");
			document.form1.TESDPtipoCambioOri_#TESDPid#.focus();
			return false;
		}
		if (parseFloat(document.form1.TESDPmontoPago_#TESDPid#.value) == 0)
		{
			alert("Faltan digitar Montos a Pagar");
			document.form1.TESDPmontoPago_#TESDPid#.focus();
			return false;
		}
	</cfoutput>
</cfif>
		return true;
	}
<cfif CBidPago NEQ "">
	function sbCambioTCP(obj)
	{
		var LvarTCP = obj;
	<cfoutput query="lista">
		<cfif CPCid EQ "">
		{
			var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_#TESDPid#");
			var LvarTC = document.getElementById ("TESDPtipoCambioOri_#TESDPid#");
			var LvarFC = document.getElementById ("TESDPfactorConversion_#TESDPid#");
			var LvarMP = document.getElementById ("TESDPmontoPago_#TESDPid#");
		<cfif Miso4217Ori EQ Miso4217EmpresaPago>
			LvarTC.value = "1.0000";
		<cfelseif Miso4217Ori EQ Miso4217Pago>
			LvarTC.value = fm(redondear(qf(LvarTCP),4),4);
		</cfif>
			LvarFactor 	 = parseFloat(qf(LvarTC)) / parseFloat(qf(LvarTCP));
			LvarFC.value = fm(redondear(LvarFactor,4),4);
			LvarMP.value = fm(redondear(parseFloat(qf(LvarMO)) * LvarFactor,2),2);
		}
		</cfif>
	</cfoutput>
	}
	function sbCambioTC(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = obj;
		var LvarFC = document.getElementById ("TESDPfactorConversion_" + LvarTESDPid);
		var LvarMP = document.getElementById ("TESDPmontoPago_" + LvarTESDPid);

		LvarFactor 	 = parseFloat(qf(LvarTC)) / parseFloat(qf(LvarTCP));
		LvarFC.value = fm(redondear(LvarFactor,4),4);
		LvarMP.value = fm(redondear(parseFloat(qf(LvarMO)) * LvarFactor,2),2);
	}
	function sbCambioFC(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = document.getElementById ("TESDPtipoCambioOri_" + LvarTESDPid);
		var LvarFC = obj;
		var LvarMP = document.getElementById ("TESDPmontoPago_" + LvarTESDPid);

		LvarMP.value = fm(redondear(parseFloat(qf(LvarMO)) * parseFloat(qf(LvarFC)),2),2);
		LvarTC.value = fm(redondear(parseFloat(qf(LvarFC)) * parseFloat(qf(LvarTCP)),4),4);
	}
	function sbCambioMonto(obj)
	{
		var LvarTESDPid = obj.name.split("_")[1];
		var LvarTCP = document.getElementById ("TESOPtipoCambioPago");
		var LvarMO = document.getElementById ("TESDPmontoAprobadoOri_" + LvarTESDPid);
		var LvarTC = document.getElementById ("TESDPtipoCambioOri_" + LvarTESDPid);
		var LvarFC = document.getElementById ("TESDPfactorConversion_" + LvarTESDPid);
		var LvarMP = obj;

		LvarFactor 	 = parseFloat(qf(LvarMP)) / parseFloat(qf(LvarMO));
		LvarFC.value = fm(redondear(LvarFactor,4),4);
		LvarTC.value = fm(redondear(LvarFactor * parseFloat(qf(LvarTCP)),4),4);
	}
</cfif>
</script>
</cffunction>
