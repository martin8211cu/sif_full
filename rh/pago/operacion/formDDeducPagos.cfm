<cfif isDefined("Url.DDpagopor") and not isDefined("Form.DDpagopor")>
	<cfset Form.DDpagopor = Url.DDpagopor>
</cfif>
<cfif isDefined("Url.DRNlinea") and not isDefined("Form.DRNlinea")>
	<cfset Form.DRNlinea = Url.DRNlinea>
</cfif>
<cfif isDefined("Url.formName") and not isDefined("Form.formName")>
	<cfset Form.formName = Url.formName>
</cfif>
<cfif isDefined("Url.deducciones") and not isDefined("Form.deducciones")>
	<cfset Form.deducciones = Url.deducciones>
</cfif>
<cfset Title =  iif(isDefined("Form.DDpagopor") and Form.DDpagopor neq 0,DE("Detalle de Otras Cargas Patrono"),DE("Detalle de Otras Deducciones Pagos"))>
<cfquery name="rsDDP" datasource="#Session.DSN#">
	select a.DDlinea, DDdescripcion,
	case isnull(substring(a.DDdescripcion,35,1),'') when '' then substring(a.DDdescripcion,1,35) else substring(a.DDdescripcion,1,31) + '...' end ShowDDdescripcion,
	a.DDmonto, a.CBcc, a.Mcodigo, DDnombre,
	case isnull(substring(a.DDnombre,35,1),'') when '' then substring(a.DDnombre,1,35) else substring(a.DDnombre,1,31) + '...' end ShowDDnombre,
	a.DDidbeneficiario, a.DDpago, a.DDpagopor, b.Msimbolo, b.Miso4217
	from DDeducPagos a, Monedas b
	where a.Mcodigo = b.Mcodigo and 
	DRNlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DRNlinea#">
	and DDpagopor = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DDpagopor#">
</cfquery>
<cfquery name="rsTotalDeduc" dbtype="query">
	select sum(DDmonto) as Total from rsDDP
