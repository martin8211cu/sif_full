<cfoutput>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
<table border="0" cellpadding="2" cellspacing="0">
	<!--- 0, Página Inicial --->
	<tr>
		<td style="border-bottom: 1px solid black; ">
			<cfif form.Paso EQ "0">
				<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
			<cfelse>
				&nbsp;
			</cfif>
		</td>
		<td align="center" style="border-bottom: 1px solid black; "> <img src="/cfmx/rh/imagenes/home.gif" border="0"> </td>
		<td class="etiquetaProgreso" style="border-bottom: 1px solid black; " nowrap>
			<a href="##" onClick="javascript: goPage('0');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
				<strong>Lista de Encuestas </strong>
			</a>
		</td>
		<td rowspan="100" width="1%">&nbsp;&nbsp;&nbsp;</td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "1">
				<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/number1_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('1');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
				Encuestas</a></td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "2">
				<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/number2_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('2');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
			Datos de la Encuesta </a></td>
	</tr>
	<tr>
		<td style="border-top: 1px solid black; ">&nbsp;
			
		</td>
		<td align="center" style="border-top: 1px solid black; ">&nbsp;</td>
		<td class="etiquetaProgreso" style="border-top: 1px solid black; " nowrap>
			<a href="##" onClick="javascript: limpiaKey();" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
				<strong>Nueva Encuesta </strong>
			</a>
		</td>
		<td rowspan="100" width="1%">&nbsp;&nbsp;&nbsp;</td>
	</tr>	
</table>
<cf_web_portlet_end>
<script language="javascript" type="text/javascript">
	function goPage(opt) {
		if (opt>1) {
			if ('#params#'.length==0){
				alert("#JSStringFormat('Debe seleccionar una encuesta.')#");
				return false;
			}
		}
		location.href = "TEncuestadoras.cfm?Paso="+opt+"&tab=4&EEid=#form.EEid##params#";
	}

	function limpiaKey(){
		location.href = "TEncuestadoras.cfm?Paso=1&tab=4&EEid=#form.EEid#";
	}

</script>
	
</cfoutput>