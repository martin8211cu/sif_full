<cfquery datasource="#session.dsn#" name="maxfoto" >
	select max(id_foto) as maxfoto
	from FotoProducto p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_producto#" null="#Len(url.id_producto) Is 0#">
	  and datalength(p.img_foto) != 0
</cfquery>

<cfset txt_descripcion="">
<cfif modo NEQ "ALTA">
	<cfset txt_descripcion=Trim(rsProducto.txt_descripcion)>
	<cfif FindNoCase('<p>', txt_descripcion) is 0 and FindNoCase('<br>', txt_descripcion) is 0>
		<cfset txt_descripcion = '<p>'&Replace(txt_descripcion, chr(10), '<br>' & chr(10) , 'all')&'</p>'>
	</cfif>
</cfif>	
<cfoutput>
<table width="800" border="0" align="center">
<tr valign="top" > 
	<td width="458" align="left" nowrap><u>C</u>aracter&iacute;sticas</td>
	<td width="10" align="left">&nbsp;</td>
	<td width="318" align="left">Agregar nueva <u>i</u>magen</td>
</tr>

<tr valign="top">
	<td rowspan="3" align="left" nowrap>
		<textarea onFocus="select()" name="txt_descripcion"
		tabindex="4" cols="70" rows="4"><cfif modo NEQ "ALTA">#txt_descripcion#</cfif></textarea></td>
	<td align="left">&nbsp;</td>
	<td height="26" align="left"><input tabindex="6" accesskey="i" type="file" name="foto_1" onChange="document.getElementById('img_foto_1').src = this.value" >
	</td>
</tr>

<tr valign="top">
  <td align="left">&nbsp;</td>
  <td align="left"><img src="<cfif Len(maxfoto.maxfoto)>../../public/producto_img.cfm?id=#URLEncodedFormat(url.id_producto)
  		#&amp;tid=#URLEncodedFormat(session.Ecodigo)
		#&amp;fid=#URLEncodedFormat(maxfoto.maxfoto)
		#&sz=nr<cfelse>../blank.gif</cfif>" alt="" height="240" name="img_foto_1" border="1" ></td>
</tr>
<tr>
  <td align="left" valign="top">&nbsp;</td>
  <td height="62" align="left" valign="top">La imagen debe tener una altura de 240 pixeles para que no se deforme, y un ancho de 180 a 320 pixeles </td>
</tr>	
</table>
</cfoutput>

<script type="text/javascript">
	function validarTab(){
		return true;
	}
</script>

<cfinclude template="htmleditarea_config_js.cfm">
<script  type="text/javascript">
<!--
	editor_generate('txt_descripcion', config);
//-->
</script>
