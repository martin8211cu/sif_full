<cfinvoke key="LB_Titulo" default="Solicitudes Seleccionadas para la Generación de Órdenes de Pago"	returnvariable="MSG_CuentaBancaria"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="LB_SolPagarEl" default="Solicitudes a Pagar el"	returnvariable="LB_SolPagarEl"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="LB_ExcSolGeneracion" default="Excluir la Solicitud de la Generación de Órdenes de Pago"	returnvariable="LB_ExcSolGeneracion"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="LB_Desea" default="Desea"	returnvariable="LB_Desea"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="LB_FecSolicitud" default="La Fecha de Pago de la Solicitud"	returnvariable="LB_FecSolicitud"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="LB_EsRequerida" default="es requerida"	returnvariable="LB_EsRequerida"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="BTN_CambiarSolicitudes" default="Cambiar Solicitudes Seleccionadas"	returnvariable="BTN_CambiarSolicitudes"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="BTN_SeleccionarSolicitudes" default="Seleccionar más Solicitudes"	returnvariable="BTN_SeleccionarSolicitudes"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="BTN_GenerarOP" default="Generar Ordenes de Pago"	returnvariable="BTN_GenerarOP"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="BTN_ListaOP" default="Lista Ordenes de Pago"	returnvariable="BTN_ListaOP"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>
<cfinvoke key="BTN_SolicitaPagarCon" default="Se solicita pagar con"	returnvariable="BTN_SolicitaPagarCon"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista2Gen.xml"/>

<script src="/cfmx/sif/js/utilesMonto.js"></script>
<cfset titulo = "">
<cfset titulo = '#LB_Titulo#'>

