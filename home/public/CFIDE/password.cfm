<html>
<head>
	<title>Registro del Password de Administrator ColdFusion</title>
	<script language="javascript">
		function sbVerificar()
		{
			var p = document.form1.txtPassword;
			if (p.value.match(/^\s*$/))
			{
				alert ("Debe digitar un password para su registro");
				return false
			}
			return true;
		}
		<cfparam name="url.alert" default="">
		<cfif url.alert EQ 1>
			alert('Esta instalación de Coldfusion requiere que registre el password de Administrador para leer la información de los Datasources');
		<cfelseif url.alert EQ 2>
			alert('El password de Administrador de Coldfusion registrado para leer la información de los Datasources fue modificado');
		</cfif>
	</script>
<style> 
body, p, td {
	font-family: Arial, Helvetica, sans-serif;
	font-size: x-small;
}
th {
 font-family: Arial, Helvetica, sans-serif;
 font-size: small; ! important;
}
th {
 text-align:left;
}
.adminbody {
	background-color: #c4c4c4;
}
.resourcelist {
	list-style-type:square;
	margin-top:5px;
	margin-bottom:10px;
}
.errorText {
	color: #CC0000; 
}
.successText {
	color: #008800; 
}
.loginWhiteText {
	color: #FFFFFF; 
	font-weight: bold;
}
.loginInvalidText {
	color: #CC0000; 
	font-weight: bold;
}
.loginCopyrightText {
	color: #000000;
	font-size: 9px;
	font-family:Arial, Helvetica, sans-serif;
}
a {
	color: #003399;
	text-decoration: none;
}
 
a:hover {
	color: #008A00; 
}
 
.iconLinkText {
	color: #FFFFFF;
	font-weight: bold;
 
	font-size: x-small;
 
}
 
.leftMenuLinkText {
	color: #6C7A83; 
 
	font-size: x-small;
 
}
 
.leftMenuLinkTextHighlighted {
	color: #123f61; 
 
	font-size: x-small;
 
	font-weight:bold;
}
 
.topMenuLinkText {
	color: #000000;
	font-size: x-small; 
}
 
.menuCFAdminText {
	color: #000000;
	font-weight: bold;
	
 
	font-size: x-small;
 
}
 
.menuAuxText {
	color: #6C7A83;
	
		font-size: x-small;
	
}
 
.menuHeaderText {
	color: #0072AC;
	font-weight: bold;
 
	font-size: xx-small;
 
	text-transform:uppercase;
}
 
.menuTD {
	/*border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: none;
	border-right-style: none;
	border-bottom-style: solid;
	border-left-style: none;
	border-bottom-color: #CCCCCC;*/
	background: #ececec;
}
 
.menuTDHeader {
	/* can delete me thinks */
	/*border-top-width: 1px;
	border-right-width: 1px;
	border-bottom-width: 1px;
	border-left-width: 1px;
	border-top-style: solid;
	border-right-style: none;
	border-bottom-style: solid;
	border-left-style: none;*/
	background: #ececec url('\2f cfmx\2f CFIDE\2f administrator\2f images/cap_menuitem_background.png') repeat-x;
}
.menuTDHeaderLeft {
	border-left-style:solid;
	border-left-width: 1px;
	border-color: #c4c4c4;
	background: #ececec url('\2f cfmx\2f CFIDE\2f administrator\2f images/cap_menuitem_background.png') repeat-x;
}
.menuTDHeaderRight {
	border-right-style:solid;
	border-right-width: 1px;
	border-color: #c4c4c4;
	background: #ececec url('\2f cfmx\2f CFIDE\2f administrator\2f images/cap_menuitem_background.png') repeat-x;
}
 
h1 {
	color: #000000;
	font-weight: bold;
	font-size: x-small;
	margin-top: 5px;
	margin-bottom: 5px;
}
 
.pageHeader {
	color: #0072AC;
	font-weight: bold;
	font-size: medium;
	margin-top: 5px;
	margin-bottom: 5px;
}
 
.currentuser {
	color: #0072AC;
	font-weight: bold;
	font-size: x-small;
	margin-top: 5px;
	margin-bottom: 5px;
}
 
.cellBlueSides {
	border-right-width: 1px;
	border-left-width: 1px;
	border-right-style: solid;
	border-left-style: solid;
	border-right-color: #C1D9DB;
	border-left-color: #C1D9DB;
}
 
.cellLeftBlueSide {
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #D5E3E6;
}
 
.cellRightAndBottomBlueSide {
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #D5E3E6;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #D5E3E6;
}
 
.cell3BlueSides {
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #D5E3E6;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #D5E3E6;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #D5E3E6;
}
 
.cell4BlueSides {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #D5E3E6;
	border-left-width: 1px;
	border-left-style: solid;
	border-left-color: #D5E3E6;
	border-right-width: 1px;
	border-right-style: solid;
	border-right-color: #D5E3E6;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #D5E3E6;
}
 
.cell2BlueSidesAndBlueBkgd {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #D5E3E6;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #D5E3E6;
	background-color: #E8F0F1;
}
 
.cellBlueTop {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #C1D9DB;
}
 
.cellBlueBottom {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #C1D9DB;
}
 
.cellBlueTopAndBottom {
	border-top-width: 1px;
	border-top-style: solid;
	border-top-color: #C1D9DB;
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #C1D9DB;
}
 
.cellBordersBlue {
	border: 1px solid #C1D9DB;
}
 
