<cf_navegacion name="PASO" value="1">
<cf_navegacion name="SNcodigo_F">
<cf_navegacion name="TESSPfechaPagar_F">
<cf_navegacion name="EcodigoOri_F">
<cf_navegacion name="Beneficiario_F">
<cf_navegacion name="NumAcuerdo">
<cf_navegacion name="McodigoOri_F">
<cfinvoke key="LB_Titulo" default="Lista de Solicitudes de Pago a Seleccionar (Aprobadas sin Orden de Pago)"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_EmpresaSolicitud" default="Empresa Solicitud"	returnvariable="LB_EmpresaSolicitud"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Origen" default="Origen"	returnvariable="LB_Origen"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_NumSolicitud" default="Num. Solicitud"	returnvariable="LB_NumSolicitud"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Tipo" default="Tipo"	returnvariable="LB_Tipo"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Socio" default="Socio" returnvariable="LB_Socio"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_o" default="or" returnvariable="LB_o"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Beneficiario" default="Beneficiario" returnvariable="LB_Beneficiario"	method="Translate" component="sif.Componentes.Translate"
xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Banco" default="Banco" returnvariable="LB_Banco"	method="Translate" component="sif.Componentes.Translate"  xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_FechaPago" default="Fecha Pago" returnvariable="LB_FechaPago"	method="Translate" component="sif.Componentes.Translate"
xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Solicitada" default="Solicitada" returnvariable="LB_Solicitada"	method="Translate" component="sif.Componentes.Translate"
xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Moneda" default="Moneda" returnvariable="LB_Moneda"	method="Translate" component="sif.Componentes.Translate"
xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="LB_Monto" default="Monto" returnvariable="LB_Monto"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista1Sel.xml"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar"	returnvariable="BTN_Filtrar"	method="Translate" component="sif.Componentes.Translate"
xmlfile="/sif/generales.xml"/>
<cfinvoke key="MSG_CuentaBancaria" default="Escoja una Cuenta Bancaria"	returnvariable="MSG_CuentaBancaria"	method="Translate" component="sif.Componentes.Translate" xmlfile="ordenesPago_lista1Sel.xml"/>


