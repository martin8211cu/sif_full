
<cfinvoke key="BTN_Filtrar" default="Filtrar"	returnvariable="BTN_Filtrar"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="/sif/generales.xml"/>
<cfinvoke key="LB_Orden" default="Orden"	returnvariable="LB_Orden"	method="Translate" component="sif.Componentes.Translate"  xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Beneficiario" default="Beneficiario"	returnvariable="LB_Beneficiario"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_FechaPago" default="Fecha Pago"	returnvariable="LB_FechaPago"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Estado" default="Estado"	returnvariable="LB_Estado"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_EmpresaPago" default="Empresa Pago"	returnvariable="LB_EmpresaPago"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Banco" default="Banco"	returnvariable="LB_Banco"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_CuentaPago" default="Cuenta Pago"	returnvariable="LB_CuentaPago"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Lote" default="Lote"	returnvariable="LB_Lote"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Pago" default="Pago"	returnvariable="LB_Pago"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_Moneda" default="Moneda"	returnvariable="LB_Moneda"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_MontoPagar" default="Monto a Pagar"	returnvariable="LB_MontoPagar"	method="Translate" component="sif.Componentes.Translate"
xmlfile="listaOPs.xml"/>
<cfinvoke key="LB_TodasMonedas" default="Todas las monedas"	returnvariable="LB_TodasMonedas"	method="Translate" component="sif.Componentes.Translate"  xmlfile="listaOPs.xml"/>

<cfparam name="Attributes.irA"	 		default="ordenesPago.cfm" type="string">
<cfparam name="Attributes.TESOPestado" 	default="-1" type="string">
<cfparam name="Attributes.noLotes" 		default="no" type="boolean">
<cfparam name="Attributes.enEmision" 	default="no" type="boolean">

<cf_navegacion name="Beneficiario_F"	session>
<cfparam name="form.TESOPnumero_F" 		default="">
<cf_navegacion name="TESOPfechaPago_F"	session>

<cf_navegacion name="EcodigoPago_F"		session>
<cf_navegacion name="CBidPago_F"		session>
<cf_navegacion name="DocPago_F"			session>
<cf_navegacion name="Miso4217Pago_F"	session>

<cfif Attributes.TESOPestado EQ -1>
	<cf_navegacion name="TESOPestado_F"		session>
<cfelse>
	<cfset form.TESOPestado_F = Attributes.TESOPestado>
</cfif>

