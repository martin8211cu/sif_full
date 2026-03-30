<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Titulo  = t.Translate('LB_Titulo','Registro de Cobros')>
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar','listaDocsAFavorCC.cfm')>
<cfset MSG_ElCampo = t.Translate('MSG_ElCampo','El campo')>
<cfset MSG_NoPuedeSer0 = t.Translate('MSG_NoPuedeSer0','no puede ser cero')>
<cfset MSG_ElMontonopuede = t.Translate('MSG_ElMontonopuede','El monto de retención no puede superar el monto del documento')>
<cfset MSG_ElMontodelDoc = t.Translate('MSG_ElMontodelDoc','El monto del documento + retenciones supera el saldo del documento, debe ser inferior o igual a')> 
<cfset MSG_ElMontoDigitado = t.Translate('MSG_ElMontoDigitado','El monto digitado supera el saldo del documento, debe ser inferior o igual a')> 
<cfset MSG_ElMontodelasLineas = t.Translate('MSG_ElMontodelasLineas','El monto de las líneas de detalle supera el monto total del documento de Cobro')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset Oficina 		= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Tipo_de_Cambio = t.Translate('LB_Tipo_de_Cambio','Tipo de Cambio','/sif/generales.xml')>
<cfset LB_MontoMonedaCobro = t.Translate('LB_MontoMonedaCobro','Monto en Moneda del Cobro')>
<cfset LB_MontoMonedaDocto = t.Translate('LB_MontoMonedaDocto','Monto en Moneda del Documento')>
<cfset LB_RetMonedaDocto = t.Translate('LB_RetMonedaDocto','Retención en Moneda del Cobro')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Cuenta = t.Translate('LB_Cuenta','Cuenta','/sif/generales.xml')>
<cfset MSG_DoctoNoBal = t.Translate('MSG_DoctoNoBal','El documento todavía no puede aplicarse porque no está balanceado!')>
<cfset MSG_DeseaAplDocCobr = t.Translate('MSG_DeseaAplDocCobr','¿Está seguro de que desea aplicar el documento de Cobro?')>




<cfif isdefined("Url.pageNum_rsLista") and not isdefined("Form.pageNum_rsLista")>
	<cfparam name="Form.pageNum_rsLista" default="#Url.pageNum_rsLista#">
</cfif>
<cfif isdefined("Url.Fecha") and not isdefined("Form.Fecha")>
	<cfparam name="Form.Fecha" default="#Url.Fecha#">
</cfif>
<cfif isdefined("Url.Transaccion") and not isdefined("Form.Transaccion")>
	<cfparam name="Form.Transaccion" default="#Url.Transaccion#">
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfparam name="Form.Usuario" default="#Url.Usuario#">
</cfif>
<cfif isdefined("Url.Moneda") and not isdefined("Form.Moneda")>
	<cfparam name="Form.Moneda" default="#Url.Moneda#">
</cfif>
<cfif isdefined("Url.Datos") and not isdefined("Form.Datos")>
	<cfparam name="Form.Datos" default="#Url.Datos#">
</cfif>



<cf_templatecss>
<cfoutput>
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" src="PagosCxC.js"></script>

