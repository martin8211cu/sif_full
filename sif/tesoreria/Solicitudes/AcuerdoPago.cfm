<cfparam name="Tipo" 				 default="0">
<cfparam name="TituloTipo" 			 default="En Preparación">
<cfparam name="MSGTipo" 			 default="Creo">
<cfparam name="BotonesI" 			 default="Generar,Regresar">
<cfparam name="BotonesLabel" 		 default="Generar Reporte,Regresar">
<cfparam name="BotonesLista" 		 default="Nuevo">
<cfparam name="IrA" 		 		 default="AcuerdoPago.cfm">
<cfparam name="SoloLectura" 		 default="false">
<cfparam name="modo" 				 default="ALTA">
<cfparam name="rs.TESAPnumero" 		 default="">
<cfparam name="rs.TASAPfecha" 		 default="">
<cfparam name="rs.TESAPautorizador1" default="">
<cfparam name="rs.TESAPautorizador2" default="">
<cfparam name="rs.Ocodigo" 			default="">


<cfif NOT isdefined('form.TESAPid') and isdefined('url.TESAPid')>
	<cfset form.TESAPid = url.TESAPid>
</cfif>
<cfif isdefined('form.btnNuevo') and isdefined('url.btnNuevo')>
	<cfset form.btnNuevo = url.btnNuevo>
</cfif>
<cfif isdefined('form.TESAPid') and len(trim(form.TESAPid))>
	<cfset modo = 'CAMBIO'>
	<cfif Tipo eq 0>
		<cfset BotonesI = "EnviarA,Generar,Regresar">
		<cfset BotonesLabel = "Enviar a Aprobación,Generar Reporte,Regresar">
	</cfif>
</cfif>

<cf_templateheader title="Acuerdos de Pago">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Acuerdos de Pago (#TituloTipo#)">
		<table width="100%" border="0" cellpadding="1" cellspacing="0">
			<tr>
				<cfif modo EQ 'ALTA' and not isdefined('btnNuevo')>
					<td valign="top" width="100%" align="center"><cfinclude template="AcuerdoPago-lista.cfm"></td>
				<cfelse>
					<td valign="top" width="100%" align="center"><cfinclude template="AcuerdoPago-form.cfm"></td>
				</cfif>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>
