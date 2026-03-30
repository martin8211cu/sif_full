<cfoutput>
<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Pasos"
	Default="Pasos"
	returnvariable="LB_Pasos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DebeSeleccionarUnConcurso"
	Default="Debe seleccionar un concurso"
	returnvariable="MSG_DebeSeleccionarUnConcurso"/>



<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Pasos#'>
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
				<strong><cf_translate key="LB_ListaDeConcursos">Lista de Concursos</cf_translate></strong>
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
				<cf_translate key="LB_AdjudicacionDePlazas">Adjudicación de plazas</cf_translate>	
		</a></td>
	</tr>
	<tr>
		<td width="1%" align="right">
			<cfif form.Paso EQ "2">
				<img src="/cfmx/rh/imagenes/addressGo.gif" border="0">
			</cfif>
		</td>
		<td width="1%" align="right"> <img src="/cfmx/rh/imagenes/number2_16.gif" border="0"> </td>
		<td class="etiquetaProgreso" nowrap><a href="##" onClick="javascript: goPage('2');" tabindex="-1" onMouseOver="javascript: window.status = ''; return true;" onMouseOut="javascript: window.status = ''; return true;">
			<cf_translate key="LB_DatosDeLosConcursantes">Datos de los concursantes</cf_translate>
		</a></td>
	</tr>	
</table>
<cf_web_portlet_end>
<script language="javascript" type="text/javascript">	
	function goPage(opt) {
		if (opt>0) {
			if ('#form.RHCconcurso#'.length==0){
				alert("#JSStringFormat(MSG_DebeSeleccionarUnConcurso)#");
				return false;
			}
		}
		if (opt==0){		
			location.href = "AdjudicacionPlazas.cfm?Paso="+opt;
		}
		else{
			if ('#form.RHCconcurso#'.length==0){
				alert("#JSStringFormat(MSG_DebeSeleccionarUnConcurso)#");
			}
			else{
				location.href = "AdjudicacionPlazas.cfm?Paso="+opt+"&RHCconcurso=#form.RHCconcurso#";
			}
		}		
	}
</script>
</cfoutput>
