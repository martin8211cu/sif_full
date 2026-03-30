<!---
	Israel Rodríguez 16-Oct-2014

--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_PopupBlock" default="Aviso: Su bloqueador de ventanas emergentes (popup blocker) \nestá evitando que se abra la ventana.\nPor favor revise las opciones de su navegador (browser), y \nacepte las ventanas emergentes de este sitio:" returnvariable="MSG_PopupBlock" xmlfile="/sif/TagsSIF/sifIncluirSelloDigital.xml"/>

<!--- Parámetros del TAG --->
<cfparam name="Attributes.Nombre"			default="Sello" 				type="string"> <!--- Nombre --->
<cfparam name="Attributes.Mostrar"			default="V" 				type="string"> <!--- Define si se visualizan los controles Horizontal(H) o Verticalmente(V)[Default] --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_TimbreFiscal" default="Timbre Fiscal UUID" returnvariable="LB_TimbreFiscal" xmlfile="sifIncluirSelloDigital.xml"/>

<cfquery name="Band" datasource="#Session.DSN#">
 SELECT Pvalor FROM Parametros WHERE Pcodigo = 200087 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>

<cfoutput>
	<script language="JavaScript">
		function toggle#Attributes.nombre#(){
			if(document.getElementById('chk_#Attributes.Nombre#').checked){
				document.getElementById('tr#Attributes.Nombre#_file').style.display = '';
				document.getElementById('tr#Attributes.Nombre#_cer').style.display = '';
				document.getElementById('tr#Attributes.Nombre#_psw').style.display = '';
				document.getElementById('psw_#Attributes.Nombre#').value = '';
				document.getElementById('key_#Attributes.Nombre#').value = '';
				document.getElementById('cer_#Attributes.Nombre#').value = '';
				document.getElementById("key_#Attributes.Nombre#").setAttributeNode(document.createAttribute("required"));
				document.getElementById("cer_#Attributes.Nombre#").setAttributeNode(document.createAttribute("required"));
				document.getElementById("psw_#Attributes.Nombre#").setAttributeNode(document.createAttribute("required"));

			}
			else{
				document.getElementById('tr#Attributes.Nombre#_file').style.display = 'none';
				document.getElementById('tr#Attributes.Nombre#_cer').style.display = 'none';
				document.getElementById('tr#Attributes.Nombre#_psw').style.display = 'none';
				document.getElementById("psw_#Attributes.Nombre#").removeAttribute("required");
				document.getElementById("key_#Attributes.Nombre#").removeAttribute("required");
				document.getElementById("cer_#Attributes.Nombre#").removeAttribute("required");
			}

		}

		function extraeNombre#Attributes.Nombre#_cer(value){
			var path = value.split('\\').pop().split('/').pop();
			//var filename = path.split('.').shift();
	       	document.getElementById('hCer_#Attributes.Nombre#').value=path;
		}

		function extraeNombre#Attributes.Nombre#_key(value){
			var path = value.split('\\').pop().split('/').pop();
			//var filename = path.split('.').shift();
	       	document.getElementById('hKey_#Attributes.Nombre#').value=path;
		}
	</script>
</cfoutput>

<cfif Band.Pvalor EQ 'S'>
	<cfoutput>
		<cfif Attributes.Mostrar EQ "V">
			<table>
				<tr>
					<td colspan="2" align="center"><input type="checkbox" id="chk_#Attributes.Nombre#" name="chk_#Attributes.Nombre#" value="sellar" onclick="toggle#Attributes.nombre#();">Incluir sello digital</td>
				</tr>
				<tr id="tr#Attributes.Nombre#_file" style="display:none">
					<td align="right">Archivo llave:</td>
					<td align="left"><input type="file" name="key_#Attributes.Nombre#" id="key_#Attributes.Nombre#" value="" onChange="javascript:extraeNombre#Attributes.Nombre#_key(this.value);" accept=".key" size="40" tabindex="100"></td>
				</tr>
				<tr id="tr#Attributes.Nombre#_cer" style="display:none">
					<td align="right">Certificado:</td>
					<td align="left"><input type="file" name="cer_#Attributes.Nombre#" id="cer_#Attributes.Nombre#" value="" onChange="javascript:extraeNombre#Attributes.Nombre#_cer(this.value);"  accept=".cer" size="40" tabindex="100"></td>
					<input type="hidden" name="hCer_#Attributes.Nombre#" id="hCer_#Attributes.Nombre#" value="">
					<input type="hidden" name="hKey_#Attributes.Nombre#" id="hKey_#Attributes.Nombre#" value="">
				</tr>
				<tr id="tr#Attributes.Nombre#_psw" style="display:none">
					<td align="right">Clave:</td>
					<td align="left"><input type="password" name="psw_#Attributes.Nombre#" id="psw_#Attributes.Nombre#" value=""></td>
				</tr>
			</table>
		<cfelse>
			<table width="100%" cellspacing="1">
				<tr valign="center">
					<td valign="center" nowrap align="left"><input type="checkbox" id="chk_#Attributes.Nombre#" name="chk_#Attributes.Nombre#" value="sellar" onclick="toggle#Attributes.nombre#();">Incluir sello digital&nbsp;</td>
					<td align="left"  id="tr#Attributes.Nombre#_file" style="display:none">Archivo llave:<input type="file" name="key_#Attributes.Nombre#" id="key_#Attributes.Nombre#" value="" onChange="javascript:extraeNombre#Attributes.Nombre#_key(this.value);" accept=".key" size="40" tabindex="100"></td>
					<td align="left"id="tr#Attributes.Nombre#_cer" style="display:none">Certificado:<input type="file" name="cer_#Attributes.Nombre#" id="cer_#Attributes.Nombre#" value="" onChange="javascript:extraeNombre#Attributes.Nombre#_cer(this.value);"  accept=".cer" size="40" tabindex="100"></td>
					<input type="hidden" name="hCer_#Attributes.Nombre#" id="hCer_#Attributes.Nombre#" value="">
					<input type="hidden" name="hKey_#Attributes.Nombre#" id="hKey_#Attributes.Nombre#" value="">
					<td align="left" id="tr#Attributes.Nombre#_psw" style="display:none">Clave:<input type="password" name="psw_#Attributes.Nombre#" id="psw_#Attributes.Nombre#" value=""></td>
				</tr>
			</table>
		</cfif>
	</cfoutput>
</cfif>
