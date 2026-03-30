<!-- modo para el encabezado -->
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

<!-- modo para el detalle -->
<cfif isdefined("form.DCEid") and  len(trim(form.DCEid)) gt 0 >
	<cfset dmodo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.DCEid")>
		<cfset dmodo="ALTA">
	<cfelseif form.dmodo EQ "CAMBIO">
		<cfset dmodo="CAMBIO">
	<cfelse>
		<cfset dmodo="ALTA">
	</cfif>
</cfif>

<cfquery name="rsECEcodigo" datasource="#Session.DSN#">
	select 	ltrim(rtrim(ECEcodigo)) as ECEcodigo
	from EConceptosExpediente
	where CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
	<cfif modo NEQ 'ALTA' and isdefined('Form.ECEid') and Len(Trim(Form.ECEid))>
	and ECEid <> <cfqueryparam value="#Form.ECEid#" cfsqltype="cf_sql_numeric">
	</cfif>		
</cfquery>

<cfif isdefined('Form.ECEid') and Len(Trim(Form.ECEid))>
	<cfquery name="rsForm" datasource="#Session.DSN#">
		select 	ECEid,
				ltrim(rtrim(ECEcodigo)) as ECEcodigo,
				ECEdescripcion,
				ECEmultiple,
				ECEfecha,
				ts_rversion
		from EConceptosExpediente
		where ECEid = <cfqueryparam value="#Form.ECEid#" cfsqltype="cf_sql_numeric">
		and CEcodigo = <cfqueryparam value="#Session.CEcodigo#" cfsqltype="cf_sql_numeric">
	</cfquery>

	<cfquery name="rsDCEcodigo" datasource="#Session.DSN#">
		Select 	ltrim(rtrim(DCEcodigo)) as DCEcodigo
		from DConceptosExpediente dce 
			left outer join EConceptosExpediente ece
				on dce.ECEid = ece.ECEid
		where dce.ECEid = <cfqueryparam value="#Form.ECEid#" cfsqltype="cf_sql_numeric">
		and ece.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		<cfif dmodo NEQ 'ALTA' and isdefined('Form.ECEid') and Len(Trim(Form.ECEid))>
			and dce.DCEid <> <cfqueryparam value="#Form.DCEid#" cfsqltype="cf_sql_numeric">
		</cfif>
	</cfquery>
	
</cfif>	

<cfif isdefined("Form.DCEid") and Form.DCEid NEQ "" and isdefined("Form.ECEid") and Form.ECEid NEQ "">	
	<cfquery name="rsFormD" datasource="#Session.DSN#">
		select dce.DCEid,
			dce.ECEid,
			DCEcuantifica,
			DCEanotacion,
			ltrim(rtrim(DCEcodigo)) as DCEcodigo,
			DCEvalor,
			DCEfecha,
			dce.ts_rversion
		from DConceptosExpediente dce
		 	 inner join	EConceptosExpediente ece
			 	on dce.ECEid = ece.ECEid
		where dce.ECEid = <cfqueryparam value="#Form.ECEid#" cfsqltype="cf_sql_numeric">
		and dce.DCEid = <cfqueryparam value="#Form.DCEid#" cfsqltype="cf_sql_numeric">
		and ece.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
</cfif>

