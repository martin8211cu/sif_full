<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select EDDcodigo, EDDdescripcion, ts_rversion, EDUid, EDDtipopintado
		from EDDatosVariables
		where EDDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
	</cfquery>
	
	<cfquery name="rsDet" datasource="#session.DSN#">
		select EDLVid, EDLVcodigo, EDLVdescripcion, ts_rversion
		from EDListaValores
		where EDDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
		order by EDLVcodigo
	</cfquery>
	<!--- registros existentes --->
	<cfquery name="rsCodigosDet" datasource="#session.DSN#">
		select EDLVcodigo
		from EDListaValores
		where EDDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select EDDcodigo
	from EDDatosVariables
<!--- 	where EDDid=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EDDid#"> --->
</cfquery>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDetalle"
	Default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	<cfif modo neq 'ALTA'>
	//carga el mantenimiento del detalle
	function fnCargaDetalle(EDLVid, EDLVcodigo, EDLVdescripcion, ts){
		objForm.EDLVid.obj.value = EDLVid;
		objForm.EDLVcodigo.obj.value = EDLVcodigo;
		objForm.EDLVdescripcion.obj.value = EDLVdescripcion;
		objForm.dtimestamp.obj.value = ts;
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Modificar#</cfoutput>';
	}
	function Borrar(EDLVid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.EDLVid.obj.value=EDLVid;
			deshabilitarValidacion();
			return true;
		}
		else
			return false;	
	}
	function fnDesCargaDetalle(){
		objForm.EDLVid.obj.value = '';
		objForm.EDLVcodigo.obj.value = '';
		objForm.EDLVdescripcion.obj.value = '';
		objForm.dtimestamp.obj.value = '';
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Agregar#</cfoutput>';
	}
	</cfif>
	//-->
</script>

<form name="form1" method="post" action="listavalores-sql.cfm">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td nowrap><input name="EDDcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.EDDcodigo)#</cfif>" size="10" maxlength="10" onfocus="javascript:this.select();" style="text-transform:uppercase;" /></td>
			</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td nowrap><input name="EDDdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDDdescripcion#</cfif>" size="53" maxlength="60" onFocus="javascript:this.select();"></td>
		</tr>
		<tr>
		<td nowrap align="right">	<cf_translate key="LB_Tipo" XmlFile="/rh/generales.xml">Tipo</cf_translate>:&nbsp;</td>
		<td><select name="Tipo" id="Tipo">
          <option value="">#CMB_Seleccionar#</option>
          <option value="1"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 1 >selected</cfif>>
            <cf_translate key="CMB_SeleccionUnica" XmlFile="/rh/generales.xml">Selecci&oacute;n &Uacute;nica</cf_translate>
          </option>
          <option value="2"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 2 >selected</cfif>>
            <cf_translate key="CMB_SeleccionMultiple" XmlFile="/rh/generales.xml">Selecci&oacute;n M&uacute;ltiple</cf_translate>
            </option>
          <option value="3"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 3 >selected</cfif>>
            <cf_translate key="CMB_Valorizacion" XmlFile="/rh/generales.xml">Valorizaci&oacute;n</cf_translate>
            </option>
          <option value="4"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 4 >selected</cfif>>
            <cf_translate key="CMB_Desarrollo" XmlFile="/rh/generales.xml">Desarrollo</cf_translate>
            </option>
          <option value="5"<cfif modo neq 'ALTA' and rsForm.EDDtipopintado eq 5 >selected</cfif>>
            <cf_translate key="CMB_Etiqueta" XmlFile="/rh/generales.xml">Etiqueta</cf_translate>
            </option>
        </select></td>
		</tr>
		<tr>
			<td nowrap align="right"><cf_translate key="LB_Unidades" XmlFile="/rh/generales.xml">Unidades</cf_translate>:&nbsp;				</td>
			<td>
			<cf_EDUnidades></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">			</td>
		</tr>
	
	<cfif modo neq 'ALTA'>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr align="center"> 
			<td colspan="2" align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
					<tr>
						<td>
							<fieldset><legend><cf_translate key="LB_Valores">Valores</cf_translate></legend>
								<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
									<tr bgcolor="FAFAFA"> 
										<td nowrap>&nbsp;</td>
										<td nowrap><b><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></b></td>
										<td nowrap><b><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></b></td>
										<td nowrap>
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Agregar"
												Default="Agregar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Agregar"/>
																						
											<cfinvoke component="sif.Componentes.Translate"
												method="Translate"
												Key="BTN_Limpiar"
												Default="Limpiar"
												XmlFile="/rh/generales.xml"
												returnvariable="BTN_Limpiar"/>
											<input type="submit" name="btnDetalleUpd" tabindex="1" value="#BTN_Agregar#" onClick="javascript: habilitarValidacionDet();">
											<input type="button" name="btnDesCargaDetalle" tabindex="1" value="#BTN_Limpiar#" onClick="javascript: fnDesCargaDetalle(); return false;">
											<input type="hidden" name="EDLVid" value="">
											<input type="hidden" name="borrarDetalle" value="">
											<input type="hidden" name="dtimestamp" value="">										</td>
									</tr>
									<tr bgcolor="FAFAFA"> 
										<td nowrap>&nbsp;</td>
										<td nowrap><input name="EDLVcodigo" type="text" tabindex="1" size="10" maxlength="10" onFocus="javascript:this.select();"></td>
										<td nowrap  colspan="2"><input name="EDLVdescripcion" tabindex="1" type="text" size="53" maxlength="80" onFocus="javascript:this.select();"></td>
										<td> </td>
									</tr>
									<cfloop query="rsDet"> 
										<cfset ts = "">
										<cfinvoke
										component="sif.Componentes.DButils"
										method="toTimeStamp"
										returnvariable="ts">
										<cfinvokeargument name="arTimeStamp" value="#ts_rversion#"/>
										</cfinvoke>
										
										<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td nowrap>&nbsp;</td>
											<td nowrap><a href="javascript: fnCargaDetalle('#EDLVid#', '#EDLVcodigo#', '#EDLVdescripcion#', '#ts#');">#EDLVcodigo#</a></td>
											<td nowrap colspan="2"><a href="javascript: fnCargaDetalle('#EDLVid#', '#EDLVcodigo#', '#EDLVdescripcion#', '#ts#');">#EDLVdescripcion#</a></td>
											<td nowrap>	
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_EliminarElemento"
													Default="Eliminar elemento"
													returnvariable="LB_EliminarElemento"/>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_EditarElemento"
													Default="Editar elemento"
													returnvariable="LB_EditarElemento"/>
												<input  name="btnBorrar#EDLVid#" type="image" alt="#LB_EliminarElemento#" onClick="javascript: return Borrar('#EDLVid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
												<input name="btnEditar#EDLVid#" type="image" alt="#LB_EditarElemento#" onClick="javascript: fnCargaDetalle('#EDLVid#', '#EDLVcodigo#', '#EDLVdescripcion#','#ts#'); return false;" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">											</td>
										</tr>
							
										<cfif RecordCount lte 0>
											<tr>
												<td nowrap colspan="5" align="center" class="fileLabel"><cf_translate key="LB_NoExistenDetalles">No existen detalles</cf_translate>.</td>
											</tr>
										</cfif>
									</cfloop>
									<tr>
										<td nowrap colspan="5">&nbsp;</td>
									</tr>
								</table>
							</fieldset>						</td>	
					</tr>
				</table>			</td>
		</tr>
	</cfif>
	<cfif modo NEQ 'ALTA'>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr>
		<td>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="EDDid" value="#form.EDDid#">		</td>
	</tr>
	</cfif>
  </table>  
  </cfoutput>
