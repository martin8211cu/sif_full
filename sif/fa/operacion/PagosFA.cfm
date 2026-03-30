<!--- Parámetros requeridos --->
<cfif isDefined("Url.FCid")>
	<cfset Form.FCid = Url.FCid>
</cfif>
<cfif isDefined("Url.ETnumero")>
	<cfset Form.ETnumero = Url.ETnumero>
</cfif>
<!--- Modo--->
<cfif isdefined("Form.btnEditar")  or ( isdefined("form.FPlinea") and len(trim(form.FPlinea)) gt 0 )>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<!--- Consultas --->
<!--- 1. Consulta de la transacción --->
<cfquery name="rsETransaccion" datasource="#Session.DSN#">
	select FCid, ETnumero, ETdocumento, ETserie, SNcodigo, ETtotal, Mcodigo, ETtc
	from ETransacciones
	where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FCid#">
	and ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ETnumero#">
</cfquery>
<!--- 2. Consulta los pagos de la transacción por FCid y ETnumero --->
<cfquery name="rsFPagos" datasource="#Session.DSN#">
	select FPlinea, FCid, ETnumero, m.Mnombre, m.Msimbolo, m.Miso4217 , FPtc, 
		FPmontoori, FPmontolocal, FPfechapago, Tipo, 
		case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' end as Tipodesc,
		FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
		FPtipotarjeta
	from FPagos f, Monedas m
	where f.Mcodigo = m.Mcodigo
	and FCid=#rsETransaccion.FCid#
	and ETnumero=#rsETransaccion.ETnumero#
</cfquery>
<!--- 3. Consulta los pagos de la transacción por FPlinea --->
<cfif modo neq "ALTA">
	<cfquery name="rsFPagoLinea" datasource="#Session.DSN#">
		select FPlinea, FCid, ETnumero, Mcodigo, FPtc, 
			FPmontoori, FPmontolocal, FPfechapago, Tipo, 
			FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
			FPtipotarjeta
		from FPagos
		Where FPlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.FPlinea#">
	</cfquery>
</cfif>
<!--- 4. Descripción de la caja de la transacción --->
<cfquery name="rsFCajas" datasource="#Session.DSN#">
	Select FCdesc
	from FCajas
	where FCid=#rsETransaccion.FCid#
</cfquery>
<!--- 5. Nombre del cliente de la transacción --->
<cfquery name="rsSNegocios" datasource="#Session.DSN#">
	Select SNnombre
	from SNegocios
	Where SNcodigo = #rsETransaccion.SNcodigo#
</cfquery>
<!--- 6. Nombre de la moneda de la transacción --->
<cfquery name="rsMonedaTran" datasource="#Session.DSN#">
	Select Mnombre,Msimbolo,Miso4217
	from Monedas
	Where Mcodigo = #rsETransaccion.Mcodigo#
</cfquery>
<!--- 7. Tipos de pagos --->
<cfquery name="rsTPagos" datasource="#Session.DSN#">
	Select 'E' as TPid, 'Efectivo' as TPdesc, 1 as orden
	Union Select 'T' as TPid, 'Tarjeta' as TPdesc, 2 as orden
	Union Select 'C' as TPid, 'Cheque' as TPdesc, 3 as orden
	Union Select 'D' as TPid, 'Deposito' as TPdesc, 4 as orden
	order by orden
</cfquery>
<!--- 8. Tipos de tarjetas --->
<cfquery name="rsTTarjeta" datasource="#Session.DSN#">
	Select 'Visa' as TTdesc, 1 as orden
	Union Select 'Master Card' as TTdesc, 2 as orden
	order by orden
</cfquery>
<!--- 9. Bancos --->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select convert(varchar, Bid) as Bid, Bdescripcion 
	from Bancos 
	where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	order by upper(Bdescripcion)
</cfquery>
<!--- 10. Cuentas Contables --->
<cfquery datasource="#Session.DSN#" name="rsCuenta">
	select convert(varchar, Ccuenta) as Ccuenta, Cdescripcion
	from CContables 
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	  and Cmovimiento='S' 
	  and Mcodigo=6
	  and Ccuenta not in (select b.Ccuenta from EMovimientos a, CuentasBancos b where a.CBid = b.CBid and b.CBesTCE = 0 and a.Ecodigo = b.Ecodigo)
	order by Cdescripcion
