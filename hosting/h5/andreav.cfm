<HTML>
<HEAD>
<TITLE>H5 - En busca del 5to elemento</TITLE>
<cfparam name="url.id" type="numeric" default="0">
<cfif url.id is 0>
	<cfparam name="url.e" type="string" default="">
	<cfquery datasource="h5_votacion" name="datos" maxrows="1">
		select * from Concursante
		where lower(elemento) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.e#">
		order by concursante
	</cfquery>
	<cfset url.id = datos.concursante>
<cfelse>
	<cfquery datasource="h5_votacion" name="datos">
	select * from Concursante
	where concursante = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.id#">
	</cfquery>
</cfif>

<cfquery datasource="h5_votacion" name="maxid">
	select max(concursante) maxid from Concursante
</cfquery>
<cfset maxid = maxid.maxid>
 
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=utf-8">
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
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
<script language="JavaScript" type="text/JavaScript">
<!--
function MM_openBrWindow(theURL,winName,features) { //v2.0
  window.open(theURL,winName,features);
}
//-->
</script>

</HEAD>
<BODY BGCOLOR=E9E9E9 LEFTMARGIN=0 TOPMARGIN=0 MARGINWIDTH=0 MARGINHEIGHT=0 onLoad="MM_preloadImages('images/sitioh52_06.jpg','images/sitioh52_07.jpg','images/sitioh52_08.jpg','images/sitioh52_09.jpg','images/sitioh5_05.jpg','fotos/<cfoutput>#datos.foto#</cfoutput>1_md80.jpg','fotos/<cfoutput>#datos.foto#</cfoutput>2_md80.jpg');MM_preloadImages('fotos/angela2_md80.jpg')">

						<cfoutput><table width="80%" border="0">
  <tr>
    <td valign="top"> 
      <TABLE WIDTH=790 BORDER=0 CELLPADDING=0 CELLSPACING=0>
        <TR valign="top"> 
          <TD COLSPAN=19>&nbsp; </TD>
        </TR>
        <TR> 
          <TD ROWSPAN=5>&nbsp;</TD>
          <TD> <IMG SRC="images/sitioh5_03.jpg" WIDTH=94 HEIGHT=20 ALT=""></TD>
          <TD COLSPAN=3> <IMG SRC="images/sitioh5_04.jpg" WIDTH=132 HEIGHT=20 ALT=""></TD>
          <TD COLSPAN=3> <a href="index.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image43','','images/sitioh5_05.jpg',1)"><img src="images/sitioh52_05.jpg" alt="inicio" name="Image43" width="64" height="20" border="0"></a></TD>
          <TD COLSPAN=2> <a href="productos.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image39','','images/sitioh52_06.jpg',1)"><img src="images/sitioh5_06.jpg" alt="Productos" name="Image39" width="93" height="20" border="0"></a></TD>
          <TD COLSPAN=2> <a href="concurso.cfm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image40','','images/sitioh52_07.jpg',1)"><img src="images/sitioh5_07.jpg" alt="Concurso" name="Image40" width="94" height="20" border="0"></a></TD>
          <TD COLSPAN=4> <a href="acercade.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image41','','images/sitioh52_08.jpg',1)"><img src="images/sitioh5_08.jpg" alt="Acerca de" name="Image41" width="159" height="20" border="0"></a></TD>
          <TD COLSPAN=2> <a href="patrocinadores.htm" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image42','','images/sitioh52_09.jpg',1)"><img src="images/sitioh5_09.jpg" alt="Patrocinadores" name="Image42" width="125" height="20" border="0"></a></TD>
          <TD ROWSPAN=5>&nbsp; </TD>
        </TR>
        <TR> 
          <TD height="19" COLSPAN=17 bgcolor="##FFFFFF"> <table width="100%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="27%"><img src="images/sitioh5_11.jpg" width="208" height="79"></td>
                <td width="18%"><img src="images/internah5_12.jpg" width="140" height="79"></td>
                <td width="40%"><img src="images/internah5_13.jpg" width="295" height="79"></td>
                <td width="15%"><img src="images/internah5_14.jpg" width="118" height="79"></td>
              </tr>
            </table></TD>
        </TR>
        <TR> 
          <TD COLSPAN=17 valign="top"> 
            <table width="95%" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td valign="top" bgcolor="##FFFFFF"><img src="images/internah5_15.jpg" width="761" height="7"></td>
              </tr>
            </table>
            <table width="99%" height="126" border="1" align="center" cellpadding="2" cellspacing="0" bordercolor="##CCCCCC" bgcolor="##FFFFFF">
              <tr> 
                <td height="124" valign="top" bgcolor="##FFFFFF"> 
                  <table width="100%" border="0" cellpadding="0" cellspacing="0">
                    <tr valign="middle">
                      <td width="31%"><img src="images/concursantes.jpg" width="234" height="36"></td>
                      <td width="10%"><img src="images/#datos.elemento#-round.gif" width="71" height="71">					  </td>
                      <td width="19%"><img src="images/#datos.elemento#-text.gif" width="145"  height="32"></td>
                      <td width="14%" align="right" valign="top"><cfif url.id gt 1><a href="andreav.cfm?id=#url.id-1#"><img src="images/anterior-text.gif" width="77" height="25" border="0"></a></cfif></td>
                      <td width="9%" align="center" valign="top"><a href="concurso.cfm"><img src="images/volver-text.gif" width="72" height="25" border="0"></a></td>
                      <td width="17%" align="left" valign="top"><cfif url.id lt maxid><a href="andreav.cfm?id=#url.id+1#"><img src="images/siguiente-text.gif" width="82" height="25" border="0"></a></cfif></td>
                    </tr>
                  </table>
                  <table width="100%" height="67" border="0" cellpadding="0" cellspacing="0">
                    <tr> 
                      <td height="10" valign="top"> <font size="2" face="Arial, Helvetica, sans-serif">                        <br>
                        </font> 
  
						
                          <table width="600" border="0" align="center" cellpadding="5" cellspacing="10">
                            <tr> 
                              <td width="242" rowspan="2" valign="top"><img src="fotos/#datos.foto#0_md80.jpg" name="foto0" width="240" height="320" border="1" id="foto0"></td>
                              <td width="361" valign="top" style="font-size:14px "><strong>                             
							   Nombre:</strong> #datos.nombre_concursante# <br>
                                <strong>Fecha de Nacimiento: </strong>#DateFormat(datos.fecha_nacimiento,'dd/mm/yyyy')#<strong><br>
                                Edad: </strong>#datos.edad# a&ntilde;os<br>
                                <strong>Estudios:</strong> #datos.estudios# <br>
                                <strong>Hobbies:</strong> #datos.hobbies# <br>
                                <strong>Direcci&oacute;n:</strong> #datos.direccion# <br>
                                <strong>Color de ojos:</strong> #datos.color_ojos# <br>
                              <strong>Color de Cabello:</strong> #datos.color_cabello# </td>
                            </tr>
                            <tr> 
                              <td valign="bottom">                              <table width="80%" border="0" align="left" cellpadding="2" cellspacing="2">
                                  <tr> 
                                    <td><div align="center"><a href="##" onMouseOut="MM_swapImgRestore()" 
							onMouseOver="MM_swapImage('foto0','','fotos/#datos.foto#1_md80.jpg',1)"><img src="fotos/#datos.foto#1_sm80.jpg" name="foto1" width="120" height="160" border="0" id="foto1"></a></div></td>
                                    <td><div align="center"><a href="##" onMouseOut="MM_swapImgRestore()" 
							onMouseOver="MM_swapImage('foto0','','fotos/#datos.foto#2_md80.jpg',1)"><img src="fotos/#datos.foto#2_sm80.jpg" name="foto2" width="120" height="160" border="0" id="foto2"></a></div></td>
                                  </tr>
                              </table></td>
                            </tr>
                            <tr align="right">
                              <td colspan="2" valign="top">Fotograf&iacute;as por Roc&iacute;o Escobar </td>
                            </tr>
                            <tr> 
                              <td colspan="2" valign="top"><div align="center"><font size="2" face="Arial, Helvetica, sans-serif"> 
                                  <a href="##" onClick="MM_openBrWindow('votar2.cfm?id=#URLEncodedFormat(url.id)#','Votar','width=725,height=350')"><img src="images/votaya.jpg" width="100" height="38" border="0"></a> 
                                </font></div></td>
                            </tr>
                          </table>                    </td>
                    </tr>
                </table></td>
              </tr>
            </table></TD>
        </TR>
        <TR> 
          <TD height="19" COLSPAN=17 valign="top" bgcolor="##FFFFFF">
