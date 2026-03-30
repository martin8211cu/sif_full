<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Untitled Document</title>
<style type="text/css">
<!--
body {
	font: 100% Verdana, Arial, Helvetica, sans-serif;
	margin: 0; /* it's good practice to zero the margin and padding of the body element to account for differing browser defaults */
	padding: 0;
	text-align: left; /* this centers the container in IE 5* browsers. The text is then set to the left aligned default in the #container selector */
	background:url(cid:FondoPagina_193.jpg)
}
.oneColElsCtr #container {
	margin: 10px auto; /* the auto margins (in conjunction with a width) center the page */
	text-align: left; /* this overrides the text-align: center on the body element. */
}
.oneColElsCtr #mainContent {
	padding: 0 30px; /* remember that padding is the space inside the div box and margin is the space outside the div box */
}
-->
</style></head>

<body class="oneColElsCtr">
<div id="container">
	<div id="mainContent">
		<img src="cid:LogoPagina_193.jpg" />
	    <h2> Estimado Cliente: <cfoutput>#LvarSNnombre#</cfoutput></h2>
		<p>Adjuntamos archivo con informaci&oacute;n detallada relativa a su cuenta de cr&eacute;dito No. <cfoutput>#LvarSNnumero#</cfoutput> correspondiente a los saldos al <cfoutput>#LvarFechaEstado#</cfoutput>.</p>
		<p>En caso de tener alguna consulta o comentario en particular, por favor cont&aacute;ctenos a los tel&eacute;fonos detallados de nuestro departamento,  o a nuestra direcci&oacute;n electr&oacute;nica <cfif isdefined("LvarEmailContacto") and len(trim(LvarEmailContacto))><a href="<cfoutput>#LvarEmailContacto#</cfoutput>"><cfoutput>#LvarEmailContacto#</cfoutput></a><cfelse><a href="mailto:gortega@toyotarp.com">gortega@toyotarp.com</a></cfif></p>
		<p>Si desea obtener informaci&oacute;n acerca de nuestra promociones y servicios puede acceder a nuestra p&aacute;gina electr&oacute;nica dando un click en la direcci&oacute;n <a href="http://www.toyotarp.com"> http://www.toyotarp.com</a></p>
		<p>Ricardo P&eacute;rez, S.A. a nivel nacional te invita a aprovechar las siguientes ofertas</p>
		<p><a href="http://toyotarp.com/kmseguros/"> http://toyotarp.com/kmseguros/</a></p>
		<p><a href="http://toyotarp.com/?cmd=repuestos&sub=43"> http://toyotarp.com/?cmd=repuestos&sub=43</a></p>

		<p>
		<table width="80%">
		<tr><td>&nbsp;</td><td>Panam&aacute;</td><td>210-7000</td><td>Ext. 7035,7034</td></tr>
		<tr><td>&nbsp;</td><td>Chitr&eacute;</td><td>970-3000</td><td>Ext. 111</td></tr>
		<tr><td>&nbsp;</td><td>David</td><td>775-2111</td><td>Ext. 153,155</td></tr>
		</table>
		</p>
		<p>Su informaci&oacute;n ser&aacute; manejada con la confidencialidad requerida.</p>
		<p>En Ricardo P&eacute;rez, S.A. estamos trabajando para servirle cada d&iacute;a mejor.</p>
		<p><strong>Departamento de Cr&eacute;ditos y Cobros</strong></p>
		<img src="cid:PiePagina_193.jpg" width="100%" />
	</div>
</div>
</body>
</html>