.cellGrayBottom {
	border-bottom-width: 1px;
	border-bottom-style: solid;
	border-bottom-color: #E2E6E7;
}
 
.copyright {
	color: #000000;
	
		font-size: xx-small;
	
}
 
.copyrightLink {
	color:#003399; 
	
		font-size: xx-small;
	
}
 
.disabled {
	color: #999999;
}
.color-title		{background-color:888885;color:white;background-color:7A8FA4;}
.color-header		{background-color:ddddd5;}
.color-buttons		{background-color:ccccc5;}
.color-border		{background-color:666666;}
.color-row			{background-color:fffff5;}
.color-rowalert		{background-color:ffddaa;}
.buttn,.buttnText	{font-size:1em;font-family: tahoma,arial,Geneva,Helvetica,sans-serif;background-color:e0e0d5;}
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<!-- frame buster - code by Gordon McComb -->
 
<body bgcolor="#6C7A83">
 
<form name="form1" action="password_apply.cfm" method="POST">
<table>
	<tr>
		<td><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="1" height="100"></td>
	</tr>
</table>
 
<table width="570" border="0" cellspacing="0" cellpadding="0" align="center" background="adobeCF.JPG">
		<tr>
			<td colspan="4"><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="1" height="100"></td>
		</tr>
		<tr>
			<td colspan="4" style="padding-left:8px;">
				Los sistemas desarrollados por SOIN Soluciones Integrales S.A. necesitan recuperar información de la definición de DSN (Data Source Names) definidos en el Administrador de Coldfusion.<BR><BR>
				En las versiones 7 y 8, esta información podía obtenerse sin restricción.<BR><BR>
				A partir de la versión 9, Adobe restringió esta información con el Password del Administrator de Coldfusion, por tanto, es necesario registrarlo en esta pantalla la primera vez y cada vez que se modifique este password, para iniciar la ejecución de los Sistemas de SOIN Soluciones Integrales.
			</td>
		</tr>
		<tr>
			<td colspan="4"><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="1" height="10"></td>
		</tr>
	
	<cftry>
		<cfset form.txtPassword = "XX_XX">
		<cfif SERVER.ColdFusion.ProductName EQ "Railo">
			<cfinclude template="password_cfadmin.cfm">
		<cfelse>
			<cfset adminObj = createObject("component","cfide.adminapi.administrator")>
			<cfset adminObj.login(form.txtPassword)>
			<cfset dataSourceObb=createobject("component","CFIDE.adminapi.datasource").getDataSources()>
			<cfset datasources = dataSourceObb>
		</cfif>
	<cfcatch type="any">
	</cfcatch>
	</cftry>

	<cftry>
		<cfinvoke component="home.Componentes.DbUtils" method="getColdfusionDatasources" returnvariable="datasources">
			<cfinvokeargument name="CFadmiPWD"  value="XXX_XXX">
		</cfinvoke>
		<cfset LvarRequired = false>
	<cfcatch type="any">
		<cfset LvarRequired = true>
	</cfcatch>
	</cftry>

	<cfif LvarRequired>
		<tr>
			<td rowspan="5"><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="25" height="1"></td>
			<td align="left">
				<table>
					<tr>
						<td>
							<p style="font-weight:bold;margin:5px 0px 5px 0px;"> User name</p>
								<input type="text" size="15" maxlength="100" value="admin" autocomplete="off" style="width:300px; padding-left:5px;" disabled="disabled">
						</td>
					</tr>
					<tr>
						<td>
							
							<p style="font-weight:bold;margin:5px 0px 5px 0px;"> Password</p>
							<input name="txtPassword" type="Password" size="15" maxlength="100" id="txtPassword" autocomplete="off" style="width:300px; padding-left:5px;">
						</td>
					</tr>
 
				</table>
			</td>
			<td width="200px" class="loginInvalidText">
				<p style="margin:75px 0px 0px 0px;">
				
				</p>
			</td>
			<td rowspan="5"><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="15" height="1"></td>
			</td>
		</tr>
		<tr>
			<td align="left" colspan="2">
				
				<input name="requestedURL" type="hidden" value="%2Fcfmx%2FCFIDE%2Fadministrator%2Findex.cfm%3F">
				<input name="salt" type="hidden" value="1343338199034">
				<input name="btnGrabar" type="submit" value="Registrar" style=" margin:7px 0px 0px 2px;;width:80px"
					 onClick="return sbVerificar();">
			</td>
		</tr>
	<cfelse>
		<tr>
			<td colspan="4" style="padding-left:8px;">
				<strong style="color:#FF0000; font-size:14px">ESTA INSTALACIÓN DE Coldfusion NO REQUIERE REGISTRAR EL PASSWORD DEL ADMINISTRADOR</strong>
			</td>
		</tr>
	</cfif>
		<tr>
	<td colspan="2">
		<table border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="vertical-align:middle;"><img src="/cfmx/CFIDE/administrator/images/spacer.gif" alt="" width="10" height="1"/><img src="/cfmx/CFIDE/administrator/images/adobelogo.gif" alt="" width="29" height="32"/>
				<td style="width:500px;"><p style="margin:20px 20px 20px 20px;" class="loginCopyrightText"> Adobe, the Adobe logo, ColdFusion, and Adobe ColdFusion are trademarks or registered trademarks of Adobe Systems Incorporated in the United States and/or other countries.  All other trademarks are the property of their respective owners.</p>
				</td>
			</tr>
		</table>
		<br />
	</td>
</tr>
</table>
</form>
</body>
</html>