<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" border="1" cellspacing="6">
	  <tr>
		<td width="50%" valign="top">
			<cfquery datasource="#session.dsn#" name="rsCuentasBan">
				Select CBid,CBdescripcion
				from CuentasBancos
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

            <cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery datasource="#session.dsn#" name="lista">
				Select
					TESOPfechaPago,
					case when coalesce(sp.CPCid,0) = 0 then 0 else cpc.SNidDestino end as CPCid,
					SNcodigoOri,
					case
						when sp.SNcodigoOri	is not null AND sn.Ecodigo = #session.EcodigoCorp# then 'Socio Corporativo'
						when sp.SNcodigoOri	is not null then 'Socio Negocios'
						when sp.TESBid 		is not null then 'Beneficiario'
						when sp.CDCcodigo 	is not null then 'Cliente Detallista'
						else 'N/A'
					end as TipoBeneficiario,
					case
						when sp.SNcodigoOri	is not null AND sn.Ecodigo = #session.EcodigoCorp# then -sp.SNcodigoOri
						when sp.SNcodigoOri	is not null then sp.SNcodigoOri
						when sp.TESBid 		is not null then sp.TESBid
						when sp.CDCcodigo 	is not null then sp.CDCcodigo
						else 0
					end as IdBeneficiario,
					sp.EcodigoSP, sp.CDCcodigo,
					coalesce(sn.SNnombrePago,sn.SNnombre,TESBeneficiario,CDCnombre) #_Cat# ' ' #_Cat# coalesce(sp.TESOPbeneficiarioSuf,'') as Beneficiario,
					sp.TESOPbeneficiarioSuf,
					sp.CBid, sp.TESMPcodigo,
						(
							select ' en ' #_Cat# mp.Mnombre #_Cat# ', a través de: ' #_Cat# ep.Edescripcion #_Cat# ', y Cuenta: ' #_Cat# cb.CBcodigo
							  from CuentasBancos cb
							  	inner join Monedas mp
									 on mp.Mcodigo = cb.Mcodigo
								inner join Empresas ep
									 on ep.Ecodigo = cb.Ecodigo
							 where cb.CBid = sp.CBid
						) as Cuenta,
					EcodigoOri, Edescripcion,
					case TESSPtipoDocumento
						when 0 		then 'Manual'
						when 1 		then 'CxP'
						when 2 		then 'Antic.CxP'
						when 3 		then 'Antic.CxC'
						when 4 		then 'Antic.POS'
						when 5 		then 'ManualCF'
						when 6 		then 'Antic.GE'
						when 7 		then 'Liqui.GE'
						when 8		then 'Fondo.CCh'
						when 9 		then 'Reint.CCh'
						when 10		then 'TEF Bcos'
						when 100 	then 'Interfaz'
						else 'Otro'
					end as Origen,
					sp.McodigoOri, Miso4217 as Mnombre,
					TESSPid, TESSPnumero, TESSPfechaPagar, TESSPtotalPagarOri
					, coalesce(snCpc.SNnombrePago, snCpc.SNnombre) as CPCbeneficiario
					,(
					 	select 	case coalesce(TESOPFPtipo,0)
									when 1  then 'Cheque'
									when 2  then 'TEF a ' #_CAT# (select TESTPbanco #_CAT# ' - ' #_CAT# Miso4217 #_CAT# ' - ' #_CAT# TESTPcuenta from TEStransferenciaP where TESTPid = f.TESOPFPcta)
									when 3  then 'Tarjeta de Crédito Empresarial'
								end
					 	  from TESOPformaPago f
					 	 where TESOPFPtipoId = 5
						   and TESOPFPid 	 = sp.TESSPid
					 ) as PagarCon
				from TESsolicitudPago sp
					left outer join SNegocios sn
						  on sn.Ecodigo  = sp.EcodigoOri
						 and sn.SNcodigo = sp.SNcodigoOri
					left join TESbeneficiario tb
						on tb.TESBid = sp.TESBid
					left join ClientesDetallistasCorp cd
						on cd.CDCcodigo = sp.CDCcodigo

					left join CPCesion cpc
						inner join SNegocios snCpc
							on snCpc.SNid = cpc.SNidDestino
						on cpc.CPCid = sp.CPCid

					inner join Empresas e
						on e.Ecodigo=sp.EcodigoOri
					inner join Monedas m
						 on m.Mcodigo	= sp.McodigoOri
							and m.Ecodigo	= sp.EcodigoOri
				where TESid=#session.Tesoreria.TESid#
				  and TESSPestado = 10
				  and TESOPid is null
				  and sp.CBid is not null
				order by TESSPnumero asc, TESOPfechaPago, sp.CBid, sp.TESMPcodigo, sp.EcodigoSP, sp.SNid, EcodigoOri, McodigoOri
			</cfquery>

		<form name="frmDetallePago" method="post" action="ordenesPago_sql.cfm">
			<input type="hidden" name="btnBorrarSel">
			<input type="hidden" name="btnBorrarTodos">
			<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
				<tr>
					<td class="tituloListas" align="left" width="18" height="17" nowrap>&nbsp;</td>
					<td class="tituloListas" align="left" nowrap><strong><cf_translate key=LB_Origen>Origen</cf_translate></strong></td>
					<td class="tituloListas" align="left" nowrap><strong><cf_translate key=LB_NumSolicitud>Num.<BR>Solicitud</cf_translate></strong></td>
					<td class="tituloListas" align="left"><strong><cf_translate key=LB_FecPagoSolicitada>Fecha Pago<br>Solicitada</cf_translate></strong></td>
				  	<td class="tituloListas"><strong><cf_translate key=LB_FecPago>Fecha Pago</cf_translate></strong></td>
					<td class="tituloListas"><strong><cf_translate key=LB_CtaYMedioPago>Cuenta y Medio de Pago</cf_translate></strong></td>
					<td class="tituloListas" align="center"><strong><cf_translate key=LB_MonedaDctos>Moneda<br>Documentos </cf_translate></strong></td>
					<td class="tituloListas" align="right"><strong><cf_translate key=LB_MontoPagoSolicitado>Monto Pago<BR>Solicitado</cf_translate></strong></td>
				</tr>
				<cfif isdefined("lista") AND #lista.recordcount# GT 0>
					<tr>
						<td colspan="2">
							<a href="javascript:  borraLineaAll();">
								<img border="0" src="../../imagenes/Borrar01_S.gif" title="Quitar Todos" alt="Quitar Todos">
							</a>
							<label for="chkTodosQuitar"><cf_translate key = LB_SeleccionaTodos>Quitar Todos</cf_translate></label>
					  	</td>
					</tr>
				</cfif>
			<cfset LvarEmpresaSP = "">
			<cfset LvarBeneficiario = "">
			<cfset LvarFecha = "">
			<cfset LvarCPCid = "">
			<cfset LvarCta = "">
			<cfset LvarMP = "">
			<cfset LvarEmpresa = "">
			<cfset LvarCorte = "">

			<cfoutput>
			<cfloop query="lista">
				<cfif LvarCorte NEQ "#EcodigoSP#|#idBeneficiario#|#TESOPbeneficiarioSuf#|#CPCid#|#TESOPfechaPago#|#CBid#|#TESMPcodigo#">
					<cfset LvarCorte = "#EcodigoSP#|#idBeneficiario#|#TESOPbeneficiarioSuf#|#CPCid#|#TESOPfechaPago#|#CBid#|#TESMPcodigo#">
					<cfset LvarEmpresaSP = EcodigoSP>
					<cfset LvarBeneficiario = idBeneficiario  & "," & TESOPbeneficiarioSuf>
					<cfset LvarFecha = TESOPfechaPago>
					<cfset LvarCPCid = CPCid>
					<cfset LvarCta = CBid>
					<cfset LvarMP = TESMPcodigo>
					<cfset LvarEmpresa = "">
				<tr style="background-color:##999999; color:##FFFFFF; font-weight:bold;">
					<td colspan="8">
						<strong><cfoutput>#LB_SolPagarEl# #LSDateFormat(TESOPfechaPago,"DD/MM/YYYY")#, a #Beneficiario#, #Cuenta#</cfoutput></strong>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<strong>#TipoBeneficiario#:</strong>
					</td>
					<td colspan="5">
						<strong>
							#Beneficiario#
							<cfif CPCid NEQ "0">
							===&gt; cedido a:
							#CPCbeneficiario#
							</cfif>
						</strong>
					</td>
				</tr>
				</cfif>
				<cfif LvarEmpresa NEQ EcodigoOri>
					<cfset LvarEmpresa = EcodigoOri>
				<tr>
					<td colspan="4">
						<strong>&nbsp;&nbsp;<cf_translate key=LB_EmpresaSolicita>Empresa que solicita</cf_translate>:</strong>
					</td>
					<td colspan="5">
						<strong>&nbsp;&nbsp;#Edescripcion#</strong>
					</td>
				</tr>
				</cfif>
				<tr>
					<td>
						<input type="hidden" name="TESSPid" value="#TESSPid#">
						<a href="javascript: borraLinea('#TESSPid#');">
							<img border="0" src="../../imagenes/Borrar01_S.gif" alt="#LB_ExcSolGeneracion#">
						</a>
					</td>
					<td align="left">#Origen#</td>
					<td align="left">#TESSPnumero#</td>
					<td>#LSDateFormat(TESSPfechaPagar,"DD/MM/YYYY")#</td>
					<td>
						<cf_sifcalendario form="frmDetallePago" value="#LSDateFormat(TESOPfechaPago,"DD/MM/YYYY")#" name="TESOPfechaPago_#TESSPid#" cboTESMPcodigo="TESMPcodigo_#TESSPid#" tabindex="1">
					</td>
					<td>
						<cf_cboTESCBid name="CBid_#TESSPid#" value="#lista.CBid#" Dcompuesto="yes" MedioPago="TESMPcodigo_#TESSPid#" cboTESMPcodigo="TESMPcodigo_#TESSPid#" tabindex="1">
					</td>
					<td align="center">#Mnombre#</td>
					<td align="right">#NumberFormat(TESSPtotalPagarOri,",0.00")#</td>
				</tr>
				<tr>
					<td colspan="5">&nbsp;</td>
					<td colspan="3">
						<table cellpadding="0" cellspacing="0">
						<tr><td>
						<cf_cboTESMPcodigo name="TESMPcodigo_#TESSPid#" CBid="CBid_#TESSPid#" value="#lista.TESMPcodigo#" session="false" tabindex="1">
						</td>
						<cfif lista.pagarCon NEQ "">
							<td>
								&nbsp;&nbsp;
								<font color="##FF0000"><strong><cfoutput>#BTN_SolicitaPagarCon#</cfoutput> #lista.pagarCon#</strong></font>
							</td>
						</cfif>
						</tr>
						</table>
					</td>
				</tr>
			</cfloop>
			</cfoutput>
			<tr><td colspan="8" style="background-color: #D4D4D4; color:#FFFFFF; font-weight:bold; font-size:4px;">&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>

			</table>
			  <cfoutput>
			  <input name="PASO" type="hidden" value="0" tabindex="-1">
              <input name="btnCambiarSel" 	type="submit" value="#BTN_CambiarSolicitudes#"
			  		onClick="return fnVerificar();" tabindex="1">
          		<input name="btnSel" 		type="button" value="#BTN_SeleccionarSolicitudes#"
			  		onClick="document.location.href='ordenesPago.cfm?PASO=1';" tabindex="1">
			  <input name="btnGenerarSel" 	type="submit" value="#BTN_GenerarOP#" tabindex="1"
			  		>
			  <input name="btnLista" type="button" id="btnSelFac" value="Lista Ordenes de Pago" tabindex="1"
			  		onClick="document.location.href='ordenesPago.cfm?PASO=0';">
			  </cfoutput>
		  </form>
		</td>
	  </tr>
	</table>
	<cf_web_portlet_end>
 <script language="javascript" type="text/javascript">
	function fnVerificar()	{
	<cfoutput query="lista">
		if (document.frmDetallePago.TESOPfechaPago_#TESSPid#.value == '')
		{
			alert("#LB_FecSolicitud# #TESSPnumero# #LB_EsRequerida#");
			document.frmDetallePago.TESOPfechaPago_#TESSPid#.focus();
			return false;
		}
	</cfoutput>
		return true;
	}
	<cfoutput>
	function borraLinea(valor){
		if ( confirm('#LB_Desea# #LB_ExcSolGeneracion#?') )
		{
			document.frmDetallePago.btnBorrarSel.value= valor;
			document.frmDetallePago.submit();
		}
	}

	function borraLineaAll(){
		document.frmDetallePago.btnBorrarTodos.value= "";
		if ( confirm('¿Desea excluir todas las Solicitudes de Pago?') ){
			document.frmDetallePago.btnBorrarTodos.value= "OK";
			document.frmDetallePago.submit();
		}
	}
	</cfoutput>
</script>
