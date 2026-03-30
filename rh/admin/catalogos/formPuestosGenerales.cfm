<!--- VARBIALES DE TRADUCCION --->
<cfsilent>
<cfinvoke Key="MSG_DeseaEliminarElDetalle" Default="Desea Eliminar el Detalle" returnvariable="MSG_DeseaEliminarElDetalle" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Modificar" Default="Modificar" returnvariable="BTN_Modificar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Agregar" Default="Agregar" returnvariable="BTN_Agregar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="BTN_Limpiar" Default="Limpiar" returnvariable="BTN_Limpiar" component="sif.Componentes.Translate" method="Translate" XmlFile="/rh/generales.xml"/>
<cfinvoke Key="LB_EliminarElemento" Default="Eliminar elemento" returnvariable="LB_EliminarElemento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_EditarElemento" Default="Editar elemento" returnvariable="LB_EditarElemento" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeFactores" Default="Lista de Factores" returnvariable="MSG_ListaDeFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronFactores" Default="No se econtraron Factores" returnvariable="MSG_NoSeEncontraronFactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_ListaDeSubfactores" Default="Lista de Subfactores" returnvariable="MSG_ListaDeSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeEncontraronSubfactores" Default="No se econtraron subfactores" returnvariable="MSG_NoSeEncontraronSubfactores" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_Factor" Default="Factor" returnvariable="MSG_Factor"component="sif.Componentes.Translate" method="Translate"/>
</cfsilent>
<!--- FIN VARBIALES DE TRADUCCION --->
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
<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="675" default="" returnvariable="UsaGrados"/>

<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select upper(rtrim(RHECGcodigo)) as RHECGcodigo, RHECGdescripcion, ts_rversion,RHHFid,RHHSFid,RHECgrado
		from RHECatalogosGenerales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHECGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">
	</cfquery>
	
	<cf_dbfunction name="length" args="RHDCGdescripcion" returnvariable="RHDCGdescripcion_length">
	<cf_dbfunction name="OP_concat"	returnvariable="_CAT">
	<cf_dbfunction name="sPart" args="RHDCGdescripcion,1,35" returnvariable="RHDCGdescripcion_sPart">
	
	<cfquery name="rsDet" datasource="#session.DSN#">
		select RHDCGid, upper(rtrim(RHDCGcodigo)) as RHDCGcodigo, 
		case when #preservesinglequotes(RHDCGdescripcion_length)# > 60 then 
			#preservesinglequotes(RHDCGdescripcion_sPart)# #_CAT# '...'
			else RHDCGdescripcion end as RHDCGdescripcionLista,
			RHDCGdescripcion,
		 ts_rversion
		from RHDCatalogosGenerales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHECGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">
		order by RHDCGcodigo
	</cfquery>
	
	<!--- registros existentes --->
	<cfquery name="rsCodigosDet" datasource="#session.DSN#">
		select upper(rtrim(RHDCGcodigo)) as RHDCGcodigo
		from RHDCatalogosGenerales
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHECGid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(rtrim(RHECGcodigo)) as RHECGcodigo
	from RHECatalogosGenerales
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

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
	function fnCargaDetalle(RHDCGid, RHDCGcodigo, RHDCGdescripcion, ts){
		objForm.RHDCGid.obj.value = RHDCGid;
		objForm.RHDCGcodigo.obj.value = RHDCGcodigo;
		objForm.RHDCGdescripcion.obj.value = RHDCGdescripcion;
		objForm.dtimestamp.obj.value = ts;
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Modificar#</cfoutput>';
	}
	function Borrar(RHDCGid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.RHDCGid.obj.value=RHDCGid;
			deshabilitarValidacion();
			return true;
		}
		else
			return false;	
	}
	function fnDesCargaDetalle(){
		objForm.RHDCGid.obj.value = '';
		objForm.RHDCGcodigo.obj.value = '';
		objForm.RHDCGdescripcion.obj.value = '';
		objForm.dtimestamp.obj.value = '';
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Agregar#</cfoutput>';
	}
	</cfif>
	//-->
</script>