<form name="formConceptosExp" method="post" action="Conceptos-sql.cfm" onSubmit="javascript: return valida(this);">
	<cfoutput>
		<cfif modo NEQ 'ALTA'>
			<input name="ECEid" type="hidden" value="#rsForm.ECEid#">
			<cfset ts = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsForm.ts_rversion#" returnvariable="ts"></cfinvoke>
			<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">				
		</cfif>
		<cfif dmodo NEQ 'ALTA'>
			<input name="DCEid" type="hidden" value="#rsFormD.DCEid#">	
			<cfset tsD = "">
			<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsFormD.ts_rversion#" returnvariable="tsD"></cfinvoke>
			<input type="hidden" name="timestampD" value="<cfif dmodo NEQ "ALTA"><cfoutput>#tsD#</cfoutput></cfif>">				
		</cfif>

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr><td align="center" class="tituloAlterno"><cf_translate key="LB_TituloEncab">Encabezado de Conceptos de Expediente</cf_translate></td></tr>
		  <tr><td>&nbsp;</td></tr>		  		
		  <tr>
		    <td align="center">
				<table width="90%" border="0" cellpadding="3" cellspacing="0">
				  <tr>
					<td nowrap><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
					<td nowrap><strong><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate></strong></td>
					<td nowrap><strong><cf_translate key="LB_Descripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				    <td nowrap><strong><cf_translate key="LB_Multiple">M&uacute;ltiple</cf_translate></strong></td>
				  </tr>
				  <tr>
					<td nowrap>
						<input name="ECEcodigo" type="text" id="ECEcodigo" size="10" maxlength="10" tabindex="1"
							value="<cfif modo NEQ 'ALTA' and isdefined('rsForm') and rsForm.recordCount GT 0>#rsForm.ECEcodigo#</cfif>">
					</td>
					<td nowrap>
						<cfif MODO EQ "ALTA">
							<cf_sifcalendario form="formConceptosExp" name="ECEfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
						<cfelse>
							<cfoutput>
								<cf_sifcalendario form="formConceptosExp" name="ECEfecha" value="#LSDateFormat(rsForm.ECEfecha,'dd/mm/yyyy')#" tabindex="1">
							</cfoutput>
						</cfif>		
					</td>
					<td nowrap><input name="ECEdescripcion" type="text" id="ECEdescripcion2" tabindex="1" size="80" maxlength="80" value="<cfif modo NEQ 'ALTA' and isdefined('rsForm') and rsForm.recordCount GT 0>#rsForm.ECEdescripcion#</cfif>"></td>
				    <td nowrap><input name="ECEmultiple" type="checkbox" tabindex="1" id="ECEmultiple2" value="checkbox"
							<cfif modo NEQ 'ALTA' and isdefined('rsForm') and rsForm.ECEmultiple EQ 1>
								checked
							</cfif>></td>
				  </tr>
				  <tr>
					<td colspan="4">&nbsp;</td>
				  </tr>	
				</table>
			</td>
	      </tr>
		  <cfif isdefined('modo') and modo neq 'ALTA'>
			  <tr>
				<td align="center" class="tituloAlterno"><cf_translate key="LB_DetalleDeConceptosDeExpediente">Detalle de Conceptos de Expediente</cf_translate></td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>		  					  
			  <tr>
				<td align="center">
 					<table width="90%" border="0" cellpadding="2" cellspacing="0">		  
					  <tr>
						<td nowrap><strong><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></strong></td>
						<td nowrap><strong><cf_translate key="LB_Fecha" XmlFile="/rh/generales.xml">Fecha</cf_translate></strong></td>
						<td nowrap><strong><cf_translate key="LB_Valor" XmlFile="/rh/generales.xml">Valor</cf_translate></strong></td>
						<td nowrap><strong><cf_translate key="LB_Cuantifica">Cuantifica</cf_translate></strong></td>
						<td nowrap><strong><cf_translate key="LB_Anotacion">Anotaci&oacute;n</cf_translate></strong></td>
					  </tr>
					  <tr>
						<td nowrap><input name="DCEcodigo" type="text" id="DCEcodigo" tabindex="1" size="10" maxlength="10" value="<cfif dmodo NEQ 'ALTA' and isdefined('rsFormD') and rsFormD.recordCount GT 0>#rsFormD.DCEcodigo#</cfif>"></td>
						<td nowrap>
							<cfif dmodo EQ "ALTA">
								<cf_sifcalendario form="formConceptosExp" name="DCEfecha" value="#LSDateFormat(Now(),'DD/MM/YYYY')#" tabindex="1">
							<cfelse>
								<cfoutput>
									<cf_sifcalendario form="formConceptosExp" name="DCEfecha" value="#LSDateFormat(rsFormD.DCEfecha,'dd/mm/yyyy')#" tabindex="1">
								</cfoutput>
							</cfif>		
						</td>
						<td nowrap><input name="DCEvalor" type="text" id="DCEvalor2" tabindex="1" size="80" maxlength="80" value="<cfif dmodo NEQ 'ALTA' and isdefined('rsFormD') and rsFormD.recordCount GT 0>#rsFormD.DCEvalor#</cfif>"></td>
						<td nowrap><input onclick="javascript: excluir_anot(this);" name="DCEcuantifica" type="checkbox" id="DCEcuantifica" value="C" tabindex="1" <cfif dmodo NEQ 'ALTA'><cfif isdefined('rsFormD') and rsFormD.DCEcuantifica EQ 1>checked</cfif></cfif> >
						
						</td>
						<td nowrap><input name="DCEanotacion" onclick="javascript: excluir_cuant(this);" type="checkbox" id="DCEanotacion" value="A" tabindex="1"
								<cfif dmodo NEQ 'ALTA' and isdefined('rsFormD') and rsFormD.DCEanotacion EQ 1>
									checked
								</cfif>>
						</td>
					  </tr>
					</table> 
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>			  			  
		  </cfif>
		  
		<!-- ============================================================================================================ -->
		<!--  											Botones													          -->
		<!-- ============================================================================================================ -->		

		<!-- Caso 1: Alta de Encabezados -->
			<cfif isdefined('modo') and modo EQ 'ALTA'>
			  <tr>
				<td align="center" valign="baseline">
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

					<input type="submit" name="btnAgregarE" class="btnGuardar" tabindex="1" value="#BTN_Agregar#" onClick="javascript: setBtn(this);" >
					<input type="reset"  name="btnLimpiar"  class="btnNormal" tabindex="1" value="#BTN_Limpiar#" >				
				</td>
			  </tr>		  
			</cfif>		  		  
		  
			<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->		
			<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
				<tr>
					<td align="center" valign="baseline" colspan="7">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Agregar"
						Default="Agregar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Agregar"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_EliminarConc"
						Default="Eliminar Concepto"
						returnvariable="BTN_EliminarConc"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarElConcepto"
						Default="Desea eliminar el Concepto? "
						returnvariable="MGS_DeseaEliminarElConcepto"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_NuevoConc"
						Default="Nuevo Concepto"
						returnvariable="BTN_NuevoConc"/>

						<input type="submit" name="btnAgregarD" tabindex="1" class="btnGuardar" value="#BTN_Agregar#" onClick="javascript: setBtn(this);" >
						<input type="submit" name="btnBorrarE" tabindex="1"  class="btnEliminar" value="#BTN_EliminarConc#" onClick="javascript: if (confirm('#MGS_DeseaEliminarElConcepto#')){ setBtn(this); deshabilitarValidacion(); return true; } else{ return false; } " >
						<input type="submit" name="btnNuevoE" tabindex="1"   class="btnNuevo" value="#BTN_NuevoConc#" onClick="javascript: setBtn(this); deshabilitarValidacion();" >
					</td>	
				</tr>
			</cfif>
	
			<!-- Caso 3: Cambio de Encabezados / Cambio de detalles -->		
			<cfif modo neq 'ALTA' and dmodo neq 'ALTA' >
				<tr>
					<td align="center" valign="baseline" colspan="6">
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Modificar"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_EliminarDet"
						Default="Eliminar Detalle"
						returnvariable="BTN_EliminarDet"/>
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarEsteDetalleDeConcepto"
						Default="Desea eliminar este detalle de concepto?"
						returnvariable="MGS_DeseaEliminarEsteDetalleDeConcepto"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_EliminarConc"
						Default="Eliminar Concepto"
						returnvariable="BTN_EliminarConc"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="MGS_DeseaEliminarElConcepto"
						Default="Desea eliminar el Concepto? "
						returnvariable="MGS_DeseaEliminarElConcepto"/>

						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_NuevoDet"
						Default="Nuevo Detalle"
						returnvariable="BTN_NuevoDet"/>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_NuevoConc"
						Default="Nuevo Concepto"
						returnvariable="BTN_NuevoConc"/>

						<input type="submit" name="btnCambiarD" class="btnGuardar" tabindex="1" value="#BTN_Modificar#" onClick="javascript: setBtn(this);" >
						<input type="submit" name="btnBorrarD"  class="btnEliminar" tabindex="1" value="#BTN_EliminarDet#" onClick="javascript: if (confirm('#MGS_DeseaEliminarEsteDetalleDeConcepto#')){ setBtn(this); deshabilitarValidacion(); return true; } else{ return false; } " >
						<input type="submit" name="btnBorrarE"  class="btnEliminar" tabindex="1" value="#BTN_EliminarConc#" onClick="javascript: if (confirm('#MGS_DeseaEliminarElConcepto#')){ setBtn(this); deshabilitarValidacion(); return true; } else{ return false; } " >
						<input type="submit" name="btnNuevoD"   class="btnNuevo" tabindex="1" value="#BTN_NuevoDet#" onClick="javascript: setBtn(this); deshabilitarValidacion();" >
						<input type="submit" name="btnNuevoE"   class="btnNuevo" tabindex="1" value="#BTN_NuevoConc#" onClick="javascript: setBtn(this); deshabilitarValidacion();" >
					</td>	
				</tr>
			</cfif>		  
			<tr>
			  <td align="center" valign="baseline" colspan="6">&nbsp;</td>
			</tr>
	  	</table>
	</cfoutput>		
