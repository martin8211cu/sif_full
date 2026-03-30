<!--- modificado con notepad --->
<!--- Sección de Etiquetas de Traducción --->
<cfsilent>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DeseaEliminarElDetalle"
	default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Modificar"
	default="Modificar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Agregar"
	default="Agregar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto"
	default="El Código de Conocimiento ya existe, defina uno distinto"
	returnvariable="MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Codigo"
	default="Código"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Descripcion"
	default="Descripción"
	xmlfile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_OrdenDelItem"
	default="Orden del Item"
	returnvariable="MSG_OrdenDelItem"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_DescripcionDeItem"
	default="Descripción de Item"
	returnvariable="MSG_DescripcionDeItem"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Limpiar"
	default="Limpiar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Agregar"
	default="Agregar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_EliminarElemento"
	default="Eliminar elemento"
	returnvariable="LB_EliminarElemento"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_EditarElemento"
	default="Editar elemento"
	returnvariable="LB_EditarElemento"/>
	
</cfsilent>

﻿<!-- Establecimiento del modo -->
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
		select upper(rtrim(RHCcodigo)) as RHCcodigo, RHCdescripcion,RHCinactivo,PCid, ts_rversion
		from RHConocimientos
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	<cfquery name="rsDet" datasource="#session.dsn#"><!--- Lista de Items de la conocimiento --->
		select RHICid, RHCid, RHICdescripcion, RHICorden, 
		case when len(RHICdescripcion) > 40 
		then {fn concat(substring(RHICdescripcion,1,37),'...')}
		else RHICdescripcion end RHICdescripcionshort
		from RHIConocimiento
		where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
		order by RHICorden, RHICdescripcion
	</cfquery>
	<cfquery name="rsMaxDet" dbtype="query">
		select max(RHICorden)+1 as nextOrden from rsDet
	</cfquery>
	<cfset nextOrden = iif(len(trim(rsMaxDet.nextOrden)) gt 0,rsMaxDet.nextOrden, 1)>
</cfif>
<cfquery name="data" datasource="#session.dsn#">
<!--- 	select PCid, PCcodigo, PCnombre, PCdescripcion, ts_rversion
	from PortalCuestionario
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	and PCtipo in (0,30) 	 --->
	select b.PCnombre, b.PCid, b.PCcodigo
	from RHEvaluacionCuestionarios a
			inner join PortalCuestionario b
				on a.PCid = b.PCid
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and PCtipo in (0,30)
	
	
</cfquery>
<!--- registros existentes
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select upper(rtrim(RHCcodigo)) as RHCcodigo
	from RHConocimientos
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
 --->
<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	<cfif modo neq 'ALTA'>
	//carga el mantenimiento del detalle
	function fnCargaDetalle(RHICid, RHICdescripcion, RHICorden){
		objForm.RHICid.obj.value = RHICid;
		objForm.RHICdescripcion.obj.value = RHICdescripcion;
		objForm.RHICorden.obj.value = RHICorden;
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Modificar#</cfoutput>';
	}
	function Borrar(RHICid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.RHICid.obj.value=RHICid;
			deshabilitarValidacion();
			return true;
		}
		else
			return false;	
	}
	function fnDesCargaDetalle(){
		objForm.RHICid.obj.value = '';
		objForm.RHICdescripcion.obj.value = '';
		objForm.RHICorden.obj.value = '';
		objForm.btnDetalleUpd.obj.value='<cfoutput>#BTN_Agregar#</cfoutput>';
	}
	</cfif>
	//-->
</script>

