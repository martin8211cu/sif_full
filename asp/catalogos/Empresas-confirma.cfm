<cf_templateheader title="Confirmación">
<script language="javascript" type="text/javascript">
	function funcGuardarContinuar() {
		document.frmEmpresas.ACCION.value = "1";
		document.frmEmpresas.submit();
	}

	function funcGuardarNuevo() {
		document.frmEmpresas.ACCION.value = "2";
		document.frmEmpresas.submit();
	}

	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
</script>

<cfquery name="rsMoneda" datasource="asp">
	select Mnombre 
	from Moneda
	where Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#">
</cfquery>
<cfset moneda = rsMoneda.Mnombre>

<cfquery name="rsCache" datasource="asp">
	select Ccache 
	from Caches
	where Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
</cfquery>
<cfset cache = rsCache.Ccache>

<cfinclude template="frame-config.cfm">
<cfoutput>
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td valign="top">
				<cfinclude template="frame-header.cfm">
			</td>
		</tr>
		<tr>
			<td valign="top">
				<form method="post" action="Empresas-sql.cfm" name="frmEmpresas" enctype="multipart/form-data">
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
						Recuerde que el cache <strong>NO</strong> podrá ser modificado una vez guardados los datos de la empresa. Verifique que éste sea el que usted desea utilizar.<br><br>
						Haga click en <font color="##0000FF">Guardar y Continuar</font> para ir al siguiente paso.<br><br>
						Si desea continuar agregando más empresas haga click en <font color="##0000FF">Guardar y Agregar Otro</font>.<br><br>
						Si desea trabajar con una empresa diferente a la actual, haga click en la opción de <font color="##0000FF">Seleccionar Empresa</font> en el cuadro de <strong>Opciones</strong>.<br><br>
						Haga click en <font color="##0000FF">Cancelar</font> si desea salir al menu principal.
					</td>
					<td style="padding-left: 5px; padding-right: 5px;" valign="top">
						<table border="0" width="100%" cellpadding="2" cellspacing="0">
						  <tr>
							<td colspan="4" class="tituloLista">Datos de la Empresa</td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" width="20%" align="right" nowrap>Nombre:&nbsp;</td>
							<td colspan="3" align="left" nowrap> #Form.Enombre# </td>
						  </tr>
						  <tr>
							<td width="20%" class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 1:&nbsp;</td>
							<td width="30%" align="left" nowrap>#Form.Etelefono1#</td>
							<td width="20%" class="etiquetaCampo" align="right" nowrap>Moneda:&nbsp;</td>
							<td width="30%" align="left" nowrap> #moneda# </td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" align="right" nowrap>Telef&oacute;no 2:&nbsp;</td>
							<td align="left" nowrap>#Form.Etelefono2#</td>
							<td class="etiquetaCampo" align="right" nowrap>Fax:&nbsp;</td>
							<td align="left" nowrap>#Form.Efax#</td>
						  </tr>
						  <tr>
							<td class="etiquetaCampo" align="right" nowrap>Cache:&nbsp;</td>
							<td align="left" nowrap> #cache# </td>
							<td align="right" class="etiquetaCampo" nowrap>Identificaci&oacute;n:&nbsp;</td>
							<td align="left" nowrap>#form.Eidentificacion#</td>
						  </tr>

						  <tr>
							<td align="right" class="etiquetaCampo" nowrap>Logo:&nbsp;</td>
							<td align="left" nowrap colspan="3">
								<!--- <input type="file" name="logo" value="kaka"  > --->
								<input id='logo' type="file" name="logo" value="">
							</td>
						  </tr>

						  <tr>
							<td colspan="4"> <cf_direccion action="display" data="#Form#" form="frmEmpresas"> </td>
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