</form>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>

 <cfif isdefined('modo') and modo neq 'ALTA'>	

	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Valor"
	Default="Valor"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Valor"/>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Fecha"/>

	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="DConceptosExpediente dce, EConceptosExpediente ece"/>
		<cfinvokeargument name="columnas" value="
													dce.DCEid,
													dce.ECEid,
													DCEcodigo,
													DCEvalor,
													DCEfecha						
		"/>
		<cfinvokeargument name="desplegar" value="DCEcodigo,DCEvalor,DCEfecha"/>
		<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Valor#, #LB_Fecha#"/>
		<cfinvokeargument name="formatos" value="V,V,D"/>
		<cfinvokeargument name="filtro" value="
												dce.ECEid = #Form.ECEid#
												and dce.ECEid = ece.ECEid						
												and ece.CEcodigo = #Session.CEcodigo#
												order by DCEvalor
		"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="irA" value="Conceptos.cfm"/>
		<cfinvokeargument name="Keys" value="ECEid,DCEid"/>
	</cfinvoke>
 </cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorElConcepto"
	Default="Error, el concepto"
	returnvariable="MSG_ErrorElConcepto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_YaExisteParaEstaCuentaEmpresarialFavorDigitarUnoDistinto"
	Default="ya existe para esta cuenta empresarial, favor digitar uno distinto"
	returnvariable="MSG_YaExisteParaEstaCuentaEmpresarialFavorDigitarUnoDistinto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_ErrorElDetalleDeConcepto"
	Default="Error, el detalle de concepto"
	returnvariable="MSG_ErrorElDetalleDeConcepto"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_YaExisteParaEsteConceptoFavorDigitarUnoDistinto"
	Default="ya existe para este concepto, favor digitar uno distinto"
	returnvariable="MSG_YaExisteParaEsteConceptoFavorDigitarUnoDistinto"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Descripcion"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Fecha"
	Default="Fecha"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Fecha"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Valor"
	Default="Valor"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Valor"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Codigo"
	Default="Código"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Codigo"/>
	

