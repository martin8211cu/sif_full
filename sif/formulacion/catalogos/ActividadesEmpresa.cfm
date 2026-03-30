<cfparam name="modo"       				  default="ALTA">
<cfparam name="mododet"       			  default="ALTA">
<cfparam name="URL.FPAEid"				  default="">
<cfparam name="form.FPADNivel"			  default="">
<cfparam name="form.FPADNivel_key"		  default="">

<cfparam name="ts"						  default="">

<cfparam name="Actividad.FPAECodigo" 	  default="">
<cfparam name="Actividad.FPAEDescripcion" default="">
<cfparam name="Actividad.FPAETipo" 		  default="">
<cfparam name="Actividad.FPAEid"		  default="">
<cfparam name="Nivel.FPADDescripcion"	  default="">
<cfparam name="Nivel.FPADIndetificador"	  default="">
<cfparam name="Nivel.FPADDepende"		  default="">
<cfparam name="Nivel.FPADNivel"		      default="">
<cfparam name="Nivel.FPADEquilibrio"	  default="0">
<cfparam name="estaLigada"	 			  default="false">

<cfset PCEcatidvalue= QueryNew("PCEcatid,PCEcodigo,PCEdescripcion")>

<cfif LEN(TRIM(URL.FPAEid)) GT 0>
	<cfset modo ="CAMBIO">
	<cfset form.FPAEid = url.FPAEid>
</cfif>
<cfif not len(trim(form.FPADNivel)) and isdefined('url.FPADNivel')>
	<cfset form.FPADNivel = url.FPADNivel>
</cfif>
<cfif len(trim(form.FPADNivel))>
	<cfset mododet = "CAMBIO">
</cfif>

<cf_templateheader title="Estimación de Presupuesto">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Actividades Empresariales">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<cfif modo EQ 'ALTA' and not isdefined('btnNuevo')>
					<td valign="top" width="100%" align="center"><cfinclude template="ActividadesEmpresa-lista.cfm"></td>
				<cfelse>
					<td valign="top" width="100%" align="center"><cfinclude template="ActividadesEmpresa-form.cfm"></td>
				</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>