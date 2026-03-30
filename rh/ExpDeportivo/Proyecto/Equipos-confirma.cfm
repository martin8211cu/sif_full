
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Tipo_de_Equipo"
Default="Tipo de Equipo"
returnvariable="Tipo_de_Equipo"/>

<cf_templateheader title="Confirmación">
<script language="javascript" type="text/javascript">
	function funcGuardarContinuar() {
		document.frmEquipos.ACCION.value = "1";
		document.frmEquipos.submit();
	}

	function funcGuardarNuevo() {
		document.frmEquipos.ACCION.value = "2";
		document.frmEquipos.submit();
	}

	function funcCancelar() {
		location.href = 'index.cfm';
	}
</script>
<cfinclude template="frame-config.cfm">
<cfquery name="rs" datasource="#session.dsn#">
select TEcodigo, TEdescripcion
from EDTiposEquipo
where TEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TiposEquipo#">
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="frame-header.cfm">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<form method="post" action="Equipos-sql.cfm" name="frmEquipos" enctype="multipart/form-data">
			<input type="hidden" name="Pantalla" value="2">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="3" bgcolor="##A0BAD3">
						<cfinclude template="frame-botones.cfm">
					</td>
				  </tr>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoAyuda" width="20%" valign="top">
						Asegurese de que los datos suministrados sean <strong>CORRECTOS</strong>.<br><br>
						Haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
						Si desea continuar agregando más equipos haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
						Si desea trabajar con un equipo diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar equipos</font> en el cuadro de <strong>Opciones</strong>.<br><br>
						Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
					</td>
					<td style="padding-left: 5px; padding-right: 5px;" valign="top">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						  <tr>
							<td colspan="4" class="tituloLista">Datos de la persona</td>
						  </tr>
						  <tr>
						  	<td class="etiquetaCampo" width="20%" align="right" nowrap>#Tipo_de_Equipo#:&nbsp;</td>
							<td align="left" colspan="3" nowrap> #rs.TEcodigo# - #rs.TEdescripcion#</td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Nombre:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.Enombre# </td>
						  </tr>
						  <tr>
							<td width="20%" class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 1:&nbsp;</td>
							<td width="30%" align="left" nowrap>#Form.Etelefono1#</td>
						  </tr>
						  <tr>
							 <td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 2:&nbsp;</td>
							<td align="left" nowrap>#Form.Etelefono2#</td> 
						  </tr>
						    <tr>
							<td class="etiquetaCampo" align="right" nowrap>Fax:&nbsp;</td>
							<td align="left" nowrap>#Form.Efax#</td>
						  </tr>
						  <tr>
							<td align="right" class="etiquetaCampo" nowrap>Logo:&nbsp;</td>
							<td align="left" nowrap colspan="3">
								<input id='logo' type="file" name="logo" value="">
							</td>
						  </tr>

						  <tr>
							<td colspan="4"> <cf_direccion action="display" data="#Form#"> </td>
						  </tr>
						  <tr>
							<td colspan="4" align="center">
								<cfloop collection="#Form#" item="i">
									<input type="hidden" name="#i#" value="#StructFind(Form, i)#">
								</cfloop>
								<input type="button" name="Anterior" value="<< Anterior" onClick="javascrit: history.back();" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';">
							</td>
						  </tr>
						</table>
					</td>
					<td width="1%" valign="top">
						<cfinclude template="frame-Progreso.cfm">
						<br>
						<cfinclude template="frame-Proceso.cfm">
					</td>
				  </tr>
				</table>
				</form>
			</td>
		</tr>

	</table>
</cfoutput>
<cf_templatefooter>

<script language="javascript1.2" type="text/javascript">
	function imagen(){
		document.getElementById("logo").value = 'jhg';
		alert(document.getElementById("logo").value)
	}
</script>

