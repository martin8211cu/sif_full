<cfparam name="Attributes.form" type="string" default="form1">
<cfparam name="Attributes.name" type="string" default="texto">
<cfparam name="Attributes.value" type="string" default="">
<cfparam name="Attributes.titulo" type="string" default="titulo">
<cfparam name="Attributes.rows" type="numeric" default="25">
<cfparam name="Attributes.height" type="numeric" default="250">
<cfparam name="Attributes.altOnMouseOver" type="string" default="Editar información adicional">
<cfoutput>
	<script language="javascript" type="text/javascript">
		<!--// //poner a código javascript 
			function info(){
				open('/UtilesExt/ConlisInfo.cfm?form=#Attributes.form#&texto=#Attributes.name#&rows=#Attributes.rows#&height=#Attributes.height#'+'&titulo=' + escape('#Attributes.titulo#'), '#Attributes.name#', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=no,resizable=no,copyhistory=yes,width=600,height=420,left=250, top=200,screenX=250,screenY=200');
			}
		//-->
	</script>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td><a href="javascript:info();"><img border="0" src="/imagenes/iedit.gif" alt="#Attributes.altOnMouseOver#"></a></td>
			<td><input name="#Attributes.name#" type="hidden" value="#Attributes.value#"></td>
		</tr>
	</table>
</cfoutput>