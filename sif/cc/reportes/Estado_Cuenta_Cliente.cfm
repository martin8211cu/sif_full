<!---
	Creado por Gustavo Fonseca H.
		Fecha: 22-7-2005
		Motivo: Creación del reporte de Estado de Cuenta del Socio de Negocios (solo en CxC).
	Modificado por Gustavo Fonseca H.
		Fecha: 6-12-2005.
		Motivo: Se agrega check para que permita ordenar los estados de cuenta por número de Reclamo.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_EdoCue = t.Translate('TIT_EdoCue','Estado de Cuenta del Socio de Negocios')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_Socio_de_Negocio','Socio de Negocios','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_OrdenRec 	= t.Translate('LB_OrdenRec','Ordenar por Reclamo')>
<cfset MSG_FechasLim = t.Translate('MSG_FechasLim','La Fecha Hasta debe ser mayor a la Fecha Desde')>



<cfsetting requesttimeout="300">
<cfif isdefined("url.Generar")>
	<cfset LvarEstadoCuentaCliente =1>
	<cfset SNCEid = -1>
	<cfset SNCDVALOR1 = ''>
	<cfset SNCDVALOR2 = ''>
	<cfset SNCDid1 = ''>
	<cfset SNCDid2 = ''>
	<cfif not isdefined('url.SNcodigo') and isdefined('url.SNcodigo1')><cfset SNcodigo = url.SNcodigo1></cfif>
	<cfif not isdefined('url.SNnumero') and isdefined('url.SNnumero1')><cfset SNnumero = url.SNnumero1></cfif>

    <cfset SNcodigob2 = SNcodigo>
	<cfset SNnumerob2 = SNnumero>
    <cfif isdefined('url.SNcodigo2') and len(trim(url.SNcodigo2))><cfset SNcodigob2 = url.SNcodigo2></cfif>
	<cfif isdefined('url.SNnumero2') and len(trim(url.SNnumero2))><cfset SNnumerob2 = url.SNnumero2></cfif>

	<cfset DEidCobrador = -1>
	<cfset chk_cod_Direccion = -1>

	<cfset fechainicio     = LSDateFormat(url.fechaIni)>
	<cfset fechafinal      = LSDateFormat(url.fechaFin)>

	<cfinclude template="Estado_Cuenta_Cliente_sql.cfm">
	<cfset Generar()>
	<cfabort>
</cfif>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_EdoCue#'>
<script language="JavaScript" src="../../js/fechas.js"></script>
<form name="form1" action="Estado_Cuenta_Cliente.cfm" method="get">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>#LB_DatosReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Desde#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaIni" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Fecha_Hasta#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaFin" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SocioNegocio#:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 ClientesAmbos="SI" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td valign="middle"><input name="ordenado" type="checkbox" value="1" tabindex="1"/> <strong>#LB_OrdenRec#</strong></td>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong></td>
                    <td>
                        <select name="Formato" id="Formato" tabindex="1">
                            <option value="1">FLASHPAPER</option>
                            <option value="2">PDF</option>
                        </select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr><td colspan="6"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</cfoutput>
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms form ="form1">
<cfoutput>
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNcodigo.required = true;
	objForm.SNcodigo.description="#LB_SocioNegocio#";
	objForm.fechaIni.required = true;
	objForm.fechaIni.description="#LB_Fecha_Desde#";
	objForm.fechaFin.required = true;
	objForm.fechaFin.description="#LB_Fecha_Hasta#";

	function funcGenerar(){
	if (datediff(document.form1.fechaIni.value, document.form1.fechaFin.value) < 0)
		{
				alert ('#MSG_FechasLim#');
				return false;
		}
	}
//-->
</script>
</cfoutput>