<form name="form1" method="post" action="SQLPuestosGenerales.cfm">
	<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr><td colspan="2">&nbsp;</td></tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
			<td nowrap>
				<input name="RHECGcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHECGcodigo)#</cfif>" size="10" maxlength="10" onFocus="javascript:this.select();" style="text-transform:uppercase;">
			</td>
		</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
			<td nowrap><input name="RHECGdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHECGdescripcion#</cfif>" size="53" maxlength="60" onFocus="javascript:this.select();"></td>
		</tr>
		
		<tr <cfif UsaGrados>style="display:''"<cfelse>style="display:'none'" </cfif>>
			<td nowrap align="right"><cf_translate key="LB_Factor">Factor</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' and LEN(TRIM(rsform.RHHFid))>
					<cfquery name="rsFactor" datasource="#session.DSN#">
						select RHHFid,RHHFcodigo,RHHFdescripcion
						from RHHFactores
						where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsform.RHHFid#">
					</cfquery>
					<cfset vArrayFactor=ArrayNew(1)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFid)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFcodigo)>
					<cfset ArrayAppend(vArrayFactor,rsFactor.RHHFdescripcion)>
				<cfelse><cfset vArrayFactor=ArrayNew(1)></cfif>
				<cf_conlis
					campos="RHHFid,RHHFcodigo,RHHFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,25"
					title="#MSG_ListaDeFactores#"
					tabla="RHHFactores"
					columnas="RHHFid,RHHFcodigo,RHHFdescripcion"
					desplegar="RHHFcodigo,RHHFdescripcion"
					filtrar_por="RHHFcodigo,RHHFdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="RHHFid,RHHFcodigo,RHHFdescripcion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronFactores# --"
					tabindex="1"
					valuesArray="#vArrayFactor#"
                    funcion="fnLimpiar()"
                    funcionValorEnBlanco="fnLimpiar()">
			</td>
		</tr>
		<tr <cfif UsaGrados>style="display:''"<cfelse>style="display:'none'" </cfif>>
			<td nowrap align="right"><cf_translate key="LB_SubFactor">Subfactor</cf_translate>:&nbsp;</td>
			<td>
				<cfif modo neq 'ALTA' and LEN(TRIM(rsForm.RHHFid)) gt 0 and LEN(TRIM(rsForm.RHHSFid)) gt 0>
					<cfquery name="rsSFactor" datasource="#session.DSN#">
						select RHHSFid,RHHSFcodigo,RHHSFdescripcion
						from RHHSubfactores
						where RHHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHHFid#">
						  and RHHSFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.RHHSFid#">
					</cfquery>
					<cfset vArraySFactor=ArrayNew(1)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFid)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFcodigo)>
					<cfset ArrayAppend(vArraySFactor,rsSFactor.RHHSFdescripcion)>
				<cfelse><cfset vArraySFactor=ArrayNew(1)></cfif>
				<cf_conlis
					campos="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					desplegables="N,S,S"
					modificables="N,S,N"
					size="0,10,25"
					title="#MSG_ListaDeSubfactores#"
					tabla="RHHSubfactores"
					columnas="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					filtro="RHHFid = $RHHFid,numeric$"
					desplegar="RHHSFcodigo,RHHSFdescripcion"
					filtrar_por="RHHSFcodigo,RHHSFdescripcion"
					etiquetas="#LB_Codigo#, #LB_Descripcion#"
					formatos="S,S"
					align="left,left"
					asignar="RHHSFid,RHHSFcodigo,RHHSFdescripcion"
					asignarformatos="S, S, S"
					showEmptyListMsg="true"
					EmptyListMsg="-- #MSG_NoSeEncontraronSubfactores# --"
					tabindex="1"
					valuesArray="#vArraySFactor#">
			</td>
		</tr>
		<cfif modo neq 'ALTA'><cfset Lvar_Grado = rsform.RHECgrado><cfelse><cfset Lvar_Grado = ''></cfif>
		<tr <cfif UsaGrados>style="display:''"<cfelse>style="display:'none'" </cfif>>
			<td nowrap align="right"><cf_translate key="LB_Grado">Grado</cf_translate>:&nbsp;</td>
			<td><cf_inputNumber name="RHECgrado" tabindex="1" value="#Lvar_Grado#" size="3" enteros="2" decimales="0" comas="false" ></td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfset tabindex="1">
				<cfinclude template="/rh/portlets/pBotones.cfm">
			</td>
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
											<input type="submit" name="btnDetalleUpd" tabindex="1" value="#BTN_Agregar#" onClick="javascript: habilitarValidacionDet();">
											<input type="button" name="btnDesCargaDetalle" tabindex="1" value="#BTN_Limpiar#" onClick="javascript: fnDesCargaDetalle(); return false;">
											<input type="hidden" name="RHDCGid" value="">
											<input type="hidden" name="borrarDetalle" value="">
											<input type="hidden" name="dtimestamp" value="">
										</td>
									</tr>
									<tr bgcolor="FAFAFA"> 
										<td nowrap>&nbsp;</td>
										<td nowrap><input name="RHDCGcodigo" type="text" tabindex="1" size="10" maxlength="10" onFocus="javascript:this.select();"></td>
										<td nowrap  colspan="2"><input name="RHDCGdescripcion" tabindex="1" type="text" size="53" maxlength="255" onFocus="javascript:this.select();"></td>
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
										
										<tr style="cursor:pointer" <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td nowrap  onclick="javascript: fnCargaDetalle('#RHDCGid#', '#RHDCGcodigo#', '#RHDCGdescripcion#', '#ts#');" >&nbsp;</td>
											<td nowrap onclick="javascript: fnCargaDetalle('#RHDCGid#', '#RHDCGcodigo#', '#RHDCGdescripcion#', '#ts#');" >#RHDCGcodigo#</td>
											<td nowrap colspan="2" onclick="javascript: fnCargaDetalle('#RHDCGid#', '#RHDCGcodigo#', '#RHDCGdescripcion#', '#ts#');" >#RHDCGdescripcionLista#</td>
											<td nowrap>	
												<input  name="btnBorrar#RHDCGid#" type="image" alt="#LB_EliminarElemento#" onClick="javascript: return Borrar('#RHDCGid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
												<input name="btnEditar#RHDCGid#" type="image" alt="#LB_EditarElemento#" onClick="javascript: fnCargaDetalle('#RHDCGid#', '#RHDCGcodigo#', '#RHDCGdescripcion#','#ts#'); return false;" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">
											</td>
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
							</fieldset>
						</td>	
					</tr>
				</table>
			</td>
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
			<input type="hidden" name="RHECGid" value="#form.RHECGid#">
		</td>
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
			if (("#ucase(trim(RHECGcodigo))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.RHECGcodigo))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "#MSG_ElCodigoDelCatalogoYaExisteDefinaUnoDistinto#.";
		</cfoutput>
	}

	_addValidator("isCods", _Field_CodigoNoExiste);

	objForm.RHECGcodigo.required = true;
	objForm.RHECGcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	objForm.RHECGcodigo.validateCods();

	
	objForm.RHECGdescripcion.required = true;
	objForm.RHECGdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";
	objForm.RHHFid.description="<cfoutput>#MSG_Factor#</cfoutput>"
	
	function deshabilitarValidacion(){
		objForm.RHECGcodigo.required = false;
		objForm.RHECGdescripcion.required = false;
		objForm.RHECgrado.required=false;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}

	function habilitarValidacion(){
		objForm.RHECGcodigo.required = true;
		objForm.RHECGdescripcion.required = true;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}
	
	<cfif modo neq 'ALTA'>
		function _Field_CodigoNoExisteDet(){
		  if (objForm.RHDCGid.obj.value=="") {
			<cfoutput query="rsCodigosDet">
				if ("#RHDCGcodigo#"==this.obj.value)
					this.error = "#MSG_ElCodigoDelValorYaExisteDefinaUnoDistinto#.";
			</cfoutput>
		  }
		}
	
		_addValidator("isCodsDet", _Field_CodigoNoExisteDet);
	
		//objForm.RHDCGcodigo.required = true;
		objForm.RHDCGcodigo.description="<cfoutput>#MSG_CodigoDeValor#</cfoutput>";
		objForm.RHDCGcodigo.validateCodsDet();
		
		//objForm.RHDCGdescripcion.required = true;
		objForm.RHDCGdescripcion.description="<cfoutput>#MSG_DescripcionDeValor#</cfoutput>";

		function deshabilitarValidacionDet(){
			objForm.RHDCGcodigo.required = false;
			objForm.RHDCGdescripcion.required = false;
		}
	
		function habilitarValidacionDet(){
			objForm.RHDCGcodigo.required = true;
			objForm.RHDCGdescripcion.required = true;
	
		}

		objForm.RHDCGcodigo.obj.focus();
	<cfelse>
		objForm.RHECGcodigo.obj.focus();
	</cfif>
	
	function fnLimpiar(){
		document.form1.RHHSFid.value = "";
		document.form1.RHHSFcodigo.value = "";
		document.form1.RHHSFdescripcion.value = "";

	}
</script>