<table width="100%" height="161" border="0" cellpadding="0" cellspacing="0">
              <tr> 
                <td width="17%" height="161"><a href="productos.htm"><img src="images/internah5_20.jpg" width="133" height="161" border="0"></a></td>
                <td width="20%"><a href="productos.htm"><img src="images/internah5_21.jpg" width="149" height="161" border="0"></a></td>
                <td width="19%"><a href="productos.htm"><img src="images/internah5_22.jpg" width="157" height="161" border="0"></a></td>
                <td width="22%"><a href="productos.htm"><img src="images/internah5_23.jpg" width="162" height="161" border="0"></a></td>
                <td width="22%"><img src="images/internah5_24.jpg" width="160" height="161" border="0" usemap="##Map"></td>
              </tr>
            </table> </TD>
        </TR>
        <TR> 
          <TD height="2" COLSPAN=17>&nbsp;</TD>
        </TR>
        <TR> 
          <TD height="2"> <IMG SRC="images/spacer.gif" WIDTH=14 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=94 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=39 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=75 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=18 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=3 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=53 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=8 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=58 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=35 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=56 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=38 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=11 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=113 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=14 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=21 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=7 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=118 HEIGHT=1 ALT=""></TD>
          <TD> <IMG SRC="images/spacer.gif" WIDTH=15 HEIGHT=1 ALT=""></TD>
        </TR>
      </TABLE></td>
  </tr>
</table>
					    </cfoutput>  
<map name="Map">
  <area shape="rect" coords="31,81,138,129" href="concurso.cfm">
</map>
</BODY>
</HTML>