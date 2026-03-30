<cfquery datasource="#session.dsn#" name="data" maxrows="200">
	select id_producto, id_foto
	from FotoProducto p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_producto#" null="#Len(url.id_producto) Is 0#">
	  and datalength(p.img_foto) != 0
</cfquery>

<cfoutput>
<table width="800" border="0" align="center" cellpadding="4" cellspacing="0">
<tr valign="top" class="tituloListas" > 
	<td width="300" align="left" nowrap>Im&aacute;genes registradas </td>
	<td width="16" align="left">&nbsp;</td>
	<td width="380" align="left">Agregar nueva <u>i</u>magen</td>
    <td width="72" align="left">&nbsp;</td>
</tr>

<tr valign="top">
	<td rowspan="3" align="left">
	

<div style="width:300px;height:12px;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:10px">
Haga clic en las siguientes im&aacute;genes para verlas en detalle
</div><div style="width:300px; height:280px; overflow:auto; margin:0;">

<cfloop query="data">
<a href="javascript:loadImage(#data.id_foto#)" onMouseOver="javascript:loadImage(#data.id_foto#)"><img 
	src="../../public/producto_img.cfm?tid=#session.Ecodigo#&id=#URLEncodedFormat(data.id_producto)
	#&fid=#URLEncodedFormat(data.id_foto)#&dft=na&sz=sm" id='foto#data.id_foto#' height="60" style="border:2px solid white"></a>
</cfloop>	

</div>
	
	</td>
	<td align="left">&nbsp;</td>
	<td height="26" align="left"><input tabindex="6" accesskey="i" type="file" id="foto_1"name="foto_1" onChange="imageSelected(this)" >
	<input type="hidden" name="id_foto" value="">
	<input type="hidden" name="modo_foto" value="alta">
	</td>
    <td align="left">&nbsp;</td>
</tr>

<tr valign="top">
  <td height="255" align="left">&nbsp;</td>
  <td align="left"><img src="../../images/blank.gif" alt="" style="height:240px;" name="bigimage" border="1" ></td>
  <td align="left">
    <input name="Cambio" type="submit" id="AltaFoto" value="Agregar" style="width:70px" onClick="imageAction(form,'alta')" disabled>
    <br><br>
    <input name="Cambio" type="submit" id="BajaFoto" value="Eliminar" style="width:70px" onClick="imageAction(form,'baja')" disabled>
    <br></td>
</tr>
<tr>
  <td align="left" valign="top">&nbsp;</td>
  <td height="54" align="left" valign="top">La imagen debe tener una altura de 240 pixeles, y un ancho entre 120 y 360 pixeles.</td>
  <td align="left" valign="top">&nbsp;</td>
</tr>	
</table>
</cfoutput>

<script type="text/javascript">
<!--
	function validarTab(){
		return true;
	}
	function imageAction(f,action){
		f.modo_foto.value = action;
	}
	document.currentimage=false;
	function loadImage (id_foto) {
		document.form1.id_foto.value = id_foto;
		var bigimage = document.all ? document.all.bigimage : document.getElementById("bigimage");
		var selected_image = document.all ? document.all['foto'+id_foto] : document.getElementById('foto'+id_foto);
		bigimage.src = selected_image.src.replace(/sz=sm/,'sz=nr');
		if (document.currentimage) {
			document.currentimage.style.borderColor = "white";
		}
		selected_image.style.borderColor = "navy";
		document.currentimage = selected_image;
		document.form1.AltaFoto.disabled = true;
		document.form1.BajaFoto.disabled = false;
		document.form1.foto_1.value = '';
	}
	function imageSelected(fileobj) {
		var bigimage = document.all ? document.all.bigimage : document.getElementById("bigimage");
		bigimage.style.height="auto";
		bigimage.src = fileobj.value;
		window.status = 'width:'+bigimage.width+', height:'+bigimage.height;
		bigimage.style.height="240px";
		document.form1.id_foto.value = '';
		document.form1.AltaFoto.disabled = false;
		document.form1.BajaFoto.disabled = true;
	}
//-->
</script>