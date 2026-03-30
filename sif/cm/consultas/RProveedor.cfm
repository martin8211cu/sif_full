<!---
	Módulo      : Contabilidad General / Consultas
	Nombre      : Reporte de Proveedores
	Descripción :
		Permite consultar las reglas por cuenta de mayor definidas para un rango de cuentas y una oficina específica.
		El reporte debe de ordenarse por oficina, cuenta de mayor y la regla.

	Hecho por   : Steve Vado Rodríguez
	Creado      : 18/04/2006
	Modificado  :
 --->

<!--- Formulario --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	<cf_templateheader title="Reporte de Proveedores">
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de Proveedores">
			<form name="form1" id="form1" action="RepProveedor.cfm" method="post">
			<table width="100%" border="0">
				<tr>
					<td  valign="top"width="41%"> <cf_web_portlet_start border="true" titulo="Reporte de Proveedores" skin="info1">
						<div align="center">
							<p align="justify">
								Muestra la siguiente información:<br>
								<br>
								•	Fecha de alta de proveedor.<br>
								•	Nombre del proveedor.<br>
								•	RFC.<br>
								•	Domicilio.<br>
								•	Teléfono de contacto.<br>
								•	Persona de contacto.<br>
								•	Correo electrónico de contacto.<br>
								•	Giro empresarial.<br>
								•	Cuenta bancaria.<br>
								•	Clasificación de proveedor.<br>
							</p>
						</div>
						<cf_web_portlet_end>
					</td>
					<td width="1%">&nbsp;</td>
					<td width="58%">
						<table width="100%" border="0">
							<tr>
								<td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
								<td width="76%">
									<cf_sifCalendario form="form1" tabindex="1" name="FechaDesde" value="#dateformat(now(),'dd/mm/yyyy')#">
								</td>
							</tr>
							<tr>
								<td align="right"><strong>Fecha Hasta:&nbsp;</strong></td>
								<td>
									<cf_sifCalendario form="form1" tabindex="1" name="FechaHasta" value="#dateformat(now(),'dd/mm/yyyy')#">
								</td>
							</tr>
							<tr>
								<td align="right"><strong>Ordenar por:</strong></td>
								<td>
									<select name="ordenar">
										<option value="Proveedor">Proveedor</option>
										<option value="Giro">Giro</option>
										<option value="CASE Actividad When 'Compra Única' then 4 WHEN 'BAJA' THEN 3 WHEN 'MEDIA' then 2 WHEN 'ALTA' then 1 END, Proveedor">Clasificación Descendente</option>
										<option value="CASE Actividad When 'Compra Única' then 1 WHEN 'BAJA' THEN 2 WHEN 'MEDIA' then 3 WHEN 'ALTA' then 4 END, Proveedor">Clasificación Ascendente</option>
									</select>
								</td>
							</tr>
						</table>
						<table width="100%" border="0">
							<tr>
								<td>&nbsp;</td>
								<td width="80%" align="right"><input type="submit" name="Consultar" id="Consultar" value="Consultar" tabindex="1">
								<td>
									<!--- <input type="hidden" name="FechaDesde" id="cuenta1Desc" value="">
									<input type="hidden" name="FechaHasta" id="cuenta2Desc" value=""> --->
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<cf_web_portlet_end>
	<cf_templatefooter>

<!--- <script language="javascript">
	function fnVerificar() {
		var f2 = document.form1.elements;

		if (f2.cmayor_ccuenta1.value == '' || f2.cmayor_ccuenta2.value == '') {
			alert('Debe indicar un rango de cuentas de mayor.');
			if (f2.cmayor_ccuenta2.value == '') {f2.cmayor_ccuenta2.focus();}
			if (f2.cmayor_ccuenta1.value == '') {f2.cmayor_ccuenta1.focus();}
			return false;
		}
		f2.cuenta1Desc.value = f2.Cdescripcion1.value;
		f2.cuenta2Desc.value = f2.Cdescripcion2.value;
		return true;
	}
	document.form1.cmayor_ccuenta1.focus();
</script> --->