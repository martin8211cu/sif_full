<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body>

<form name="form1" action="#CGI.script_name#?#CGI.query_string#"method="Post" onSubmit="javascript: return valida()">
 <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr bgcolor="#000000"> 
    <td colspan="3"><img src="images/black.gif" width="82" height="30"></td>
  </tr>
  <tr> 
    <td>&nbsp;</td>
    <td width="512"> 
      <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr> 
          <td width="330"><a href="Parche.jsp"><img src="images/acce1a.gif"  width="330" height="175" border="0"></a></td>
          <td valign="bottom" width="182"> 
          
              <b><font face="Arial, Helvetica, sans-serif" size="2">Usuario</font></b><br> 
				<INPUT 	TYPE="textbox" 
				NAME="j_username" 
				VALUE="<cfif isdefined("url.LOGIN") and url.LOGIN NEQ ""><cfoutput>#url.LOGIN#</cfoutput></cfif>"
				SIZE="20" 
				MAXLENGTH="20" 
				ONBLUR="" 
				ONFOCUS="" 
				ONKEYUP="" 
				>
              <br>
              <b><font face="Arial, Helvetica, sans-serif" size="2">Contrase&ntilde;a</font></b><br>
				<INPUT 	TYPE="password" 
				NAME="j_password" 
				VALUE=""
				SIZE="20" 
				MAXLENGTH="20" 
				ONFOCUS="" 
				ONKEYUP="" 
				onBlur="javascript:encriptar(this);"
				>
              <br>
			 <a href="javascript:ACEPTAR()"><img border="0" src="images/boton.gif" width="59" height="26"></a>
          </td>
        </tr>
        <tr> 
          <td colspan="2"><img src="images/acce2.gif" width="512" height="106"></td>
        </tr>
        <tr> 
          <td colspan="2">
            <p align="center"><img src="images/white.gif" width="20" height="39"><input name="msgs" size="20" onfocus='this.blur()' tabindex='-1' 
        style="background-color: rgb(255,255,255); color: rgb(255,0,0);border: medium none"></p>
          </td>
        </tr>
      </table>
    </td>
    <td>&nbsp;</td>
  </tr>
  <tr bgcolor="#000000"> 
    <td colspan="3"><img src="images/black.gif" width="1" height="1"></td>
  </tr>
  <tr> 
    <td rowspan="4">&nbsp;</td>
    <td rowspan="4"> 
      <p align="center"><br>
        <img src="images/logos.gif" width="265" height="48"></p>
      </td>
    <td rowspan="4">&nbsp;</td>
  </tr>
</table>


<input type="hidden" name="VALIDA" value="1">
</form>
</body>
</html>
<script language="JavaScript1.2" src="../js/secure/md5.js"></script>
<script language="JavaScript">
function encriptar(dato) {	
	var  codigo="lcm140679";
	var  user = document.form1.j_username.value;

	if(user !="" && dato.value !=""){
		var  hash = hex_md5(user+codigo+dato.value);
		var  nueva  = "";
		for (var i=0; i<hash.length; i++){
			CARACTER = hash.substring(i,i+1);
			switch (CARACTER) {	
				case "8": {
					CARACTER = "0"
					break
				}
				case "9": {
					CARACTER = "1"
					break
				}
				case "a": {
					CARACTER = "2"
					break
				}
				case "b": {
					CARACTER = "3"
					break
				}
				case "c": {
					CARACTER = "4"
					break
				}	
				case "d": {
					CARACTER = "5"
					break
				}			
				case "e": {
					CARACTER = "6"
					break
				}
				case "f": {
					CARACTER = "7"
					break
				}											
															
			}
			CARACTER2 = hash.substring(i+1,i+2);
			nueva = nueva + CARACTER+ CARACTER2
			i++
		}
		dato.value = nueva;
	}
	else{
		alert("debe digitar el login")
		dato.value="";
		document.form1.j_username.focus();
	}	
		document.form1.VALIDA.value = "0"	
}	
function valida(){
	if(document.form1.VALIDA.value == "0")
		return true;
	else
		return false;	
	alert(document.form1.VALIDA.value)	
}

function ACEPTAR(){
	var x1 = document.forms[0];
	x1.submit();
}
</script>