</cfquery>
<script language="JavaScript" type="text/javascript" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//funciones utilizadas en el form
	function setBtn(obj) {
		var result = true;
		switch(obj.alt){
		case '0'://No se usa
			break;
		case '1'://Agregar
			document.form1.Accion.value="Alta";
			break;
		case '2'://limpiar
			break;
		case '3'://Modificar
			document.form1.Accion.value="Cambio";
			break;
		case '4'://Borrar
			if (confirm("¿Desea eliminar el registro?"))
				document.form1.Accion.value="Baja";
			else
				result = false;
			break;
		case '5'://Nuevo
			break;
		}
		if (obj.alt in[4]) fnNoValidar();//en la lista [] meter las acciones que no requieren validación.
		return result;
	}
	function fnNoValidar() {
		objForm.DDidbeneficiario.required = false;
		objForm.DDidbeneficiario.validate = false;
		objForm.DDnombre.required = false;
		objForm.DDnombre.validate = false;
		objForm.CBcc.required = false;
		objForm.CBcc.validate = false;
		objForm.Mcodigo.required = false;
		objForm.DDmonto.required = false;
		objForm.DDmonto.validate = false;
		objForm.DDdescripcion.required = false;
		objForm.DDdescripcion.validate = false;
	}
	function initpage() {
	}
	function setDeducOnParent() {
		<cfoutput>
		<cfif rsTotalDeduc.RecordCount gt 0>
			window.opener.document.#Form.formName#.#Form.deducciones#.value="#LSCurrencyFormat(rsTotalDeduc.Total,'none')#";
		<cfelse>
			window.opener.document.#Form.formName#.#Form.deducciones#.value="0.00";
		</cfif>
		</cfoutput>
	}
	function fnFinalizar() {
		document.form1.DDmonto.value = qf(document.form1.DDmonto);
	}
	//Funcion de Cambio a modo Cambio
	function fnModificar(_DDlinea) {
		resetDivs();
		<cfoutput query="rsDDP">
			if ('#DDlinea#'==_DDlinea){
				//Pone los valores a los campos
				document.form1.DDlinea.value='#Trim(DDlinea)#';
				document.form1.DDidbeneficiario.value='#Trim(DDidbeneficiario)#';
				document.form1.DDnombre.value='#Trim(DDnombre)#';
				document.form1.CBcc.value='#Trim(CBcc)#';
				//document.form1.Mcodigo.value='#Trim(Mcodigo)#';
				for (i = 0;i<document.form1.Mcodigo.length;i++) {
					if ('#Trim(Mcodigo)#'==document.form1.Mcodigo.options[i].value)
						document.form1.Mcodigo.options[i].selected=true;
					else
						document.form1.Mcodigo.options[i].selected=false;
				}
				document.form1.DDmonto.value='#LSCurrencyFormat(Trim(DDmonto),'none')#';
				document.form1.DDpago.checked = (#DDpago#==1);
				document.form1.DDdescripcion.value='#Trim(DDdescripcion)#';
				document.form1.DDidbeneficiario.focus();
				document.form1.DDidbeneficiario.select();
				//Pone los botones adecuados
				var div_butsAlta = document.getElementById("div_butsAlta");
				var div_butsCambio = document.getElementById("div_butsCambio");
				div_butsAlta.style.display = 'none';
				div_butsCambio.style.display = '';
				//Pone el Registro que se está modificando en Rojo
				var div_#DDlinea#Black1 = document.getElementById("div_#DDlinea#Black1");
				var div_#DDlinea#Black2 = document.getElementById("div_#DDlinea#Black2");
				var div_#DDlinea#Black3 = document.getElementById("div_#DDlinea#Black3");
				var div_#DDlinea#Red1 = document.getElementById("div_#DDlinea#Red1");
				var div_#DDlinea#Red2 = document.getElementById("div_#DDlinea#Red2");
				var div_#DDlinea#Red3 = document.getElementById("div_#DDlinea#Red3");
				div_#DDlinea#Black1.style.display = 'none';
				div_#DDlinea#Black2.style.display = 'none';
				div_#DDlinea#Black3.style.display = 'none';
				div_#DDlinea#Red1.style.display = '';
				div_#DDlinea#Red2.style.display = '';
				div_#DDlinea#Red3.style.display = '';
			}
		</cfoutput>
	}
	function resetDivs() {
		<cfoutput query="rsDDP">
			//Pone los botones adecuados
			var div_butsAlta = document.getElementById("div_butsAlta");
			var div_butsCambio = document.getElementById("div_butsCambio");
			div_butsAlta.style.display = '';
			div_butsCambio.style.display = 'none';
			//Pone el Registro que se está modificando en Rojo
			var div_#DDlinea#Black1 = document.getElementById("div_#DDlinea#Black1");
			var div_#DDlinea#Black2 = document.getElementById("div_#DDlinea#Black2");
			var div_#DDlinea#Black3 = document.getElementById("div_#DDlinea#Black3");
			var div_#DDlinea#Red1 = document.getElementById("div_#DDlinea#Red1");
			var div_#DDlinea#Red2 = document.getElementById("div_#DDlinea#Red2");
			var div_#DDlinea#Red3 = document.getElementById("div_#DDlinea#Red3");
			div_#DDlinea#Black1.style.display = '';
			div_#DDlinea#Black2.style.display = '';
			div_#DDlinea#Black3.style.display = '';
			div_#DDlinea#Red1.style.display = 'none';
			div_#DDlinea#Red2.style.display = 'none';
			div_#DDlinea#Red3.style.display = 'none';
		</cfoutput>	
	}
</script>
<html>
<head>
	<title><cfoutput>#Title#</cfoutput></title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<cf_templatecss>
<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<body onUnload="javascript: setDeducOnParent();">
	<form name="form1" action="SQLDDeducPagos.cfm" method="post" onSubmit="javascript: fnFinalizar();">
	<cf_web_portlet_start titulo="#title#">
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Identificación del Beneficiario :</td><!--- sifsociosnegociosFA --->
			<td nowrap>
				<input type="text" name="DDidbeneficiario" size="30" maxlength="30" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Nombre del Beneficiario :</td><!--- sifsociosnegociosFA --->
			<td nowrap>
				<input type="text" name="DDnombre" size="40" maxlength="80" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Cuenta Cliente :</td><!--- Cuentas Cliente --->
			<td nowrap>
				<input type="text" name="CBcc" size="30" maxlength="25" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Moneda de la Cuenta :</td><!--- sifmonedas --->
			<td nowrap>
				<cf_sifmonedas tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Monto :</td><!--- Money --->
			<td nowrap>
				<input name="DDmonto" type="text" size="20" maxlength="18" style="text-align: right"  onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,2);"  onkeyup="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="0.00" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Pago Electr&oacute;nico :</td><!--- Check --->
			<td nowrap>
				<input type="checkbox" name="DDpago" tabindex="1">
				<input type="hidden" value="<cfoutput>#Form.DDpagopor#</cfoutput>" name="DDpagopor">
				<input type="hidden" value="<cfoutput>#Form.DRNlinea#</cfoutput>" name="DRNlinea">
				<input type="hidden" value="<cfoutput>#Form.formName#</cfoutput>" name="formName">
				<input type="hidden" value="<cfoutput>#Form.deducciones#</cfoutput>" name="deducciones">
				<input type="hidden" value="" name="Accion">
				<input type="hidden" value="" name="DDlinea">
			</td>
		  </tr>
		  <tr>
			<td nowrap align="right" class="fileLabel">Descripci&oacute;n :</td><!--- Text--->
			<td nowrap>
				<input type="text" name="DDdescripcion" size="40" maxlength="60" tabindex="1">
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <tr>
		  <!--- Lista --->
			<td nowrap colspan="2">
				<table width="85%" align="center" border="0" cellspacing="0" cellpadding="0" >
          <tr> 
            <td width="40%" class="tituloListas" nowrap>Descripci&oacute;n</td>
            <td width="40%"class="tituloListas" nowrap>Beneficiario</td>
            <td align="right" width="20%"class="tituloListas" nowrap>Monto</td>
          </tr>
          <cfloop query="rsDDP">
            <cfoutput>
			  <tr> 
				<td nowrap>
					<div id="div_#DDlinea#Black1" style="display:;"><a href="javascript: fnModificar('#DDlinea#');">#rsDDP.ShowDDdescripcion#</a></div>
					<div id="div_#DDlinea#Red1" style="display:none;"><a href="javascript: fnModificar('#DDlinea#');"><font color="##FF0000">#rsDDP.ShowDDdescripcion#</font></a></div>
				</td>
				<td nowrap>
					<div id="div_#DDlinea#Black2" style="display:;"><a href="javascript: fnModificar('#DDlinea#');">#rsDDP.ShowDDnombre#</a></div>
					<div id="div_#DDlinea#Red2" style="display:none;"><a href="javascript: fnModificar('#DDlinea#');"><font color="##FF0000">#rsDDP.ShowDDnombre#</font></a></div>
				</td>
				<td nowrap align="right">
					<div id="div_#DDlinea#Black3" style="display:;"><a href="javascript: fnModificar('#DDlinea#');">#LSCurrencyFormat(rsDDP.DDmonto,'none')#</a></div>
					<div id="div_#DDlinea#Red3" style="display:none;"><a href="javascript: fnModificar('#DDlinea#');"><font color="##FF0000">#LSCurrencyFormat(rsDDP.DDmonto,'none')#</font></a></div>
				</td>
              </tr>
            </cfoutput> 
          </cfloop>
          <cfif rsDDP.RecordCount EQ 0>
            <tr> 
              <td nowrap colspan="3" align="center" class="fileLabel"> 
                *** No existen Registros *** </td>
            </tr>
            <input type="hidden" name="total" value="0.00">
            <cfelse>
            <cfoutput> 
              <tr> 
                <td nowrap class="tituloListas" >Total</td>
                <td nowrap class="tituloListas" >&nbsp;</td>
                <td align="right" nowrap class="tituloListas" >#LSCurrencyFormat(rsTotalDeduc.Total,'none')#</td>
              </tr>
              <!--- Se necesita formateado porque es el valor que se va a pintar en la pantalla RNomina --->
              <input type="hidden" name="total" value="#LSCurrencyFormat(rsTotalDeduc.Total,'none')#">
            </cfoutput> 
          </cfif>
        </table>
			</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
		  <!--- Botones --->
		  <tr>
			<td nowrap colspan="2" align="center">
				<div id="div_butsAlta" style="display:;">
				<input name="Agregar" type="submit" value="Agregar" alt="1" onClick="javascript: return setBtn(this);" tabindex="2">
				<input name="Limpiar" type="reset" value="Limpiar" alt="2" tabindex="2">
				</div>
				<div id="div_butsCambio" style="display:none;">
				<input name="Modificar" type="submit" value="Modificar" alt="3" onClick="javascript: return setBtn(this);" tabindex="2">
				<input name="Borrar" type="submit" value="Borrar" alt="4" onClick="javascript: return setBtn(this);" tabindex="2">
				<input name="Nuevo" type="reset" value="Nuevo" alt="5" tabindex="2" onClick="javascript: resetDivs();">
				</div>
		</td>
		  </tr>
		  <tr>
			<td colspan="2">&nbsp;</td>
		  </tr>
	</table>
	<cf_web_portlet_end>
	</form>