<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<cfflush interval="64">		
		<cfinclude template="formPagosCxC.cfm">
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	var popUpWin=0;
	function funcDocumento(){ 
		obtieneValores(document.form1,document.form1.CodSNcodigo2.value);
	}
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	  window.onfocus=closePopUp; 
	}
	function closePopUp() {
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
		popUpWin = 0;
	  }
	  if (document.form1.F5.value == "F5")
	  	document.form1.CambiarE.click();
	}
	function Lista() {
		var params   = '?pageNum_rsLista='+document.form1.pageNum_rsLista.value;
			params += (document.form1.fecha.value != -1) ? "&fecha=" + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != -1) ? "&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.usuario.value != -1) ? "&usuario=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != -1) ? "&moneda=" + document.form1.moneda.value : '';
		location.href="ListaPagos.cfm" + params;
	}
	function NuevoPago() {
		var params   = '?pageNum_rsLista='+document.form1.pageNum_rsLista.value;
			params += (document.form1.fecha.value != -1) ? "&fecha=" + document.form1.fecha.value : '';
			params += (document.form1.transaccion.value != -1) ? "&transaccion=" + document.form1.transaccion.value : '';
			params += (document.form1.usuario.value != -1) ? "&usuario=" + document.form1.usuario.value : '';
			params += (document.form1.moneda.value != -1) ? "&moneda=" + document.form1.moneda.value : '';
		location.href="PagosCxC.cfm"+params;
	}
	function LimpiarCampos(){
		document.form1.Mcodigod.value = "";
		document.form1.CCTcodigod.value = "";
		document.form1.Ddocumento.value ="";
		document.form1.Ccuentad.value = "";
		document.form1.DPmontodoc.value="0.00";
		document.form1.DPtotal.value="0.00";
		document.form1.Dsaldo.value = "0.00";
		document.form1.DsaldoLabel.value = "0.00";
		document.form1.CcuentadLabel.value = "";
		document.form1.PPnumero.value ="";
		}
	function Editar(data) {
		if (data!="") {
			document.form1.action='PagosCxC.cfm';
			document.form1.datos.value = data;
			document.form1.submit();
		}
		return false;
	}
	function initPage(f) {
		validatcLOAD(f);
	}
	initPage(document.form1);
	function deshabilitarVD(){
		objForm.DTM.required = false;
		objForm.DPtotal.required = false;
		objForm.DPmontodoc.required = false;
		objForm.DPmontoretdoc.required = false;
	}
	function deshabilitarValidacion(boton) {
		objForm.SNcodigo.required = false;
		objForm.Pfecha.required = false;
		objForm.Ocodigo.required = false;
		if (objForm.Ccuenta) objForm.Ccuenta.required = false;
		objForm.Ptotal.required = false;
		objForm.Ptotal.validate = false;
		objForm.DTM.required = false;
		objForm.DPtotal.required = false;
		objForm.DPmontodoc.required = false;
		objForm.DPmontoretdoc.required = false;
	}
/*-------------------------------------------------*/
	function habilitarVE(){
		objForm.SNcodigo.required = true;
		objForm.Pfecha.required = true;
		objForm.Ocodigo.required = true;
		if (objForm.Ccuenta) objForm.Ccuenta.required = true;
		objForm.Ptotal.required = true;
		objForm.Ptotal.validate = true;
	}
	function habilitarValidacion() {
		objForm.SNcodigo.required = true;
		objForm.Pfecha.required = true;
		objForm.Ocodigo.required = true;
		if (objForm.Ccuenta) objForm.Ccuenta.required = true;
		objForm.Ptotal.required = true;
		objForm.Ptotal.validate = true;
		objForm.DTM.required = true;
		objForm.DTM.description = "#LB_Documento#";
		objForm.DPtotal.required = true;
		objForm.DPmontodoc.required = true;
		objForm.DPmontoretdoc.required = true;
	}
