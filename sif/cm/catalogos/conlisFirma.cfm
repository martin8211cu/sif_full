<cfif isdefined("url.CMCid") and not isdefined("form.CMCid")>
	<cfset form.CMCid= url.CMCid >
</cfif>
<cfset modo="CAMBIO">


<!---  Se asignan las variables que vienen por URL a FORM  ----->
<cfif isdefined("Url.CMCid") and not isdefined("Form.CMCid")>
	<cfparam name="Form.CMCid" default="#Url.CMCid#">
</cfif>
<!--- Recibe conexion, form, name y desc --->
<script language="JavaScript" type="text/javascript">
function Terminar(){
		//window.document.AtualizarFirma.submit();
		window.opener.document.form1.submit();
		//window.close();
}
</script>
<html>
<head>
<title>Actualizaci&oacute;n de Firma Digital</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cfoutput>
<form style="margin:0;" name="AtualizarFirma" method="post" enctype="multipart/form-data" onSubmit="return Terminar();">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
	  <td align="right"><strong>Firma Digital:</strong>&nbsp;</td>
	  <td><input type="file" name="CMFfirma"></td>
		<td align="center">
			<input name="btnFirma" type="submit" id="btnFirma" value="Actualizar firma">
		</td>
	</tr>
</table>
</form>
<cfif isdefined("form.CMFfirma") and len(trim(form.CMFfirma)) and isdefined("form.btnFirma")>
	
	<cfquery name="deleteFirma" datasource="#Session.DSN#">
		delete from CMFirmaComprador
		where CMCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">
	</cfquery>
	<cfquery name="insertFirma" datasource="#Session.DSN#">
		insert into CMFirmaComprador(CMCid, CMFfirma)
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CMCid#">,
				<cf_dbupload filefield="CMFfirma" accept="image/*" datasource="#session.DSN#">)
	</cfquery>
	<script language="JavaScript" type="text/javascript">
		window.close();
	</script>	
</cfif>	

</cfoutput>

</body>
</html>