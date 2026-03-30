<!---
	Creado  por Ana Villavicencio
	Fecha: 09 de diciembre del 2005
	Motivo: Nuevo reporte de Socios sin Clasificar.

	Modoficado por Gustavo Fonseca H.
		Fecha: 1-6-2006.
		Motivo: se corrige la navegación por tabs en la pantalla.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_RepSalsClas	= t.Translate('TIT_RepSalsClas','Cuentas por Pagar - Reporte de Socios sin Clasificaci&oacute;n')>
<cfset TIT_SocsClas		= t.Translate('TIT_SocsClas','Socios sin Clasificaci&oacute;n')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_ClasifIni	= t.Translate('LB_ClasifIni','Clasificación inicial')>
<cfset LB_ClasifFin	= t.Translate('LB_ClasifFin','Clasificación Final')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_Ambos 		= t.Translate('LB_Ambos','Ambos')>
<cfset LB_Clientes 		= t.Translate('LB_Clientes','Clientes')>
<cfset LB_Proveedores 	= t.Translate('LB_Proveedores','Proveedores')>
<cfset LB_ClasEmpr 		= t.Translate('LB_ClasEmpr','Clasificaciones solo de la empresa')>

<cfoutput>
<cf_templateheader title="#TIT_RepSalsClas#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SocsClas#'>

<form name="form1" method="post" action="SociosSinClasificarResCP.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosRep#</legend>
			<table  width="100%" cellpadding="2" cellspacing="2" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<!--- <tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_ClasifIni#</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_ClasifFin#</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1" name="Clasif1" id="SNCEid1" desc="SNCEdescripcion1"></td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1" name="Clasif2"  id="SNCEid2" desc="SNCEdescripcion2"></td>
				</tr> --->
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Ini#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Fin#:&nbsp;</strong></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI" tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="2"><input tabindex="1" name="SC" type="radio" value="SC" id="SC" checked onClick="javascript: document.form1.SP.checked=false;document.form1.SA.checked=false;"><label for="SC"><strong>#LB_Clientes#</strong></label>
					<input name="SP" tabindex="1" type="radio" value="SP" id="SP" onClick="javascript: document.form1.SC.checked=false;document.form1.SA.checked=false;"><label for="SP"><strong>#LB_Proveedores#</strong></label>
					<input name="SA" tabindex="1" type="radio" value="SA" id="SA" onClick="javascript: document.form1.SP.checked=false;document.form1.SC.checked=false;"><label for="SA"><strong>#LB_Ambos#</strong></label></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><input name="Empresa" tabindex="1" type="checkbox" value="Empresa" id="Empresa"><label for="Empresa"><strong>#LB_ClasEmpr#</strong></label></td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</form>
	<cf_qforms>
		<cf_qformsRequiredField name="Clasif1" description="#LB_ClasifIni#">
		<cf_qformsRequiredField name="Clasif2" description="#LB_ClasifFin#">
	</cf_qforms>
<cf_web_portlet_end>
<cf_templatefooter>
</cfoutput>