<cfset titulo = '#LB_Titulo#'>
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">
	<table width="100%" border="0" cellspacing="6">
		<tr>
			<td width="50%" valign="top">
				<form name="formFiltro" method="post" action="ordenesPago.cfm" style="margin: '0' ">
					<input type="hidden" name="PASO" value="1">
					<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
						<tr>
							<td nowrap align="right"><strong><cf_translate key=LB_EmpresaSolicitud>Empresa Solicitud</cf_translate>:</strong>&nbsp; </td>
							<td>
								<cf_cboTESEcodigo name="EcodigoOri_F" tabindex="1" Tipo="CE">
							</td>
							<td nowrap align="right"><strong><cf_translate key=LB_NumSolicitud>Num. Solicitud</cf_translate>:</strong>&nbsp; </td>
							<td>
								<cfparam name="form.TESSPnumero_F" default="">
								<cf_inputNumber name="TESSPnumero_F" value="" comas="no" tabindex="1">
							</td>
						</tr>
						<tr>
							<td width="17%" nowrap align="right"><strong><cf_translate key=LB_SocioNegocio>Socio Negocios</cf_translate>:</strong></td>
							<td width="32%"><cfif isdefined('form.SNcodigo_F') and len(trim(form.SNcodigo_F))>
									<cf_sifsociosnegocios2 form="formFiltro" SNnombre='SNnombre_F'
									SNcodigo='SNcodigo_F' idquery="#form.SNcodigo_F#" tabindex="1">
									<cfelse>
									<cf_sifsociosnegocios2 form="formFiltro" SNnombre='SNnombre_F' SNcodigo='SNcodigo_F' tabindex="1">
								</cfif>
							</td>
							<td width="14%" nowrap align="right" valign="middle"><strong><cf_translate key=LB_HastaFecha>Hasta Fecha</cf_translate>:</strong></td>
							<td width="13%" nowrap valign="middle"><cfset fechadoc = ''>
									<cfif isdefined('form.TESSPfechaPagar_F') and len(trim(form.TESSPfechaPagar_F))>
										<cfset fechadoc = LSDateFormat(form.TESSPfechaPagar_F,'dd/mm/yyyy') >
									</cfif>
									<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESSPfechaPagar_F" tabindex="1">
							</td>
							<td width="24%" nowrap align="center" valign="middle">
                            	<cfoutput><input name="btnFiltrar" class="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="2" /></cfoutput>
							</td>
						</tr>
						<tr>
							<td width="18%" nowrap align="right"><strong><cf_translate key=LB_Socio>Socio</cf_translate> <cf_translate key=LB_o>o</cf_translate> <cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong></td>
							<td ><cfparam name="form.Beneficiario_F" default="">
									<input type="text" name="Beneficiario_F" value="<cfoutput>#form.Beneficiario_F#</cfoutput>" size="60" tabindex="1" />
							</td>
							<td width="23%" align="right" nowrap><strong><cf_translate key=LB_MonedaFactura>Moneda Factura</cf_translate>:</strong> </td>
							<td><cfquery name="rsMonedas" datasource="#session.DSN#">
								select distinct Mcodigo, (select min(Mnombre) from Monedas m2 where m.Mcodigo=m2.Mcodigo) as Mnombre
								from Monedas m
								inner join TESempresas e
								on e.TESid =
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
								and e.Ecodigo = m.Ecodigo
								</cfquery>
									<select name="McodigoOri_F" tabindex="1">
										<option value="">(<cf_translate key=LB_Todos>Todas las monedas</cf_translate>)</option>
										<cfoutput query="rsMonedas">
											<option value="#Mcodigo#" <cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F EQ Mcodigo>selected</cfif>>#Mnombre#</option>
										</cfoutput>
									</select>
							</td>
						</tr>
						<tr>
							<td width="18%" nowrap align="right"><strong><cf_translate key=LB_NumeroAcuerdo>Numero Acuerdo</cf_translate>:</strong></td>
							<td ><cfparam name="form.NumAcuerdo" default="">
									<input type="text" name="NumAcuerdo" value="<cfoutput>#form.NumAcuerdo#</cfoutput>" size="60" tabindex="1" />
							</td>
                            <!---►►Filtro para el Banco Default◄◄--->
                            <cfparam name="form.BidDefault" default="">
                            <cfquery name="rsBancos" datasource="#session.DSN#">
                                select Bid,Bdescripcion
                                  from Bancos
                                 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                 order by Bdescripcion
                            </cfquery>
                            <td align="right" nowrap><strong><cf_translate key=LB_Banco>Banco</cf_translate> Default:</strong> </td>
							<td>
                            	<select name="BidDefault">
									<option value="">(<cf_translate key=LB_Todos>Todos los Bancos</cf_translate>)</option>
									<cfoutput query="rsBancos">
										<option value="#rsBancos.Bid#" <cfif rsBancos.Bid EQ form.BidDefault>selected</cfif>>#rsBancos.Bdescripcion#</option>
									</cfoutput>
								</select>
                            </td>

						</tr>
					</table>
					<table width="100%"  border="0">
					  <tr>
						<td width="10%" nowrap><strong><cf_translate key=LB_CuentaBancariaPago>Cuenta Bancaria de Pago</cf_translate>:</strong></td>
						<td width="90%">
							<cf_cboTESCBid name="CBidPagar" Dcompuesto="yes" none="yes" cboTESMPcodigo="TESMPcodigoPagar" tabindex="2">						</td>
					  </tr>
					  <tr>
						<td width="10%" nowrap><strong><cf_translate key=LB_MedioPago>Medio de Pago</cf_translate>:</strong></td>
						<td width="90%">
							<cf_cboTESMPcodigo name="TESMPcodigoPagar" CBid="CBidPagar" tabindex="2">
						</td>
					  </tr>
					  <tr><td><input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
				<label for="chkTodos"><cf_translate key = LB_SeleccionaTodos>Seleccionar Todos</cf_translate></label>&nbsp;&nbsp;&nbsp;</td></tr>
					</table>
				</form>
			</td>
		</tr>
		<cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#session.dsn#" name="lista">
			Select
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
				TESSPid,
				TESSPnumero,
				SNcodigoOri,
				case
					when sp.SNcodigoOri is not null AND sn.SNidCorporativo is not null then 'SNC'
					when sp.SNcodigoOri is not null then 'SN'
					when sp.TESBid 		is not null then 'B'
					when sp.CDCcodigo	is not null then 'CD'
					else '???'
				end as TipoBeneficiario,
				coalesce (SNnombrePago, SNnombre, tb.TESBeneficiario, cd.CDCnombre) #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as Beneficiario,
				TESSPfechaPagar,
				Edescripcion,
				m.Mcodigo,
				Mnombre,
				TESSPtotalPagarOri,
				sp.CBid as CBidPagar, 0 as TESMPcodigo,
                coalesce(banSN.Bdescripcion,banBC.Bdescripcion,banCD.Bdescripcion,'') as bancoDefault
			from TESsolicitudPago sp
				inner join Empresas e
					on e.Ecodigo=sp.EcodigoOri

				inner join Monedas m
					on m.Mcodigo=sp.McodigoOri
						and m.Ecodigo=sp.EcodigoOri

				left join SNegocios sn
					on sn.SNcodigo=sp.SNcodigoOri
						and sn.Ecodigo=sp.EcodigoOri
				left join TESbeneficiario tb
					on tb.TESBid = sp.TESBid
				left join ClientesDetallistasCorp cd
					on cd.CDCcodigo = sp.CDCcodigo
				left join TESacuerdoPago tap
					on tap.TESAPid = sp.TESAPid

				<!---►►Banco Default para pagos por tranferencia(Socios de Negocios)◄◄--->
                left join TEStransferenciaP CtaDestSN
                	 on CtaDestSN.SNidP       = sn.SNid
                    and CtaDestSN.TESTPestado = 1
					and CtaDestSN.TESid = #session.Tesoreria.TESid#
                left join Bancos banSN
                	on banSN.Bid = CtaDestSN.Bid

                <!---►►Banco Default para pagos por tranferencia(Beneficiario de Contado)◄◄--->
                left join TEStransferenciaP CtaDestBC
                	 on CtaDestBC.TESBid       = tb.TESBid
                    and CtaDestBC.TESTPestado = 1
					and CtaDestBC.TESid = #session.Tesoreria.TESid#
                left join Bancos banBC
                	on banBC.Bid = CtaDestBC.Bid

                <!---►►Banco Default para pagos por tranferencia(Cliente Detallista)◄◄--->
                left join TEStransferenciaP CtaDestCD
                	 on CtaDestCD.CDCcodigo       = cd.CDCcodigo
                    and CtaDestCD.TESTPestado = 1
					and CtaDestCD.TESid = #session.Tesoreria.TESid#
                left join Bancos banCD
                	on banCD.Bid = CtaDestCD.Bid

			where sp.TESid=#session.Tesoreria.TESid#
				and TESSPestado = 2				<!--- Aprobadas --->
				<cfif isdefined('form.SNcodigo_F') and len(trim(form.SNcodigo_F))>
					and sn.SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo_F#">
				</cfif>
				<cfif isdefined('form.TESSPfechaPagar_F') and len(trim(form.TESSPfechaPagar_F))>
					and sp.TESSPfechaPagar <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESSPfechaPagar_F)#">
				</cfif>
				<cfif isdefined('form.Beneficiario_F') and len(trim(form.Beneficiario_F))>
					and upper(coalesce(sn.SNnombrePago,sn.SNnombre,TESBeneficiario,cd.CDCnombre)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
				</cfif>
				<cfif isdefined('form.NumAcuerdo') and len(trim(form.NumAcuerdo))>
					and tap.TESAPnumero like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#trim(form.NumAcuerdo)#%">
				</cfif>
				<cfif isdefined('form.EcodigoOri_F') and len(trim(form.EcodigoOri_F)) and form.EcodigoOri_F NEQ '-1'>
					and sp.EcodigoOri=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoOri_F#">
				</cfif>
				<cfif isdefined('form.McodigoOri_F') and len(trim(form.McodigoOri_F)) and form.McodigoOri_F NEQ '-1'>
					and sp.McodigoOri=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.McodigoOri_F#">
				</cfif>
				<cfif isdefined('form.TESSPnumero_F') and len(trim(form.TESSPnumero_F))>
					and sp.TESSPnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESSPnumero_F#">
				</cfif>
                <cfif isdefined('form.BidDefault') and LEN(TRIM(form.BidDefault))>
                	and (Coalesce(banSN.Bid,banBC.Bid,banCD.Bid) = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.BidDefault#"> )
                </cfif>
			Order by TESSPnumero,TESSPfechaPagar,SNcodigoOri,McodigoOri
		</cfquery>
		
		<tr>
			<td>
				<form name="formListaAsel" method="post" action="ordenesPago_sql.cfm" style="margin: '0' ">
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
						query="#lista#"
						desplegar="Edescripcion, Origen, TESSPnumero,TipoBeneficiario, Beneficiario,bancoDefault,TESSPfechaPagar,Mnombre,TESSPtotalPagarOri"
						etiquetas="#LB_EmpresaSolicitud#, #LB_Origen#, #LB_NumSolicitud#,#LB_Tipo#,#LB_Socio# #LB_o# #LB_Beneficiario#,#LB_Banco# Default,#LB_FechaPago#<BR>#LB_Solicitada#, #LB_Moneda#,#LB_Monto# #LB_Solicitada#"
						formatos="S,S,S,S,S,S,D,S,M"
						align="left,left,center,left,left,left,center,left,right"
						ira="ordenesPago_sql.cfm"
						form_method="post"
						showLink="no"
						showEmptyListMsg="yes"
						keys="TESSPid"
						checkboxes="S"
						incluyeForm="no"
						formName="formListaAsel"
						botones=""
						navegacion="#navegacion#"
					/>
					<BR>
					<cf_botones values="Seleccionar,Siguiente,Lista_Ordenes" tabindex="2">
					<input type="checkbox" name="chkSNCorporativo" tabindex="2">
					<cf_translate key=LB_AgruparSolicitudes>Agrupar Solicitudes seleccionadas por Socio de Negocio Corporativo </cf_translate><BR><BR>
					<strong><cf_translate key=LB_TipoSocioBeneficiario>Tipo Socio o Beneficiario</cf_translate>:</strong> SN=<cf_translate key=LB_SocioNegocio>Socio Negocio</cf_translate>, SNC=<cf_translate key=LB_SocioCorporativo>Socio Corporativo</cf_translate>, B=<cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>, CD=<cf_translate key=LB_ClienteDetallista>Cliente Detallista</cf_translate>
				</form>
			</td>
		</tr>
	</table>
	<cf_web_portlet_end>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcSeleccionar(){
		if (document.formFiltro.CBidPagar.value == "")
		{
			alert ("#MSG_CuentaBancaria#");
			document.formFiltro.CBidPagar.focus();
			return false;
		}
		document.formListaAsel.CBIDPAGAR.value=document.formFiltro.CBidPagar.value;
		document.formListaAsel.TESMPCODIGO.value=document.formFiltro.TESMPcodigoPagar.value;
	}
	function funcSiguiente(){
		var idOrdenes = getMarcados();
		var idListaSP = getListadoSP();

		if(idListaSP > 0){
			if(idOrdenes === ""){
				alert("Favor de seleccionar al menos una solicitud de pago.")
				return false
			} else {
				var resultAjaxValidaOP = validaSolicitudes(idOrdenes);
					if(resultAjaxValidaOP == 'OK'){
						document.formListaAsel.CBIDPAGAR.value=document.formFiltro.CBidPagar.value;
						document.formListaAsel.TESMPCODIGO.value=document.formFiltro.TESMPcodigoPagar.value;
						<!--- return true; --->
					} else {
						if (document.formFiltro.CBidPagar.value == ""){
							alert(resultAjaxValidaOP);
							return false;
						} else if (document.formFiltro.TESMPcodigoPagar.value == ""){
							alert(resultAjaxValidaOP);
							return false;
						} else {
							document.formListaAsel.CBIDPAGAR.value=document.formFiltro.CBidPagar.value;
							document.formListaAsel.TESMPCODIGO.value=document.formFiltro.TESMPcodigoPagar.value;
							return true;
						}

					}
			}
		} else {
			return true;
		}
	}
	function funcLista_Ordenes(){
		location.href='ordenesPago.cfm?PASO=0';
		return false;
	}

	<!--- INICIO VALIDACION DE EXISTENCIA DE LA CUENTA DE PAGO --->

	function validaSolicitudes(idOrdenes){
		var returnValue = "";
		$.ajax({
		        method: "post",
		        url: "ajaxValidaOrdenesPago.cfc",
		        async: false,
		        data: {
		            method: "validaCuentaPagoSP",
		            returnFormat: "JSON",
		            idsSP: idOrdenes,
		        },
		        dataType: "json",
		        success: function(obj) {
		            if (obj.MSG == 'validaOK') {
		                returnValue = "OK";
		            } else {
		                returnValue = obj.MSG;
		            }
		        }
		    });
		return returnValue;
	}

	function getListadoSP(){
		var f = document.formListaAsel;
		var total = 0;
		if (f.chk.value) {
			total = 1;
		} else {
			total = f.chk.length;
		}
		return total;
	}

	function getMarcados(){
		var f = document.formListaAsel;
		var m = "";
		if (f.chk != null) {
			if (f.chk.value) {
				if (f.chk.checked) {
					m = f.chk.value;
				}
			} else {
				for (var i=0; i<f.chk.length; i++) {
					if (f.chk[i].checked) {
						if (m.length==0)
							m = f.chk[i].value;
						else
							m += ',' + f.chk[i].value;
					}
				}
			}
		}
		return m;
	}

	<!--- FIN VALIDACION DE EXISTENCIA DE LA CUENTA DE PAGO --->

	<!--- INICIO SELECCIONAR TODOS --->
	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.formListaAsel.chk.length; counter++)
			{
				if ((!document.formListaAsel.chk[counter].checked) && (!document.formListaAsel.chk[counter].disabled))
					{  document.formListaAsel.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.formListaAsel.chk.disabled)) {
				document.formListaAsel.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.formListaAsel.chk.length; counter++)
			{
				if ((document.formListaAsel.chk[counter].checked) && (!document.formListaAsel.chk[counter].disabled))
					{  document.formListaAsel.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.formListaAsel.chk.disabled)) {
				document.formListaAsel.chk.checked = false;
			}
		};
	}
	<!--- FIN SELECCIONAR TODOS --->
	document.formFiltro.EcodigoOri_F.focus();
</script>
</cfoutput>

