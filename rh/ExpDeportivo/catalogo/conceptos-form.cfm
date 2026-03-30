
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
		select EDCEcod, EDCEdescripcion, EDCEte, ts_rversion
		from EDConceptoExp
		where EDCEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDCEid#">
	</cfquery>
	<cfquery name="rsDet" datasource="#session.DSN#">
		select a.EDDCid, a.EDDCdetalle, a.ts_rversion, a.EDUid, a.EDDCcodigo, b.EDUcodigo, b.EDUdescripcion
		from EDDetConcepto a inner join
		EDUnidad b on
		a.EDUid = b.EDUid
		where a.EDCEid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDCEid#">
	</cfquery>

<cfquery name="rsCodigosDet" datasource="#session.DSN#">
		select EDDCcodigo
		from EDDetConcepto
		where EDCEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDCEid#">
	</cfquery> 
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select EDCEcod
	from EDConceptoExp
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
	function fnCargaDetalle(EDUid, EDDCcodigo, EDDCdetalle, ts){
		objForm.EDUid.obj.value = EDUid;
		objForm.EDDCcodigo.obj.value = EDDCcodigo;
		objForm.EDDCdetalle.obj.value = EDDCdetalle;
		objForm.dtimestamp.obj.value = ts;
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Modificar#</cfoutput>';
	}
	function Borrar(EDDCid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.EDDCid.obj.value=EDDCid;
			deshabilitarValidacion();
			return true;
		}
		else
			return false;	
	}
	function fnDesCargaDetalle(){
		objForm.EDUid.obj.value = '';
		objForm.EDDCcodigo.obj.value = '';
		objForm.EDDCdetalle.obj.value = '';
		objForm.dtimestamp.obj.value = '';
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Agregar#</cfoutput>';
	}
	</cfif>
	//-->
</script>