<script language="JavaScript1.2">document.formConceptosExp.ECEcodigo.focus();</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">
	botonActual = "";
//------------------------------------------------------------------------------------------							
	function setBtn(obj) {
		botonActual = obj.name;
	}
//------------------------------------------------------------------------------------------								
	function btnSelected(name, f) {
		return (botonActual == name)
	}
//------------------------------------------------------------------------------------------							
	// 	Para la validacion del detalle
	<cfif isdefined('modo') and modo neq 'ALTA'>
		arrDCEcodigo = new Array();
		
		//DCEcodigo por CEcodigo
		var cont = 0;
		<cfloop query="rsDCEcodigo">	
			cont++;	
			arrDCEcodigo[arrDCEcodigo.length] = '<cfoutput>#rsDCEcodigo.DCEcodigo#</cfoutput>';
		</cfloop>	
	</cfif>	
//------------------------------------------------------------------------------------------							
	arrECEcodigo = new Array();
	
	//DCEcodigo por CEcodigo
	var cont = 0;
	<cfloop query="rsECEcodigo">	
		cont++;	
		arrECEcodigo[arrECEcodigo.length] = '<cfoutput>#rsECEcodigo.ECEcodigo#</cfoutput>';
	</cfloop>
//------------------------------------------------------------------------------------------								
	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}
