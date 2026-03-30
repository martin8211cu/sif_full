<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html><!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" -->
<head>
<title>SIF</title>
<meta http-equiv="Expires" content="Fri, Jan 01 1970 08:20:00 GMT">
<meta http-equiv="Cache-Control" content="no-cache, no-store, must-revalidate">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<meta http-equiv="Pragma" content="no-cache">
<!-- InstanceBeginEditable name="head" -->
<meta http-equiv="pragma" content="no-cache">
<script language="JavaScript" src="../../js/calendar.js"></script>
<script language="JavaScript" type="text/javascript">
<!--
var popUpWin=0;
function popUpWindow(URLStr, left, top, width, height)
{
  if(popUpWin)
  {
    if(!popUpWin.closed) popUpWin.close();
  }
  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
}

function doConlisIDcontable() {
	popUpWindow("ConlisPolizas.cfm?form=form1&id=IDcontable&desc=Poliza",250,200,700,450);
}

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
//-->
</script>
<!-- InstanceEndEditable -->
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
MM_reloadPage(true);
//-->
</script>
<cf_templatecss>
<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
    <td width="154" rowspan="2" align="center" valign="top"><img src="/cfmx/sif/imagenes/logo2.gif" width="154" height="62"></td>
    <td valign="bottom" style="padding-left: 5; padding-bottom: 5;"> <!-- InstanceBeginEditable name="Ubica" -->
	<cfinclude template="../../portlets/pubica.cfm">
	<!-- InstanceEndEditable --> </td>
  </tr>
  <tr> 
    <td valign="top">
	<!-- InstanceBeginEditable name="Titulo" --> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr class="area"> 
          <td width="275" rowspan="2" valign="middle">
				<cfinclude template="../../portlets/pEmpresas2.cfm"></td>
          <td nowrap>
            <div align="center"><span class="superTitulo"><font size="5">Contabilidad 
              General </font></span></div>
          </td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="../jsMenuCG.cfm"></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->	
	
	</td>
  </tr>
</table>
  
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td width="84" align="left" valign="top" nowrap></td> 
    <td width="3" align="left" valign="top" nowrap></td>
    <td width="661" height="1" align="left" valign="top"><!-- InstanceBeginEditable name="Titulo2" --><!-- InstanceEndEditable --></td>
  </tr>
  <tr>
    <td width="1%" align="left" valign="top" nowrap><cfinclude template="/sif/menu.cfm"></td>
    <td width="3" align="left" valign="top" nowrap></td> 
    <td valign="top" width="100%">
	<!-- InstanceBeginEditable name="portletMantenimientoInicio" -->	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Copia 
            de Documentos Contables'>
	<!-- InstanceEndEditable -->		
	<!-- InstanceBeginEditable name="Mantenimiento2" -->
<script language="JavaScript">
	function showLink(c) {
		var a = document.getElementById("linkP");
		if (c.value != '') {
			a.style.display = "";
		} else {
			a.style.display = "none";
		}
	}

	function hideLink() {
		var a = document.getElementById("linkP");
		a.style.display = "none";
	}
	
	function go() {
		location.href="../consultas/SQLPolizaConta.cfm?IDcontable=" + document.form1.IDcontable.value;
	}
</script>

<style type="text/css">
	.corteConsulta {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
}
</style>

<cfinclude template="Funciones.cfm">
<cfset periodo="#get_val(30).Pvalor#">
<cfset mes="#get_val(40).Pvalor#">

<cfquery name="rsConceptos" datasource="#Session.DSN#">
	select Cconcepto, Cdescripcion from ConceptoContableE 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset PolizaE = t.Translate('PolizaE','P&oacute;liza')>