/*-------------------------------------------------	*/
	function __isNotCero() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.disabled) && ((this.value == "") || (this.value == " ") || (new Number(qf(this.value)) == 0))) {
			//this.obj.focus();
			this.error = "#MSG_ElCampo# " + this.description + " #MSG_NoPuedeSer0#!";
		}
	}
	// Se aplica sobre el monto del documento
	function __isRetenciones() {
		if ((btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) && (!this.obj.form.DPmontoretdoc.disabled)) {
			// averiguar factor de conversion
			var fc = 1.0;
			if (this.obj.form.FC.value == "calculado") {
				fc = new Number(qf(this.obj.form.DPmontodoc.value)) / new Number(qf(this.obj.form.DPtotal.value));
			} else if (this.obj.form.FC.value == "encabezado") {
				fc = new Number(qf(this.obj.form.Ptipocambio.value));
			}
			var retenciones = new Number(qf(this.obj.form.DPmontoretdoc.value)) * fc;
			if (retenciones > new Number(qf(this.obj.form.DPmontodoc.value))) {
				this.error = "#MSG_ElMontonopuede#!";
			}
			if (!this.obj.form.DPmontodoc.disabled) {
				// Valida Monto de Documento + retenciones contra el saldo del documento
				if ((retenciones + new Number(qf(this.obj.form.DPmontodoc.value))) > (new Number(qf(this.obj.form.Dsaldo.value)))) {
					this.error = "#MSG_ElMontodelDoc# " + this.obj.form.Dsaldo.value;
				}
			}
		}
	}
	// Se aplica sobre el monto del documento
	function __isMontoDoc() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			// Valida Monto de Documento contra saldo del documento
			if ( (parseFloat(qf(this.obj.form.DPmontodoc.value))) > (parseFloat(qf(this.obj.form.Dsaldo.value))) ) {
				if (!this.obj.form.DPmontodoc.disabled) this.obj.form.DPmontodoc.focus();
				else this.obj.form.DPtotal.focus();
				this.error = "#MSG_ElMontoDigitado# " + this.obj.form.Dsaldo.value;
			}
		}
	}
	/*  Valida que el Pago sea menor al disponible en el documento de pago
		Se aplica sobre el monto del documento
		dptotal			= Monto moneda de cobro detalle digitado
		T1				= total cubierto
		dptotalAnterior	= Monto moneda de cobro detalle anterior
	*/
	function __isMontoPago() {
		if (btnSelected("AgregarE") || btnSelected("AgregarD") || btnSelected("CambiarD")) {
			var dptotal 		= new Number( qf(this.obj.form.DPtotal.value)*100 ) 
			var t1      		= new Number( this.obj.form.tl.value*100 );
			var dptotalAnterior	= new Number(this.obj.form.DPtotal_anterior.value*100); 
			if (btnSelected("CambiarD"))
			{
				var total1  = (dptotal+t1-dptotalAnterior)/100; 
				var total1  = Math.round(total1*100)/100;
			}
			else
			{
				var total1  = (dptotal+t1)/100; 
				var total1  = Math.round(total1*100)/100
			}
			var ptotal = new Number( qf(this.obj.form.Ptotal.value)*100 );
			var ta      = new Number(this.obj.form.ta.value)*100;
			var total2  = (ptotal+ta)/100;
			if ( total1 > total2 ) {				
				this.error = "#MSG_ElMontodelasLineas#!";
			}
		}
	}
	qFormAPI.errorColor = "FFFFFF";
	_addValidator("isNotCero", __isNotCero);
	_addValidator("isRetenciones", __isRetenciones);
	_addValidator("isMontoDoc", __isMontoDoc);
	_addValidator("isMontoPago", __isMontoPago);
	objForm = new qForm("form1");
	<cfif modo EQ "ALTA">
		objForm.Pcodigo.obj.focus();
		objForm.Pcodigo.required = true;
		objForm.Pcodigo.description = "#LB_Documento#";
		objForm.CCTcodigo.required = true;
		objForm.CCTcodigo.description = "#LB_Transaccion#";
		objForm.SNcodigo.required = true;
		objForm.SNcodigo.description = "#LB_SocioNegocio#";
		objForm.Pfecha.required = true;
		objForm.Pfecha.description = "#LB_Fecha#";
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "#Oficina#";
		objForm.Ptipocambio.required = true;
		objForm.Ptipocambio.description = "#LB_Tipo_de_Cambio#";
		objForm.Ptipocambio.validateNotCero();
		objForm.Ptotal.required = true;
		objForm.Ptotal.description = "Total";
		objForm.Ptotal.validateNotCero();
	<cfelseif modo EQ "CAMBIO">
		objForm.SNcodigo.required = true;
		objForm.SNcodigo.description = "#LB_SocioNegocio#";
		objForm.Pfecha.required = true;
		objForm.Pfecha.description = "#LB_Fecha#";
		objForm.Ocodigo.required = true;
		objForm.Ocodigo.description = "#Oficina#";
		objForm.Ptotal.required = true;
		objForm.Ptotal.description = "Total";
		objForm.Ptotal.validateNotCero();
		objForm.DPtotal.required = true;
		objForm.DPtotal.description = "#LB_MontoMonedaCobro#";
		objForm.DPtotal.validateNotCero();
		objForm.DPtotal.validateMontoPago();
		objForm.DPmontodoc.required = (!objForm.DPmontodoc.obj.disabled);
		objForm.DPmontodoc.description = "#LB_MontoMonedaDocto#";
		objForm.DPmontodoc.validateNotCero();
		objForm.DPmontodoc.validateMontoDoc();
		objForm.DPmontoretdoc.required = (!objForm.DPmontoretdoc.obj.disabled);
		objForm.DPmontoretdoc.description = "#LB_RetMonedaDocto#";
		objForm.DPmontoretdoc.validateNotCero();
		objForm.DPmontoretdoc.validateRetenciones();
	</cfif>
	//Llamado al popup de seleccion masiva
	function funcPantallaSeleccion(){
		var params ='';
		params = "?SNcodigo="+document.form1.SNcodigo.value+"&pn_disponible="+document.form1.DisponibleLabel.value+"&Mcodigo="+	document.form1.Mcodigo.value+"&Pcodigo="+document.form1.Pcodigo.value+"&CCTcodigo="+document.form1.CCTcodigo.value+"&mantieneFiltro=no";
		popUpWindow("/cfmx/sif/cc/operacion/SeleccionMasiva.cfm"+params,130,100,800,800);
	}
	<cfif modo EQ 'CAMBIO'>
		<cfif isdefined('form.CCTcodigoConlis')>
			document.form1.DPtotal.focus();
		<cfelse>
			document.form1.CCTcodigoConlis.focus();
		</cfif>
	</cfif>
</script>
</cfoutput>