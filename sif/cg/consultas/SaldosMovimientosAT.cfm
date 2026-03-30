<cf_templateheader title="Contabilidad General">
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<script language="JavaScript">
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}
function doConlisCuentas() {
	popUpWindow("ConlisCuentas.cfm?form=form1&id=Ccuenta&desc=Cdescripcion&fmt=Cformato",250,200,550,350);
}
</script>
<script language="JavaScript">
<!--
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
		  } else if (test!='R') { num = parseFloat(val);
			if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
			if (test.indexOf('inRange') != -1) { p=test.indexOf(':');
			  min=test.substring(8,p); max=test.substring(p+1);
			  if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
		} } } else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n'; }
	  } if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
	function validar() {
		var msg = 'Se presentaron los siguientes errores:\n\n'	
		if ((trim(document.form1.Ccuenta1.value) == "") && 
			(trim(document.form1.Ccuenta2.value) == "")) {
			msg += ' - Debe seleccionar un rango de cuentas contables';
			alert(msg);
			return false;
		}
		else{
			if((trim(document.form1.Ccuenta1.value) == "") && (trim(document.form1.Cdescripcion1.value) == "")){
				msg += ' - La Cuenta Contable es requerida en el rango 1';
				alert(msg);
				return false;
			}
			else
				if((trim(document.form1.Ccuenta2.value) == "") && (trim(document.form1.Cdescripcion2.value) == "")){
					msg += ' - La Cuenta Contable es requerida en el rango 2';
					alert(msg);
					return false;
				}
		}
		document.getElementById('Consultar').disabled = false;
		return true;
}
//-->
</script>

<cfquery name="rsparam" datasource="#Session.DSN#">
	select distinct Speriodo
	from CGPeriodosProcesados
	where Ecodigo = #session.Ecodigo#
	order by Speriodo desc
</cfquery>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select 
    	Mcodigo as Mcodigo, 
    	Mnombre, 
        Msimbolo, 
        Miso4217, 
        ts_rversion 
	from Monedas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset longitud = len(Trim(rsMonedas.Miso4217))>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
		select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
		from Empresas a, Monedas b 
		where a.Ecodigo = #Session.Ecodigo#
		  and a.Mcodigo = b.Mcodigo
