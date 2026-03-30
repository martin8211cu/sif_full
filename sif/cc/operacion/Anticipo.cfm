<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Tit_GenerarAnticipo = t.Translate('Tit_GenerarAnticipo','Generar Anticipo')>
<cfset LB_Notiene = t.Translate('LB_Notiene','No tiene')>
<cfset MSG_SelecTra = t.Translate('MSG_SelecTra','\n - Debe seleccionar una transacción.')>
<cfset MSG_SelecCta = t.Translate('MSG_SelecCta','\n - Debe seleccionar una cuenta.')>
<cfset MSG_SelecDir = t.Translate('MSG_SelecDir','\n - Debe seleccionar una Dirección.')>
<cfset MSG_MontoMayCero = t.Translate('MSG_MontoMayCero','\n - El monto del Anticipo debe ser mayor a cero.')>
<cfset MSG_SelecConCob = t.Translate('MSG_SelecConCob','\n - Debe seleccionar un concepto de cobro.')>
<cfset MSG_RevisarD = t.Translate('MSG_RevisarD','Por favor revise los siguiente datos:')>
<cfset MSG_MontMayDisp = t.Translate('MSG_MontMayDisp','El monto del anticipo no puede ser mayor al disponible en el documento de pago!')>
<cfset Tit_GeneracionAnticipo = t.Translate('Tit_GeneracionAnticipo','Generación de Anticipos')>

<cfif isdefined("Url.CCTcodigo") and not isdefined("Form.CCTcodigo")>
	<cfparam name="Form.CCTcodigo" default="#Url.CCTcodigo#">
</cfif>
<cfif isdefined("Url.Pcodigo") and not isdefined("Form.Pcodigo")>
	<cfparam name="Form.Pcodigo" default="#Url.Pcodigo#">
</cfif>
<cfif isdefined("Url.NC_linea") and not isdefined("Form.NC_linea")>
	<cfparam name="Form.NC_linea" default="#Url.NC_linea#">
</cfif>
<cfparam name="selectedAPagosCxC.NC_RPTCietu"   default="2">
<cfparam name="selectedAPagosCxC.NC_CCTcodigo"  default="">
<cfparam name="selectedAPagosCxC.id_direccion"  default="">
<cfparam name="selectedAPagosCxC.NC_RPTCid"     default="">
<cfparam name="selectedAPagosCxC.recordcount"   default="0">
<cfparam name="selectedAPagosCxC.NC_total"   	default="0">
<cfparam name="ModoAnticipo" 					default="ALTA">

<cfif isdefined('form.CCTcodigo') and isdefined('form.Pcodigo') and isdefined('form.NC_linea') and len(trim(form.NC_linea))>
	<cfset ModoAnticipo = "CAMBIO">
	<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_getAnticipo" returnvariable="selectedAPagosCxC">
		<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
		<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
		<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
		<cfinvokeargument name="NC_linea"       value="#form.NC_linea#">
	</cfinvoke>
</cfif>
<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoEncabezado" returnvariable="rsPagos">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
	<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
</cfinvoke>
<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_GetAnticipoTotales" returnvariable="rsAPagosCxCTotal">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
	<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
</cfinvoke>
<cfinvoke component="sif.Componentes.CC_Anticipos" method="Cc_GetAnticipoDirecciones" returnvariable="direcciones">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
	<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
</cfinvoke>
<cfinvoke component="sif.Componentes.CC_Anticipos" method="CC_getAnticipo" returnvariable="rsAPagosCxC">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="CCTcodigo"      value="#form.CCTcodigo#">
	<cfinvokeargument name="Pcodigo"       	value="#form.Pcodigo#">
	<cfinvokeargument name="CCTcodigoName"  value="CCTcodigo_Key">
	<cfinvokeargument name="PcodigoName"    value="Pcodigo_Key">
</cfinvoke>
<cfif ModoAnticipo EQ 'ALTA'> 
	<cfset selectedAPagosCxC.NC_Ddocumento = rsPagos.Pcodigo>
