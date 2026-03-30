<cfif isdefined("Url.IDpago") and not isdefined("Form.IDpago")>
	<cfparam name="Form.IDpago" default="#Url.IDpago#">
</cfif>
<cfif isdefined("Url.NC_linea") and not isdefined("Form.NC_linea")>
	<cfparam name="Form.NC_linea" default="#Url.NC_linea#">
</cfif>
<cfparam name="selectedAPagosCxP.NC_RPTCietu"   default="2">
<cfparam name="selectedAPagosCxP.NC_CPTcodigo"  default="">
<cfparam name="selectedAPagosCxP.id_direccion"  default="">
<cfparam name="selectedAPagosCxP.NC_RPTCid"     default="">
<cfparam name="selectedAPagosCxP.recordcount"   default="0">
<cfparam name="selectedAPagosCxP.NC_Total"      default="0">

<cfparam name="ModoAnticipo" 					default="ALTA">
<cfif isdefined('form.IDpago') and isdefined('form.NC_linea') and len(trim(form.NC_linea))>
	<cfset ModoAnticipo = "CAMBIO">
	<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_getAnticipo" returnvariable="selectedAPagosCxP">
		<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
		<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
		<cfinvokeargument name="NC_linea"       value="#form.NC_linea#">
	</cfinvoke>
</cfif>
<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoEncabezado" returnvariable="rsPagos">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
</cfinvoke>
<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_getAnticipo" returnvariable="rsAPagosCxP">
	<cfinvokeargument name="Conexion" 	       value="#session.dsn#">
	<cfinvokeargument name="IDpago"       	   value="#form.IDpago#">
	<cfinvokeargument name="nameIDpago"        value="IDpago_key">
	<cfinvokeargument name="nameNC_Ddocumento" value="NC_Ddocumento_key">
</cfinvoke>
<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoDirecciones" returnvariable="direcciones">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
</cfinvoke>
<cfinvoke component="sif.Componentes.CP_Anticipos" method="CP_GetAnticipoTotales" returnvariable="rsAPagosCxPTotal">
	<cfinvokeargument name="Conexion" 	    value="#session.dsn#">
	<cfinvokeargument name="IDpago"       	value="#form.IDpago#">
</cfinvoke>
<cfif ModoAnticipo EQ 'ALTA'> 
	<cfset selectedAPagosCxP.NC_Ddocumento = rsPagos.EPdocumento>
</cfif>
<cfif selectedAPagosCxP.recordcount EQ 0>
	<cfset selectedAPagosCxP.NC_total = rsAPagosCxPTotal.DisponibleAnticipos>
</cfif>
<cfquery name="rsParam" datasource="#session.DSN#">
	select Pvalor
	from Parametros
	where Ecodigo =  #Session.Ecodigo# 
	  and Pcodigo = 2
