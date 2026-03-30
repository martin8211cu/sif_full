<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Fotos del producto</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0">
<script type="text/javascript">
<!--
	document.currentimage=false;
	function loadImage(imageid) {
		var bigimage = document.all ? document.all.bigimage : document.getElementById("bigimage");
		var selected_image = document.all ? document.all[imageid] : document.getElementById(imageid);
		bigimage.src = selected_image.src.replace(/sz=sm/,'sz=nr');
		if (document.currentimage) {
			document.currentimage.style.borderColor = "white";
		}
		selected_image.style.borderColor = "navy";
		document.currentimage = selected_image;
	}
//--></script>

<cfquery datasource="#session.dsn#" name="data" maxrows="20">
	select id_producto, id_foto
	from FotoProducto p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
	  and datalength(p.img_foto) != 0
</cfquery>
<cfquery datasource="#session.dsn#" name="producto">
	select nombre_producto
	from Producto p
	where p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.comprar_Ecodigo#">
	  and p.id_producto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.prod#">
</cfquery>

<center style="width:360px;font-size:16px;font-family:Verdana, Arial, Helvetica, sans-serif">
<cfoutput>#producto.nombre_producto#</cfoutput></center>
<cfif data.RecordCount GT 1>
	<div style="width:360px;height:12px;font-family:Verdana, Arial, Helvetica, sans-serif;font-size:10px">
	Haga clic en las siguientes im&aacute;genes para verlas en detalle
	</div><div style="width:360px; height:70px; overflow:auto; margin:0;">
	<table border="0" width="360" cellpadding="2" cellspacing="0" style="margin:0"><tr>
	<cfoutput query="data">
	<td height="60"><a href="##" onClick="loadImage('foto#data.id_foto#')"><img 
		src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#URLEncodedFormat(data.id_producto)
		#&fid=#URLEncodedFormat(data.id_foto)#&dft=na&sz=sm" id='foto#data.id_foto#' height="60" style="border:2px solid white"></a></td>
	</cfoutput>	
	</tr></table>
	</div>
</cfif>

<center style="margin-top:6px;;width:360px">
<cfoutput>
<img align="absmiddle" src="producto_img.cfm?tid=#session.comprar_Ecodigo#&id=#URLEncodedFormat(data.id_producto)
	#&fid=#URLEncodedFormat(data.id_foto)#&dft=na&sz=nr"  height="240" border="1" id="bigimage" >
</cfoutput>
<form style="margin:0;margin-top:6px;" action="" method="get">
<input type="button" value="Cerrar" onClick="window.close()"></form></center>
</body>
</html>
