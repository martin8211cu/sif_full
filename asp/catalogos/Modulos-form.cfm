<cfquery name="rsSistemas" datasource="asp">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo, SSdescripcion
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select rtrim(a.SScodigo) as SScodigo,
		rtrim(b.SMcodigo) as SMcodigo,
		b.SMdescripcion
	from SSistemas a, SModulos b
	where a.SScodigo = b.SScodigo
	<cfif isdefined("Form.SScodigo") and Len(Trim(Form.SScodigo)) NEQ 0>
	and a.SScodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.SScodigo#">
	</cfif>
	and not exists (
		select 1
		from ModulosCuentaE c
		where c.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#"> 
		and c.SScodigo = b.SScodigo
		and c.SMcodigo = b.SMcodigo
	)
	order by a.SScodigo, b.SMcodigo, b.SMdescripcion
</cfquery>

<cfquery name="rsModulosAsignados" datasource="asp">
	select rtrim(a.SScodigo) as SScodigo, 
		   rtrim(b.SMcodigo) as SMcodigo, 
		   b.SMdescripcion
	from ModulosCuentaE x, SSistemas a, SModulos b
	where x.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#">
	and x.SScodigo = a.SScodigo
	and x.SScodigo = b.SScodigo
	and x.SMcodigo = b.SMcodigo 
	order by a.SScodigo, a.SSdescripcion, b.SMcodigo, b.SMdescripcion
</cfquery>

<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="javascript" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}

	function funcContinuar() {
		document.frmModulos.ACCION.value = "1";
		document.frmModulos.submit();
	}
	
	function funcCancelar() {
		location.href = '/cfmx/asp/index.cfm';
	}
	
	function Eliminar(SScodigo, SMcodigo) {
		if (confirm('¿Está seguro de que desea quitar el acceso al módulo '+SScodigo+'-'+SMcodigo+' en la cuenta empresarial seleccionada?')) {
			document.frmModulos.ACCION.value = "3";
			document.frmModulos.SScodigoDel.value = SScodigo;
			document.frmModulos.SMcodigoDel.value = SMcodigo;
			document.frmModulos.submit();
		}
	}
	
	function filtrarSistema() {
		document.frmModulos.action = '<cfoutput>#pagina#</cfoutput>';
		document.frmModulos.submit();
	}
	
</script>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
  	<td colspan="3" bgcolor="#A0BAD3">
		<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
			<tr>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcContinuar();">
					<img src="../imagenes/r_arrow.gif" border="0" align="top" hspace="2">Continuar
				</td>
				<td>|</td>
				<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: return funcCancelar();">
					<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
				</td>
			</tr>
		</table>
	</td>
  </tr>
  <tr>
  	<td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td class="textoAyuda" width="20%" valign="top">
		Un <strong>módulo</strong> es un conjunto de funcionalidades que forman parte de un sistema.<br><br>
		En el formulario que se muestra, se listan todos los módulos a los cuales tiene acceso la cuenta empresarial seleccionada.<br><br>
		Para agregar un nuevo módulo a la lista, seleccione el módulo y haga click en el botón <font color="#0000FF">Agregar</font>.<br><br>
		Para eliminar el acceso a uno de los módulos en la lista, haga click en la imagen que contiene una <font color="#0000FF">Equis (X)</font>, ubicada al lado derecho del módulo que se lista.
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top" align="center">
		<cfoutput>
		<form name="frmModulos" method="post" action="Modulos-sql.cfm" style="margin:0;">
			<input name="ACCION" type="hidden" value="2">
			<input type="hidden" name="SScodigoDel" value="">
			<input type="hidden" name="SMcodigoDel" value="">
			<table border="0" cellspacing="0" cellpadding="3" width="100%">
			  <tr>
				<td width="15%" align="right" nowrap class="etiquetaCampo" style="padding-right: 10px; border-top: 1px solid black;">
					Sistema:
				</td>
				<td align="left" style="border-top: 1px solid black;">
					<select name="SScodigo" onChange="javascript: filtrarSistema();">
					  <option value="">-- Todos --</option>
					  <cfloop query="rsSistemas">
						<option value="#SScodigo#"<cfif isdefined("Form.SScodigo") and Form.SScodigo EQ rsSistemas.SScodigo> selected</cfif>>#SScodigo# - #SSdescripcion#</option>
					  </cfloop>
					</select>
				</td>
				<td align="left" style="border-top: 1px solid black;">&nbsp;</td>
			  </tr>
			  <tr>
				<td width="15%" align="right" nowrap class="etiquetaCampo" style="padding-right: 10px; border-bottom: 1px solid black;">
					Módulo:
				</td>
				<td align="left" style="border-bottom: 1px solid black;">
					<select name="SMcodigo">
					  <cfif rsModulos.recordCount EQ 0>
						<option value="">--No Disponible--</option>
					  </cfif>
					  <cfloop query="rsModulos">
						<option value="#SScodigo#|#SMcodigo#">#SScodigo# - #SMcodigo#: #SMdescripcion#</option>
					  </cfloop>
					</select>
				</td>
				<td align="center" style="border-bottom: 1px solid black;" nowrap>
					<input name="btnAgregar" type="submit" id="btnAgregar" class="btnGuardar" value="Agregar">
				</td>
			  </tr>
			  <tr>
				<td colspan="3" nowrap>&nbsp;</td>
			  </tr>
			  <tr>
				<td align="left" colspan="3">
					<cfif rsModulosAsignados.recordCount GT 0>
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td colspan="2" class="tituloLista">Módulos asignados a la cuenta empresarial</td>
							</tr>
							<cfloop query="rsModulosAsignados">
								<tr <cfif rsModulosAsignados.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif> onMouseOver="style.backgroundColor='##E4E8F3';" onMouseOut="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';" >
									<td height="18" nowrap>#SScodigo# - #SMcodigo#: #SMdescripcion#</td>
									<td height="18" width="1%" nowrap>
										<a href="javascript:Eliminar('#rsModulosAsignados.SScodigo#', '#rsModulosAsignados.SMcodigo#');">
											<img border="0" src="/cfmx/asp/imagenes/delete.gif" alt="Eliminar"> 
										</a>
									</td>
								</tr>
							</cfloop>
						</table>
					<cfelse>
						<div class="textoMensajes">
							Actualmente no hay modulos asignados a esta cuenta empresarial
						</div>
					</cfif>
				</td>
			  </tr>
			</table>
		</form>
		</cfoutput>
	</td>
    <td width="1%" valign="top">
		<cfinclude template="frame-Progreso.cfm">
		<br>
		<cfinclude template="frame-Proceso.cfm">
	</td>
  </tr>
</table>


<script language="javascript" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("frmModulos");
	
	objForm.SMcodigo.required = true;
	objForm.SMcodigo.description = "Módulo";
	
	function showList(){
		location.href = 'Modulos.cfm?selecc=1';
	}
	
</script>