</cfquery>
<!--- 11. Moneda Local --->
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select convert(varchar,Mcodigo) as Mcodigo from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 	
</cfquery>
<!--- 12. Cuentas Bancarias ---> 
<cfquery name="rsCuentasBancos" datasource="#Session.DSN#">
	select convert(varchar,Bid) Bid, convert(varchar,CBid) as CBid, CBdescripcion
	from CuentasBancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
      and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">	
	  and CBid not in (Select c.Bid from ECuentaBancaria d, Bancos e, CuentasBancos c
	  					where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                          and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">  
						  and d.Bid = e.Bid and d.CBid = c.CBid and d.ECaplicado = 'N' and d.EChistorico = 'N')
	order by CBcodigo, CBdescripcion
</cfquery>

<script language="JavaScript" type="text/JavaScript">
<!--
<!--- Funciones de Validación del Form --->

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}
function MM_validateForm() { //v4.0
	var i,p,q,nm,test,num,min,max,errors='',args=MM_validateForm.arguments;
	for (i=0; i<(args.length-2); i+=3) { test=args[i+2]; val=MM_findObj(args[i]);
	if (val) { if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
		if (test.indexOf('isEmail')!=-1) { p=val.indexOf('@');
		if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
		} else if (test!='R') { num = parseFloat(qf(val)); 
		if (isNaN(qf(val))) errors+='- '+nm+' debe ser numérico.\n';
		if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			min=test.substring(8,p); max=test.substring(p+1);
			if (num<=min) errors+='- '+nm+' debe ser mayor a ' + min + '.\n';
			if (num>=max) errors+='- '+nm+' debe ser menor a ' + max + '.\n';
	} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	} if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	document.MM_returnValue = (errors == '');
}

// ===========================================================================================
//								Conlis de Cuentas
// ===========================================================================================
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height){
	if(popUpWin) {
	if(!popUpWin.closed) popUpWin.close();
	}
	popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlisCuentas(form, id, desc, mcodigo, Bid) {
	popUpWindow("ConlisCuentasBancarias.cfm?form=form&id=id&desc=desc&mcodigo="+mcodigo+"&Bid="+Bid,250,200,650,350);
}
// ===========================================================================================

function cambiarTipo(tipo) {
	debug = false; if (debug)
		alert("cambiarTipo");
		
	if (tipo == null) {
		tipo = document.form1.Tipo.value;
	}

	var div_A1 = document.getElementById("divA1");
	var div_A2 = document.getElementById("divA2");
	var div_A3 = document.getElementById("divA3");
	var div_A4 = document.getElementById("divA4");
	var div_A5 = document.getElementById("divA5");
	var div_A6 = document.getElementById("divA6");
	
	var div_B1 = document.getElementById("divB1");
	var div_B2 = document.getElementById("divB2");
	var div_B3 = document.getElementById("divB3");
	var div_B4 = document.getElementById("divB4");
	var div_B5 = document.getElementById("divB5");
	var div_B6 = document.getElementById("divB6");

	var div_C1 = document.getElementById("divC1");
	var div_C2 = document.getElementById("divC2");
	var div_C3 = document.getElementById("divC3");
	var div_C4 = document.getElementById("divC4");
	var div_C5 = document.getElementById("divC5");
	var div_C6 = document.getElementById("divC6");

	var div_D1 = document.getElementById("divD1");
	var div_D2 = document.getElementById("divD2");
	var div_D3 = document.getElementById("divD3");
	var div_D4 = document.getElementById("divD4");
	var div_D5 = document.getElementById("divD5");
	var div_D6 = document.getElementById("divD6");

	if (tipo == "E") {
	div_A1.style.display = '';
	div_A2.style.display = '';
	div_A3.style.display = '';
	div_A4.style.display = '';
	div_A5.style.display = '';
	div_A6.style.display = '';
	
	div_B1.style.display = 'none';
	div_B2.style.display = 'none';
	div_B3.style.display = 'none';
	div_B4.style.display = 'none';
	div_B5.style.display = 'none';
	div_B6.style.display = 'none';

	div_C1.style.display = 'none';
	div_C2.style.display = 'none';
	div_C3.style.display = 'none';
	div_C4.style.display = 'none';
	div_C5.style.display = 'none';
	div_C6.style.display = 'none';

	div_D1.style.display = 'none';
	div_D2.style.display = 'none';
	div_D3.style.display = 'none';
	div_D4.style.display = 'none';
	div_D5.style.display = 'none';
	div_D6.style.display = 'none';
	}else if (tipo == "T") {
	div_A1.style.display = 'none';
	div_A2.style.display = 'none';
	div_A3.style.display = 'none';
	div_A4.style.display = 'none';
	div_A5.style.display = 'none';
	div_A6.style.display = 'none';
	
	div_B1.style.display = '';
	div_B2.style.display = '';
	div_B3.style.display = '';
	div_B4.style.display = '';
	div_B5.style.display = '';
	div_B6.style.display = '';

	div_C1.style.display = 'none';
	div_C2.style.display = 'none';
	div_C3.style.display = 'none';
	div_C4.style.display = 'none';
	div_C5.style.display = 'none';
	div_C6.style.display = 'none';

	div_D1.style.display = 'none';
	div_D2.style.display = 'none';
	div_D3.style.display = 'none';
	div_D4.style.display = 'none';
	div_D5.style.display = 'none';
	div_D6.style.display = 'none';
	}else if (tipo == "C") {
	div_A1.style.display = 'none';
	div_A2.style.display = 'none';
	div_A3.style.display = 'none';
	div_A4.style.display = 'none';
	div_A5.style.display = 'none';
	div_A6.style.display = 'none';
	
	div_B1.style.display = 'none';
	div_B2.style.display = 'none';
	div_B3.style.display = 'none';
	div_B4.style.display = 'none';
	div_B5.style.display = 'none';
	div_B6.style.display = 'none';

	div_C1.style.display = '';
	div_C2.style.display = '';
	div_C3.style.display = '';
	div_C4.style.display = '';
	div_C5.style.display = '';
	div_C6.style.display = '';

	div_D1.style.display = 'none';
	div_D2.style.display = 'none';
	div_D3.style.display = 'none';
	div_D4.style.display = 'none';
	div_D5.style.display = 'none';
	div_D6.style.display = 'none';
	}else if (tipo == "D") {
	div_A1.style.display = 'none';
	div_A2.style.display = 'none';
	div_A3.style.display = 'none';
	div_A4.style.display = 'none';
	div_A5.style.display = 'none';
	div_A6.style.display = 'none';
	
	div_B1.style.display = 'none';
	div_B2.style.display = 'none';
	div_B3.style.display = 'none';
	div_B4.style.display = 'none';
	div_B5.style.display = 'none';
	div_B6.style.display = 'none';

	div_C1.style.display = 'none';
	div_C2.style.display = 'none';
	div_C3.style.display = 'none';
	div_C4.style.display = 'none';
	div_C5.style.display = 'none';
	div_C6.style.display = 'none';

	div_D1.style.display = '';
	div_D2.style.display = '';
	div_D3.style.display = '';
	div_D4.style.display = '';
	div_D5.style.display = '';
	div_D6.style.display = '';	
	}
}

function inicio() {
	debug = false; 		
	cambiarTipo();
	cambiarCuentas();
	setTC();
	setMontoLocal();
}

function setMontoLocal() {
	debug = false; 
	if (document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>") {
		document.form1.FPmontolocal.value = document.form1.FPmontoori.value;
	}
	else {
		monto = new Number(qf(document.form1.FPmontoori));
		tc = new Number(qf(document.form1.FPtc));
		document.form1.FPmontolocal.value = monto * tc;
	}
	fm(document.form1.FPmontolocal,2);
	fm(document.form1.FPmontoori,2);
	fm(document.form1.FPtc,2);
	if (debug)
		alert(document.form1.FPmontolocal.value)
}

function setTC() {
	//Cuando la moneda seleccionada es igual a la moneda local el tc es 1. Esto lo hace el Tag.
	//Cuando la moneda seleccionada es igual al de la transaccion el tc es el de la transaccion.
	//En ninguno de estos casos el tc se debe modificar.
	debug = false; 		
	var estado  = document.form1.Mcodigo.value == "<cfoutput>#rsMonedaLocal.Mcodigo#</cfoutput>"
				||document.form1.Mcodigo.value == "<cfoutput>#rsETransaccion.Mcodigo#</cfoutput>";
	document.form1.FPtc.disabled = false;
	if (document.form1.Mcodigo.value == "<cfoutput>#rsETransaccion.Mcodigo#</cfoutput>")
		document.form1.FPtc.value = <cfoutput>#rsETransaccion.ETtc#</cfoutput>;
	else
		document.form1.FPtc.value = document.form1.TC.value;
	fm(document.form1.FPtc,2);
	document.form1.FPtc.disabled = estado;
}

function ValidaForm() {
	debug = false; 
	if (document.form1.modo.value!="BAJA") {
	 if (document.form1.modo.value!="PRECAMBIO") {
		tipo = document.form1.Tipo.value;
	
		switch (tipo) {//NinRange0:9999999999
			case 'T':
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'T_FPdocnumero','','R','T_FPdocfecha','','R','T_FPtipotarjeta','','R');
				break;
			case 'C':
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'C_FPBanco','','R','C_FPdocnumero','','R','C_FPdocfecha','','R');
				break;
			case 'D':
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999',
				'D_FPBanco','','R','D_FPCuenta','','R','D_FPdocnumero','','R');
				break;
			default :
				MM_validateForm('Tipo','','R','FPmontoori','','R','FPmontoori','','NinRange0:999999999','Mcodigo','','R','FPtc','','R','FPtc','','NinRange0:9999');
		}
		
		if  (document.MM_returnValue) {
			document.form1.FPtc.disabled = false;
			document.form1.FPmontoori.value=qf(document.form1.FPmontoori);
			document.form1.FPmontolocal.value=qf(document.form1.FPmontolocal);
			document.form1.FPtc.value=qf(document.form1.FPtc);
		}
		
		return document.MM_returnValue;
	 }
	 else {
	 	//Se utiliza el modo PRECAMBIO para el momento en que se le da click al icono de cambio de una línea de la lista de pagos,
		//y el momento en que se va, y se cambia a CAMBIO para que se vaya y cuando vuelva lo encuentre como CAMBIO y lo deje así.
		document.form1.modo.value!="CAMBIO"
	 	return true;	
	 }	
	}
	else
		return true;
}

