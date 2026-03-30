<cfinclude template="/home/menu/pNavegacion.cfm">

<form action="ProcesoImportar.cfm" enctype="multipart/form-data" method="post">
	<table width="100%" border="0" cellpadding="1" cellspacing="1">
		<tr>
			<td width="1%" nowrap>Ubicaci&oacute;n del archivo (framework-app.xml):&nbsp;</td>
			<td width="1%"><input type="file" name="FiletoUpload" size="45"></td>
			<td>&nbsp;<input type="submit" name="Procesar" value="Procesar"></td>
		</tr>
	</table>
</form>
