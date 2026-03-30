<cfparam name="url.formName" 	default="form1" 					type="String">
<cfparam name="url.sufijo" 		default="" 							type="string">
<cfparam name="url.Ecodigo" 	default="#session.Ecodigo#" 		type="numeric">
<cfparam name="url.width" 		default="815" 						type="integer">
<cfparam name="url.height" 		default="500" 						type="integer">

<cfoutput>
<cf_templatecss>
<table border="0" cellpadding="0" cellspacing="0" width="100%">
	<tr>
		<td align="right">
			<form name="frmAtras" action="OBProyObra.cfm" method="get">
				<input type="hidden" name="formName" 	value="#url.formName#">
				<input type="hidden" name="sufijo" 		value="#url.sufijo#">
				<input type="hidden" name="Ecodigo" 	value="#url.Ecodigo#">
				<input type="hidden" name="width" 		value="#url.width#">
				<input type="hidden" name="height" 		value="#url.height#">
				<input type="submit" class="btnNormal" name="Limpar" id="Limpar" value="Limpar"/>
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<iframe id="ifrObras#url.sufijo#" width="#url.width#" height="#url.height#" src="ConlisOBProyObra.cfm?formName=#url.formName#&sufijo=#url.sufijo#&nivel=0"></iframe>
		</td>
	</tr>
</table>

<script language="javascript1.2" type="text/javascript">
	function fnAsignar#url.sufijo#(nivel, OBPid, OBOid){
		nivel = parseInt(nivel) + 1;
		if(OBOid)
			document.getElementById('ifrObras#url.sufijo#').src="ConlisOBProyObra.cfm?formName=#url.formName#&sufijo=#url.sufijo#&nivel="+nivel+"&OBPid="+OBPid+"&OBOid="+OBOid;
		else
			document.getElementById('ifrObras#url.sufijo#').src="ConlisOBProyObra.cfm?formName=#url.formName#&sufijo=#url.sufijo#&nivel="+nivel+"&OBPid="+OBPid;
		}

	function fnOk#url.sufijo#(OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion){
		if (window.opener.asignarValores#url.sufijo#)
			window.opener.asignarValores#url.sufijo#(OBOid, OBOcodigo, OBOdescripcion, OBPid, OBPcodigo, OBPdescripcion);
		window.close();
	}
</script>
</cfoutput>