</form>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDelCatalogoYaExisteDefinaUnoDistinto"
	Default="El Código del Catálogo ya existe, defina uno distinto"
	returnvariable="MSG_ElCodigoDelCatalogoYaExisteDefinaUnoDistinto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ElCodigoDelValorYaExisteDefinaUnoDistinto"
	Default="El Código del Valor ya existe, defina uno distinto"
	returnvariable="MSG_ElCodigoDelValorYaExisteDefinaUnoDistinto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripción"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Tipo"
	Default="Tipo"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Tipo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Unidades"
	Default="Unidades"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Unidades"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_CodigoDeValor"
	Default="Código de Valor"
	returnvariable="MSG_CodigoDeValor"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DescripcionDeValor"
	Default="Descripción de Valor"
	returnvariable="MSG_DescripcionDeValor"/>

<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function _Field_CodigoNoExiste(){
		<cfoutput query="rsCodigos">
			if (("#ucase(trim(EDDcodigo))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.EDDcodigo))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "#MSG_ElCodigoDelCatalogoYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}

	_addValidator("isCods", _Field_CodigoNoExiste);

	objForm.EDDcodigo.required = true;
	objForm.EDDcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.EDDcodigo.validateCods();
	
	objForm.EDDdescripcion.required = true;
	objForm.EDDdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	objForm.Tipo.required = true;
	objForm.Tipo.description="<cfoutput>#MSG_Tipo#</cfoutput>";
	
	objForm.EDUnidades.required = true;
	objForm.EDUnidades.description="<cfoutput>#MSG_Unidades#</cfoutput>";

	function deshabilitarValidacion(){
		objForm.EDDcodigo.required = false;
		objForm.EDDdescripcion.required = false;
		objForm.Tipo.required = false;
		objForm.EDUnidades.required = false;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}

	function habilitarValidacion(){
		objForm.EDDcodigo.required = true;
		objForm.EDDdescripcion.required = true;
		objForm.Tipo.required = true;
		objForm.EDUnidades.required = true;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}
	
	<cfif modo neq 'ALTA'>
		function _Field_CodigoNoExisteDet(){
		  if (objForm.EDLVid.obj.value=="") {
			<cfoutput query="rsCodigosDet">
				if ("#EDLVcodigo#"==this.obj.value)
					this.error = "#MSG_ElCodigoDelValorYaExisteDefinaUnoDistinto#.";
			</cfoutput>
		  }
		}
	
		_addValidator("isCodsDet", _Field_CodigoNoExisteDet);
	
		//objForm.EDLVcodigo.required = true;
		objForm.EDLVcodigo.description="<cfoutput>#MSG_CodigoDeValor#</cfoutput>";
		objForm.EDLVcodigo.validateCodsDet();
		
		//objForm.EDLVdescripcion.required = true;
		objForm.EDLVdescripcion.description="<cfoutput>#MSG_DescripcionDeValor#</cfoutput>";

		function deshabilitarValidacionDet(){
			objForm.EDLVcodigo.required = false;
			objForm.EDLVdescripcion.required = false;
		}
	
		function habilitarValidacionDet(){
			objForm.EDLVcodigo.required = true;
			objForm.EDLVdescripcion.required = true;
		}

		objForm.EDLVcodigo.obj.focus();
	<cfelse>
		objForm.EDDcodigo.obj.focus();
	</cfif>
</script>