function Editar(FPlinea) {
	debug = false; 
	document.form1.FPlinea.value = FPlinea;
	document.form1.modo.value = "BAJA";
}

function Modificar(FPlinea){
	debug = false; 
	document.form1.action = "PagosFA.cfm";
	document.form1.FPlinea.value = FPlinea;
	document.form1.modo.value = "PRECAMBIO"; //PRECAMBIO PARA QUE NO VALIDE ANTES DE IRSE. Lo cambia la funcion de validación del form.
}

function cambiarCuentas(Banco) {
	debug = false; 
	if (Banco==null) {
		Banco=document.form1.D_FPBanco.value;
	}
	document.form1.D_FPCuenta.length = 0;
	i = 0;
	<cfoutput query="rsCuentasBancos">
		if ( #Trim(rsCuentasBancos.Bid)# == Banco ){
			document.form1.D_FPCuenta.length = i+1;
			document.form1.D_FPCuenta.options[i].value = '#rsCuentasBancos.CBid#';
			document.form1.D_FPCuenta.options[i].text  = '#rsCuentasBancos.CBdescripcion#';
			<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D'>
				if ( #rsFPagoLinea.FPCuenta# == #rsCuentasBancos.CBid# ) {
					document.form1.D_FPCuenta.options[i].selected=true;
				}
			</cfif>
			i++;
		};
	</cfoutput>
}

