<cfif isDefined("Url.DSplaca") and not isDefined("Form.DSplaca")>
  <cfset Form.DSplaca = Url.DSplaca>
</cfif>
<cfif isDefined("Url.Periodo") and not isDefined("Form.Periodo")>
  <cfset Form.Periodo = Url.Periodo>
</cfif>
<cfif isDefined("Url.Periodoini") and not isDefined("Form.Periodoini")>
  <cfset Form.Periodoini = Url.Periodoini>
</cfif>
<cfif isDefined("Url.Mes") and not isDefined("Form.Mes")>
  <cfset Form.Mes = Url.Mes>
</cfif>
<cfif isDefined("Url.Mesini") and not isDefined("Form.Mesini")>
  <cfset Form.Mesini = Url.Mesini>
</cfif>
<cfif isDefined("Url.Aid") and not isDefined("Form.Aid")>
  <cfset Form.Aid = Url.Aid>
</cfif>

<cfset lineas = "---------------------------------------" >
<cfset mensaje = " Fin de la Consulta " >

<cfinclude template="/sif/af/Utiles/functions.cfm">	

<script language="JavaScript" type="text/JavaScript">
	function regresar() {
		location.href='/cfmx/sif/af/consultas/activosPorPlaca/activosPorPlaca.cfm';
	}
</script>
	
<style type="text/css">
	.encabReporte {
		background-color: #006699;
		font-weight: bold;
		color: #FFFFFF;
		padding-top: 2px;
		padding-bottom: 2px;
	}
	.pageEnd {
		page-break-before:always;
	}
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		border-right-style: none;
		border-bottom-style: none;
		border-left-style: none;
		border-top-color: #CCCCCC;
	}
	.bottomline {
		border-bottom-width: 1px;
		border-bottom-style: solid;
		border-right-style: none;
		border-top-style: none;
		border-left-style: none;
		border-bottom-color: #CCCCCC;
	}
	.subTituloRep {
		font-weight: bold; 
		font-size: x-small; 
		background-color: #F5F5F5;
	}
</style>

<cf_sifhtml2word titulo="Activos">

	<cfinclude template="activosPorPlaca_Encabezado.cfm" >
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de la Adquisici&oacute;n del Activo'>
		<cfinclude template="/sif/af/catalogos/Activos_frameInformacion.cfm" >
	<cf_web_portlet_end>	
	<cfinclude template="/sif/af/catalogos/Activos_frameTotales.cfm" >
	
	<!--- 	
	<cfif isdefined("url.Imprime") >				 
		<!--- Corte por Impresión --->
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr class="pageEnd"><td colspan="4">&nbsp;</td></tr>
		</table>
		<cfinclude template="activosPorPlaca_Encabezado.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de la Adquisici&oacute;n del Activo'>
			<cfinclude template="/sif/af/catalogos/Activos_frameInformacion.cfm">
		<cf_web_portlet_end>	
	</cfif>
 	--->	
	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="50%">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Revaluación'>
					<cfinclude template="/sif/af/catalogos/Activos_frameRevaluacion.cfm">
				<cf_web_portlet_end>
			</td>
			<td nowrap>&nbsp;</td>
			<td width="50%">
				<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Mejoras'>
					<cfinclude template="/sif/af/catalogos/Activos_frameMejora.cfm">
				<cf_web_portlet_end>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
	</table>
	
	<!--- 	
	<cfif isdefined("url.Imprime")>				 
		<!--- Corte por Impresión --->
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr class="pageEnd"><td colspan="4">&nbsp;</td></tr>
		</table>
		<cfinclude template="activosPorPlaca_Encabezado.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Consulta de la Adquisici&oacute;n del Activo'>
			<cfinclude template="/sif/af/catalogos/Activos_frameInformacion.cfm">
		<cf_web_portlet_end>	
	</cfif>
 	--->
		
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Depreciación'>
		<cfinclude template="/sif/af/catalogos/Activos_frameDepreciacion.cfm">
	<cf_web_portlet_end>
		
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr><td nowrap>&nbsp;</td></tr>
			<tr><td align="center">#lineas##mensaje##lineas#</td></tr>
		</table>
	</cfoutput>
	
</cf_sifhtml2word>

<cfif not isdefined("url.Imprime")>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td nowrap>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input name="btnRegresar" type="submit" value="Regresar" onClick="javascript: regresar();">
			</td>
		</tr>
		<tr><td nowrap>&nbsp;</td></tr>
	</table>
</cfif>
