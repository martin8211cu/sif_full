<cfparam name="modo"       			  default="ALTA">
<cfparam name="param" 	   			  default="">
<cfparam name="Concep.FPCid" 	   	  default="">
<cfparam name="Concep.FPCCid" 	   	  default="">
<cfparam name="Concep.FPCcodigo" 	  default="">
<cfparam name="Concep.FPCdescripcion" default="">
<cfparam name="ts"					  default="">
<cfparam name="URL.FPCid"			  default="-1">
<cfparam name="URL.idTree"			  default="">
<cfparam name="URL.FPCCid"			  default="-1">

<cfif URL.FPCid neq -1>
	<cfset modo ="CAMBIO">
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Conceptos de Fuentes de Financiamiento y Egresos">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<td valign="top" width="5%">&nbsp;</td>
				<td valign="top" width="60%" align="left"><!---<cfinclude template="ClasificacionConcepto-Arbol.cfm">--->
					<cf_ConceptoGatosIngresos name="FPCid" name2="FPCCid" metodo="get" selecionadoCAT="#URL.FPCCid#" selecionadoCON="#URL.FPCid#" mostrarConceptos="true" irA="ConceptoGI.cfm"  mostrarFiltro="true">
				</td>
				<td valign="top" width="30%" align="right"><cfinclude template="ConceptoGI-form.cfm"></td>
				<td valign="top" width="5%">&nbsp;</td>
			</tr>
			<tr><td colspan="4">&nbsp;
			</td>
		</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>