//------------------------------------------------------------------------------------------							
	function valida(form){
		<cfoutput>
		if(btnSelected('btnAgregarD',document.formConceptosExp) || btnSelected('btnCambiarD',document.formConceptosExp)){
			var existe = false;
			
			for(var i=0;i<arrECEcodigo.length;i++){
				if(arrECEcodigo[i] == trim(document.formConceptosExp.ECEcodigo.value)){
					existe = true;
				}
			}
			
			if(existe){
				alert("#MSG_ErrorElConcepto# " + document.formConceptosExp.ECEcodigo.value +  "#MSG_YaExisteParaEstaCuentaEmpresarialFavorDigitarUnoDistinto#");
				
				return false;
			}
			
			// 	Para la validacion del detalle
			<cfif isdefined('modo') and modo neq 'ALTA'>
				if(btnSelected('btnAgregarD',document.formConceptosExp) || btnSelected('btnCambiarD',document.formConceptosExp)){
					var existeD = false;
					
					for(var i=0;i<arrDCEcodigo.length;i++){
						if(arrDCEcodigo[i] == trim(document.formConceptosExp.DCEcodigo.value)){
							existeD = true;
						}
					}
					
					if(existeD){
						alert("#MSG_ErrorElDetalleDeConcepto# " + document.formConceptosExp.DCEcodigo.value + " #MSG_YaExisteParaEsteConceptoFavorDigitarUnoDistinto#");
						
						return false;
					}
				}		
			</cfif>			
		}
		
		return true;
		</cfoutput>
	}
//------------------------------------------------------------------------------------------								
	function deshabilitarValidacion(){
		objForm.ECEcodigo.required = false;
		objForm.ECEfecha.required= false;
		objForm.ECEdescripcion.required= false;	
		
		<cfif isdefined('modo') and modo neq 'ALTA'>
			objForm.DCEcodigo.required = false;
			objForm.DCEfecha.required= false;
			objForm.DCEvalor.required= false;
		</cfif>		
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.ECEcodigo.required = true;
		objForm.ECEfecha.required= true;
		objForm.ECEdescripcion.required= true;	
		
		<cfif isdefined('modo') and modo neq 'ALTA'>
			objForm.DCEcodigo.required = true;
			objForm.DCEfecha.required= true;
			objForm.DCEvalor.required= true;
		</cfif>		
	}	
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formConceptosExp");	
//------------------------------------------------------------------------------------------	
<cfoutput>
	objForm.ECEcodigo.required = true;
	objForm.ECEcodigo.description="#MSG_Codigo#";				
	objForm.ECEfecha.required= true;
	objForm.ECEfecha.description="#MSG_Fecha#";
	objForm.ECEdescripcion.required= true;
	objForm.ECEdescripcion.description="#MSG_Descripcion#";	
	
	<cfif isdefined('modo') and modo neq 'ALTA'>
		objForm.DCEcodigo.required = true;
		objForm.DCEcodigo.description="#MSG_Codigo#";				
		objForm.DCEfecha.required= true;
		objForm.DCEfecha.description="#MSG_Fecha#";
		objForm.DCEvalor.required= true;
		objForm.DCEvalor.description="#MSG_Valor#";	
 	</cfif>		
</cfoutput>
//------------------------------------------------------------------------------------------		


	function excluir_anot(obj){
		if (obj.checked){
			document.formConceptosExp.DCEanotacion.checked = false;
		}
	}
	
	function excluir_cuant(obj){
		if (obj.checked){
			document.formConceptosExp.DCEcuantifica.checked = false;
		}
	}

</script>