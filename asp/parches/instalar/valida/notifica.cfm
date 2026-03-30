<cfinvoke component="asp.parches.comp.instala" method="get_servidor" returnvariable="servidor" />
<cfquery datasource="asp" name="APServidor">
	select
		servidor, cliente, hostname, ipaddr, admin_email,
		notifica_instalacion, actualizado
	from APServidor
	where servidor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#servidor#">
</cfquery>

<cfset Politicas = CreateObject("component", "home.Componentes.Politicas")>
<cfset remitente = Politicas.trae_parametro_global("correo.cuenta")>
<cfinvoke component="asp.parches.comp.instala" method="redactar_mensaje" returnvariable="message" />
<cfset message_body = ''>
<cf_templateheader title="Notificar resultado">
<cfinclude template="../mapa.cfm">
<cf_web_portlet_start titulo="Notificar resultado" width="700">


<style type="text/css">
<!--
.style1form {
	color: #FFFFFF;
	font-size:12px;
	font-weight: bold;
	font-family: Georgia, "Times New Roman", Times, serif;
}
.botonDown {
	font-family: Tahoma, sans-serif; 
	font-size: 8pt; 
	padding-left: 3px;
	padding-right: 3px;
	background-color: #E9F2F8;
	border: 1px solid #336699;
	cursor: pointer;
}
.botonUp {
	font-family: Tahoma, sans-serif; 
	font-size: 8pt; 
	padding-left: 4px;
	padding-right: 4px;
	cursor: pointer;
}
-->
</style>
<script language="javascript" type="text/javascript">
	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}
	
	function isMailValid(mail) {
		return (mail.match(/^[^@]+@[A-Za-z_-]+(\.[A-Za-z_-]+)+$/));
	}
	
	function mailChanged(mailctl) {
		mailctl.style.color = isMailValid(mailctl.value) ? 'black' : 'red';
	}
	
	function checkForm(f) {
		if (f.email.value == "") {
			f.email.focus();
			alert("Digite un email v\\u00e1lido");  <!--- no se porque pero ocupo un doble backslash --->
			f.email.select();
			return false;
		}
		if (!isMailValid(f.email.value)) {
			f.email.focus();
			if (!confirm("El email seleccionado no parece ser v\\u00e1lido. Desea continuar?")){  <!--- no se porque pero ocupo un doble backslash --->
				f.email.select();
				return false;
			}
		}
		return true;
	}
	
</script>
<form action="notifica-apply.cfm" method="post" name="mailform" id="mailform" onSubmit="return checkForm(this)">
  <cfoutput>
    <table width="680" border="1" cellpadding="2" cellspacing="0" bordercolor="##CCCCCC">
      <tr>
        <td colspan="2" bgcolor="##0033CC"><span class="style1form"> Seleccione el nuevo destinatario</span></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td colspan="2" valign="top" align="left"><table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
            <tr>
              <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" 
			  onmouseout="javascript: buttonOut(this);" onClick="javascript: document.mailform.submit();">
			  <img src="../../images/sendgo.gif" width="23" height="12" hspace="2" border="0" align="top">Enviar ahora </td>
			  <td>
			  <cfif IsDefined('url.msg') and url.msg EQ '1'>
			  <div id="div_msg_ok" style="font-weight:bold;color:##993300" >El mensaje ha sido enviado</div>
			  <script type="text/javascript">
			  function hidemsgok(){
			  	with (document.all ? document.all.div_msg_ok : document.getElementById('div_msg_ok')) {
					style.display = "none";
				}
			  }
			  window.setTimeout("hidemsgok()", 5000);
			  </script>
			  </cfif>
			  </td>
            </tr>
          </table></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td width="67" align="left">De</td>
        <td width="398" align="left">#HTMLEditFormat(remitente)#</td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Fecha</td>
        <td align="left">#LSDateFormat(Now(),'dd-mmm-yyyy')# #LSTimeFormat(Now(),'hh:mm:ss')#</td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Para</td>
        <td align="left"><input type="text" onKeyUp="mailChanged(this)" name="email" style="width:370px" onFocus="this.select()" value="# HTMLEditFormat( APServidor.admin_email)#"></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Asunto</td>
        <td align="left"><strong># HTMLEditFormat( message.subject )#</strong></td>
      </tr>
    <tr bgcolor="##CCCCCC">
      <td>Archivos adjuntos</td>
      <td><strong>informe.xml</strong>&nbsp;</td>
    </tr>
    </table>
    <div style="border:2px inset;height:300px;width:676px;overflow:scroll;text-align:left">
	#message.body#
    </div>
  </cfoutput>
</form>


<cf_web_portlet_end>