<cfoutput>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
<table border="0" cellpadding="2" cellspacing="0">
	<!--- 0, Página Inicial --->
	<tr>
		<td style="border-bottom: 1px solid black; ">
			<cfif form.Paso EQ "0">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td align="center" style="border-bottom: 1px solid black; "> <img src="/cfmx/sif/imagenes/home.gif" border="0"> </td>
		<td class="etiquetaProgreso" style="border-bottom: 1px solid black; " nowrap>
			<a href="##" onClick="javascript: goPage('0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
				<strong>Consola de Máquinas</strong>
			</a>
		</td>
		<td rowspan="100" width="1%">&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "1">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/number1_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('1');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
				Máquinas
		</a></td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "2">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/number2_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('2');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
			Impresoras 
		</a></td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "3">
				<img src="/cfmx/sif/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/sif/imagenes/number3_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('3');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
			Cajas
		</a></td>
	</tr>
</table>
<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
function goPage(opt) {
	if (opt>1) {
		if ('#params#'.length==0){
			alert("#JSStringFormat('Debe seleccionar una máquina.')#");
			return false;
		}
	}
	location.href = "cajasProceso.cfm?Paso="+opt+"#params#";
}
</script>
</cfoutput>