</body>
</html>
<script language="JavaScript" type="text/javascript">
	//Inicializa valores de la página
	initpage();
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	//Funciones adicionales de validación
	function _Field_isAlfaNumerico()
	{
		var validchars=" áéíóúabcdefghijklmnñopqrstuvwxyz1234567890/*-+.:,;{}[]|°!$&()=?";
		var tmp="";
		var string = this.value;
		var lc=string.toLowerCase();
		for(var i=0;i<string.length;i++) {
			if(validchars.indexOf(lc.charAt(i))!=-1)tmp+=string.charAt(i);
		}
		if (tmp.length!=this.value.length)
		{
			this.error="El valor para "+this.description+" debe contener solamente caracteres alfanuméricos,\n y los siguientes simbolos: (/*-+.:,;{}[]|°!$&()=?).";
		}
	}
	function _Field_isRango(low, high){var low=_param(arguments[0], 0, "number");
	var high=_param(arguments[1], 9999999, "number");
	var iValue=parseInt(qf(this.value));
	if(isNaN(iValue))iValue=0;
	if((low>iValue)||(high<iValue)){this.error="El campo "+this.description+" debe contener un valor entre "+low+" y "+high+".";
	}}
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isAlfaNumerico", _Field_isAlfaNumerico);
	_addValidator("isRango", _Field_isRango);
	_addValidator("isFecha", _Field_isFecha);	
	//Validaciones del Encabezado
	objForm.DDidbeneficiario.required = true;
	objForm.DDidbeneficiario.description = "Identificación del Beneficiario";
	objForm.DDidbeneficiario.validateAlfaNumerico();
	objForm.DDidbeneficiario.validate = true;
	objForm.DDnombre.required = true;
	objForm.DDnombre.description = "Nombre del Beneficiario";
	objForm.DDnombre.validateAlfaNumerico();
	objForm.DDnombre.validate = true;
	objForm.CBcc.required = true;
	objForm.CBcc.description = "Cuenta Cliente";
	objForm.CBcc.validateNumeric("El valor para " + objForm.CBcc.description + " debe ser numérico.");
	objForm.CBcc.validate = true;
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description = "Moneda";
	objForm.DDmonto.required = true;
	objForm.DDmonto.description = "Salario";
	objForm.DDmonto.validateRango('0','999999999');
	objForm.DDmonto.validate = true;
	objForm.DDdescripcion.required = true;
	objForm.DDdescripcion.description = "Descripción";
	objForm.DDdescripcion.validateAlfaNumerico();
	objForm.DDdescripcion.validate = true;
	objForm.DDidbeneficiario.obj.focus();
</script>