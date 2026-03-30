<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Conceptos de servicios entre segmentos</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
</head>

 <!---*********************** --->
<!---** AREA DE PINTADO    ** --->
<!---************************ --->
<!---********************************* --->
<!---** AREA DE IMPORTACION DE JS   ** --->
<!---********************************* --->
<SCRIPT LANGUAGE='Javascript'  src="../js/utilies.js"></SCRIPT>

<body>

	<!--- <p align="center"><img src="http://intranet.ice/daf/contabilidad/codigoweb/codigo/parte%20de%20arriba.gif" width="770" height="111" border="0" usemap="#Map"> ---> 
  	<p align="center"><img src="parte%20de%20arriba.gif" width="770" height="111" border="0" usemap="#Map"> 
	<map name="Map">    
	<area shape="rect" coords="240,1,296,19" href="http://intranet.ice/daf/contabilidad/codigoweb/home.htm">
	<area shape="rect" coords="301,1,366,19" href="http://intranet.ice/daf/contabilidad/codigoweb/codigo/Codigomain.htm">
    <area shape="rect" coords="506,2,584,18" href="http://intranet.ice/daf/contabilidad/codigoweb/segmentos/SEGMENTOS.htm">
    <area shape="rect" coords="591,3,673,18" href="http://intranet.ice/daf/contabilidad/codigoweb/actualizacion/formularindex.htm" target="_blank">
    <area shape="rect" coords="373,3,498,19" href="http://10.129.20.145/cfmx/sif/Contaweb_Ext/consulta/cmn_consultacuentas.cfm">
    <area shape="rect" coords="679,3,766,17" href="http://intranet.ice/daf/contabilidad/codigoweb/Glosario/Glosariohome.htm">
	</map>
</p>

	<table width="770" align="center" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td width="100%" align="center">
		<!---********************************************************************************* --->
		<!---** 					INICIA PINTADO DE LA PANTALLA 							** --->
		<!---********************************************************************************* --->
			<form method="post" name="form1" onSubmit="javascript:verificar()">
			<cfoutput>
			<table width="100%" border="0">
				<tr>
					<td>
						<strong>Segmento :</strong>
					</td>						
					<td>
						<cf_cjcConlis 	
							size		="5"  
							tabindex    ="1"
							name 		="CGE5COD" 
							desc 		="CGE5DES" 
							cjcConlisT 	="cjc_traeUEN"
							frame		="CGE5COD_FRM"
							>
					</td>
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<cfinclude template="../reportes/CajaNegra/CajaNegraCuentas.cfm">
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<td width="8%">
						<strong>Mascara :</strong>
					</td>
					<td width="92%">
						<strong><INPUT 	TYPE="textbox" 
							NAME="MASCARA" 
							VALUE="" 
							SIZE="50" 
							tabindex="1"
							MAXLENGTH="50" 
							readonly=""
							ONBLUR="" 
							ONFOCUS="this.select(); " 
							ONKEYUP="" 
							style="border: medium none; text-align:left; size:auto;"
						></strong>
						<input type="button"  id="verificar" name="verificar" value="verificar" onClick="consultar();">			
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="4"><font size="-1">Luego de digitar la cuenta mayor presione <strong>TAB</strong> para visualizar los niveles de la cuenta</font></td>
				</tr>
				<!---********************************************************************************* --->
				<tr>
					<td  colspan=" 2" width="20%">
						<iframe id="FRAMECJNEGRA2" name="FRAMECJNEGRA2" marginheight="0" marginwidth="0" frameborder="0" height="300" width="770" src="" style="visibility:hiddens"></iframe>
					</td> 
				</tr>
				<!---********************************************************************************* --->
			</table>
			</cfoutput>

			<INPUT type="hidden" style="visibility:hidden" name="NivelDetalle" value="">
			<INPUT type="hidden" style="visibility:hidden" name="NivelTotal" value="">
			<INPUT type="hidden" style="visibility:hidden" name="ORIGEN" value="C">
		    </form>
		<!---********************************************************************************* --->
		<!---** 					   FIN PINTADO DE LA PANTALLA 						    ** --->
		<!---********************************************************************************* --->
		</td>
  	</tr>	
	</table>

	<div align="center"><br>
  	<!--- http://intranet.ice/daf/contabilidad/codigoweb/codigo/ --->
	<img src="parte%20de%20abajo.gif" width="770" height="93" border="0" usemap="#Map2"> 
  	<map name="Map2">
    <area shape="rect" coords="361,4,429,36" href="http://intranet.ice/daf/contabilidad/codigoweb/estructuras/Estructuras.htm">
    <area shape="rect" coords="433,2,478,36" href="http://intranet.ice/daf/contabilidad/codigoweb/objetosgasto/objetosgasto.htm">
    <area shape="rect" coords="480,3,532,34" href="http://intranet.ice/daf/contabilidad/codigoweb/objetosingreso/objetosingreso.htm">
    <area shape="rect" coords="534,4,632,33" href="http://intranet.ice/daf/contabilidad/codigoweb/auxiliares/auxiliares.htm">
    <area shape="rect" coords="634,5,765,36" href="http://intranet.ice/daf/contabilidad/codigoweb/conceptos/conceptoscr.htm">
  	</map>
	</div>

<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<script language="JavaScript1.2" type="text/javascript">
	function valida(){
		if (document.form1.CGE5COD.value == "" || document.form1.CGE5DES.value == "") { alert("Debe digitar el segmento");  document.form1.CGE5COD.focus();return false}
		if (document.form1.CGM1IM.value == "") { alert("Debe digitar la cuenta mayor");  document.form1.CGM1IM.focus();return false}
		if (document.form1.CGM1CD.value == "") { alert("Debe digitar la cuenta detalle");  document.form1.CGM1CD.focus();return false}
		return true
	}
	function  consultar(){
		cargadetalle()		
		if(valida()){
			var  params = "?CGE5COD="+document.form1.CGE5COD.value+"&CGM1IM="+document.form1.CGM1IM.value+"&CGM1CD="+document.form1.CGM1CD.value;
			var frame  = document.getElementById("FRAMECJNEGRA2");
			frame.src 	= "/cfmx/sif/Contaweb_Ext/reportes/CajaNegra/cmn_validacion.cfm"+params;
		}
	}
</script> 
</body>
</html>
