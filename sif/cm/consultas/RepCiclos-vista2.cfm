<html>
<head>
<title>Ciclos de compra</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_templateheader title="Compras - Consulta ciclos de compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta ciclos de compra'>
			<cfif isdefined("form.CFid") and len(trim(form.CFid))>
				<cfset paramsuri = "?CFid=#form.CFid#">
			</cfif>
			<cfif isdefined("form.mesIni") and len(trim(form.mesIni))>
				<cfset paramsuri = paramsuri&"&mesIni=#form.mesIni#">
			</cfif>
			<cfif isdefined("form.mesFin") and len(trim(form.mesFin))>
				<cfset paramsuri = paramsuri&"&mesFin=#form.mesFin#">
			</cfif>
			<cfif isdefined("form.anoIni") and len(trim(form.anoIni))>
				<cfset paramsuri = paramsuri&"&anoIni=#form.anoIni#">
			</cfif>
			<cfif isdefined("form.anoFin") and len(trim(form.anoFin))>
				<cfset paramsuri = paramsuri&"&anoFin=#form.anoFin#">
			</cfif>
			<cfif isdefined("form.cod_CMTScodigo") and len(trim(form.cod_CMTScodigo))>
				<cfset paramsuri = paramsuri&"&cod_CMTScodigo=#form.cod_CMTScodigo#">
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
			<cfif isdefined("form.AgruparPor") and len(trim(form.AgruparPor))>
				<cfset paramsuri = paramsuri & "&AgruparPor=#form.AgruparPor#">
			</cfif>

			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="2">&nbsp;</td>
					<td><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="2">&nbsp;</td>
					<td><cf_rhimprime datos="/sif/cm/consultas/RepCiclos-form.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>				
				<form name="form1" action="RepCiclos-lista.cfm" method="post">	
					<tr>
						<td width="2">&nbsp;</td>
						<td><cfinclude template="RepCiclos-form.cfm"></td>
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