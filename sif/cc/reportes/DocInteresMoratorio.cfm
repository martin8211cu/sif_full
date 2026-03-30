<!---
	Creado por: Ana Villavicencio
	Fecha: 09 de agosto del 2006
	Motivo: Nuevo reporte de Documentos de Interés Moratorio Generados
 --->

<cf_templateheader title="SIF - Cuentas por Pagar">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<script language="JavaScript" src="../../js/fechas.js"></script>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos Pagados'>
<!--- FILTROS PARA EL REPORTE --->
<cfoutput>
	<form name="form1" method="get" action="DocInteresMoratorioRep.cfm">
	<table width="100%" cellpadding="2" cellspacing="0" border="0" align="center">
		<tr>
			<td valign="top" align="center">
			<fieldset>
				<legend>Datos del Reporte</legend>
				<table  width="75%" align="center" cellpadding="2" cellspacing="0" border="0">
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td>
							<input type="radio" id="radio1" name="TipoReporte" value="0" checked tabindex="1">
							<label for="radio1" style="font-style:normal; font-variant:normal;">Resumido</label>
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<input type="radio" id="radio2" name="TipoReporte" value="1" tabindex="1">
							<label for="radio2" style="font-style:normal; font-variant:normal;">Detallado</label>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td valign="top" nowrap><strong>Cliente Inicial</strong></td>
						<td nowrap><strong>Cliente Final</strong></td>
					</tr>
					<tr>
						<td>
							<cfset valuesArray = ArrayNew(1)>
							<cf_conlis
								title="Lista de Clientes"
								campos = "SNcodigo,SNnumero,SNnombre"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,15,30"
								valuesarray="#valuesArray#"
								tabla="SNegocios"
								columnas="SNcodigo, SNnombre, SNnumero, SNidentificacion"
								filtro="Ecodigo = #Session.Ecodigo#
										  and SNtiposocio in ('A','C')
										  order by SNnombre, SNnumero"
								desplegar="SNnumero,SNidentificacion,SNnombre"
								filtrar_por="SNnumero,SNidentificacion,SNnombre"
								etiquetas="C&oacute;digo,Identificaci&oacute;n,Nombre"
								formatos="S,S,S"
								align="left,left,left"
								asignar="SNcodigo,SNnumero,SNnombre"
								asignarformatos="S,S,S"
								left="125"
								top="100"
								width="750"
								MaxRowsQuery="500"
								tabindex="1"
								ajustar="false">
						</td>
						<td>
							<cfset valuesArray = ArrayNew(1)>
							<cf_conlis
								title="Lista de Clientes"
								campos = "SNcodigo2,SNnumero2,SNnombre2"
								desplegables = "N,S,S"
								modificables = "N,S,N"
								size = "0,15,30"
								valuesarray="#valuesArray#"
								tabla="SNegocios"
								columnas="SNcodigo as SNcodigo2, SNnombre as SNnombre2, SNnumero as SNnumero2, SNidentificacion as SNidentificacion2"
								filtro="Ecodigo = #Session.Ecodigo#
										  and SNtiposocio in ('A','C')
										  order by SNnombre, SNnumero "
								desplegar="SNnumero2,SNidentificacion2,SNnombre2"
								filtrar_por="SNnumero,SNidentificacion,SNnombre"
								etiquetas="C&oacute;digo,Identificaci&oacute;n,Nombre"
								formatos="S,S,S"
								align="left,left,left"
								asignar="SNcodigo2,SNnumero2,SNnombre2"
								asignarformatos="S,S,S"
								left="125"
								top="100"
								width="750"
								MaxRowsQuery="500"
								tabindex="1"
								ajustar="false">
						</td>
					</tr>
					<tr>
						<td align="left"><strong>Fecha&nbsp;Desde</strong></td>
						<td align="left"><strong>Fecha Hasta</strong></td>
					</tr>
					<tr>
						<td>
							<cfset LvarFecha = createdate(year(now()),month(now()),1)>
							<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="FechaI" tabindex="1">
						</td>
						<td><cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="FechaF" tabindex="1"></td>
					</tr>
					<tr>
						<td align="left" colspan="2"><strong>Formato:&nbsp;</strong>
							<select name="Formato" id="Formato" tabindex="1">
								<option value="1">FLASHPAPER</option>
								<option value="2">PDF</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr><td colspan="2"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				</table>
				</fieldset>
			</td>
		</tr>
	</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms>
	<cf_qformsRequiredField name="SNcodigo" description="Cliente Inicial">
	<cf_qformsRequiredField name="SNcodigo2" description="Cliente Final">
	<cf_qformsRequiredField name="FechaI" description="Fecha Inicial">
	<cf_qformsRequiredField name="FechaF" description="Fecha Final">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function funcGenerar(){
	if (datediff(document.form1.FechaI.value, document.form1.FechaF.value) < 0)
		{
				alert ('La Fecha Hasta debe ser mayor a la Fecha Desde');
				return false;
		}
	}
</script>