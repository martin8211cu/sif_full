<html>
<head>
<title>Cambios de estado de impresi&oacute;n de OC</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
<body>
<cf_templateheader title="Cambios de estado de impresi&oacute;n de OC">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cambios de estado de impresi&oacute;n de OC'>
			<cfinclude template="../../portlets/pNavegacionCM.cfm">
			<cfset paramsuri =''>
			<cfif isdefined("form.fESnumeroD") and len(trim("form.fESnumeroD")) >
				<cfset paramsuri = "&fESnumeroD=#form.fESnumeroD#">
			</cfif>
			<cfif isdefined("form.fESnumeroH") and len(trim("form.fESnumeroH")) >
				<cfset paramsuri = "&fESnumeroH=#form.fESnumeroH#">
			</cfif>			
			<cfif isdefined("form.fechaD") and len(trim(form.fechaD))>
				<cfset paramsuri = "&fechaD=#form.fechaD#">
			</cfif>
			<cfif isdefined("form.fechaH") and len(trim(form.fechaH))>
				<cfset paramsuri = paramsuri&"&fechaH=#form.fechaH#">
			</cfif>
			<cfif isdefined("form.CMCcodigo") and len(trim(form.CMCcodigo))>
				<cfset paramsuri = paramsuri&"&CMCcodigo=#form.CMCcodigo#">
			</cfif>
			<cfif isdefined("form.CMCnombre") and len(trim(form.CMCnombre))>
				<cfset paramsuri = paramsuri&"&CMCnombre=#form.CMCnombre#">
			</cfif>			
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfset paramsuri = paramsuri&"&SNcodigo=#form.SNcodigo#">
			</cfif>
			<cfif isdefined("form.CMCid") and len(trim(form.CMCid))>
				<cfset paramsuri = paramsuri&"&CMCid=#form.CMCid#">
			</cfif>			
			<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo))>
				<cfset paramsuri = paramsuri & "&CMTOcodigo=#form.CMTOcodigo#">
			</cfif>
			<cfif isdefined("form.CMTOdescripcion") and len(trim(form.CMTOdescripcion))>
				<cfset paramsuri = paramsuri & "&CMTOdescripcion=#form.CMTOdescripcion#">
			</cfif>
					
			<table width="98%" cellpadding="0" cellspacing="0" border="0">				
				<tr>
					<td width="2">&nbsp;</td>
					<td><cfinclude template="/sif/portlets/pNavegacion.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr>
					<td width="2">&nbsp;</td>
					<td><cf_rhimprime datos="/sif/cm/consultas/RepcambioestadoimpresionOC-form.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>				
				<form name="form1" action="" method="post" >					
				<tr>
					<td width="2">&nbsp;</td>
					<td align="center"><cfinclude template="RepcambioestadoimpresionOC-form.cfm"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td width="2">&nbsp;</td>
					<td align="center"><input type="button" name="btnRegresar"  value="Regresar" onClick="javascript: location.href = 'RepcambioestadoimpresionOC-lista.cfm';"></td>
					<td width="2">&nbsp;</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				</form>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>
</body>
</html>
