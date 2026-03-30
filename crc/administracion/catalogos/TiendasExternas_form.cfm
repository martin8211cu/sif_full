
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif isdefined("url.id") and Len("url.id") gt 0>
	<cfset form.id = url.id >
</cfif>

<cfif isdefined("Session.Ecodigo") and isdefined("Form.id") and not isDefined("Form.Nuevo")>
	<cfset modo="CAMBIO">
</cfif>

<cfif modo eq "CAMBIO">
	<cfquery name="rsTienda" datasource="#Session.DSN#">
		SELECT id,Codigo,Descripcion,Activo,ExpRegFolio
		FROM CRCTiendaExterna
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and id = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id#">
	</cfquery>
</cfif>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>

<script language="JavaScript">

	function deshabilitarValidacion(){
		objForm.Codigo.required = false;
		objForm.Descripcion.required = false;
	}

</script>
<cfoutput>


<!---Redireccion ConfiguracionParametros_sql.cfm --->
<form method="post" name="form1" action="TiendasExternas_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr valign="baseline">
			<td nowrap align="right">#LB_Codigo#:&nbsp;</td>
			<td>
				<input type="text" name="Codigo" tabindex="1" required
				value="<cfif modo NEQ "ALTA">#rsTienda.Codigo#</cfif>"
				size="10" maxlength="20" onfocus="javascript:this.select();" enable="false" <cfif isdefined("rsTienda.Codigo") and #rsTienda.Codigo# neq ""> readonly </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_Descripcion#:&nbsp;</td>
			<td>
				<input type="text" name="Descripcion" tabindex="1" required
				value="<cfif modo NEQ "ALTA">#rsTienda.Descripcion#</cfif>"
				size="30" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right"><cf_translate key="LB_Activo" XmlFile="/crc/generales.xml">Activo</cf_translate>:&nbsp;</td>
			<td>
				<input type="checkbox" id="Activo" name="Activo" <cfif modo eq 'ALTA' or (modo eq 'CAMBIO' and rsTienda.Activo eq 1)> checked </cfif>>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">#LB_ExpREg#:&nbsp;</td>
			<td>
				<input type="text" name="ExpRegFolio" tabindex="1" maxlength="255" 
				value="<cfif modo NEQ "ALTA">#rsTienda.ExpRegFolio#</cfif>"
				size="30" maxlength="50" onfocus="javascript:this.select();" >
			</td>
		</tr> 
		<tr valign="baseline">
			<td colspan="2" align="right" nowrap>
				<div align="center">
					<script language="JavaScript" type="text/javascript">
						// Funciones para Manejo de Botones
						botonActual = "";

						function setBtn(obj) {
							botonActual = obj.name;
						}
						function btnSelected(name, f) {
							if (f != null) {
								return (f["botonSel"].value == name)
							} else {
								return (botonActual == name)
							}
						}
					</script>

					<input tabindex="-1" type="hidden" name="botonSel" value="">
					<input tabindex="-1" name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">
					<cfif modo eq 'ALTA'>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Agregar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Limpiar"/>

						<input type="submit" tabindex="3" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
						<input type="reset" tabindex="3" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">
					<cfelse>
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Modificar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Eliminar"
							Default="Eliminar"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Eliminar"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_DeseaElimarElRegistro"
							Default="Desea Eliminar el Registro?"
							XmlFile="/crc/generales.xml"
							returnvariable="LB_DeseaElimarElRegistro"/>

							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Nuevo"
							Default="Nuevo"
							XmlFile="/crc/generales.xml"
							returnvariable="BTN_Nuevo"/>

						<input tabindex="3" type="submit" name="Cambio" value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name; ">
						<input tabindex="3" type="submit" name="Baja" value="#BTN_Eliminar#" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('#LB_DeseaElimarElRegistro#') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
						<input tabindex="3" type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
					</cfif>
				</div>
			</td>
		</tr>
		<tr>
		  <td>&nbsp;</td>
		</tr>
		<tr valign="baseline">
			<input tabindex="-1" type="hidden" name="id" value="<cfif modo NEQ "ALTA">#rsTienda.id#</cfif>">
			<input tabindex="-1" type="hidden" name="Pagina"
			value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ "">#Pagenum_lista#<cfelseif isdefined("Form.PageNum")>#PageNum#</cfif>">
			<cfif modo NEQ "ALTA">
				<td colspan="2" align="right" nowrap>
					<div align="center">
					</div>
				</td>
			</cfif>
		</tr>
	</table>
</form>
</cfoutput>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Descripcion" Default="Descripción" XmlFile="/crc/generales.xml" returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Codigo" Default="Orden" XmlFile="/crc/generales.xml" returnvariable="MSG_Codigo"/>

<cf_qforms>
	<cf_qformsRequiredField name="Codigo" description="#MSG_Codigo#">
	<cf_qformsRequiredField name="Descripcion" description="#MSG_Descripcion#">
</cf_qforms>
