<script language="JavaScript" type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}
//-->
</script>
<body onLoad="MM_preloadImages('/cfmx/edu/Imagenes/date_d.gif')">
<cfform action="" name="" >
  <table width="100%" border="0" class="areaFiltro">
    <tr> 
      <td width="8%" class="subTitulo">Fecha</td>
      <td width="11%" nowrap class="subTitulo"><a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
        <input name="fIfecha" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif modo NEQ "ALTA"><cfoutput>#rsIncidencias.fIfecha#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formfactIncidencias.fIfecha');"></a></td>
      <td width="9%" class="subTitulo">Nombre </td>
      <td width="62%" class="subTitulo"><input name="fNombreAl" type="text" id="fNombreAl" size="80" onFocus="this.select()" maxlength="80" value="<cfif isdefined("Form.fNombreAl") AND #Form.fNombreAl# NEQ "" ><cfoutput>#Form.fNombreAl#</cfoutput></cfif>"></td>
      <td width="10%" align="center" class="subTitulo"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" ></td>
    </tr>
  </table>
</cfform>
