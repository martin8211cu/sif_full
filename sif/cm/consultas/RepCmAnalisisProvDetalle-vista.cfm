<html>
<head>
<title>Analisis de proveedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_templatecss>
	<cfset paramsuri =''>
	<cfif isdefined("url.Socio") and len(trim(url.Socio))>
		<cfset paramsuri = "?Socio=#url.Socio#">
	</cfif>
	<cfif isdefined("url.Mes") and len(trim(url.Mes))>
		<cfset paramsuri = paramsuri&"&Mes=#url.Mes#">
	</cfif>
	<cfif isdefined("url.Anno") and len(trim(url.Anno))>
		<cfset paramsuri = paramsuri&"&Anno=#url.Anno#">
	</cfif>
	<cfif isdefined("url.Criterio") and len(trim(url.Criterio))>
		<cfset paramsuri = paramsuri&"&Criterio=#url.Criterio#">
	</cfif>
	<cfif isdefined("url.AgruparPor") and len(trim(url.AgruparPor))>
		<cfset paramsuri = paramsuri&"&AgruparPor=#url.AgruparPor#">
	</cfif>
	<cfif isdefined("url.CMCid1") and len(trim(url.CMCid1))>
		<cfset paramsuri = paramsuri & "&CMCid1=#url.CMCid1#">
	</cfif>
	<cfif isdefined("url.Ccodigo") and len(trim(url.Ccodigo))>
		<cfset paramsuri = paramsuri & "&Ccodigo=#url.Ccodigo#">
	</cfif>
	<cfif isdefined("url.CCid") and len(trim(url.CCid))>
		<cfset paramsuri = paramsuri & "&CCid=#url.CCid#">
	</cfif>
	<cfif isdefined("url.MesIni") and len(trim(url.MesIni))>
		<cfset paramsuri = paramsuri & "&MesIni=#url.MesIni#">
	</cfif>
	<cfif isdefined("url.AnnoIni") and len(trim(url.AnnoIni))>
		<cfset paramsuri = paramsuri & "&AnnoIni=#url.AnnoIni#">
	</cfif>
	<cfif isdefined("url.MesFin") and len(trim(url.MesFin))>
		<cfset paramsuri = paramsuri & "&MesFin=#url.MesFin#">
	</cfif>
	<cfif isdefined("url.AnnoFin") and len(trim(url.AnnoFin))>
		<cfset paramsuri = paramsuri & "&AnnoFin=#url.AnnoFin#">
	</cfif>

	<table width="98%" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td width="2">&nbsp;</td>
			<td><cf_rhimprime datos="/sif/cm/consultas/RepCmAnalisisProvDetalle.cfm" paramsuri="#paramsuri#"></td>
			<td width="2">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<form name="form1" action="RepCmAnalisisProv-vista.cfm" method="post" >
		<tr>
			<td width="2">&nbsp;</td>
			<td><cfinclude template="RepCmAnalisisProvDetalle.cfm">
			<td width="2">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td width="2">&nbsp;</td>
			<td align="center"><input type="button" name="btnRegresar"  value="Cerrar" onClick="javascript: window.close();"></td>
			<td width="2">&nbsp;</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		</form>
	</table>
</body>
</html>