<table width="100%" border="0" cellspacing="6">
  <tr>
	<td width="50%" valign="top">
		<form name="formFiltro" method="post" action="#Attributes.irA#" style="margin: '0' ">
			<table class="areaFiltro" width="100%"  border="0" cellpadding="0" cellspacing="0">
			  <tr>
				<td nowrap align="right">
					<strong><cf_translate key=LB_TrabajarConTesoreria>Trabajar con Tesorería</cf_translate>:</strong>&nbsp;
				</td>
				<td colspan="3">
					<cf_cboTESid onchange="this.form.submit();" tabindex="1">
				</td>
				<td align="right"><strong><cf_translate key=LB_EmpresaPago>Empresa&nbsp;Pago</cf_translate>:</strong></td>
				<td >
					<cf_cboTESEcodigo name="EcodigoPago_F" tabindex="1">
				</td>
			  </tr>
			  <tr>
				<td nowrap align="right"><strong><cf_translate key=LB_Beneficiario>Beneficiario</cf_translate>:</strong></td>
				<td colspan="3">
					<cfparam name="form.Beneficiario_F" default="">
					<input type="text" name="Beneficiario_F" value="<cfoutput>#form.Beneficiario_F#</cfoutput>" size="60" tabindex="1">
				</td>

				<td align="right" nowrap>
					<strong><cf_translate key=LB_CuentaPago>Cuenta Pago</cf_translate>:</strong>
				</td>
				<td colspan="2">
					<cf_cboTESCBid name="CBidPago_F" Ccompuesto="yes" all="yes" onChange="javascript: cambioCB(this);" tabindex="1" >
				</td>
				<td width="100%"></td>
			  </tr>
			  <tr>
				<td align="right" nowrap>
					<strong><cf_translate key=LB_Estado>Estado</cf_translate>:</strong>
				</td>
				<td nowrap valign="middle" colspan="3">
					<select name="TESOPestado_F" id="TESOPestado_F" tabindex="1"
						<cfif Attributes.TESOPestado NEQ -1>disabled</cfif>
					>
					<cfif Attributes.TESOPestado EQ -1>
						<option value="-1">-- <cf_translate key=LB_Todos>Todos</cf_translate> --</option>
					</cfif>
						<option value="10" <cfif form.TESOPestado_F EQ 10>selected</cfif>><cf_translate key=LB_EnPreparacion>En Preparación</cf_translate></option>
						<!---
						<option value="101" <cfif form.TESOPestado_F EQ 101>selected</cfif>>En Aprobación</option>
						<option value="103" <cfif form.TESOPestado_F EQ 103>selected</cfif>>Rechazada</option>
						--->
						<option value="11" <cfif form.TESOPestado_F EQ 11>selected</cfif>><cf_translate key=LB_EnEmision>En Emisión</cf_translate></option>
                        <option value="110" <cfif form.TESOPestado_F EQ 110>selected</cfif>><cf_translate key=LB_SinAplicar>Sin Aplicar</cf_translate></option>
						<option value="12" <cfif form.TESOPestado_F EQ 12>selected</cfif>><cf_translate key=LB_Emitidas>Emitidas</cf_translate></option>
						<option value="13" <cfif form.TESOPestado_F EQ 13>selected</cfif>><cf_translate key=LB_Anuladas>Anuladas</cf_translate></option>
					</select>
				</td>
				<td align="right" nowrap>
					<strong><cf_translate key=LB_MonedaPago>Moneda Pago</cf_translate>:</strong>
				</td>
				<td >
					<cfquery name="rsMonedas" datasource="#session.DSN#">
						select distinct Miso4217, (select min(Mnombre) from Monedas m2 where m.Miso4217=m2.Miso4217) as Mnombre
						from Monedas m
							inner join TESempresas e
								 on e.TESid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
								and e.Ecodigo = m.Ecodigo
					</cfquery>

					<select name="Miso4217Pago_F" tabindex="1">
						<cfoutput><option value="">(#LB_TodasMonedas#)</option></cfoutput>
						<cfoutput query="rsMonedas">
							<option value="#Miso4217#" <cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F EQ Miso4217>selected</cfif>>#Mnombre#</option>
						</cfoutput>
					</select>
				</td>
			  </tr>
			  <tr>
				<td align="right" nowrap>
					<strong><cf_translate key=LB_NumOrden>Num.Orden</cf_translate>:</strong>
				</td>
				<td>
							<input name="TESOPnumero_F" type="text" tabindex="1"
							size="22">
				</td>
				<td nowrap align="right" valign="middle">
					<strong><cf_translate key=LB_HastaFecha>Hasta Fecha</cf_translate>:</strong>
				</td>
				<td nowrap valign="middle">
					<cfset fechadoc = ''>
					<cfif isdefined('form.TESOPfechaPago_F') and len(trim(form.TESOPfechaPago_F))>
						<cfset fechadoc = LSDateFormat(form.TESOPfechaPago_F,'dd/mm/yyyy') >
					</cfif>
					<cf_sifcalendario form="formFiltro" value="#fechadoc#" name="TESOPfechaPago_F" tabindex="1">
				</td>
				<td align="right" nowrap>
					<strong>&nbsp;<cf_translate key=LB_DocumentoPago>Documento Pago</cf_translate>:</strong>
				</td>
				<td >
					<input name="DocPago_F" type="text" tabindex="1"
						value="<cfoutput>#form.DocPago_F#</cfoutput>"
						size="20">
				</td>
				<td align="right">
					<cfoutput><input name="btnFiltrar" type="submit" id="btnFiltrar" value="#BTN_Filtrar#" tabindex="2"></cfoutput>
				</td>
			  </tr>
			</table>

			<cfif isDefined("form.chkEnEmision")>
				<cfset chkList = "N">
			<cfelse>
				<cfset chkList = "S">
			</cfif>

			<cfif chkList EQ "S">
				<input name="chkTodos" type="checkbox" value="" border="0" onClick="javascript:Marcar(this);" style="background:background-color ">
				<label for="chkTodos"><cf_translate key = LB_SeleccionaTodos>Seleccionar Todos</cf_translate></label>&nbsp;&nbsp;&nbsp;
			</cfif>


			<cfif Attributes.enEmision>
			<input type="checkbox" name="chkEnEmision" tabindex="2"
				<cfif isdefined("form.chkEnEmision")>checked</cfif>
				onclick="this.form.submit();"
				> <cf_translate key=LB_TrabajarOrdenesEmision>Trabajar con Ordenes en Emisión</cf_translate>
			</cfif>
		</form>
		<script>
			window.setTimeout("document.formFiltro.Beneficiario_F.focus();",500);</script>

        <cfinclude template="../../Utiles/sifConcat.cfm">
		<cfquery datasource="#session.dsn#" name="lista" maxrows="5000">
			Select	op.TESOPid,
					TESOPnumero,
					TESOPbeneficiario #_Cat# ' <strong>' #_Cat# coalesce(TESOPbeneficiarioSuf,'') #_Cat# '</strong>' as TESOPbeneficiario,
					TESOPfechaPago,
					op.Miso4217Pago,
					Edescripcion as empPago,
					Bdescripcion as bcoPago,
					CBcodigo,
					TESOPtotalPago,
					case mp.TESTMPtipo
						when 1 then 'CHK ' #_Cat# <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then 'TRI ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then 'TRE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then 'TRM ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then 'TCE ' #_Cat# (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end as DocPago,
					TESOPmsgRechazo,
					<cfif isdefined("form.chkEnEmision")>
						1 as chkEnEmision,
					</cfif>
					10 as PASO
				, 	case op.TESOPestado
						when  10 then 'Preparación'
						when  11 then 'En Emisión'
                        when  110 then 'Sin Aplicar'
						when  12 then 'Aplicada'
						when  13 then 'Anulada'
						when 101 then 'Aprobación'
						when 103 then 'Rechazada'
						else 'Estado desconocido'
					end as TESOPestado
                    ,coalesce(op.TESTLid,op.TESCFLid) as Lote
			from TESordenPago op
				left join CuentasBancos cb
					inner join Bancos b
						on b.Bid = cb.Bid
					 on cb.CBid=CBidPago
				left join TESmedioPago mp
					 on mp.TESid 		= #session.Tesoreria.TESid#
					and mp.CBid			= op.CBidPago
					and mp.TESMPcodigo 	= op.TESMPcodigo
				left outer join Empresas e
					on e.Ecodigo=op.EcodigoPago
			where op.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">
				<cfif len(trim(TESOPnumero_F))>
					and TESOPnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#TESOPnumero_F#">
				</cfif>
				<cfif len(trim(form.Beneficiario_F))>
					and upper(TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'')) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(trim(form.Beneficiario_F))#%">
				</cfif>
				<cfif len(trim(form.TESOPfechaPago_F))>
					and TESOPfechaPago <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDatetime(form.TESOPfechaPago_F)#">
				</cfif>

				<cfif len(trim(form.CBidPago_F)) and form.CBidPago_F NEQ '-1'>
					and CBidPago=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBidPago_F#">
				<cfelse>
					<cfif isdefined('form.EcodigoPago_F') and len(trim(form.EcodigoPago_F)) and form.EcodigoPago_F NEQ '-1'>
						and op.EcodigoPago=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.EcodigoPago_F#">
					</cfif>
					<cfif isdefined('form.Miso4217Pago_F') and len(trim(form.Miso4217Pago_F)) and form.Miso4217Pago_F NEQ '-1'>
						and op.Miso4217Pago=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Miso4217Pago_F#">
					</cfif>
				</cfif>


				<cfif form.TESOPestado_F NEQ -1 AND form.TESOPestado_F NEQ "">
				  and TESOPestado in (#form.TESOPestado_F#)
				</cfif>
				<cfif form.docPago_F NEQ "">
					AND case mp.TESTMPtipo
						when 1 then <cf_dbfunction name="to_char" args="op.TESCFDnumFormulario">
						when 2 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 3 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 4 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
						when 5 then (select fd.TESTDreferencia from TEStransferenciasD fd where fd.TESTDid = op.TESTDid)
					end = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.docPago_F#">
				</cfif>
				<cfif Attributes.noLotes>
				  and TESTLid is null
				  and TESCFLid is null
				</cfif>
		</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#lista#"
			desplegar="TESOPnumero,TESOPbeneficiario,TESOPfechaPago,TESOPestado,empPago,CBcodigo,BcoPago,Lote,DocPago,Miso4217Pago,TESOPtotalPago"
			etiquetas="Num.<BR>#LB_Orden#, #LB_Beneficiario#, #LB_FechaPago#,#LB_Estado#, #LB_EmpresaPago#, #LB_CuentaPago#,#LB_Banco#,#LB_Lote#,Doc<BR>#LB_Pago#, #LB_Moneda#<BR>#LB_Pago#, #LB_MontoPagar#"
			formatos="S,S,D,S,S,S,S,S,S,S,M"
			align="center,left,center,left,left,left,left,left,left,right,right"
            maxrowsquery="5000"
			ira="#Attributes.irA#"
			form_method="post"
			showEmptyListMsg="yes"
			keys="TESOPid"
			checkboxes="#chkList#"
			navegacion="#navegacion#"
		>
		<cfif Attributes.TESOPestado eq 10><!--- En preparacion --->
			<cfinvokeargument name="botones" value="Emitir_Seleccionados">
		</cfif>
		</cfinvoke>
	</td>
  </tr>
</table>


<script language="javascript" type="text/javascript">
	function funcEmitir_Seleccionados()
	{
		var idOrdenes = getMarcados();
		if(idOrdenes === ""){
			alert("Favor de seleccionar al menos una orden de pago.")
			return false
		} else {
			var resultAjaxValidaOP = validaOrdenes(idOrdenes);
				if(resultAjaxValidaOP == 'OK'){
				document.lista.action = "ordenesPago_sql.cfm";
				return true;
			} else {
				alert(resultAjaxValidaOP)
				return false;
			}
		}
	}

	function getMarcados(){
		var f = document.lista;
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

	function validaOrdenes(idOrdenes){
		var returnValue = "";
		$.ajax({
		        method: "post",
		        url: "ajaxValidaOrdenesPago.cfc",
		        async: false,
		        data: {
		            method: "validaOrdenesPago",
		            returnFormat: "JSON",
		            idsOP: idOrdenes,
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

	function Marcar(c) {
		if (c.checked) {
			for (counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((!document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = true;}
			}
			if ((counter==0)  && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = true;
			}
		}
		else {
			for (var counter = 0; counter < document.lista.chk.length; counter++)
			{
				if ((document.lista.chk[counter].checked) && (!document.lista.chk[counter].disabled))
					{  document.lista.chk[counter].checked = false;}
			};
			if ((counter==0) && (!document.lista.chk.disabled)) {
				document.lista.chk.checked = false;
			}
		};
	}

	function cambioCB(cb){
		if(cb.value != ""){
			var LvarCodigos = "";
			var LvarCbo = null;

			//document.formFiltro.EcodigoPago_F.disabled = true;
			//document.formFiltro.Miso4217Pago_F.disabled = true;
			LvarCodigos = cb.value.split(",");

			LvarCbo = document.formFiltro.EcodigoPago_F;
			LvarCbo.disabled = true;
			for (var i=0; i<LvarCbo.options.length; i++)
			{
				if (LvarCbo.options[i].value == LvarCodigos[1])
				{
				  LvarCbo.selectedIndex = i;
				  break;
				}
			}

			LvarCbo = document.formFiltro.Miso4217Pago_F;
			LvarCbo.disabled = true;
			for (var i=0; i<LvarCbo.options.length; i++)
			{
				if (LvarCbo.options[i].value == LvarCodigos[2])
				{
				  LvarCbo.selectedIndex = i;
				  break;
				}
			}
		}else{
			document.formFiltro.EcodigoPago_F.disabled = false;
			document.formFiltro.Miso4217Pago_F.disabled = false;
		}
	}
	cambioCB(document.formFiltro.CBidPago_F);
	document.formFiltro.TESid.focus();
</script>
