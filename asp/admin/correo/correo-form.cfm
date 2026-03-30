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
	<cfif formdata.RecordCount>
	  <cfset QuerySetCell(formdata,'SMTPremitente',remitente)>
	</cfif>
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
	
</script>
<cfoutput>
  <table width="580" border="1" cellpadding="2" cellspacing="0" bordercolor="##CCCCCC">
    <tr>
      <td colspan="2" bgcolor="##0033CC"><span class="style1form">
        <cfif formdata.RecordCount is 0>
          El correo ya no est&aacute; en el servidor
          <cfelseif formdata.SMTPintentos is 0>
          Correo pendiente de env&iacute;o
          <cfelse>
          Correo no se pudo enviar
        </cfif>
        </span></td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td colspan="2" valign="top"><table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
          <tr>
            <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: location.href='borrar-apply.cfm?id=#url.id#&PageNum_lista=#PageNum_lista#&sort=#sort#';"><img src="images/delete.gif" width="13" height="13" hspace="2" border="0" align="top">Eliminar </td>
            <td>|</td>
            <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: location.href='retry-apply.cfm?id=#url.id#&PageNum_lista=#PageNum_lista#&sort=#sort#';"><img src="images/sendgo.gif" width="23" height="12" hspace="2" border="0" align="top">Reintentar ahora </td>
            <td>|</td>
            <td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: location.href='reenviar.cfm?id=#url.id#&PageNum_lista=#PageNum_lista#&sort=#sort#';"><img src="images/to.gif" width="14" height="14" hspace="2" border="0" align="top">Reenviar a otra direcci&oacute;n de correo </td>
          </tr>
        </table></td>
    </tr>
    <cfif isdefined("url.retry_status")>
      <tr bgcolor="##CCCCCC">
        <td colspan="2"><span style="color:red;font-weight:bold;">
          <cfif url.retry_status>
            El mensaje fue enviado con &eacute;xito
            <cfelse>
            El mensaje no se pudo enviar
            <cfif IsDefined("url.retry_error")>
              <br>
              #HTMLEditFormat(url.retry_error)#
            </cfif>
          </cfif>
          </span></td>
      </tr>
    </cfif>
    <tr bgcolor="##CCCCCC">
      <td width="67">De</td>
      <td width="398">#HTMLEditFormat(formdata.SMTPremitente)#&nbsp;</td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>Fecha</td>
      <td><cfif Len(formdata.SMTPcreado)>
          #LSDateFormat(formdata.SMTPcreado,'dd-mmm-yyyy')# #LSTimeFormat(formdata.SMTPcreado,'hh:mm:ss')#
        </cfif>
        &nbsp;</td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>Para</td>
      <td>#HTMLEditFormat(formdata.SMTPdestinatario)#&nbsp;</td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>CC</td>
      <td>#HTMLEditFormat(formdata.SMTPcc)#&nbsp;</td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>BCC</td>
      <td>#HTMLEditFormat(formdata.SMTPbcc)#&nbsp;</td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>Reintentos </td>
      <td bgcolor="##CCCCCC"><cfif formdata.SMTPintentos IS 0>
          Pendiente de env&iacute;o
          <cfelse>
          #formdata.SMTPintentos#
          <cfif Len(formdata.SMTPenviado)>
            (&Uacute;ltimo reintento el #LSDateFormat(formdata.SMTPenviado,'dd-mmm-yyyy')# #LSTimeFormat(formdata.SMTPenviado,'hh:mm:ss')#)
          </cfif>
        </cfif>
        &nbsp; </td>
    </tr>
    <tr bgcolor="##CCCCCC">
      <td>Asunto</td>
      <td><strong>#formdata.SMTPasunto#</strong>&nbsp;</td>
    </tr>
	<cfif attach.RecordCount>
    <tr bgcolor="##CCCCCC">
      <td>Archivos adjuntos</td>
      <td><strong>#ValueList(attach.SMTPnombre)#</strong>&nbsp;</td>
    </tr></cfif>
  </table>
  <div style="border:2px inset;height:300px;width:577px;overflow:scroll">
    <cfif Len(formdata.SMTPhtml) and formdata.SMTPhtml>
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