/*
function prueba(){
	//if ((window.event.clientY < 0) ¦¦ (window.event.clientX < 0)){
	if (window.event.clientY < 0 )  {
		if ( !window.opener.closed ){
			window.opener.document.location.reload();
			return;
		}	
	}
	if (window.event.clientX < 0 )  {
		if ( !window.opener.closed ){
			window.opener.document.location.reload();
			return;
		}	
	}
}
*/

function prueba(){
	if ( (window.event.clientY < 0 ) || ( window.event.clientX < 0 ) ){
		if ( !window.opener.closed ){
			//window.opener.document.location.reload();
			window.opener.document.form1.FCid.value='<cfoutput>#form.FCid#</cfoutput>';
			window.opener.document.form1.ETnumero.value='<cfoutput>#form.ETnumero#</cfoutput>';
			window.opener.document.form1.Cambio.value='Cambio';
			window.opener.document.form1.action='TransaccionesFA.cfm';
			window.opener.document.form1.submit();
			return;
		}
	}	
}

//-->
</script>

<html>
<head>
<title>Registro de Pagos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>
<!---<body onUnload="javascript:window.opener.document.location.reload();">--->
<body onUnload="javascript:prueba();" >
<font size="2"> 
<style type="text/css">
	.cuadro{
		border: 1px solid #999999;
	}

	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
