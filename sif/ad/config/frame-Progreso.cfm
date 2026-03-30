
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Pasos'>
	<table border="0" cellpadding="2" cellspacing="0">
		<!--- Inicio --->
		<tr>
			<td style="border-bottom: 1px solid black; ">
				<cfif thisForm is 0>
					<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
				<cfelse>
				&nbsp;
				</cfif>
			</td>
			<td align="right" style="border-bottom: 1px solid black; "> <img src="/cfmx/asp/imagenes/home.gif" border="0"> </td>
			<td class="etiquetaProgreso" style="border-bottom: 1px solid black; "><a href="/cfmx/sif/ad/config/wizBienvenida.cfm" tabindex="-1"><strong>Inicio</strong></a></td>
		</tr>
	  
		<cfset pagina = #GetFileFromPath(GetTemplatePath())#>
		<!--- 1 --->
		<tr>
			<td width="1%" align="right">
				<cfif pagina eq 'wizGeneral02.cfm' or pagina eq 'wizConfirma.cfm'>
					<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
				<cfelseif thisForm is 1>
					<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
				</cfif>
			</td>
			<td width="1%" align="right"> <img src="/cfmx/asp/imagenes/menu/num1_small.gif" border="0"> </td>
			<td class="etiquetaProgreso" nowrap><a href="javascript:generales();" tabindex="-1">Parámetros</a></td>
		</tr>
	  
	  	<!--- 2 --->
		<tr>
			<td width="1%" align="right">
				<cfif pagina eq 'wizConfirma.cfm'>
					<img src="/cfmx/asp/imagenes/w-check.gif" border="0">
				<cfelseif pagina eq 'wizGeneral02.cfm' >
					<img src="/cfmx/asp/imagenes/addressGo.gif" border="0">
				</cfif>
			</td>
			<td width="1%" align="right"> <img src="/cfmx/asp/imagenes/menu/num2_small.gif" border="0"> </td>
			<td class="etiquetaProgreso" nowrap><a href="javascript:catalogo();" tabindex="-1">Catálogo Contable</a></td>
		</tr>

  </table>
<cf_web_portlet_end>

<script language="javascript1.2" type="text/javascript">
	function generales(){
		document.forms[0].action = '/cfmx/sif/ad/config/wizGeneral01.cfm';
		document.forms[0].submit();
	}

	function catalogo(f){
		document.forms[0].action = '/cfmx/sif/ad/config/wizGeneral02.cfm';		
		document.forms[0].submit();
	}
</script>