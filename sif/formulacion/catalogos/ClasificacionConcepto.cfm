<cfparam name="modo"       						default="ALTA">
<cfparam name="param" 	   						default="">
<cfparam name="ClasConcep.FPCCcodigo" 			default="">
<cfparam name="ClasConcep.FPCCdescripcion"	 	default="">
<cfparam name="ClasConcep.FPCCcomplementoC" 	default="">
<cfparam name="ClasConcep.FPCCcomplementoP"		default="">
<cfparam name="ClasConcep.FPCCtipo"				default="">
<cfparam name="ClasConcep.FPCCconcepto"			default="">
<cfparam name="ClasConcep.FPCCid"				default="">
<cfparam name="ClasConcep.FPCCidPadre"			default="">
<cfparam name="ClasConcep.Hijos"				default="0">
<cfparam name="ClasConcep.FPCCExigeFecha"		default="0">
<cfparam name="URL.idTree"						default="">
<cfparam name="ClasConcep.hijos"				default="0">
<cfparam name="ts"								default="">
<cfparam name="URL.FPCCid"						default="-1">

<cfif URL.FPCCid neq -1>
	<cfset modo ="CAMBIO">
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Clasificación de Conceptos de Fuentes de Financiamiento y Egresos">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top" width="2%">&nbsp;</td>
				<td valign="top" width="52%" align="left"><cf_ConceptoGatosIngresos name="FPCCid" metodo="get" selecionadoCAT="#URL.FPCCid#" soloUltimo="true" irA="ClasificacionConcepto.cfm"  tabindex="2"  mostrarFiltro="true"></td>
				<td valign="top" width="48%" align="right"><cfinclude template="ClasificacionConcepto-form.cfm"></td>
				<td valign="top" width="2%">&nbsp;</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>