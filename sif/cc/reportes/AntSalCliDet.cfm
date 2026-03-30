<cf_templateheader title="Cuentas Por Cobrar - Antigüedad de Saldos por Cliente">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Antig&uuml;edad&nbsp;Saldos&nbsp;por&nbsp;Cliente Detallado'>
<!--- <cfdump var="#rs#"> --->
<form name="form1" method="get" action="AntSalCliDet-sql.cfm" onsubmit="return validar(this);" >
	<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr>
			<td width="50%" valign="top">
				<table width="100%">
					<tr>
						<td valign="top">
							<cf_web_portlet_start border="true" titulo="Documentos" skin="info1">
								<div align="justify">En &eacute;ste reporte
								  se realiza un detallado de documentos con su
								  saldo respectivo al día de hoy.
								  Este reporte se puede generar en varios
								  formatos, aumentando as&iacute; su utilidad
								  y eficiencia en el traslado de datos.
								</div>
							<cf_web_portlet_end>
						</td>
					</tr>
				</table>
			</td>
			<td width="50%" valign="top">
				<table width="100%"  border="0" cellspacing="2" cellpadding="0">
					<tr>
						<td align="right"><strong>Socio&nbsp;de&nbsp;Negocios:&nbsp;</strong></td>
						<td>
						<!--- <cf_sifclientedetcorp modo='ALTA'> --->
						<cf_sifsociosnegocios2 ClientesAmbos="SI" tabindex="1">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Fecha Corte:&nbsp;</strong></td>
						<td>
						<cf_sifcalendario form="form1" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" name="FechaF">
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Formato:&nbsp;</strong></td>
						<td>
							<select name="formato" tabindex="1">
								<option value="flashpaper">Flash Paper</option>
								<option value="pdf">Adobe PDF</option>
								<option value="excel">Microsoft Excel</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2" align="center"><input type="submit" value="Generar" name="Reporte" tabindex="1"></td>
					</tr>
				</table>
			</td>
		</tr>
	</table>
</form>
<cf_web_portlet_end>

<script language="javascript" type="text/javascript">
	function validar(f){
		if ( f.SNcodigo.value == '' || f.SNnumero.value == '' ){
			alert('Se presentaron los siguientes errores \n - El campo Socio de Negocios es requerido.')
			return false;
		}
		return true;
	}

<!-- //
	//objForm.SNcodigo.required = true;
	//objForm.SNcodigo.description="Socio de Negocios";
	//objForm.SNnumero.required = true;
	//objForm.SNnumero.description="Socio de Negocios";
//-->
</script>
<cf_templatefooter>