</cfquery>
<cf_dbfunction name="sPart"	args="a.CPTdescripcion,1,10" returnvariable="CPTdescripcion10">
<cf_dbfunction name="sPart"	args="a.CPTdescripcion,1,20" returnvariable="CPTdescripcion20">
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	select 	a.CPTcodigo, 
			case when coalesce(a.CPTvencim,0) < 0 then <cf_dbfunction name="concat"	args="#CPTdescripcion10# + ' (contado)'" delimiters="+"> else #CPTdescripcion20# end as CPTdescripcion,
			case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end as CPTorden,
			a.CPTtipo
	<cfif isdefined("form.NC_CPTcodigo") and (isdefined("form.SNcodigo") and LEN(TRIM(form.SNcodigo)))>
			, case when ctas.CFcuenta is null
				then
					(
						select min(rtrim(CFformato))
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxp
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
						select min(CFdescripcion)
						  from CFinanciera
						 where Ccuenta = n.SNcuentacxp
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
				then n.SNcuentacxp
				else
					(
						select Ccuenta
						  from CFinanciera
						 where CFcuenta = ctas.CFcuenta
					)
				end
			as Ccuenta
	  from CPTransacciones a
	  	 inner join SNegocios n
		 	 on n.Ecodigo 	= #session.Ecodigo#
			and n.SNcodigo 	= #form.SNcodigo#
	  	 left join SNCPTcuentas ctas
		 	 on ctas.Ecodigo 	= #session.Ecodigo#
			and ctas.SNcodigo 	= #form.SNcodigo#
			and ctas.CPTcodigo 	= a.CPTcodigo
	<cfelse>
	  from CPTransacciones a
	</cfif>
	 where a.Ecodigo =  #Session.Ecodigo# 
	   and a.CPTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D">
	   and coalesce(a.CPTpago,0) != 1
	   and NOT a.CPTdescripcion like '%Tesorer_a%'
	order by case when coalesce(a.CPTvencim,0) >= 0 then 1 else 2 end, a.CPTcodigo
</cfquery>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_GenAnt 	= t.Translate('LB_GenAnt','Generar Anticipo')>
<cfset MSG_DigDoct 	= t.Translate('MSG_DigDoct','Debe Digitar un Documento.')>
<cfset MSG_SelTrans	= t.Translate('MSG_SelTrans','Debe seleccionar una transacción.')>
<cfset MSG_SelCta 	= t.Translate('MSG_SelCta','Debe seleccionar una cuenta.')>
<cfset MSG_SelDir 	= t.Translate('MSG_SelDir','Debe seleccionar una Dirección.')>
<cfset MSG_MontoMay = t.Translate('MSG_MontoMay','El monto del Anticipo tiene que ser mayor a cero.')>
<cfset MSG_SelConcP = t.Translate('MSG_SelConcP','Debe seleccionar un concepto de Pago.')>
<cfset MSG_RevDatos = t.Translate('MSG_RevDatos','Por favor revise los siguiente datos:')>
<cfset MSG_MonAnt 	= t.Translate('MSG_MonAnt','El monto del anticipo no puede ser mayor al disponible en el documento de pago!')>
<cfset LB_GenerAnt 	= t.Translate('LB_GenerAnt','Generación de Anticipos')>
<cfset LB_DocPago 	= t.Translate('LB_DocPago','Documento del Pago:')>
<cfset LB_TransPago = t.Translate('LB_TransPago','Transacci&oacute;n del Pago')>
<cfset LB_Proveedor = t.Translate('LB_Proveedor','Proveedor','/sif/generales.xml')>
<cfset LB_FecPago 	= t.Translate('LB_FecPago','Fecha del Pago')>
<cfset LB_ArchGen 	= t.Translate('LB_ArchGen','Anticipos Generados')>
<cfset LB_DispAnt 	= t.Translate('LB_DispAnt','Disponible para Anticipo')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacción','/sif/generales.xml')>
<cfset LB_DirFact = t.Translate('LB_DirFact','Direcci&oacute;n facturaci&oacute;n')>
<cfset LB_Ninguna = t.Translate('LB_Ninguna','Ninguna')>
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset MSG_AfIETU = t.Translate('MSG_AfIETU','Afectar IETU inmediato')>
<cfset LB_No = t.Translate('LB_No','No')>
<cfset LB_Si = t.Translate('LB_Si','Si')>
<cfset LB_ConcPago 	= t.Translate('LB_ConcPago','Concepto Pago')>
<cfset LB_Total 	= t.Translate('LB_Total','Total')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_NoTiene 	= t.Translate('LB_NoTiene','No tiene')>

<html>
<head>
<title><cfoutput>#LB_GenAnt#</cfoutput></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
</head>

<body>
<cfoutput>
<script language="JavaScript" type="text/javascript">

	botonActual = "";
	
	function setBtn(boton) {
		botonActual = boton.name;
	}
	
	function btnSelected(name) {
		return (botonActual == name)
	}
	


	function valida(f) {
		if (btnSelected("btnGenerar") || btnSelected("btnModificar")) {
			var error_input;
			var error_msg = '';
			if (f.NC_Ddocumento.value == "") {
				error_msg += "\n - #MSG_DigDoct#";
				error_input = f.NC_Ddocumento;
			}			
			if (f.NC_CPTcodigo.value == "") {
				error_msg += "\n - #MSG_SelTrans#";
				error_input = f.NC_CPTcodigo;
			}
			if (f.Ccuenta.value == "") {
				error_msg += "\n - #MSG_SelCta#";
				error_input = f.Ccuenta.value;
			}
			if (f.id_direccion.value == "") {
				error_msg += "\n - #MSG_SelDir#";
				error_input = f.id_direccion.value;
			}
			if (f.NC_total.value <= 0) {
				error_msg += "\n - #MSG_MontoMay#";
				error_input = f.NC_total.value;
			}
			if (f.NC_RPTCietu.value == 3 && f.NC_RPTCid.value =="") {
				error_msg += "\n - #MSG_SelConcP#";
				error_input = f.NC_RPTCietu.value;
			}
			if (error_msg.length != "") {
				alert("#MSG_RevDatos#"+error_msg);
				return false;
			}
		}
			<cfif ModoAnticipo EQ 'ALTA'>
				<cfset limiteAnticipo = rsAPagosCxPTotal.DisponibleAnticipos>
			<cfelse>
				<cfset limiteAnticipo = rsAPagosCxPTotal.DisponibleAnticipos + selectedAPagosCxP.NC_total >
			</cfif>
			if (parseFloat(qf(f.NC_total.value)) > <cfoutput>#limiteAnticipo#</cfoutput>) {
				alert("#MSG_MonAnt#");
				f.NC_total.value = fm(<cfoutput>#limiteAnticipo#</cfoutput>, 2);
				return false;
			}
		f.NC_total.value = qf(f.NC_total.value);
		return true;
	}
</script>
</cfoutput>
<cfflush interval="64">
<cfoutput>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="#LB_GenerAnt#">
</cfoutput>
  <form name="form1" method="post" action="Anticipo-sql.cfm" onSubmit="return valida(this);">
   		<cfoutput>
				<input name="IDpago" 	type="hidden" id="IDpago" value="#Form.IDpago#">
			<cfif ModoAnticipo EQ 'CAMBIO'> 
				<input name="LineAnticipo" 	type="hidden" id="LineAnticipo" value="#Form.NC_linea#">
			</cfif>
		</cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="2">
  	<tr> 
    	<td colspan="2"> 
        	<table width="100%" cellpadding="2" cellspacing="0">
          		<tr> 
					<td width="27%"><strong><cfoutput>#LB_DocPago#</cfoutput></strong></td>
					<td width="22%"><cfoutput>#rsPagos.EPdocumento#</cfoutput></td>
					<td width="5%">&nbsp;</td>
					<td width="25%"><strong><cfoutput>#LB_TransPago#:</cfoutput></strong></td>
					<td width="21%"><cfoutput>#rsPagos.CPTdescripcion#</cfoutput></td>
			  	</tr>
          		<tr> 
					<td><strong><cfoutput>#LB_Proveedor#:</cfoutput></strong></td>
					<td><cfoutput>#rsPagos.SNnombre#</cfoutput></td>
					<td>&nbsp;</td>
					<td><strong><cfoutput>#LB_FecPago#:</cfoutput></strong></td>
					<td><cfoutput>#rsPagos.EPfecha#</cfoutput></td>
          		</tr>
          		<tr> 
            		<td><strong><cfoutput>#LB_ArchGen#:</cfoutput></strong></td>
           			<td> 
                    	<cfoutput>
              			<cfif rsAPagosCxPTotal.TotalAnticipos NEQ 0>
               				#LSCurrencyFormat(rsAPagosCxPTotal.TotalAnticipos, 'none')# 
                		<cfelse>
                			#LB_NoTiene# 
              			</cfif>
                        </cfoutput>
            		</td>
          		</tr>
          		<tr>
            		<td><strong><cfoutput>#LB_DispAnt#:</cfoutput></strong></td>
            		<td><cfoutput>#LSCurrencyFormat(rsAPagosCxPTotal.DisponibleAnticipos, 'none')#</cfoutput></td>
          		</tr>
        	</table>
      	</td>
	</tr>
    <tr> 
    	<td width="15%"><cfoutput>#LB_Documento#:</cfoutput></td>
      	<td width="85%"> 
        	<input name="NC_Ddocumento" type="text" id="NC_Ddocumento" size="20" maxlength="20" value="<cfoutput>#selectedAPagosCxP.NC_Ddocumento#</cfoutput>">
      	</td>
    </tr>
    <tr> 
    	<td><cfoutput>#LB_Transaccion#:</cfoutput></td>
      	<td> 
			<select name="NC_CPTcodigo" onChange="sbCPTcodigoOnChange(this.value);">
				<option value=""></option>
			  <cfoutput query="rsTransacciones"> 
				<option value="#CPTcodigo#" <cfif selectedAPagosCxP.NC_CPTcodigo EQ rsTransacciones.CPTcodigo>selected</cfif>>#CPTdescripcion#</option>
			  </cfoutput> 
			</select>
     	</td>
    </tr>
	<tr>
		<td nowrap><cfoutput>#LB_DirFact#:</cfoutput></td>
		<td colspan="12">
			<select style="width:450px" name="id_direccion" id="id_direccion"  onChange="sbid_direccionOnChange(this.value);">
				<option value=""><cfoutput>- #LB_Ninguna# -</cfoutput></option>
				<cfoutput query="direcciones">
					<option value="#id_direccion#" <cfif id_direccion eq selectedAPagosCxP.id_direccion>selected</cfif>>#HTMLEditFormat(texto_direccion)#</option>
				</cfoutput>
			</select>
		</td> 
	</tr>
    <tr> 
      <td><cfoutput>#LB_Cuenta#:</cfoutput></td>
      <td> 
	  	<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
			<input 	type="hidden" 	name="Ccuenta" 	id="Ccuenta"  	VALUE="<cfif ModoAnticipo EQ 'CAMBIO'><cfoutput>#selectedAPagosCxP.Ccuenta#</cfoutput></cfif>">
			<input	type="text"		name="NC_Ccuenta" 	id="NC_Ccuenta" VALUE="<cfif ModoAnticipo EQ 'CAMBIO'><cfoutput>#selectedAPagosCxP.CFformato# - #selectedAPagosCxP.CFdescripcion#</cfoutput></cfif>" size="70" style="border:none;" readonly="yes" tabindex="-1">
		<cfelse>
			<cfif ModoAnticipo EQ 'CAMBIO'>
				<cf_cuentas Conexion="#Session.DSN#" Conlis="S" query="#selectedAPagosCxP#" auxiliares="N" movimiento="S" 
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
			#MSG_AfIETU#: 
		</td>
         <td  colspan="2" align="left">
				<select name="NC_RPTCietu" id="NC_RPTCietu" onChange="this.form.NC_RPTCid.disabled = (this.value==2)">
					<option value="2" <cfif selectedAPagosCxP.NC_RPTCietu EQ 2>selected</cfif>>#LB_No#</option>
					<option value="3" <cfif selectedAPagosCxP.NC_RPTCietu EQ 3>selected</cfif>>#LB_Si#</option>
				</select>
				#LB_ConcPago#:
			   	<cf_cboTESRPTCid value="#selectedAPagosCxP.NC_RPTCid#" tabindex="1" SNid="#rsPagos.SNid#" name="NC_RPTCid" disabled="#selectedAPagosCxP.NC_RPTCietu EQ 2#">
		</td>
        </cfoutput>
	</tr>
    <tr> 
      <td><cfoutput>#LB_Total#:</cfoutput></td>
      <td> 
        <input name="NC_total" type="text" id="NC_total" style="text-align: right"  value="<cfoutput>#LSCurrencyFormat(selectedAPagosCxP.NC_total, 'none')#</cfoutput>" size="17" maxlength="17" onFocus="this.value=qf(this); this.select();" onBlur="fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
      </td>
    </tr>
    <tr> 
      <td colspan="2">
	 
      </td>
    </tr>
    <tr align="center"> 
      <td colspan="2"> 
	  <cfif ModoAnticipo EQ 'ALTA'>
        <input name="btnGenerar" 	type="submit" id="btnGenerar" 	class="btnGuardar"  value="Aceptar"   onClick="javascript: setBtn(this);">
	  <cfelse>
	  	<input name="btnModificar" 	type="submit" id="btnModificar" class="btnGuardar" 	value="Modificar" onClick="javascript: setBtn(this);">
		<input name="btnBorrar" 	type="submit" id="btnBorrar" 	class="btnEliminar" value="Borrar Anticipo">
		<input name="btnNuevo" 	    type="submit" id="btnNuevo" 	class="btnNuevo"    value="Nuevo">
	  </cfif>
        <input name="btnCerrar" 	type="button" id="btnCerrar"   	class="btnNormal" 	value="Cerrar" 	   onClick="javascript: setBtn(this); window.close();">
      </td>
    </tr>
	<!---Listado de los Anticipos--->
	<tr>
		<td colspan="2">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" >
				<cfinvokeargument name="query" 				value="#rsAPagosCxP#"/>
				<cfinvokeargument name="desplegar" 			value="NC_Ddocumento_key,NC_CPTcodigo,NC_total"/>
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
  <cf_web_portlet_end>
	<cfif isdefined("url.reload")>
		<script language="JavaScript" type="text/javascript">
			parent.opener.document.form1.Anticipo.value = "1";
			parent.opener.document.form1.submit();
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
		LvarArrCcuenta  ["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.Ccuenta#";
		LvarArrCFformato["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.CFformato#";
		LvarArrCFdescripcion["#rsTransacciones.CPTcodigo#"] = "#rsTransacciones.CFdescripcion#";
	<cfelse>
		LvarArrCcuenta  ["#rsTransacciones.CPTcodigo#"] = "";
		LvarArrCFformato["#rsTransacciones.CPTcodigo#"] = "";
		LvarArrCFdescripcion["#rsTransacciones.CPTcodigo#"] = "";
	</cfif>
</cfoutput>
	function sbCPTcodigoOnChange (NC_CPTcodigo)
	{
		if (NC_CPTcodigo != ""){
			document.getElementById("Ccuenta").value 	= LvarArrCcuenta  [NC_CPTcodigo];
			<cfif isdefined("rsParam") and rsParam.Pvalor EQ 'N'>
				document.getElementById("NC_Ccuenta").value 		= LvarArrCFformato[NC_CPTcodigo] + ': ' + LvarArrCFdescripcion[NC_CPTcodigo];
			<cfelse>
				var LvarCFformato = LvarArrCFformato[NC_CPTcodigo];
				document.getElementById("Cmayor").value 		= LvarCFformato.substring(0,4);
				document.getElementById("Cformato").value 		= LvarCFformato.substring(5,100);
				document.getElementById("Cfdescripcion").value 	= LvarArrCFdescripcion[NC_CPTcodigo];
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
	<cfif isdefined("rsTransacciones.CFformato") and isdefined('form.NC_CPTcodigo') and LEN(TRIM(form.NC_CPTcodigo)) 
		and isdefined('form.NC_Total') and form.NC_Total EQ 0>
	sbCPTcodigoOnChange ("#form.NC_CPTcodigo#");	
	</cfif>
</cfoutput>
</script>
