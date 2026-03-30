<cfparam name="modo"       				  		default="ALTA">
<cfparam name="param" 	   				  		default="">
<cfparam name="url.tab" 	   			  		default="1">
<cfparam name="plantilla.FPEPid" 	   	  		default="">
<cfparam name="plantilla.FPCCtipo" 	   	  		default="I">
<cfparam name="plantilla.FPEPdescripcion" 		default="">
<cfparam name="plantilla.FPEPnotas" 	  		default="">
<cfparam name="plantilla.Categoria" 	  		default="0">
<cfparam name="plantilla.FPCCconcepto" 	  	 	default="0">
<cfparam name="plantilla.PCGDxCantidad" 		default="0">
<cfparam name="plantilla.PCGDxPlanCompras" 		default="0">
<cfparam name="plantilla.FPEPmultiperiodo" 		default="0">
<cfparam name="plantilla.CFid" 					default="">
<cfparam name="plantilla.CFcodigo" 				default="">
<cfparam name="plantilla.CFdescripcion" 		default="">
<cfparam name="plantilla.CcontrolaXPlan" 		default="0">
<cfparam name="plantilla.tieneEstimaciones" 	default="0">
<cfparam name="plantilla.FPEPnomodifica" 		default="0">
<cfparam name="ts"						  		default="">
<cfparam name="url.FPEPid"						default="">
<cfparam name="form.FPEPid"						default="">

<cfif LEN(TRIM(url.FPEPid)) GT 0>
	<cfset form.FPEPid = url.FPEPid>
</cfif>
<cfif LEN(TRIM(form.FPEPid)) GT 0>
	<cfset modo ="CAMBIO">
</cfif>
<cfif isdefined('url.tab') and not isdefined('form.tab')>
	<cfset form.tab = url.tab>
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Plantillas">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<cfif modo EQ 'ALTA' and not isdefined('btnNuevo')>
					<td valign="top" width="100%" align="center"><cfinclude template="Plantillas-lista.cfm"></td>
				<cfelse>
					<td valign="top" width="100%" align="center"><cfinclude template="Plantillas-form.cfm"></td>
				</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>