</cfif>
<cfif selectedAPagosCxC.recordcount EQ 0>
	<cfset selectedAPagosCxCNC_total = rsAPagosCxCTotal.DisponibleAnticipos>
</cfif>
<!---<cf_dump var = "#selectedAPagosCxC.NC_total#">--->
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CCTcodigo, 
			case when coalesce(a.CCTvencim,0) < 0 
				then <cf_dbfunction name="concat" args="substring(a.CCTdescripcion,1,10)+' (contado)'" delimiters="+"> 
				else <cf_dbfunction name="string_part"  args="a.CCTdescripcion, 1, 20">
				end as CCTdescripcion,
			case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end as CCTorden,
			a.CCTtipo

	<cfif isdefined("form.NC_CCTcodigo") and (isdefined("form.SNcodigo") and len(trim(form.SNcodigo)))>
			, case when ctas.CFcuenta is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxc
					)
				else
					(
						select rtrim(CFformato)
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFformato
			, case when ctas.CFcuenta is null
				then
					(
						select CFdescripcion
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxc
					)
				else
					(
						select CFdescripcion
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as CFdescripcion
			, case when ctas.CFcuenta is null
				then n.SNcuentacxc
				else
					(
						select Ccuenta
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as Ccuenta
	  from CCTransacciones a
	  	 inner join SNegocios n
		 	 on n.Ecodigo 	= #session.Ecodigo#
			and n.SNcodigo 	= #form.SNcodigo#
	  	 left join SNCCTcuentas ctas
		 	 on ctas.Ecodigo 	= #session.Ecodigo#
			and ctas.SNcodigo 	= #form.SNcodigo#
			and ctas.CCTcodigo 	= a.CCTcodigo
	<cfelse>
	  from CCTransacciones a
	</cfif>
	 where a.Ecodigo = #Session.Ecodigo#
	   and a.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="C"><!--- 'D' --->
	   and coalesce(a.CCTpago,0) != 1
	   and NOT a.CCTdescripcion like '%Tesorer_a%'
	order by case when coalesce(a.CCTvencim,0) >= 0 then 1 else 2 end, a.CCTcodigo
</cfquery>

<cfquery name="rsCuentaCaja" datasource="#Session.DSN#">
	select Pvalor as Ccuenta
	  from Parametros 
 	 where Ecodigo = #session.Ecodigo#
	   and Pcodigo = 350
</cfquery>

<cfquery name="rsCuentas" datasource="#Session.DSN#">
	select Ccuenta, Cdescripcion 
	from CContables 
	where Ecodigo = #Session.Ecodigo#
	and Cmovimiento='S' 
	and Mcodigo = 2
	order by Ccuenta
</cfquery>

<cfset LvarSNid = rsPagos.SNid>

<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo = #Session.Ecodigo#
	  and Pcodigo = 2
</cfquery>
<html>
<head>
<cfoutput>
<title>#Tit_GenerarAnticipo#</title>
</cfoutput>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
</head>

<body>
<script language="JavaScript" type="text/javascript">

	botonActual = "";
	
	function setBtn(boton) {
		botonActual = boton.name;
	}
	
	function btnSelected(name) {
		return (botonActual == name)
	}
	
	function listo() {
		<cfif isdefined("Form.btnGenerar")>
			parent.opener.document.form1.NC_CCTcodigo.value = "<cfoutput>#Form.NC_CCTcodigo#</cfoutput>"
			parent.opener.document.form1.NC_Ddocumento.value = "<cfoutput>#Form.NC_Ddocumento#</cfoutput>"
			parent.opener.document.form1.NC_Ccuenta.value = "<cfoutput>#Form.Ccuenta#</cfoutput>"
			parent.opener.document.form1.id_direccion.value = "<cfoutput>#Form.id_direccion#</cfoutput>"
			parent.opener.document.form1.NC_total.value = "<cfoutput>#Form.NC_total#</cfoutput>";
				parent.opener.document.form1.ta.value = "<cfoutput>#Form.NC_total#</cfoutput>";
			<cfif Form.NC_total NEQ 0>
				parent.opener.document.form1.AnticipoLabel.value = "<cfoutput>#Form.NC_total#</cfoutput>";
				parent.opener.document.form1.AnticipoLabel.value = fm(parent.opener.document.form1.AnticipoLabel.value, 2);
			<cfelse>
				parent.opener.document.form1.AnticipoLabel.value = "#LB_Notiene#";
			</cfif>
			parent.opener.document.form1.Balance.value = "<cfoutput>#rsPagos.Balance#</cfoutput>";
			parent.opener.document.form1.Anticipo.value = 1;
		<cfelseif isdefined("Form.btnBorrar")>
			parent.opener.document.form1.NC_CCTcodigo.value = ""
			parent.opener.document.form1.NC_Ddocumento.value = "<cfoutput>#rsPagos.Pcodigo#</cfoutput>"
			parent.opener.document.form1.NC_Ccuenta.value = ""
			parent.opener.document.form1.id_direccion.value = ""
			parent.opener.document.form1.NC_total.value = "0.00";
			parent.opener.document.form1.ta.value = "0.00";
			parent.opener.document.form1.AnticipoLabel.value = "#LB_Notiene#";
			parent.opener.document.form1.Balance.value = "<cfoutput>#rsPagos.Balance#</cfoutput>";
			parent.opener.document.form1.Anticipo.value = 0	;
		</cfif>
		parent.opener.document.form1.submit();
		window.close();
	}
	<cfoutput>
	function valida(f) {
		if (btnSelected("btnGenerar") || btnSelected("btnModificar")) {
			var error_input;
			var error_msg = '';
			
			if (f.NC_CCTcodigo.value == "") {
				error_msg += "#MSG_SelecTra#";
				error_input = f.NC_CCTcodigo;
			}
			try {
				if (f.Ccuenta.value == "") {
					error_msg += "#MSG_SelecCta#";
					error_input = f.Ccuenta.value;
				}
			}catch(e){}
			if (f.id_direccion.value == "") {
				error_msg += "#MSG_SelecDir#";
				error_input = f.id_direccion.value;
			}
			if (parseFloat(qf(f.NC_total.value)) <= 0) {
				error_msg += "#MSG_MontoMayCero#";
				error_input = f.NC_total.value;
			}
			
			if (f.NC_RPTCietu.value == 3 && f.NC_RPTCid.value =="") {
				error_msg += "#MSG_SelecConCob#";
				error_input = f.NC_RPTCietu.value;
			}
			if (error_msg.length != "") {
				alert("#MSG_RevisarD#"+error_msg);
				return false;
			}
		}
		<!---<cf_dump var = "#selectedAPagosCxC.NC_total#">--->
		<cfif ModoAnticipo EQ 'ALTA'>
			<cfset limiteAnticipo = rsAPagosCxCTotal.DisponibleAnticipos>
		<cfelse>
			<cfset limiteAnticipo = rsAPagosCxCTotal.DisponibleAnticipos + selectedAPagosCxCNC_total >
		</cfif>
		if (parseFloat(qf(f.NC_total.value)) > <cfoutput>#limiteAnticipo#</cfoutput>) {
			alert("#MSG_MontMayDisp#");
			f.NC_total.value = fm(<cfoutput>#limiteAnticipo#</cfoutput>, 2);
			return false;
		}
		f.NC_total.value = qf(f.NC_total.value);
		return true;
	}
	</cfoutput>
</script>
<cfflush interval="64">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#Tit_GeneracionAnticipo#">
	<form name="form1" method="post" action="Anticipo-sql.cfm" onSubmit="return valida(this);">
		<cfoutput>
			<input name="CCTcodigo" type="hidden" id="CCTcodigo" value="#Form.CCTcodigo#">
			<input name="Pcodigo" 	type="hidden" id="Pcodigo"   value="#Form.Pcodigo#">
			<cfif ModoAnticipo EQ 'CAMBIO'> 
				<input name="LineAnticipo" 	type="hidden" id="LineAnticipo" value="#Form.NC_linea#">
			</cfif>
		</cfoutput>

<cfset LB_DoctoCobro = t.Translate('LB_DoctoCobro','Documento del Cobro')>
<cfset LB_TransPago = t.Translate('LB_TransPago','Transacci&oacute;n del Pago')>
<cfset LB_CLIENTE = t.Translate('LB_CLIENTE','Cliente','/sif/generales.xml')>
<cfset LB_FechCobro = t.Translate('LB_FechCobro','Fecha del Cobro')>
<cfset LB_AnticGen = t.Translate('LB_AnticGen','Anticipos Generados')>
<cfset LB_DispAnt= t.Translate('LB_DispAnt','Disponible para Anticipo')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_DirFact = t.Translate('LB_DirFact','Direcci&oacute;n de facturaci&oacute;n')>
<cfset LB_Seleccionaruna = t.Translate('LB_Seleccionaruna','Seleccionar una')>
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset LB_AfectarIETU = t.Translate('LB_AfectarIETU','Afectar IETU inmediato')>
<cfset LB_NO = t.Translate('LB_NO','NO')>
<cfset LB_SI = t.Translate('LB_SI','SI')>
<cfset LB_ConcCobroTerc = t.Translate('LB_ConcCobroTerc','Concepto Cobro Terceros')>
<cfset LB_Total = t.Translate('LB_Total','Total','/sif/generales.xml')>
<cfset BTN_Aceptar	= t.Translate('BTN_Aceptar','Aceptar','/sif/generales.xml')>
<cfset BTN_Modificar	= t.Translate('BTN_Modificar','Modificar','/sif/generales.xml')>
<cfset BTN_Borrar = t.Translate('BTN_Borrar','Borrar Anticipo')>
<cfset LB_btnNuevo = t.Translate('LB_btnNuevo','Nuevo','/sif/generales.xml')> 
<cfset BTN_Cerrar = t.Translate('BTN_Cerrar','Cerrar','/sif/generales.xml')> 
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')> 
        
  	<table width="100%" border="0" cellspacing="0" cellpadding="2">
		<tr> 
			<td colspan="2"> 
				<table width="100%" cellpadding="2" cellspacing="0">
					<tr> 
					<cfoutput>
						<td width="27%"><strong>#LB_DoctoCobro#:</strong></td>
						<td width="22%"><cfoutput>#rsPagos.Pcodigo#</cfoutput></td>
						<td width="5%">&nbsp;</td>
						<td width="25%"><strong>#LB_TransPago#:</strong></td>
						<td width="21%"><cfoutput>#rsPagos.CCTdescripcion#</cfoutput></td>
					</cfoutput>
					</tr>
					<tr> 
                    	<cfoutput>
						<td><strong>#LB_CLIENTE#:</strong></td>
						<td>#rsPagos.SNnombre#</td>
						<td>&nbsp;</td>
						<td><strong>#LB_FechCobro#:</strong></td>
						<td>#rsPagos.Pfecha#</td>
                        </cfoutput>
					</tr>
					<tr> 
						<td><strong><cfoutput>#LB_AnticGen#:</cfoutput></strong></td>
						<td> 
                        <cfoutput>
							<cfif rsAPagosCxCTotal.TotalAnticipos NEQ 0>
								#LSCurrencyFormat(rsAPagosCxCTotal.TotalAnticipos, 'none')# 
							<cfelse>
								#LB_Notiene# 
							</cfif>
                        </cfoutput>    
						</td>
					</tr>
					<tr>
				</table>
						<td><strong><cfoutput>#LB_DispAnt#:</cfoutput></strong></td>
						<td><cfoutput>#LSCurrencyFormat(rsAPagosCxCTotal.DisponibleAnticipos, 'none')#</cfoutput></td>
					</tr>
	 		</td>
		</tr>
    <tr> 
    	<td><cfoutput>#LB_Documento#</cfoutput></td>
      	<td><input name="NC_Ddocumento" type="text" id="NC_Ddocumento" size="20" value="<cfoutput>#selectedAPagosCxC.NC_Ddocumento#</cfoutput>"></td>
    </tr>
    <tr> 
    	<td><cfoutput>#LB_Transaccion#</cfoutput></td>
      	<td> 
			<select name="NC_CCTcodigo" onChange="sbCCTcodigoOnChange(this.value);">
				<option value=""></option>
			  <cfoutput query="rsTransacciones"> 
				<option value="#CCTcodigo#" <cfif selectedAPagosCxC.NC_CCTcodigo EQ rsTransacciones.CCTcodigo>selected</cfif>>#CCTdescripcion#</option>
			  </cfoutput> 
			</select>
      </td>
    </tr>
	<tr>
		<td align="left" nowrap><cfoutput>#LB_DirFact#:</cfoutput></td>
		<td colspan="9">
			<select style="width:400px" name="id_direccion" id="id_direccion"  onChange="sbid_direccionOnChange(this.value);">
				<option value=""><cfoutput>-- #LB_Seleccionaruna# --</cfoutput></option>
				<cfoutput query="direcciones">
					<option value="#id_direccion#" <cfif id_direccion eq selectedAPagosCxC.id_direccion>selected</cfif>>#HTMLEditFormat(texto_direccion)#</option>
				</cfoutput>
			</select>
		</td> 
	</tr>
	<tr> 
    	<cfoutput><td>#LB_Cuenta#</td></cfoutput>
      	<td> 
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
				<input 	type="hidden" 	name="Ccuenta" 	id="Ccuenta"  	VALUE="<cfif ModoAnticipo EQ 'CAMBIO'>#selectedAPagosCxC.Ccuenta#</cfif>">
				<input	type="text"		name="NC_Ccuenta" 	id="NC_Ccuenta" VALUE="<cfif isdefined('rsCuenta') and rsCuenta.RecordCount><cfoutput>#selectedAPagosCxC.CFformato# - #selectedAPagosCxC.CFdescripcion#</cfoutput></cfif>" size="70" style="border:none;" readonly="yes" tabindex="-1">
			<cfelse>
				<cfif ModoAnticipo EQ 'CAMBIO'>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#selectedAPagosCxC#" auxiliares="N" movimiento="S" 
						ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato"> 
				<cfelse>
					<cf_cuentas Conexion="#Session.DSN#" Conlis="S" auxiliares="N" movimiento="S" 
						ccuenta="Ccuenta" cdescripcion="Cfdescripcion" cformato="Cformato"> 
				</cfif>
			</cfif>
 		</td>
    </tr>
	 <tr>
		<cfoutput>
			<td  align="left">
				#LB_AfectarIETU#:&nbsp; 
			</td>
         	<td  colspan="2" align="left">
				<select name="NC_RPTCietu" id="NC_RPTCietu" onChange="this.form.NC_RPTCid.disabled = (this.value==2)">
					<option value="2" <cfif selectedAPagosCxC.NC_RPTCietu eq 2>selected</cfif>>#LB_NO#</option>
					<option value="3" <cfif selectedAPagosCxC.NC_RPTCietu eq 3>selected</cfif>>#LB_SI#</option>
				</select>
				#LB_ConcCobroTerc#:
			   	<cf_cboTESRPTCid value="#selectedAPagosCxC.NC_RPTCid#" tabindex="1" SNid="#rsPagos.SNid#" name="NC_RPTCid" CxP="no" CxC="yes" disabled="#selectedAPagosCxC.NC_RPTCietu EQ 2#">
			 </td>
		</cfoutput>
		</td>
	 </tr>
    <tr> 
      <td><cfoutput>#LB_Total#</cfoutput></td>
      <td> 
        <input name="NC_total" type="text" id="NC_total" style="text-align: right" value="<cfoutput>#LSCurrencyFormat(selectedAPagosCxCNC_total, 'none')#</cfoutput>" size="17" maxlength="17" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);" onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
      </td>
    </tr>
    <tr align="center"> 
      <td colspan="2"> 
      <cfoutput>
         <cfif ModoAnticipo EQ 'ALTA'>
        	<input name="btnGenerar" 	type="submit" id="btnGenerar" 	class="btnGuardar"  value="#BTN_Aceptar#"   onClick="javascript: setBtn(this);">
	  	<cfelse>
			<input name="btnModificar" 	type="submit" id="btnModificar" class="btnGuardar" 	value="#BTN_Modificar#" onClick="javascript: setBtn(this);">
			<input name="btnBorrar" 	type="submit" id="btnBorrar" 	class="btnEliminar" value="#BTN_Borrar#">
			<input name="btnNuevo" 	    type="submit" id="btnNuevo" 	class="btnNuevo" 	value="#LB_btnNuevo#">
	 	 </cfif>
       	 	<input name="btnCerrar" 	type="button" id="btnCerrar"   	class="btnNormal" 	value="#BTN_Cerrar#" 	   onClick="javascript: setBtn(this); window.close();">
      </cfoutput>
      </td>
      </td>
    </tr>
	<!---Listado de los Anticipos--->
	<tr>
		<td colspan="2">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
				<cfinvokeargument name="query" 				value="#rsAPagosCxC#"/>
				<cfinvokeargument name="desplegar" 			value="NC_Ddocumento,NC_CCTcodigo,NC_total"/>
				<cfinvokeargument name="etiquetas" 			value="#LB_Documento#,#LB_Transaccion#,#LB_Monto#"/>
				<cfinvokeargument name="formatos" 			value="S,S,M"/>
				<cfinvokeargument name="align" 				value="left,left,left"/>
				<cfinvokeargument name="keys" 				value="NC_linea"/>
				<cfinvokeargument name="ira" 				value="Anticipo.cfm"/>
				<cfinvokeargument name="MaxRows" 			value="10"/>
				<cfinvokeargument name="PageIndex" 			value="1"/>
				<cfinvokeargument name="formName" 			value="form1"/>
				<cfinvokeargument name="incluyeForm" 		value="false"/>
				<cfinvokeargument name="totalgenerales" 	value="NC_total"/>
			</cfinvoke>
		</td>
	</tr>
  </table>
	</form>
	<cfif isdefined("url.reload")>
		<script language="JavaScript" type="text/javascript">
			parent.opener.document.form1.Anticipo.value = "1";
			parent.opener.document.form1.submit();
		</script>
	</cfif>
	  <cf_web_portlet_end>
	<cfif isdefined("Form.btnGenerar") or isdefined("Form.btnBorrar")>
		<script language="JavaScript" type="text/javascript">
			listo();
		</script>
	</cfif>
</body>
</html>
<script language="JavaScript1.2" type="text/javascript">

// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA TRANSACCION
var LvarArrCcuenta   = new Array();
	var LvarArrCFformato = new Array();
	var LvarArrCFdescripcion = new Array();
<cfoutput query="rsTransacciones"> 
	<cfif isdefined("rsTransacciones.CFformato")>
		<cfif rsTransacciones.CCTorden eq 2>
		LvarArrCcuenta  ["#rsTransacciones.CCTcodigo#"] = "#rsCuentaCaja.Ccuenta#";
		LvarArrCFformato["#rsTransacciones.CCTcodigo#"] = "#rsCuentaCaja.CFformato#";
		LvarArrCFdescripcion["#rsTransacciones.CCTcodigo#"] = "#rsCuentaCaja.CFdescripcion#";
		<cfelse>
		LvarArrCcuenta  ["#rsTransacciones.CCTcodigo#"] = "#rsTransacciones.Ccuenta#";
		LvarArrCFformato["#rsTransacciones.CCTcodigo#"] = "#rsTransacciones.CFformato#";
		LvarArrCFdescripcion["#rsTransacciones.CCTcodigo#"] = "#rsTransacciones.CFdescripcion#";
		</cfif>
	<cfelse>
		LvarArrCcuenta  ["#rsTransacciones.CCTcodigo#"] = "";
		LvarArrCFformato["#rsTransacciones.CCTcodigo#"] = "";
		LvarArrCFdescripcion["#rsTransacciones.CCTcodigo#"] = "";
	</cfif>
</cfoutput>
	function sbCCTcodigoOnChange (NC_CCTcodigo)
	{
		if (NC_CCTcodigo != ""){
			document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [NC_CCTcodigo];
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
				document.getElementById("NC_Ccuenta").value 		= LvarArrCFformato[NC_CCTcodigo] + ': ' + LvarArrCFdescripcion[NC_CCTcodigo];
			<cfelse>
				var LvarCFformato = LvarArrCFformato[NC_CCTcodigo];
				document.getElementById("Cmayor").value 		= LvarCFformato.substring(0,4);
				document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
				document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[NC_CCTcodigo];
			</cfif>
		}else{
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
			document.getElementById("NC_Ccuenta").value 		= "";
			<cfelse>
				document.getElementById("Cmayor").value 		= "";
				document.getElementById("Cformato").value 		= "";
				document.getElementById("Cfdescripcion").value 	= "";
			</cfif>
		}
	}

// PROCEDIMIENTO PARA CAMBIAR LA CUENTA SEGUN LA DIRECCION
	var LvarArrCcuentaD   = new Array();
	var LvarArrCFformatoD = new Array();
	var LvarArrCFdescripcionD = new Array();
<cfoutput query="direcciones"> 
	<cfif isdefined("direcciones.CFformato")>
		LvarArrCcuentaD  ["#direcciones.id_direccion#"] = "#direcciones.Ccuenta#";
		LvarArrCFformatoD["#direcciones.id_direccion#"] = "#direcciones.CFformato#";
		LvarArrCFdescripcionD["#direcciones.id_direccion#"] = "#direcciones.CFdescripcion#";
	<cfelse>
		LvarArrCcuentaD  ["#direcciones.id_direccion#"] = "";
		LvarArrCFformatoD["#direcciones.id_direccion#"] = "";
		LvarArrCFdescripcionD["#direcciones.id_direccion#"] = "";
	</cfif>
</cfoutput>
	function sbid_direccionOnChange (id_direccion)
	{
		if (id_direccion != ""){
			document.getElementById("Ccuenta").value 	= LvarArrCcuentaD  [id_direccion];
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
				document.getElementById("NC_Ccuenta").value 		= LvarArrCFformatoD[id_direccion] + ': ' + LvarArrCFdescripcionD[id_direccion];
			<cfelse>
				var LvarCFformatoD = LvarArrCFformatoD[id_direccion];
				document.getElementById("Cmayor").value 		= LvarCFformatoD.substring(0,4);
				document.getElementById("Cformato").value 		= LvarCFformatoD.substring(5,100);
				document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcionD[id_direccion];
			</cfif>
		}else{
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
			document.getElementById("NC_Ccuenta").value 		= "";
			<cfelse>
				document.getElementById("Cmayor").value 		= "";
				document.getElementById("Cformato").value 		= "";
				document.getElementById("Cfdescripcion").value 	= "";
			</cfif>
		}
	}
	
<cfoutput>
	<cfif isdefined("rsTransacciones.CFformato") and isdefined('form.NC_CCTcodigo') and LEN(TRIM(form.NC_CCTcodigo))
		and isdefined('form.NC_Total') and form.NC_Total EQ 0>
	sbCCTcodigoOnChange ("#form.NC_CCTcodigo#");	
	</cfif>
</cfoutput>
</script>