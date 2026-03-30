<!--- 	
	Modificado por Gustavo Fonseca H.
		Fecha: 3-3-2006.
		Motivo: Se utiliza la tabla CGPeriodosProcesados para sacar el combo de los periodos y así mejorar el 
			rendimiento de la pantalla. 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se modifica para que conserve los valores en el regresar.
	Modificado por Gustavo Fonseca H.
		Fecha: 14-3-2006.
		Motivo: Se modifica para que pida la cuenta como un campo obligatorio.
--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Titulo" Default="Saldos y Movimientos por Cuenta Contable" 
returnvariable="LB_Titulo" xmlfile = "saldosymov.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="BTN_Consultar" Default="Consultar" 
returnvariable="BTN_Consultar" xmlfile = "/sif/generales.xml"/>


<cf_templateheader title="#LB_Titulo#">
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
	if ( (trim(document.form1.Ccuenta.value) == "") && (trim(document.form1.Cdescripcion.value) != "")) {
		msg += ' - Debe seleccionar una Cuenta que acepte movimientos';
		alert(msg);
		return false;
	}
	else{
		if( (trim(document.form1.Ccuenta.value) == "") && (trim(document.form1.Cdescripcion.value) == "")){
			msg += ' - La Cuenta Contable es requerida';
			alert(msg);
			return false;
		}
	}	
	document.form1.Cdescripcion.disabled = false;
	return true;
}
//-->
</script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	
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
<script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
<cfflush interval="64">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
<form action="saldosymov01.cfm" method="post" name="form1" onSubmit="return sinbotones(); validar(); ">
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
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td colspan="2"><cfinclude template="/sif/portlets/pNavegacionCG.cfm"></td>
                </tr>
				<!---<tr><td colspan="2" align="right"><table width="100%" border="0" align="center"><tr><td align="right"><cf_sifayudaRoboHelp name="imAyuda" imagen="1" Tip="true" width="500" url="Saldos_movimientos.htm"></td></tr></table></td></tr>--->
                <tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td nowrap align="right" >&nbsp;</td>
					<td nowrap>
					<input 
							type="text" 
							name="MascaraM"
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
							name="Mascara"
							value="" 
							size="60" 
							autocomplete="off"
							disabled="disabled"
							style="border: medium none; visibility:visible;"
							alt="Mascara"
							title="Mascara"
							>
					</td>
				</tr>				
				
				<tr> 
                  <td nowrap align="right" width="35%" ><cf_translate key =LB_CuentaContable>Cuenta Contable</cf_translate>:&nbsp;</td>
                  <td nowrap width="60%">
					<input 
						type="text" 
						name="Cmayor"
						value="" 
						size="4" 
						maxlength="4"  
						autocomplete="off"
						style="border:solid 1px #CCCCCC; background:inherit;"
						alt="Cmayor"
						title="Cmayor"
                        id="Cmayor"
						onChange="javascript:document.form1.Cformato.value='';"
						onblur  = "javascript: validaMayor()">
					
					<input 
						type="text" 
						name="Cformato"
						value="" 
						size="52" 
						maxlength="100" 
						autocomplete="off"
						style="border:solid 1px #CCCCCC; background:inherit;"
						alt="Cformato"
						title="Cformato"
						onchange = "javascript: validadetalle();">
					<a href="javascript:doConlisCcuenta();" id="imgCcuenta">
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
							name="Cdescripcion"
							value="" 
							size="60" 
							autocomplete="off"
							readonly
							style="border:solid 1px #CCCCCC; background:inherit;"
							alt="Cdescripcion"
							title="Cdescripcion"
							>
					<input type="hidden" name="Ccuenta" value="" alt="Ccuenta">		
					</td>
				</tr>
				<tr>
				  <td nowrap align="right" ><cf_translate key=LB_Periodo>Período</cf_translate>:&nbsp;</td>
                  <td>
                      <select name="Periodos"><cfoutput query="rsparam"> 
                        <option value="#rsparam.Speriodo#" <cfif isdefined("form.Periodo") and trim(form.periodo) eq trim(rsparam.Speriodo)>selected</cfif>>#rsparam.Speriodo#</option>
                      
                    </cfoutput></select>
				  </td>
                </tr>
				<tr>
                  <td><div align="right"><cf_translate key=LB_Moneda>Moneda</cf_translate>:</div></td>
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
                        <td nowrap><cf_translate key=LB_Origen> Origen</cf_translate>:</td>
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
                  <td colspan="2" align="center"><cfoutput>
                      <input type="submit" name="Submit" value="#BTN_Consultar#" id="Consultar"></cfoutput>
                  </td>
                </tr>
              </table>
			<script type="text/javascript" language="JavaScript1.2">
				document.form1.Cdescripcion.alt = "La Cuenta Contable";
			</script>
			<script type="text/javascript" language="JavaScript1.2" >
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");
					
				objForm.Cmayor.required = true;
				objForm.Cmayor.description="Mayor";
			
				objForm.Ccuenta.required = true;
				objForm.Ccuenta.description="Cuenta";
			
				function doConlisCcuenta() {
					var Cmayor = document.form1.Cmayor.value;
					var PARAM  = "ConlisCuentascontable.cfm?Cmayor="+ Cmayor;
					open(PARAM,'V1','left=110,top=100,scrollbars=yes,resizable=yes,width=900,height=650')
				}
				function validaMayor() {
					var Cmayor = document.form1.Cmayor.value;
					if(Cmayor != "" ) {
						var btn  = document.getElementById("Consultar");
						btn.disabled = false;
						var LvarCerosV = "0000" + trim(Cmayor);
						var LvarCerosN = LvarCerosV.length;
						Cmayor = LvarCerosV.substring(LvarCerosN-4,LvarCerosN);
						document.form1.Cmayor.value = Cmayor;
						var PARAMS = "?Cmayor="+Cmayor;
						
						var frame  = document.getElementById("FRAMECJNEGRA");
						frame.src 	= "validaCuenta.cfm" + PARAMS;
					}
				}
				function validadetalle() {
					var Cmayor   = document.form1.Cmayor.value;
					var Cformato = document.form1.Cformato.value ;
					if(Cmayor != ""  && Cformato != "") {
						var btn  = document.getElementById("Consultar");
						btn.disabled = false;
						var Cformato = document.form1.Cmayor.value +'-'+document.form1.Cformato.value ;
						var PARAMS = "?Cmayor="+Cmayor+"&Cformato="+Cformato;
						var frame  = document.getElementById("FRAMECJNEGRA");
						frame.src 	= "validaCuenta.cfm" + PARAMS;
					}
				}
			</script>
			</form>
	<cf_web_portlet_end>
<cf_templatefooter>
