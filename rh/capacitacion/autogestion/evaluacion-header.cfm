<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td rowspan="6" width="5%">&nbsp;</td>
	<td width="90%">&nbsp;</td>
	<td rowspan="6" width="5%">&nbsp;</td>
  </tr>
  <tr>
  	<td class="titulo<cfif not isdefined("rsRHRC")>Sub</cfif>">
	<div align="center">Relaci&oacute;n de Evaluaci&oacute;n de Capacitaci&oacute;n y Desarrollo </div></td>
  </tr>
  <cfif isdefined("rsRHRC")>
  <tr>
  	<td <cfif not isdefined("rsDE")>class="subtitulo"<cfelse>style="font-weight:bold"</cfif> align="center">
		<cfoutput>#rsRHRC.RHRCdesc#, corte al #LSDateFormat(rsRHRC.RHRCfcorte,'dd/mm/yyyy')#.</cfoutput>
	</td>
  </tr>
  </cfif>
  <cfif isdefined("rsDE")>
  <tr>
  	<td class="subtitulo" align="center">
		<cfoutput>#rsDE.DEnombrecompleto#</cfoutput>
	</td>
  </tr>
  </cfif>
  <tr>
	<td width="90%">&nbsp;</td>
  </tr>
  <tr>
    <td valign="top">
		<fieldset>
