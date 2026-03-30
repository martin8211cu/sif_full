<html>
<head>
<title>Análisis de proveedores</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_templateheader title="Análisis de proveedores">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Análisis de proveedores'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfset paramsuri =''>
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfset paramsuri = "?SNcodigo=#form.SNcodigo#">
			</cfif>
			<cfif isdefined("form.MesIni") and len(trim(form.MesIni))>
				<cfset paramsuri = paramsuri&"&MesIni=#form.MesIni#">
			</cfif>
			<cfif isdefined("form.MesFin") and len(trim(form.MesFin))>
				<cfset paramsuri = paramsuri&"&MesFin=#form.MesFin#">
			</cfif>
			<cfif isdefined("form.AnnoIni") and len(trim(form.AnnoIni))>
				<cfset paramsuri = paramsuri&"&AnnoIni=#form.AnnoIni#">
			</cfif>
			<cfif isdefined("form.AnnoFin") and len(trim(form.AnnoFin))>
				<cfset paramsuri = paramsuri&"&AnnoFin=#form.AnnoFin#">
			</cfif>
			<cfif isdefined("form.CMTid") and len(trim(form.CMTid))>
				<cfset paramsuri = paramsuri&"&CMTid=#form.CMTid#">
			</cfif>
			<cfif isdefined("form.AgruparPor") and len(trim(form.AgruparPor))>
				<cfset paramsuri = paramsuri & "&AgruparPor=#form.AgruparPor#">
			</cfif>
			<cfif isdefined("form.CMCid1") and len(trim(form.CMCid1))>
				<cfset paramsuri = paramsuri & "&CMCid1=#form.CMCid1#">
			</cfif>
			<cfif isdefined("form.Ccodigo") and len(trim(form.Ccodigo))>
				<cfset paramsuri = paramsuri & "&Ccodigo=#form.Ccodigo#">
			</cfif>
			<cfif isdefined("form.CCid") and len(trim(form.CCid))>
				<cfset paramsuri = paramsuri & "&CCid=#form.CCid#">
			</cfif>
		
			<table width="98%" cellpadding="0" cellspacing="0" border="0">				
				<tr>
					<td width="2">&nbsp;</td>
					<td><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="2">&nbsp;</td>
					<td><cf_rhimprime datos="/sif/cm/consultas/RepCmAnalisisProv.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>				
				<form name="form1" action="CmAnalisisProv.cfm" method="post" >					
				<tr>
					<td width="2">&nbsp;</td>
					<td><cfinclude template="RepCmAnalisisProv.cfm">
					<td width="2">&nbsp;</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td width="2">&nbsp;</td>
					<td align="center"><input type="submit" name="btnRegresar"  value="Regresar"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				</form>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
</body>
</html>