
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="Tipo_de_Persona"
Default="Tipo de Persona"
returnvariable="Tipo_de_Persona"/>

<cf_templateheader title="Confirmación">
<script language="javascript" type="text/javascript">
	function funcGuardarContinuar() {
		document.formDatosEmpleado.ACCION.value = "1";
		document.formDatosEmpleado.submit();
	}

	function funcGuardarNuevo() {
		document.formDatosEmpleado.ACCION.value = "2";
		document.formDatosEmpleado.submit();
	}

	function funcCancelar() {
		location.href = '../Proyecto/index.cfm';
		
	}
</script>

<cfinclude template="../Proyecto/frame-config.cfm">
<cfquery name="rs" datasource="#session.dsn#">
select TPcodigo, TPdescripcion
from EDTiposPersona
where TPid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TiposPersona#">
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="../Proyecto/frame-header.cfm">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<form method="post" action="SQLdatosEmpleado.cfm" name="formDatosEmpleado" enctype="multipart/form-data">
			
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td colspan="3" bgcolor="##A0BAD3">
						<cfinclude template="../Proyecto/frame-botones.cfm">
					</td>
				  </tr>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
					<td class="textoAyuda" width="20%" valign="top">
						Asegurese de que los datos suministrados sean <strong>CORRECTOS</strong>.<br><br>
						Haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
						Si desea continuar agregando más personas haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
						Si desea trabajar con una persona diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar personas</font> en el cuadro de <strong>Opciones</strong>.<br><br>
						Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
					</td>
					<td style="padding-left: 5px; padding-right: 5px;" valign="top">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						  <tr>
							<td colspan="4" class="tituloLista">Datos de la persona</td>
						  </tr>
						  <tr>
						  	<td class="etiquetaCampo" width="20%" align="right" nowrap>#Tipo_de_Persona#:&nbsp;</td>
							<td align="left" colspan="3" nowrap> #rs.TPcodigo# - #rs.TPdescripcion#</td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Nombre:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.DEnombre# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Primer Apellido:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.DEapellido1# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Segundo Apellido:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.DEapellido2# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Tipo de Identificaci&oacute;n:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.NTIcodigo# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Numero de Identificaci&oacute;n:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.DEidentificacion# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Fecha de Vencimiento:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #LSDateFormat(form.DEdato1, "DD/MM/YYYY")# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Estado Civil:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEcivil# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Fecha de Nacimiento:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #LSDateFormat(form.DEfechanac, "DD/MM/YYYY")# </td>
						  </tr>
						   <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Sexo:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEsexo# </td>
						  </tr>
						   <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Direcci&oacute;n:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEdireccion# </td>
						  </tr>
						  <tr>
							<td width="20%" class="etiquetaCampo" align="right" nowrap>Telef&oacute;no de Residencia:&nbsp;</td>
							<td width="30%" align="left" nowrap>#Form.DEtelefono1#</td>
						  </tr>
						  <tr>
							 <td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no de Celular:&nbsp;</td>
							<td align="left" nowrap>#Form.DEtelefono2#</td> 
						  </tr>
						   <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Direcci&oacute;n Electr&oacute;nica:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEemail# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Pa&iacute;s de Nacimiento:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.Ppais# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Nivel:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.nivel# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>&Uacute;ltimo A&ntilde;o Aprobado:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEinfo1# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Instituci&oacute;n:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #form.DEinfo2# </td>
						  </tr>
						  <tr>
						  <td colspan="2" align="center">
						    <input type="button" name="Anterior" value="<< Anterior" onClick="javascrit: history.back();" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';">
							</td>
						  </tr>
						</table>
					</td>
					<td width="1%" valign="top">
						<cfinclude template="../Proyecto/frame-Progreso.cfm">
						<br>
						<cfinclude template="../Proyecto/frame-Proceso.cfm">
					</td>
				  </tr>
				</table>
				</form>
			</td>
		</tr>

	</table>
</cfoutput>
<cf_templatefooter>