<cfset PolizaVal = t.Translate('PolizaVal','El valor de la P&oacute;liza')>
<cfset PolizaList = t.Translate('PolizaList','Lista de P&oacute;lizas Contables')>
<cfset PolizaSel = t.Translate('PolizaSel','Seleccionar P&oacute;liza a Copiar')>
<cfset PolizaCon = t.Translate('PolizaCon','Consultar P&oacute;liza')>
<cfset PolizaDat = t.Translate('PolizaDat','Datos de Nueva P&oacute;liza')>

		<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
		  <cfoutput>
		  <cfset regresar = "/cfmx/sif/cg/MenuCG.cfm">
		  <tr align="left"> 
			<td><a href="/cfmx/sif/">SIF</a></td>
			<td>|</td>
			<td nowrap><a href="../MenuCG.cfm">Contabilidad General</a></td>
			<td>|</td>
			<td width="100%"><a href="#regresar#">Regresar</a></td>
		  </tr>
		  </cfoutput>
		</table>
		  <form action="SQLCopiaAsientos.cfm" method="post" name="form1" onSubmit="MM_validateForm('Poliza','','R','Eperiodo','','RinRange1980:2050','Edescripcion','','R');return document.MM_returnValue">
		  	  <table width="90%" border="0" cellspacing="0" cellpadding="2" align="center">
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6" class="corteConsulta"><cfoutput>#PolizaSel#</cfoutput></td>
                </tr>
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="4"> <cfoutput>#PolizaE#</cfoutput>
                    <input name="Poliza" type="text" size="40" alt="<cfoutput>#PolizaSel#</cfoutput>" onSelect="javascript:showLink(this);" readonly="readonly"> 
                    <a href="#"><img src="../../imagenes/Description.gif" alt="<cfoutput>#PolizaList#</cfoutput>" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisIDcontable();"></a> 
                    <a id="linkP" href="javascript:go()" style="display: none"><img src="../../imagenes/find.small.png" alt="<cfoutput>#PolizaCon#</cfoutput>" name="imagen" width="16" height="16" border="0" align="absmiddle"></a> 
                    <input name="IDcontable" type="hidden" id="IDcontable" vale=""> 
                  </td>
                  <td colspan="2">Reversar 
                    <input name="chkReversar" type="checkbox" id="chkReversar" value="1"> 
                  </td>
                </tr>
                <tr> 
                  <td colspan="6">&nbsp;</td>
                </tr>
                <tr> 
                  <td colspan="6" class="corteConsulta"><cfoutput>#PolizaDat#</cfoutput></td>
                </tr>
                <tr> 
                  <td colspan="6" nowrap>&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap> Lote: </td>
                  <td nowrap><select name="Cconcepto">
                      <cfoutput query="rsConceptos"> 
                        <option value="#rsConceptos.Cconcepto#">#rsConceptos.Cdescripcion#</option>
                      </cfoutput> </select></td>
                  <td nowrap> Per&iacute;odo: </td>
                  <td nowrap><input name="Eperiodo" type="text" value="<cfoutput>#periodo#</cfoutput>" maxlength="4" alt="El Período"></td>
                  <td nowrap> Mes: </td>
                  <td nowrap><select name="Emes" size="1">
                      <option value="1" <cfif #mes# EQ 1>selected</cfif>>Enero</option>
                      <option value="2" <cfif #mes# EQ 2>selected</cfif>>Febrero</option>
                      <option value="3" <cfif #mes# EQ 3>selected</cfif>>Marzo</option>
                      <option value="4" <cfif #mes# EQ 4>selected</cfif>>Abril</option>
                      <option value="5" <cfif #mes# EQ 5>selected</cfif>>Mayo</option>
                      <option value="6" <cfif #mes# EQ 6>selected</cfif>>Junio</option>
                      <option value="7" <cfif #mes# EQ 7>selected</cfif>>Julio</option>
                      <option value="8" <cfif #mes# EQ 8>selected</cfif>>Agosto</option>
                      <option value="9" <cfif #mes# EQ 9>selected</cfif>>Setiembre</option>
                      <option value="10" <cfif #mes# EQ 10>selected</cfif>>Octubre</option>
                      <option value="11" <cfif #mes# EQ 11>selected</cfif>>Noviembre</option>
                      <option value="12" <cfif #mes# EQ 12>selected</cfif>>Diciembre</option>
                    </select></td>
                </tr>
                <tr> 
                  <td nowrap> Descripci&oacute;n: </td>
                  <td nowrap><input name="Edescripcion" type="text" value="" size="63" maxlength="100" alt="La Descripción"> 
                    <script language="JavaScript">document.form1.Edescripcion.focus();</script></td>
                  <td colspan="2" nowrap>&nbsp;</td>
                  <td colspan="2" nowrap>&nbsp;</td>
                </tr>
                <tr> 
                  <td nowrap> Fecha: </td>
                  <td nowrap>
				  <cf_sifcalendario name="Efecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
<!--- 				  <input name="Efecha" type="text" value="<cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput>" size="15" maxlength="10" alt="La Fecha" readonly> 
                    <a href="#" ><img src="/cfmx/sif/imagenes/DATE_D.gif" alt="Calendario" name="Calendar" width="16" height="14" border="0" onClick="javascript:showCalendar('document.form1.Efecha');"></a>
 --->  				  </td>
                  <td nowrap> Referencia: </td>
                  <td nowrap><input name="Ereferencia" type="text" value="" size="25" maxlength="25"></td>
                  <td nowrap> Documento: </td>
                  <td nowrap><input name="Edocbase" type="text" value="" size="20" maxlength="20"></td>
                </tr>
                <tr> 
                  <td colspan="6" nowrap>&nbsp;</td>
                </tr>
                <tr align="center"> 
                  <td colspan="6" nowrap> <input name="btnCopiar" type="submit" id="btnCopiar" value="Copiar"> 
                    <input name="btnReset" type="reset" id="btnReset" value="Limpiar" onClick="javascript:hideLink();"> 
                  </td>
                </tr>
              </table>
		  </form>
            <!-- InstanceEndEditable -->
	<!-- InstanceBeginEditable name="portletMantenimientoFin" -->	
		<cf_web_portlet_end>
	<!-- InstanceEndEditable -->		
     </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>