</style>
</font> 
<cf_templatecss>
<font size="2"> 
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/calendar.js"></script>
<script language="JavaScript1.2" type="text/javascript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</script>
</font> 
<form action="SQLPagosFA.cfm" method="post"  name="form1" onSubmit="javascript: return ValidaForm();">
  <font size="2"> 
  <cfset ncols=6>
  </font> 
  <table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
    <cfoutput> 
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;</td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#" align="center" bgcolor="FAFAFA"><font size="2"><b>Registro 
          de Pagos</b></font></td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;</td>
      </tr>
      <tr> 
        <td nowrap align="right"><font size="2"><b>Caja:</b>&nbsp;</font></td>
        <td nowrap><font size="2">#rsFCajas.FCdesc# 
          <input name="FCid" value="#rsETransaccion.FCid#" type="hidden">
          </font></td>
        <td nowrap align="right"><font size="2"><b>Factura:</b>&nbsp;</font></td>
        <td nowrap><font size="2">#rsETransaccion.ETnumero# 
          <input name="ETnumero" value="#rsETransaccion.ETnumero#" type="hidden">
          </font></td>
        <td nowrap align="right"><font size="2"><b>Transacci&oacute;n:</b>&nbsp;</font></td>
        <td nowrap><font size="2">#rsETransaccion.ETdocumento##rsETransaccion.ETserie#</font></td>
      </tr>
      <tr> 
        <td nowrap align="right"><font size="2"><b>Cliente:</b>&nbsp;</font></td>
        <td nowrap colspan="3"><font size="2">#rsSNegocios.SNnombre#</font></td>
        <td nowrap align="right"><font size="2"><b>Total a Pagar:</b>&nbsp;</font></td>
        <td nowrap> <font size="2">#rsMonedaTran.Msimbolo# #LSCurrencyFormat(rsETransaccion.ETtotal,'none')# (#rsMonedaTran.Miso4217#) </font></td>
      </tr>
      <tr> 
        <td nowrap colspan="#ncols#">&nbsp;</td>
      </tr>
    </cfoutput> 
    <tr> 
      <td nowrap colspan="6"> <table width="100%" border="0" cellspacing="0" cellpadding="0" class="cuadro" align="center">
          <tr> 
            <td nowrap colspan="5">&nbsp;</td>
          </tr>
          <tr> 
            <td nowrap><font size="2">&nbsp;<b>T.Pago</b></font></td>
            <td nowrap><font size="2"><b>Monto</b></font></td>
            <td nowrap><font size="2"><b>Moneda</b></font></td>
            <td nowrap><font size="2"><b>T.Cambio</b></font></td>
            <td nowrap>&nbsp;</td>
          </tr>
          <tr> 
            <td nowrap><font size="2">&nbsp; 
              <select name="Tipo" onChange="javascript: cambiarTipo(this.value);">
                <cfoutput query="rsTPagos"> 
                  <cfif modo neq "ALTA" and #rsFPagoLinea.Tipo# eq #TPid#>
                    <option value="#TPid#" selected>#TPdesc#</option>
                    <cfelse>
                    <option value="#TPid#">#TPdesc#</option>
                  </cfif>
                </cfoutput> 
              </select>
              </font></td>
            <td nowrap> <font size="2"> 
              <input type="text" name="FPmontoori" maxlength="12" size="14" style="text-align: right;" onBlur="fm(this,2); setMontoLocal();" onFocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}" value="<cfif modo neq 'ALTA'><cfoutput>#rsFPagoLinea.FPmontoori#</cfoutput></cfif>">
              <input type="hidden" name="FPmontolocal" value="<cfif modo neq 'ALTA'><cfoutput>#rsFPagoLinea.FPmontolocal#</cfoutput></cfif>">
              </font></td>
            <td nowrap> <font size="2"> 
              <cfif modo neq 'ALTA'>
                <cf_sifmonedas query="#rsFPagoLinea#" valueTC="#rsFPagoLinea.FPtc#" onChange="javascript: setTC(); setMontoLocal();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" CrearMoneda='false'> 
                <cfelse>
                <cf_sifmonedas onChange="javascript: setTC(); setMontoLocal();" FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#" CrearMoneda='false'> 
              </cfif>
              </font></td>
            <td nowrap> <font size="2"> 
              <input type="text" name="FPtc" maxlength="7" size="8" value="" style="text-align: right;" onBlur="fm(this,2); setMontoLocal();" onFocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}">
              <!--- Obtiene el valor en modo cambio al ejecutarse la función setTC() en la función inicio(),
										con base en valor que se le da en modo cambio en el tag de monedas.
							--->
              </font></td>
            <td nowrap align="right"> <font size="2"> 
              <input name="btnAceptar" type="submit" value="Aceptar">
              <input name="btnNuevo" type="submit" value="Nuevo">
              &nbsp; </font></td>
          </tr>
          <tr> 
            <td nowrap> <div id="divA1" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB1" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                &nbsp;No. Tarjeta </b></font></div>
              <div id="divC1" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                &nbsp;Banco </b></font></div>
              <div id="divD1" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                &nbsp;Banco </b></font></div></td>
            <td nowrap> <div id="divA2" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB2" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                Fecha Venc. </b></font></div>
              <div id="divC2" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                No. Cheque </b></font></div>
              <div id="divD2" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                Cuenta Bancaria </b></font></div></td>
            <td nowrap> <div id="divA3" style="display: none ;"><font size="2"><b> 
                <!--- Efectivo --->
                </b></font></div>
              <div id="divB3" style="display: none ;"><font size="2"><b> 
                <!--- Tarjeta --->
                Tipo </b></font></div>
              <div id="divC3" style="display: none ;"><font size="2"><b> 
                <!--- Cheque --->
                Fecha </b></font></div>
              <div id="divD3" style="display: none ;"><font size="2"><b> 
                <!--- Deposito --->
                No. Deposito&nbsp; </b></font></div></td>
            <td nowrap></td>
            <td nowrap></td>
          </tr>
          <tr> 
            <td nowrap> <div id="divA4" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB4" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                &nbsp; 
                <input type="text" name="T_FPdocnumero" maxlength="25" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();">
                </font></div>
              <div id="divC4" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                &nbsp; 
                <select name="C_FPBanco">
                  <cfoutput query="rsBancos"> 
                    <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C' and #rsFPagoLinea.FPBanco# eq #Bid# >
                      <option value="#Bid#" selected>#Bdescripcion#</option>
                      <cfelse>
                      <option value="#Bid#">#Bdescripcion#</option>
                    </cfif>
                  </cfoutput> 
                </select>
                </font></div>
              <div id="divD4" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                &nbsp; 
                <select name="D_FPBanco" onChange="javascript: cambiarCuentas(this.value);">
                  <cfoutput query="rsBancos"> 
                    <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D' and #rsFPagoLinea.FPBanco# eq #Bid# >
                      <option value="#Bid#" selected>#Bdescripcion#</option>
                      <cfelse>
                      <option value="#Bid#">#Bdescripcion#</option>
                    </cfif>
                  </cfoutput> 
                </select>
                </font></div></td>
            <td nowrap> <div id="divA5" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB5" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                <cfoutput> 
                  <input name="T_FPdocfecha" type="text" size="11" maxlength="10" onBlur="javascript: onblurdatetime(this);" 
									value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T'>#LSDateFormat(rsFPagoLinea.FPdocfecha,"dd/mm/yyyy")#<cfelse>#LSDateFormat(now(),"dd/mm/yyyy")#</cfif>"
									onfocus="this.select();">
                </cfoutput> <a href="#" tabindex="-1"> <img src="../../imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript: showCalendar('document.form1.T_FPdocfecha');"> 
                </a> </font></div>
              <div id="divC5" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                <input type="text" name="C_FPdocnumero" maxlength="10" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();">
                </font></div>
              <div id="divD5" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                <select name="D_FPCuenta" >
                  <!--- Este select se llena con la función inicio() o al cambiar el Banco. --->
                </select>
                <!---
								<input name="D_FPCuentadesc" disabled type="text" value="" size="40" maxlength="80" > 
								<a href="#">
									<img src="../../imagenes/Description.gif" alt="Lista de Cuentas Bancarias" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisCuentas('form1', 'D_FPCuenta', 'D_FPCuentadesc', document.form1.Mcodigo.value,document.form1.D_FPBanco.value);">
								</a> 
								<input type="hidden" name="D_FPCuenta" value="">
								--->
                </font></div></td>
            <td nowrap> <div id="divA6" style="display: none ;"> <font size="2"> 
                <!--- Efectivo --->
                </font></div>
              <div id="divB6" style="display: none ;"> <font size="2"> 
                <!--- Tarjeta --->
                <select name="T_FPtipotarjeta" >
                  <cfoutput query="rsTTarjeta"> 
                    <cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'T' and #rsFPagoLinea.FPtipotarjeta# eq #TTdesc#>
                      <option value="#TTdesc#" selected>#TTdesc#</option>
                      <cfelse>
                      <option value="#TTdesc#">#TTdesc#</option>
                    </cfif>
                  </cfoutput> 
                </select>
                </font></div>
              <div id="divC6" style="display: none ;"> <font size="2"> 
                <!--- Cheque --->
                <cfoutput> 
                  <input name="C_FPdocfecha" type="text" size="11" maxlength="10" onBlur="javascript: onblurdatetime(this);" 
									value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'C'>#LSDateFormat(rsFPagoLinea.FPdocfecha,"dd/mm/yyyy")#<cfelse>#LSDateFormat(now(),"dd/mm/yyyy")#</cfif>"
									onfocus="this.select();">
                </cfoutput> <a href="#" tabindex="-1"> <img src="../../imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript: showCalendar('document.form1.C_FPdocfecha');"> 
                </a> </font></div>
              <div id="divD6" style="display: none ;"> <font size="2"> 
                <!--- Deposito --->
                <input type="text" name="D_FPdocnumero" maxlength="10" size="20" value="<cfif modo neq 'ALTA' and #rsFPagoLinea.Tipo# eq 'D'><cfoutput>#rsFPagoLinea.FPdocnumero#</cfoutput></cfif>" style="text-align: right;" onBlur="" onFocus="javascript: this.select();" >
                </font></div></td>
            <td nowrap></td>
            <td nowrap></td>
          </tr>
          <tr> 
            <td nowrap colspan="5">&nbsp;</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="6">&nbsp;</td>
    </tr>
    <tr> 
      <td nowrap colspan="6"> <table width="100%" border="0" cellspacing="0" cellpadding="0"align="center">
          <tr bgcolor="FAFAFA"> 
            <td nowrap>&nbsp;</td>
            <td nowrap><font size="2">&nbsp;<b>Tipo de Pago</b></font></td>
            <td nowrap align="right"><font size="2"><b>Monto</b></font></td>
			<td nowrap align="right"><font size="2"><b>&nbsp;</b></font></td>
			<td nowrap align="left"><font size="2"><b>Moneda</b></font></td>
            <td nowrap align="right"><font size="2"><b>T.Cambio</b></font></td>
            <td nowrap align="right"><font size="2"><b>Monto Pago <cfoutput>(#rsMonedaTran.Miso4217#)</cfoutput></b></font></td>
            <td nowrap>&nbsp;</td>
          </tr>
          <cfset MontoTotal = 0>
          <cfset Monto = 0>
          <cfset Saldo = rsETransaccion.ETtotal>
          <cfset MaxLen = len(LSCurrencyFormat(rsETransaccion.ETtotal,'none'))>
          <cfoutput query="rsFpagos"> 
            <!---
						FPlinea, FCid, ETnumero, Mcodigo, FPtc, 
						FPmontoori, FPmontolocal, FPfechapago, Tipo, 
						FPdocnumero, FPdocfecha, FPBanco, FPCuenta, 
						FPtipotarjeta
						--->
            <cfset Monto = FPmontolocal / rsETransaccion.ETtc>
            <cfset Saldo = Saldo - Monto>
            <cfset MontoTotal = MontoTotal + Monto>
            <tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
              <td nowrap> 
                <font size="2"> 
                <cfif modo neq "ALTA" and FPlinea eq rsFPagoLinea.FPlinea>
                  <input name="btnEditar" type="image" alt="Elemento en edición" 
								 		onClick="javascript: return false;" src="../../imagenes/edita.gif" width="16" height="16">
                  <cfelse>
                  &nbsp; 
                </cfif>
                </font></td>
              <td nowrap><font size="2">&nbsp;#Tipodesc#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(FPmontoori,'none')#</font></td>
			  <td nowrap align="right"><font size="2">&nbsp;</font></td>
			  <td nowrap align="left"><font size="2">#Mnombre#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(FPtc,'none')#</font></td>
              <td nowrap align="right"><font size="2">#LSCurrencyFormat(Monto,'none')#</font></td>
              <td nowrap> <font size="2"> 
                <input  name="btnBorrar" type="image" alt="Eliminar elemento" 
								onClick="javascript: Editar('#FPlinea#');" src="../../imagenes/Borrar01_T.gif" width="16" height="16">
                <input name="btnEditar" type="image" alt="Editar elemento" 
								onClick="javascript: Modificar('#FPlinea#');" src="../../imagenes/edit_o.gif" width="16" height="16">
                </font></td>
            </tr>
          </cfoutput> <cfoutput> 
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5">&nbsp;</td>
              <td nowrap align="right"><font size="2"><b> 
                <cfset CountVar = 0>
                <cfloop condition = "CountVar LESS THAN OR EQUAL TO MaxLen">
                  <cfset CountVar = CountVar + 1>
                  - 
                </cfloop>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Total (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b>#rsMonedaTran.Msimbolo# #LSCurrencyFormat(MontoTotal,'none')#</b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Saldo (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b> 
                <cfif Saldo gt 0>
                  #rsMonedaTran.Msimbolo# #LSCurrencyFormat(Saldo,'none')# 
                  <cfelse>
                  #rsMonedaTran.Msimbolo# 0.00 
                </cfif>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
            <tr> 
              <td nowrap>&nbsp;</td>
              <td nowrap colspan="5"><font size="2">&nbsp;<b>Vuelto (#rsMonedaTran.Miso4217#)</b></font></td>
              <td nowrap align="right"><font size="2"><b> 
                <cfif Saldo lt 0>
                  #rsMonedaTran.Msimbolo# #LSCurrencyFormat(Saldo*-1,'none')# 
                  <cfelse>
                  #rsMonedaTran.Msimbolo# 0.00 
                </cfif>
                </b></font></td>
              <td nowrap>&nbsp;</td>
            </tr>
          </cfoutput> </table></td>
      <td nowrap>&nbsp;</td>
    </tr>
    <cfoutput> 
      <tr> 
        <td nowrap colspan="#ncols#"> <font size="2"> 
          <input type="hidden" name="FPlinea" value="<cfif modo neq 'ALTA'>#rsFPagoLinea.FPlinea#</cfif>">
          <input type="hidden" name="modo" value="#modo#">
          </font></td>
      </tr>
    </cfoutput> 
  </table>
</form>
<font size="2"> 
<script language='JavaScript'>
	var f=document.form1;
	f.Tipo.alt="El tipo de pago";
	f.FPmontoori.alt="El monto";
	f.Mcodigo.alt="El campo moneda";
	f.FPtc.alt="El tipo de cambio";
	f.T_FPdocnumero.alt="El número de tarjeta de crédito";
	f.C_FPBanco.alt="El banco";
	f.D_FPBanco.alt="El banco";
	f.T_FPdocfecha.alt="El campo fecha de vencimiento";
	f.C_FPdocnumero.alt="El número de cheque";
	f.D_FPCuenta.alt="El campo cuenta bancaria";
	f.T_FPtipotarjeta.alt="El tipo de tarjeta";
	f.C_FPdocfecha.alt="El campo fecha";
	f.D_FPdocnumero.alt="El número de depósito";

	//Validaciones con qForms
	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");
	objForm.T_FPdocnumero.validateCreditCard(f.T_FPdocnumero.alt + " es inválido.");
	objForm.C_FPdocnumero.validateNumeric(f.C_FPdocnumero.alt + " es inválido.");
	objForm.D_FPdocnumero.validateNumeric(f.D_FPdocnumero.alt + " es inválido.");

	inicio();
</script>
</font> 
</body>
</html>