<form name="form1" method="post" action="SQLPuestosConocimientos.cfm">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr><td colspan="2">&nbsp;</td></tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate>:&nbsp;</td>
      <td nowrap>
	  	<input name="RHCcodigo" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#Trim(rsForm.RHCcodigo)#</cfif>" size="10" maxlength="5" onfocus="javascript:this.select();" style="text-transform:uppercase;">
	  </td>
    </tr>
    <tr> 
      <td nowrap align="right"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate>:&nbsp;</td>
      <td nowrap><input name="RHCdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.RHCdescripcion#</cfif>" size="65" maxlength="100" onfocus="javascript:this.select();"></td>
    </tr>
	<tr>
		<td align="right" width="25%">&nbsp;</td>
		<td>
			<input type="checkbox" name="RHCinactivo" value="1" <cfif modo NEQ 'ALTA' and rsForm.RHCinactivo EQ 1>checked</cfif>>
			<cf_translate  key="LB_Inactivo">Inactivo</cf_translate>
		</td>
	</tr>
	<tr>
		<td nowrap align="right"><cf_translate key="LB_CuestionarioPredeterminado">Cuestionario Predeterminado</cf_translate>:&nbsp;</td>
		<td>
			<select id="PCid" name="PCid" tabindex="1">
				<option value="" <cfif modo neq 'ALTA'>selected</cfif>>--- <cf_translate key="CMB_NoEspecificado" XmlFile="/rh/generales.xml">No especificado</cf_translate> ---</option>
				<cfloop query="data">
					<option value="#data.PCid#" <cfif isdefined("rsForm") and rsForm.PCid EQ data.PCid>selected</cfif>>#HTMLEditFormat(data.PCcodigo)#-#HTMLEditFormat(data.PCnombre)#</option>
				</cfloop>
			</select>
		</td>
	</tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr>
		<td nowrap colspan="2" align="center">
			<cfset tabindex=1>
			<cf_botones modo="#modo#">
		</td>
	</tr>
	<cfif modo neq 'ALTA'>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr align="center"> 
    <td colspan="2" align="center">
	<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
		<tr>
			<td>
				<fieldset><legend><cf_translate key="LB_Items">Items</cf_translate></legend>
					<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
						<tr bgcolor="FAFAFA"> 
							<td nowrap>&nbsp;</td>
							<td nowrap><b><cf_translate key="LB_Orden">Orden</cf_translate></b></td>
							<td nowrap><b><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></b></td>
							<td nowrap align="right">
								<input type="submit" name="btnDetalleUpd" tabindex="1" value="#BTN_Agregar#" onclick="javascript: habilitarValidacionDet();">
								<input type="button" name="btnDesCargaDetalle" tabindex="1" value="#BTN_Limpiar#" onclick="javascript: fnDesCargaDetalle(); return false;">
								<input type="hidden" name="RHICid" value="">
								<input type="hidden" name="borrarDetalle" value="">
							</td>
						</tr>
						<tr bgcolor="FAFAFA"> 
							<td nowrap>&nbsp;</td>
							<td nowrap><input name="RHICorden" type="text" tabindex="1" size="5" maxlength="3" onkeypress="return acceptNum(event)" onfocus="javascript:this.select();" value="#nextOrden#"></td>
							<td nowrap colspan="2"><input name="RHICdescripcion" type="text" tabindex="1" size="60" maxlength="255" onfocus="javascript:this.select();"></td>
							
						</tr>
						<cfloop query="rsDet"> 
							<tr <cfif CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
								<td nowrap>&nbsp;</td>
								<td nowrap><a href="javascript: fnCargaDetalle('#RHICid#', '#RHICdescripcion#', '#RHICorden#');">#RHICorden#</a></td>
								<td nowrap colspan="2"><a href="javascript: fnCargaDetalle('#RHICid#', '#RHICdescripcion#', '#RHICorden#');">#RHICdescripcionshort#</a></td>
								<td nowrap>
									<input  name="btnBorrar#RHICid#" type="image" tabindex="-1" alt="#LB_EliminarElemento#" onclick="javascript: return Borrar('#RHICid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
									<input name="btnEditar#RHICid#" type="image" tabindex="-1" alt="#LB_EditarElemento#" onclick="javascript: fnCargaDetalle('#RHICid#', '#RHICdescripcion#', '#RHICorden#'); return false;" src="/cfmx/rh/imagenes/edit_o.gif" width="16" height="16">
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
	
	<tr align="center"> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>

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
			<input type="hidden" name="RHCid" value="#form.RHCid#">
		</td>
	</tr>
	</cfif>
  </table>  
  </cfoutput>
</form>
	
<script language="JavaScript1.2" type="text/javascript">

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	<!--- 
	function _Field_CodigoNoExiste(){
		<cfoutput query="rsCodigos">
			if (("#ucase(trim(RHCcodigo))#"==this.obj.value.toUpperCase())
			<cfif modo neq "ALTA">
			&&("#ucase(trim(rsForm.RHCcodigo))#"!=this.obj.value.toUpperCase())
			</cfif>
			)
				this.error = "<cfoutput>#MSG_ElCodigoDeConocimientoYaExisteDefinaUnoDistinto#</cfoutput>.";
		</cfoutput>
	}

	_addValidator("isCods", _Field_CodigoNoExiste); 
	
	--->

	objForm.RHCcodigo.required = true;
	objForm.RHCcodigo.description="<cfoutput>#MSG_Codigo#</cfoutput>";
	o<!--- bjForm.RHCcodigo.validateCods(); --->
	
	objForm.RHCdescripcion.required = true;
	objForm.RHCdescripcion.description="<cfoutput>#MSG_Descripcion#</cfoutput>";

	function deshabilitarValidacion(){
		objForm.RHCcodigo.required = false;
		objForm.RHCdescripcion.required = false;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}

	function habilitarValidacion(){
		objForm.RHCcodigo.required = true;
		objForm.RHCdescripcion.required = true;
		<cfif modo neq 'ALTA'>
			deshabilitarValidacionDet();
		</cfif>
	}
	
	<cfif modo neq 'ALTA'>
		//objForm.RHDCGcodigo.required = true;
		objForm.RHICorden.description="<cfoutput>#MSG_OrdenDelItem#</cfoutput>";
		
		//objForm.RHDCGdescripcion.required = true;
		objForm.RHICdescripcion.description="<cfoutput>#MSG_DescripcionDeItem#</cfoutput>";

		function deshabilitarValidacionDet(){
			objForm.RHICorden.required = false;
			objForm.RHICdescripcion.required = false;
		}
	
		function habilitarValidacionDet(){
			objForm.RHICorden.required = true;
			objForm.RHICdescripcion.required = true;
		}

		objForm.RHICdescripcion.obj.focus();
	<cfelse>
		objForm.RHCcodigo.obj.focus();
	</cfif>

</script>