</cfquery>
<cfflush interval="64">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos y Movimientos por rango de Cuentas Contables'>
<form action="SaldosMovimientosA.cfm" method="post" name="form1" onSubmit="return validar()">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
        <td valign="top">
            <iframe id="FRAMECJNEGRA" 
                name="FRAMECJNEGRA" 
                marginheight="0" 
                marginwidth="0" 
                frameborder="0" 
                height="0" 
                width="0" 
                src="" 
                style="visibility:hiddens">
            </iframe>
      	</td>
  </tr>
              
  <table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
   <tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacionCG.cfm"></td></tr>
    <tr>
        <td width="50%" valign="top">
            <table width="100%">
                <tr>
                    <td> 
                        <cf_web_portlet_start border="true" titulo="Saldos y Movimientos" skin="info1">
                            <div align="justify">
                                <p>
                                	Muestra los saldos y movimientos entre un rango de fechas seleccionadas, 
                                	tanto los movimientos de los asientos aplicados como los asientos en tr&aacute;nsito. Los saldos rojos son cr&eacute;ditos, color negro son d&eacute;bitos, 
                                    en los casos en que no existi&oacute; movimiento en la cuenta, no se muestra el vinculo de detalle, en los casos en que hubo movimientos, pero el resultado 
                                    fue cero, se muestra de color azul el v&iacute;nculo.
                               	</p>
                            </div>
                        <cf_web_portlet_end> 
                    </td>
                </tr>
            </table>
        </td>
                                    
	<td width="50%" valign="top">
    <table width="100%" cellpadding="0" cellspacing="0" align="center">                        
      	<tr><td colspan="2">&nbsp;</td></tr>
   		<!--- Campos para la busqueda de la cuenta 1--->
        <tr>
            <td nowrap align="right" >&nbsp;</td>
            <td nowrap>
            <input 
                    type="text" 
                    name="MascaraM1"
                    value="" 
                    size="4" 
                    autocomplete="off"
                    disabled="disabled"
                    style="border: medium none; visibility:visible;"
                    alt=""
                    title="MascaraM"
                    >
            <input 
                    type="text" 
                    name="Mascara1"
                    value="" 
                    size="60" 
                    autocomplete="off"
                    disabled="disabled"
                    style="border: medium none; visibility:visible;"
                    alt="Mascara cuenta 1"
                    title="Mascara cuenta 1"
                    >
            </td>
        </tr>				
                    
        <tr> 
          <td nowrap align="right" width="35%" ><strong>Desde la Cuenta:&nbsp;</strong></td>
          <td nowrap width="60%">
            <input 
                type="text" 
                name="Cmayor1"
                value="<cfoutput><cfif isdefined("Form.Cmayor1")>#Form.Cmayor1#</cfif></cfoutput>" 
                size="4" 
                maxlength="4"  
                autocomplete="off"
                style="border:solid 1px #CCCCCC; background:inherit;"
                alt="Cuenta de mayor 1"
                title="Cuenta de mayor 1"
                onChange="javascript:document.form1.Cformato1.value='';"
                onblur  = "javascript: validaMayor(1)">
            
            <input 
                type="text" 
                name="Cformato1"
                value="<cfoutput><cfif isdefined("Form.Cformato1")>#Form.Cformato1#</cfif></cfoutput>" 
                size="52" 
                maxlength="100" 
                autocomplete="off"
                style="border:solid 1px #CCCCCC; background:inherit;"
                alt="Formato cuenta 1"
                title="Formato cuenta 1"
                onchange = "javascript: validadetalle(1);">
            <a href="javascript:doConlisCcuenta(1);" id="imgCcuenta">
                <img src="/cfmx/sif/imagenes/Description.gif"
                alt="Lista de Cuentas Contables"
                name="imagenCcuenta"
                width="18" height="14"
                border="0" align="absmiddle">
            </a>
          	</td>
        </tr>
                                    
        <tr>
            <td nowrap align="right" >&nbsp;</td>
            <td nowrap>
            <input 
                    type="text" 
                    name="Cdescripcion1"
                    value="<cfoutput><cfif isdefined("Form.Cdescripcion1")>#Form.Cdescripcion1#</cfif></cfoutput>"
                    size="60" 
                    autocomplete="off"
                    readonly
                    style="border:solid 1px #CCCCCC; background:inherit;"
                    alt="Descripci&oacute;n Cuenta 1"
                    title="Descripci&oacute;n Cuenta 1"
                    >
            <input type="hidden" name="Ccuenta1" value="<cfoutput><cfif isdefined("Form.Ccuenta1")>#Form.Ccuenta1#</cfif></cfoutput>"  alt="Ccuenta">		
            </td>
        </tr> 
        
      	<tr><td colspan="2">&nbsp;</td></tr>
   		<!--- Campos para la busqueda de la cuenta 2--->
        <tr>
            <td nowrap align="right" >&nbsp;</td>
            <td nowrap>
            <input 
                    type="text" 
                    name="MascaraM2"
                    value="" 
                    size="4" 
                    autocomplete="off"
                    disabled="disabled"
                    style="border: medium none; visibility:visible;"
                    alt=""
                    title="MascaraM"
                    >
            <input 
                    type="text" 
                    name="Mascara2"
                    value="" 
                    size="60" 
                    autocomplete="off"
                    disabled="disabled"
                    style="border: medium none; visibility:visible;"
                    alt="Mascara cuenta 2"
                    title="Mascara cuenta 2"
                    >
            </td>
        </tr>				
                    
        <tr> 
          <td nowrap align="right" width="35%" ><strong>Hasta la Cuenta:&nbsp;</strong></td>
          <td nowrap width="60%">
            <input 
                type="text" 
                name="Cmayor2"
                value="<cfoutput><cfif isdefined("Form.Cmayor2")>#Form.Cmayor2#</cfif></cfoutput>" 
                size="4" 
                maxlength="4"  
                autocomplete="off"
                style="border:solid 1px #CCCCCC; background:inherit;"
                alt="Cuenta de mayor 2"
                title="Cuenta de mayor 2"
                onChange="javascript:document.form1.Cformato2.value='';"
                onblur  = "javascript: validaMayor(2)">
            
            <input 
                type="text" 
                name="Cformato2"
                value="<cfoutput><cfif isdefined("Form.Cformato2")>#Form.Cformato2#</cfif></cfoutput>"  
                size="52" 
                maxlength="100" 
                autocomplete="off"
                style="border:solid 1px #CCCCCC; background:inherit;"
                alt="Formato cuenta 2"
                title="Formato cuenta 2"
                onchange = "javascript: validadetalle(2);">
            <a href="javascript:doConlisCcuenta(2);" id="imgCcuenta">
                <img src="/cfmx/sif/imagenes/Description.gif"
                alt="Lista de Cuentas Contables"
                name="imagenCcuenta"
                width="18" height="14"
                border="0" align="absmiddle">
            </a>
          	</td>
        </tr>
                                    
        <tr>
            <td nowrap align="right" >&nbsp;</td>
            <td nowrap>
            <input 
                    type="text" 
                    name="Cdescripcion2"
                    value="<cfoutput><cfif isdefined("Form.Cdescripcion2")>#Form.Cdescripcion2#</cfif></cfoutput>"
                    size="60" 
                    autocomplete="off"
                    readonly
                    style="border:solid 1px #CCCCCC; background:inherit;"
                    alt="Descripci&oacute;n Cuenta 2"
                    title="Descripci&oacute;n Cuenta 2"
                    >
            <input type="hidden" name="Ccuenta2" value="<cfoutput><cfif isdefined("Form.Ccuenta2")>#Form.Ccuenta2#</cfif></cfoutput>" alt="Ccuenta">		
            </td>
        </tr>                    
               <tr><td colspan="2">&nbsp;</td></tr>            
          <td nowrap align="right" >Período:&nbsp;</td>
          <td>
              <select name="Periodo">
			  <cfoutput query="rsparam"> 
              	<option value="#rsparam.Speriodo#" <cfif isdefined("form.Periodo") and trim(form.periodo) eq trim(rsparam.Speriodo)>selected</cfif>>#rsparam.Speriodo#</option>
            </cfoutput>
            </select>
          </td>
        </tr>
        <tr>
          <td><div align="right">Moneda:</div></td>
          <td rowspan="2" valign="top"><table border="0" cellspacing="0" cellpadding="2">
              <tr>
                <td nowrap><input name="mcodigoopt" type="radio" value="-2" checked></td>
                <td nowrap> Local:</td>
                <td><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
              </tr>
              <cfif isdefined("rsMonedaConvertida")>
              </cfif>
              <tr>
                <td nowrap><input name="mcodigoopt" type="radio" value="0" <cfif isdefined("form.mcodigoopt") and form.mcodigoopt eq 0>checked</cfif>></td>
                <td nowrap> Origen:</td>
                <td>
                    <select name="Mcodigo">
                        <cfoutput query="rsMonedas">
                          <option value="#rsMonedas.Mcodigo#"
                        <cfif isdefined('rsMonedas') and isdefined('rsMonedaLocal')>
                            <cfif isdefined("form.mcodigoopt") and form.mcodigoopt EQ "0" and isdefined("form.Mcodigo")>
                                <cfif rsMonedas.Mcodigo EQ form.Mcodigo >selected</cfif>
                            <cfelse>
                                <cfif rsMonedas.Mcodigo EQ rsMonedaLocal.Mcodigo >selected</cfif>
                            </cfif>
                        </cfif>
                        >#rsMonedas.Mnombre#</option>
                        </cfoutput>
                    </select>
                </td>
              </tr>
          </table></td>
        </tr>
        <tr>
          <td>&nbsp;</td>
        </tr>
    
        <tr><td colspan="2">&nbsp;</td></tr>
        <tr>
            <td align="right" nowrap="nowrap"><strong>Exportar a Excel:&nbsp;</strong>
            </td>
            <td><input type="checkbox" name="toExcel" /></td>
        </tr>
        <tr> 
          <td colspan="2" align="center">
          	<input type="submit" name="Submit" value="Consultar" id="Consultar">
			<input type="button" name="Limpiar" value="Limpiar" tabindex="18" onClick="vaciarCampos()">              
          </td>
        </tr>
        </table>
        </td>
    </tr>
    </table>
  	</table>
	</form>
	<cf_web_portlet_end>
