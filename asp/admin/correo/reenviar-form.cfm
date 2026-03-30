<cfparam name="url.id" type="numeric" default="0">
<cfquery datasource="asp" name="formdata">
	select SMTPremitente, SMTPdestinatario, SMTPasunto,
		SMTPintentos, SMTPcreado, SMTPenviado, SMTPhtml, SMTPtexto, SMTPcc, SMTPbcc
	from SMTPQueue
	where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>
<cfquery datasource="asp" name="attach">
	select SMTPnombre, SMTPmime, SMTPcontentid, SMTPcontenido, SMTPlocalURL
	from SMTPAttachment
	where SMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>
<cfif Len(Trim(formdata.SMTPremitente)) EQ 0 OR Trim(formdata.SMTPremitente) EQ 'gestion@soin.co.cr'>
  <cfinvoke component="home.Componentes.Politicas"
		method="trae_parametro_global"
		parametro="correo.cuenta"
		returnvariable="remitente"/>
  <cfset QuerySetCell(formdata,'SMTPremitente',remitente)>
</cfif>
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
	
	function mailChangedMultiple(mailctl) {
		mailctl.style.color = isMailMultipleValid(mailctl.value) ? 'black' : 'red';
	}
	
	function isMailMultipleValid(value) { 
		result = value.split(","); 
		for(var i = 0;i < result.length;i++) {
			if(!isMailValid(result[i]))  
				return false;
		}
		return true; 
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
<form action="reenviar-apply.cfm" method="post" name="mailform" id="mailform" onSubmit="return checkForm(this)">
  <cfoutput query="formdata">
    <input type="hidden" name="id" value="#url.id#">
    <input type="hidden" name="sort" value="#sort#">
    <input type="hidden" name="PageNum_lista" value="#PageNum_lista#">
    <table width="580" border="1" cellpadding="2" cellspacing="0" bordercolor="##CCCCCC">
      <tr>
        <td colspan="2" bgcolor="##0033CC"><span class="style1form"> Seleccione el nuevo destinatario</span></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td colspan="2" valign="top" align="left"><table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
            <tr>
              <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: document.mailform.submit();"><img src="images/sendgo.gif" width="23" height="12" hspace="2" border="0" align="top">Reenviar ahora </td>
              <td>|</td>
              <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: history.go(-1);"><img src="images/delete.gif" width="13" height="13" hspace="2" border="0" align="top">Cancelar</td>
            </tr>
          </table></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td width="67" align="left">De</td>
        <td width="398" align="left">#HTMLEditFormat(formdata.SMTPremitente)#</td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Fecha</td>
        <td align="left">#LSDateFormat(formdata.SMTPcreado,'dd-mmm-yyyy')# #LSTimeFormat(formdata.SMTPcreado,'hh:mm:ss')#</td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Para</td>
        <td align="left"><input type="text" onKeyUp="mailChanged(this)" name="email" style="width:370px" onFocus="this.select()" value="# HTMLEditFormat( formdata.SMTPdestinatario)#"></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">CC</td>
        <td align="left"><input type="text" onKeyUp="mailChangedMultiple(this)" name="emailcc" style="width:370px" onFocus="this.select()" value="# HTMLEditFormat(formdata.SMTPcc)#"></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">BCC</td>
        <td align="left"><input type="text" onKeyUp="mailChangedMultiple(this)" name="emailbcc" style="width:370px" onFocus="this.select()" value="# HTMLEditFormat(formdata.SMTPbcc)#"></td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Reintentos </td>
        <td align="left" bgcolor="##CCCCCC"><cfif formdata.SMTPintentos IS 0>
            Pendiente de env&iacute;o
            <cfelse>
            #formdata.SMTPintentos# (&Uacute;ltimo reintento el #LSDateFormat(formdata.SMTPcreado,'dd-mmm-yyyy')# #LSTimeFormat(formdata.SMTPcreado,'hh:mm:ss')#)
          </cfif>
          &nbsp; </td>
      </tr>
      <tr bgcolor="##CCCCCC">
        <td align="left">Asunto</td>
        <td align="left"><strong>#formdata.SMTPasunto#</strong></td>
      </tr>
	<cfif attach.RecordCount>
    <tr bgcolor="##CCCCCC">
      <td>Archivos adjuntos</td>
      <td><strong>#ValueList(attach.SMTPnombre)#</strong>&nbsp;</td>
    </tr></cfif>
    </table>
    <div style="border:2px inset;height:300px;width:577px;overflow:scroll;text-align:left">
      <cfif formdata.SMTPhtml>
        <cfinvoke component="formato"
	  	method="preview"
		texto="#formdata.SMTPtexto#"
		id="#url.id#"
		attach="#attach#"/>
        <cfelse>
        <span style="font:'Courier New', Courier, mono">#formdata.SMTPtexto#</span>
      </cfif>
    </div>
  </cfoutput>
</form>
