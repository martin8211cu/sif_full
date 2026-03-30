<cf_templateheader title="SIF - Punto de Ventas">

<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Reporte de Transacciones de Venta por POS'>
<script language="JavaScript" src="../../js/fechas.js"></script>

<cfquery name="rsMonedas" datasource="#session.DSN#">
	select Mcodigo, Mnombre, Miso4217
	from Monedas 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre 
</cfquery>


<form name="form1" action="TransaccionesPOS_Reporte.cfm" method="post">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
			<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="6">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Desde:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<cfset Lvardesde = dateadd('d',-1,now())>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(Lvardesde,'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;Hasta:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><strong>Tipo de Reporte:&nbsp;</strong>
					
					<select name="tiporeporte" id="tiporeporte" tabindex="1">
						<option value="ResumidoFecha">Resumido por Fecha</option>
						<option value="ResumidoCajaFecha">Resumido por Caja / Fecha</option>
						<option value="Detallado">Detallado</option>
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
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<cfif isdefined("url.Generar")>
	<cfset LvarEstadoCuentaCliente =1>
	<cfset url.SNCEid = ''>
	<cfset url.SNCDVALOR1 = ''>
	<cfset url.SNCDVALOR2 = ''>
	<cfset url.SNCDid1 = ''>
	<cfset url.SNCDid2 = ''>
	<cfset url.Cobrador = ''>

	<cfset TIPOREPORTE = 0>
	<cfset url.TIPOREPORTE = 0>
	<cfinclude template="Estado_Cuenta_Cliente_ClasiF_sql.cfm">
</cfif> 

 
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.fechaDes.required = true;
	objForm.fechaDes.description="Fecha Desde";
	objForm.fechaHas.required = true;
	objForm.fechaHas.description="Fecha Hasta";

	function funcGenerar(){ 
	if (datediff(document.form1.fechaDes.value, document.form1.fechaHas.value) < 0) 
		{	
				alert ('La Fecha Hasta debe ser mayor a la Fecha Desde');
				return false;
		} 
	}
//-->	
</script>