<form name="form1" method="post" action="conceptos-sql.cfm">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		<td nowrap align="right"><cf_translate key="LB_TipodeExpediente" XmlFile="/rh/generales.xml">Tipo de Expediente</cf_translate>:&nbsp;</td>
		<td nowrap> <select name="EDCEte" id="EDCEte">
					<option value="">#CMB_Seleccionar#</option>
                    <option value="1"<cfif modo NEQ 'ALTA' and rsForm.EDCEte EQ 1>selected</cfif>><cf_translate key="LB_Medico">M&eacute;dico</cf_translate></option>
                    <option value="2"<cfif modo NEQ 'ALTA' and rsForm.EDCEte EQ 2>selected</cfif>><cf_translate key="LB_Fisico">F&iacute;sico</cf_translate></option>
                  </select></td>
		</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
		  <td nowrap><input name="EDCEcod" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.EDCEcod)#</cfif>" size="10" maxlength="10" onfocus="javascript:this.select();" style="text-transform:uppercase;" /></td>
			</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td nowrap><input name="EDCEdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.EDCEdescripcion#</cfif>" size="53" maxlength="60" onFocus="javascript:this.select();"></td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">			</td>
		</tr>
		
	<cfif modo neq 'ALTA' or isdefined('form.modo')>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr align="center"> 
			<td colspan="2" align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
					<tr>
						<td>
							<fieldset><legend><cf_translate key="LB_Valores">Valores</cf_translate></legend>
								<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
									<tr bgcolor="FAFAFA"> 
										<td width="1%" nowrap>&nbsp;</td>
										<td width="19%" nowrap><b>
									  <cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></b></td>
										<td width="51%" nowrap><b>
									  <cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></b></td>
										<td width="22%" nowrap><b>
									  <cf_translate key="LB_Unidades" XmlFile="/rh/generales.xml">Unidades</cf_translate></b></td>
								  </tr>
										
									<tr bgcolor="FAFAFA"> 
										<td nowrap>&nbsp;</td>
								
										<td nowrap><input name="EDDCcodigo" type="text" tabindex="1" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;" ></td>
										<td nowrap ><input name="EDDCdetalle" tabindex="1" type="text" size="30" maxlength="80" onFocus="javascript:this.select();"></td>
										<td nowrap>
			<cf_EDUnidad></td>
									</tr>
									<tr>
										<td colspan="3" nowrap>
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
											<input type="hidden" name="EDDCid" value="<cfif modo NEQ 'ALTA' and isdefined('rsDet.EDDcid')><cfoutput>#rsDet.EDDCid#</cfoutput></cfif>">
											<input type="hidden" name="EDUdescripcion" value="<cfif modo NEQ 'ALTA' and isdefined('rsDet.EDUdescripcion')><cfoutput>#rsDet.EDUdescripcion#</cfoutput></cfif>">
											<input type="hidden" name="borrarDetalle" value="">
											<input type="hidden" name="dtimestamp" value="">
																				</td>
									</tr>
									<cfif modo NEQ 'ALTA'>
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
											<td nowrap><a href="javascript: fnCargaDetalle('#EDDCid#', '#EDDCcodigo#', '#EDDCdetalle#', #EDUid#, '#ts#');">#EDDCcodigo#</a></td>
											<td nowrap><a href="javascript: fnCargaDetalle('#EDDCid#', '#EDDCcodigo#', '#EDDCdetalle#', #EDUid#, '#ts#');">#EDDCdetalle#</a></td>
											<td nowrap>&nbsp;<a href="javascript: fnCargaDetalle('#EDDCid#', '#EDDCcodigo#', '#EDDCdetalle#', #EDUid#, '#ts#');">#EDUdescripcion#</a></td>
											<td width="7%" nowrap>	
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
												<input  name="btnBorrar#EDDCid#" type="image" alt="#LB_EliminarElemento#" onClick="javascript: return Borrar('#EDDCid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
										  <input name="btnEditar#EDDCid#" type="image" alt="#LB_EditarElemento#" onClick="javascript: fnCargaDetalle('#EDDCid#', '#EDDCcodigo#', '#EDDCdetalle#', #EDUid#, '#ts#'); return false;" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">											</td>
										</tr>
							
										<cfif RecordCount eq 0>
											<tr>
												<td nowrap colspan="5" align="center" class="fileLabel"><cf_translate key="LB_NoExistenDetalles">No existen detalles</cf_translate>.</td>
											</tr>
										</cfif>
									</cfloop>
									</cfif>
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
	
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>

	<tr>
		<td>
			<input type="hidden" name="ts_rversion" value="#ts#">
			<input type="hidden" name="EDCEid" value="#form.EDCEid#">		</td>
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
	Key="MSG_TipodeExpediente	"
	Default="Tipo de Expediente"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_TipodeExpediente"/>
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
			if (("#ucase(trim(EDCEcod))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.EDCEcod))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "#MSG_ElCodigoDelCatalogoYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}

	_addValidator("isCods", _Field_CodigoNoExiste);

	objForm.EDCEcod.required = true;
	objForm.EDCEcod.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.EDCEcod.validateCods();
	
	objForm.EDCEdescripcion .required = true;
	objForm.EDCEdescripcion .description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	
	objForm.EDCEte.required = true;
	objForm.EDCEte.description="<cfoutput>#MSG_TipodeExpediente#</cfoutput>";

	function deshabilitarValidacion(){
		objForm.EDCEcod.required = false;
		objForm.EDCEdescripcion .required = false;
		objForm.EDCEte.required = false;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}

	function habilitarValidacion(){
		objForm.EDCEcod.required = true;
		objForm.EDCEdescripcion .required = true;
		objForm.EDCEte.required = true;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}
	
	<cfif modo neq 'ALTA'>
		function _Field_CodigoNoExisteDet(){
		  if (objForm.EDDCid.obj.value=="") {
			<cfoutput query="rsCodigosDet">
				if ("#EDDCcodigo#"==this.obj.value)
					this.error = "#MSG_ElCodigoDelValorYaExisteDefinaUnoDistinto#.";
			</cfoutput>
		  }
		}
	
		_addValidator("isCodsDet", _Field_CodigoNoExisteDet);
	
		//objForm.EDDCcodigo.required = true;
		objForm.EDDCcodigo.description="<cfoutput>#MSG_CodigoDeValor#</cfoutput>";
		objForm.EDDCcodigo.validateCodsDet();
		
		//objForm.EDDCdetalle.required = true;
		objForm.EDDCdetalle.description="<cfoutput>#MSG_DescripcionDeValor#</cfoutput>";
		
		//objForm.EDUid.required = true;
		objForm.EDUid.description="<cfoutput>#MSG_Unidades#</cfoutput>";

		function deshabilitarValidacionDet(){
			objForm.EDDCcodigo.required = false;
			objForm.EDDCdetalle.required = false;
			objForm.EDUid.required = false;
		}
	
		function habilitarValidacionDet(){
			objForm.EDDCcodigo.required = true;
			objForm.EDDCdetalle.required = true;
			objForm.EDUid.required = true;
		}

		objForm.EDDCcodigo.obj.focus();
	<cfelse>
		objForm.EDCEcod.obj.focus();
	</cfif>
</script>