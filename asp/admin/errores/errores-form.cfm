<cfparam name="url.id" type="numeric" default="0">
<cfparam name="session.sitio.ip" default="">
<cfquery datasource="aspmonitor" name="formdata">
	update MonErrores
	set leido = 1, leido_por =
	<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.usuario# @ #session.sitio.ip#">
	where errorid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>
<cfquery datasource="aspmonitor" name="formdata">
	select * from MonErrores
	where errorid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id#">
</cfquery>
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
<table width="480" border="1" cellpadding="2" cellspacing="0" bordercolor="##CCCCCC">
  <tr>
    <td colspan="2" bgcolor="##0033CC"><span class="style1form">
	
	<cfif formdata.RecordCount is 0>
	El error ya no est&aacute; en el servidor
	<cfelseif formdata.leido is 0>
	Error pendiente de revisi&oacute;n
	<cfelseif formdata.resuelto is 0>
	Error pendiente de soluci&oacute;n
	<cfelse>
	Error revisado
	</cfif> </span></td>
    </tr>
  <tr bgcolor="##CCCCCC">
    <td colspan="2" valign="top"><table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
	<tr>
		<td class="botonUp" valign="middle" onMouseOver="javascript: buttonOver(this);" onMouseOut="javascript: buttonOut(this);" onClick="javascript: location.href='borrar-apply.cfm?id=#url.id#&PageNum_lista=#PageNum_lista#&sort=#sort#';">
			<img src="images/delete.gif" width="13" height="13" hspace="2" border="0" align="top">Eliminar
		</td>
		<td>|</td>
		<td class="botonUp" valign="middle" onMouseOver="javascript: buttonOver(this);" onMouseOut="javascript: buttonOut(this);" onClick="javascript: location.href='../sesion/index.cfm?aspsessid=#formdata.sessionid#'" >
			<img src="images/sendgo.gif" width="23" height="12" hspace="2" border="0" align="top">Ver sesi&oacute;n </td>
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
	</cfif></span></td>
    </tr>
	</cfif>
  <tr bgcolor="##CCCCCC">
    <td width="67" valign="top">Componente</td>
    <td width="398">#formdata.componente#&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">Fecha</td>
    <td><cfif Len(formdata.cuando)>#LSDateFormat(formdata.cuando,'dd-mmm-yyyy')# #LSTimeFormat(formdata.cuando,'hh:mm:ss')#</cfif>&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">URL</td>
    <td><div style="width:398px;overflow:hidden">
	<a href="#formdata.url#" onclick="return false;">
	#formdata.url#&nbsp;</a></div></td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">IP</td>
    <td>#formdata.ip#&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">Login</td>
    <td>#formdata.login#&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">sessionid</td>
    <td>#formdata.sessionid# | <a href="../sesion/index.cfm?aspsessid=#formdata.sessionid#">ver sesi&oacute;n &gt;&gt;</a>&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">Titulo</td>
    <td>#formdata.titulo#&nbsp;</td>
  </tr>
  <tr bgcolor="##CCCCCC">
    <td valign="top">Detalle</td>
    <td><strong>#formdata.detalle#</strong>&nbsp;</td>
  </tr>
</table>

<div style="border:2px inset;height:200px;width:477px;overflow:scroll">
	  <span>
	  #Replace(formdata.detalle_extra, chr(13),'<br>', 'all')#
	  </span></div>
</cfoutput>