<cf_templatefooter>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	
	//-->	
</script>

<script type="text/javascript" language="JavaScript1.2" >
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
		
	objForm.Cmayor1.required = true;
	objForm.Cmayor1.description="Mayor";
	
	objForm.Cmayor2.required = true;
	objForm.Cmayor2.description="Mayor";

	objForm.Ccuenta1.required = true;
	objForm.Ccuenta1.description="Cuenta";
	
	objForm.Ccuenta2.required = true;
	objForm.Ccuenta2.description="Cuenta";				

	function doConlisCcuenta(Campo) {
		if(Campo == 1)
			var Cmayor = document.form1.Cmayor1.value;						
		else
			var Cmayor = document.form1.Cmayor2.value;		
		var PARAM  = "ConlisCuentascontable.cfm?Cmayor="+ Cmayor + "&Campo=" + Campo;
		open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
	}
	function validaMayor(Campo) {
		if(Campo == 1)
			var Cmayor = document.form1.Cmayor1.value;
		else
			var Cmayor = document.form1.Cmayor2.value;
		if(Cmayor != "" ) {
			var LvarCerosV = "0000" + trim(Cmayor);
			var LvarCerosN = LvarCerosV.length;
			Cmayor = LvarCerosV.substring(LvarCerosN-4,LvarCerosN);
			if(Campo == 1)
				document.form1.Cmayor1.value = Cmayor;
			else
				document.form1.Cmayor2.value = Cmayor;
			var PARAMS = "?Cmayor=" + Cmayor + "&Campo=" + Campo;
			
			var frame  = document.getElementById("FRAMECJNEGRA");
			frame.src 	= "validaCuenta.cfm" + PARAMS;
		}

	}
	function validadetalle(Campo) {
		if(Campo == 1){
			var Cmayor   = document.form1.Cmayor1.value;
			var Cformato = document.form1.Cformato1.value ;
		}
		else{
			var Cmayor   = document.form1.Cmayor2.value;
			var Cformato = document.form1.Cformato2.value ;						
		}
		
		if(Cmayor != ""  && Cformato != "") {
			if(Campo == 1)
				var Cformato = document.form1.Cmayor1.value +'-'+document.form1.Cformato1.value;
			else
				var Cformato = document.form1.Cmayor2.value +'-'+document.form1.Cformato2.value;
			var PARAMS = "?Cmayor="+Cmayor+"&Cformato=" + Cformato  + "&Campo=" + Campo;
			var frame  = document.getElementById("FRAMECJNEGRA");
			frame.src 	= "validaCuenta.cfm" + PARAMS;
		}					
	}

	function vaciarCampos()
	{
		document.form1.MascaraM1.value = "";
		document.form1.MascaraM2.value = "";
		document.form1.Mascara1.value = "";
		document.form1.Mascara2.value = "";
		document.form1.Cformato1.value = "";
		document.form1.Cformato2.value = "";
		document.form1.Cmayor1.value = "";
		document.form1.Cmayor2.value = "";	
		document.form1.Cdescripcion1.value = "";
		document.form1.Cdescripcion2.value = "";	
		document.form1.Periodo[0].selected = true;
		document.form1.Mcodigo[0].selected = true;
		document.form1.Ccuenta1.value = "";		
		document.form1.Ccuenta2.value = "";
		var Input = document.getElementsByTagName("INPUT");
		Input[13].checked = true;
		document.form1.toExcel.checked = false;						
	}
	
</script>	
