<!---
	Módulo      : Contabilidad General / Consultas
	Nombre      : Reporte de Reglas
	Descripción : 
		Permite consultar las reglas por cuenta de mayor definidas para un rango de cuentas y una oficina específica.
		El reporte debe de ordenarse por oficina, cuenta de mayor y la regla.
		
	Hecho por   : Steve Vado Rodríguez
	Creado      : 18/04/2006
	Modificado  : 
 --->

<!--- Formulario --->
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

	<cf_templateheader title="Reporte de Reglas">
		<cfinclude template="../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de Reglas">
			<form name="form1" id="form1" action="ReglasRep.cfm" method="post" onSubmit="return fnVerificar()">
			<table width="100%" border="0">
				<tr>
					<td  valign="top"width="41%"> <cf_web_portlet_start border="true" titulo="Reporte de Reglas" skin="info1">
						<div align="center">
							<p align="justify">
								Permite consultar las reglas por cuenta de mayor definidas para un
								rango de cuentas y una oficina específica.
								El reporte debe de ordenarse por oficina, cuenta de mayor y la regla.
							</p>
						</div>
						<cf_web_portlet_end> 
					</td>
					<td width="1%">&nbsp;</td>
					<td width="58%">
						<table width="100%" border="0">
							<tr>
								<td align="right"><strong>Cuenta Desde:&nbsp;</strong></td>
								<td width="76%">
									<cf_sifCuentasMayor form="form1" tabindex="1" Cmayor="cmayor_ccuenta1" Cdescripcion="Cdescripcion1" size="50">
								</td>
							</tr>
							<tr>
								<td align="right"><strong>Cuenta Hasta:&nbsp;</strong></td>
								<td>
									<cf_sifCuentasMayor form="form1" tabindex="1" Cmayor="cmayor_ccuenta2" Cdescripcion="Cdescripcion2" size="50">
								</td>							
							</tr>
							<tr>
								<td width="24%" align="right"><strong>Oficina:&nbsp;</strong></td>
								<td colspan="3">								
									<cfset ArrayOF=ArrayNew(1)>
									<cf_conlis
										Campos="Ocodigo,Oficodigo,Odescripcion"
										Desplegables="N,S,S"
										Modificables="N,S,N"
										Size="0,10,40"
										ValuesArray="#ArrayOF#" 
										Title="Lista de Oficinas"
										Tabla="Oficinas"
										Columnas="Ocodigo,Oficodigo,Odescripcion"
										Filtro="Ecodigo = #Session.Ecodigo#"
										Desplegar="Oficodigo,Odescripcion"
										Etiquetas="C&oacute;digo,Descripci&oacute;n"
										filtrar_por="Oficodigo,Odescripcion"
										Formatos="S,S"
										tabindex="1"
										Align="left,left"
										Asignar="Ocodigo,Oficodigo,Odescripcion"
										Asignarformatos="S,S,S"/>
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td colspan="3">
									<input type="checkbox" name="chkVerHijas" id="chkVerHijas"><strong>Mostrar reglas hijas</strong>
								</td>
							</tr>								
						</table>
						<table width="100%" border="0">
							<tr>
								<td>&nbsp;</td>
								<td width="80%" align="right"><input type="submit" name="Consultar" id="Consultar" value="Consultar" tabindex="1">
								<td>
									<input type="hidden" name="cuenta1Desc" id="cuenta1Desc" value="">
									<input type="hidden" name="cuenta2Desc" id="cuenta2Desc" value="">
								</td>
							</tr>
						</table>
					</td> 
				</tr>
			</table> 
		</form> 
		<cf_web_portlet_end>
	<cf_templatefooter> 

<script language="javascript">
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
</script>