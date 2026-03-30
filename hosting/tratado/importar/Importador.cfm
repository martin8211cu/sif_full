<cf_template template="#session.sitio.template#">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Importador"
	Default="Importador"
	returnvariable="LB_Importador"/>
	<cf_templatearea name="title">
		 <cfoutput>#LB_Importador#</cfoutput>
      &nbsp;
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td valign="top">
		<cfif IsDefined("form.btnExportar")>
		  <cflocation url="Exportar.cfm">
		</cfif><cfif IsDefined("form.btnImportar")>
		  <cflocation url="Importar.cfm">
		</cfif>	
		<script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>	<script src="/cfmx/sif/js/qForms/qforms.js"></script>
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Importador">
	 
	
			<cfif isdefined("url.EIid") and not isdefined("form.EIid")>
				<cfset form.EIid = url.EIid >
			</cfif>

			<cfif isdefined("url.modo") and not isdefined("form.modo")>
				<cfset form.modo = url.modo >
			</cfif>

			<!--- ==================================================== --->
			<!-- Establecimiento del modo -->
			<cfif isdefined("form.Cambio")>
				<cfset modo="CAMBIO">
			<cfelse>
				<cfif not isdefined("form.modo")>
					<cfset modo="ALTA">
				<cfelseif form.modo EQ "CAMBIO">
					<cfset modo="CAMBIO">
				<cfelse>
					<cfset modo="ALTA">
				</cfif>
			</cfif>
			<cfif isdefined('Form.btnNuevo')>
					<cfset modo="ALTA">
			</cfif>
			<cfif isdefined("form.EIid") AND Len(form.EIid)>
					<cfset modo="CAMBIO">
			</cfif>
		
			<!-- modo para el detalle -->
			<cfif isdefined("form.DInumero")>
				<cfset dmodo="CAMBIO">
			<cfelse>
				<cfif not isdefined("form.DInumero")>
					<cfset dmodo="ALTA">
				<cfelseif form.dmodo EQ "CAMBIO">
					<cfset dmodo="CAMBIO">
				<cfelse>
					<cfset dmodo="ALTA">
				</cfif>
			</cfif>

			<!--- ==================================================== --->

			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td>
						<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="#DFDFDF">
						  <tr align="left"> 
							<td width="100%"><a href="/cfmx/hosting/tratado/importar/ListaImportador.cfm">
							<cf_translate  key="LB_ListaDeImportaciones">Lista de Importaciones</cf_translate>
							</a></td>
						  </tr>
						</table>
					</td>
				</tr>

				<form style="margin-top:0;" name="form1" method="post" action="SQLImportador.cfm" onSubmit="return validar();">
				<tr>
					<td><cfinclude template="formEImportador.cfm"></td>
				</tr>
				
				<cfif modo neq 'ALTA'>
					<tr><td class="tituloAlterno"><cf_translate  key="LB_DetalleDeFormato">Detalle de Formato</cf_translate></td></tr>
					<tr>
						<td align="center"><cfinclude template="formDImportador.cfm"></td>
					</tr>
				</cfif>	

				<tr><td>&nbsp;</td></tr>
				
				<!--- ================================================================================= --->
				<!-- Caso 1: Alta de Encabezados -->
				<cfif modo EQ 'ALTA'>
					<tr>
						<td align="center" valign="baseline" >
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Agregar"
							Default="Agregar"
							returnvariable="BTN_Agregar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							returnvariable="BTN_Limpiar"/>
							
							
							<input type="submit" name="AltaE" value="<cfoutput>#BTN_Agregar#</cfoutput>" onClick="javascript: document.form1.regenerar.value = 1;" >
							<input type="reset"  name="Limpiar"  value="<cfoutput>#BTN_Limpiar#</cfoutput>" >
						</td>	
					</tr>
				</cfif>
				
				<!-- Caso 2: Cambio de Encabezados / Alta de detalles -->		
				<cfif modo NEQ 'ALTA' and dmodo EQ 'ALTA' >
					<tr>
						<td align="center" valign="baseline" >
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_AgregarDetalle"
							Default="Agregar Detalle"
							returnvariable="BTN_AgregarDetalle"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_ModificarEncabezado"
							Default="Modificar Encabezado"
							returnvariable="BTN_ModificarEncabezado"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_BorrarImportacion"
							Default="Borrar Importaci&oacute;n"
							returnvariable="BTN_BorrarImportacion"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_EmpresasPorFormato"
							Default="Empresas por Formato"
							returnvariable="BTN_EmpresasPorFormato"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							returnvariable="BTN_Limpiar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_DeseaEliminarEstaImportacionYSusDetalles"
							Default="Desea eliminar esta Importación y sus detalles"
							returnvariable="MSG_DeseaEliminarEstaImportacionYSusDetalles"/>
							
							<input type="submit" name="AltaD"   value="<cfoutput>#BTN_AgregarDetalle#</cfoutput>" onClick="javascript: regenera();">
							<input type="submit" name="CambioE" value="<cfoutput>#BTN_ModificarEncabezado#</cfoutput>" onClick="javascript:deshabilitarValidacion();" >
							<input type="submit" name="BajaE"   value="<cfoutput>#BTN_BorrarImportacion#</cfoutput>" onClick="javascript: if ( confirm('<cfoutput>#MSG_DeseaEliminarEstaImportacionYSusDetalles#</cfoutput>?') ){ deshabilitarValidacion(this); return true; }else{return false;}" >
							<input type="reset"  name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" >
							<input type="submit" name="AltaEmpresas"   value="<cfoutput>#BTN_EmpresasPorFormato#</cfoutput>" onClick="javascript: deshabilitarValidacion(); AsociarEmpresas();">
						</td>	
					</tr>
				</cfif>
				
				<!-- Caso 3: Cambio de Encabezados / Cambio de detalle -->		
				<cfif modo NEQ 'ALTA' and dmodo NEQ 'ALTA' >
					<tr>
						<td align="center" valign="baseline" >
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Modificar"
							Default="Modificar"
							returnvariable="BTN_Modificar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_BorrarImportacion"
							Default="Borrar Importaci&oacute;n"
							returnvariable="BTN_BorrarImportacion"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_NuevoDetalle"
							Default="Nuevo Detalle"
							returnvariable="BTN_NuevoDetalle"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_EmpresasPorFormato"
							Default="Empresas por Formato"
							returnvariable="BTN_EmpresasPorFormato"/>
							
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="BTN_Limpiar"
							Default="Limpiar"
							returnvariable="BTN_Limpiar"/>
							
							<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="MSG_DeseaEliminarEsteDetalleDeImportacion"
							Default="Desea eliminar este detalle de Importación"
							returnvariable="MSG_DeseaEliminarEsteDetalleDeImportacion"/>
							
							
							<input type="submit" name="CambioD" value="<cfoutput>#BTN_Modificar#</cfoutput>" onClick="javascript: regenera();">
							<input type="submit" name="BajaE"   value="<cfoutput>#BTN_BorrarImportacion#</cfoutput>" onClick="javascript: if ( confirm('<cfoutput>#MSG_DeseaEliminarEsteDetalleDeImportacion#</cfoutput>?') ){ deshabilitarValidacion(this); return true; }else{return false;}" >
							<input type="submit" name="NuevoD"  value="<cfoutput>#BTN_NuevoDetalle#</cfoutput>" onClick="javascript: deshabilitarValidacion(this);" >
							<input type="reset"  name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" >	
							<input type="submit" name="AltaEmpresas"   value="<cfoutput>#BTN_EmpresasPorFormato#</cfoutput>" onClick="javascript: deshabilitarValidacion(); AsociarEmpresas();">
			
						</td>	
					</tr>
				</cfif>
				<!--- ================================================================================= --->
				
					<!--- 0 no regenera, 1 regenera --->
					<input name="regenerar" type="hidden" value="0">
				</form>

				
				<tr><td>&nbsp;</td></tr>

				<cfif modo neq 'ALTA'>
				<tr>
				<td>
				<cfset navegacion = "EIid=#form.EIid#&modo=#modo#" >

				<cfquery datasource="sifcontrol" name="lista_det">
				 select EIid, DInumero, DInombre, DIdescripcion,DItipo, DIlongitud,
				 
				 {fn concat(
				 {fn concat(
				 	'<a href=''javascript:borrar(' 
					,
						<cf_dbfunction name="to_char" datasource="sifcontrol" args="DInumero"> 
					)}
					,
						')''><img src=''../imagenes/Borrar01_S.gif'' border=''0''></a>'
					)}
					as EIborrar, 'Borrar' as BajaD
				from DImportador where EIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIid#">
				order by DInumero
				</cfquery>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Numero"
				Default="Numero"
				returnvariable="LB_Numero"/> 
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Nombre"
				Default="Nombre"
				returnvariable="LB_Nombre"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripción"
				returnvariable="LB_Descripcion"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo"
				Default="Tipo"
				returnvariable="LB_Tipo"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Longitud"
				Default="Longitud"
				returnvariable="LB_Longitud"/>
				
				
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery" debug="N"
					query="#lista_det#"
					returnvariable="pListaRet"
					desplegar="DInumero, DInombre, DIdescripcion, DItipo, DIlongitud, EIborrar"
					etiquetas="#LB_Numero#,#LB_Nombre#,#LB_Descripcion#,#LB_Tipo#, #LB_Longitud#,&nbsp;"
					formatos="V,V,V,V,I,V" 
					align="left,left,left,left,left,center"
					ajustar="N"
					Nuevo="Importador.cfm"
					irA="Importador.cfm"
					showEmptyListMsg="true"
					keys="EIid,DInumero"
					MaxRows="30"
					navegacion="#navegacion#">
				</cfinvoke>
				</td>
				</tr>
				</cfif>
			</table>
			
			<script language="javascript1.2" type="text/javascript">
				<!--//
				// specify the path where the "/qforms/" subfolder is located
				qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
				// loads all default libraries
				qFormAPI.include("*");
				//-->
				
				qFormAPI.errorColor = "#FFFFCC";
				objForm = new qForm("form1");

				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Codigo"
				Default="Código"
				returnvariable="LB_Codigo"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Modulo"
				Default="Módulo"
				returnvariable="LB_Modulo"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Descripcion"
				Default="Descripción"
				returnvariable="LB_Descripcion"/>
				
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Delimitador"
				Default="Delimitador"
				returnvariable="LB_Delimitador"/>
				
				// Validaciones del Encabezado	
				objForm.EIcodigo.required 	 	  = true;
				objForm.EIcodigo.description 	  = "<cfoutput>#LB_Codigo#</cfoutput>";
				objForm.EImodulo.required 	 	  = true;
				objForm.EImodulo.description 	  = "<cfoutput>#LB_Modulo#</cfoutput>";
				objForm.EIdescripcion.required    = true;
				objForm.EIdescripcion.description = "<cfoutput>#LB_Descripcion#</cfoutput>";
				objForm.EIdelimitador.required 	  = true;
				objForm.EIdelimitador.description = "<cfoutput>#LB_Delimitador#</cfoutput>";

				// Validaciones del Detalle	
				<cfif modo neq 'ALTA'>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Numero"
					Default="Número"
					returnvariable="LB_Numero"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Nombre"
					Default="Nombre"
					returnvariable="LB_Nombre"/>
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Descripcion"
					Default="Descripción"
					returnvariable="LB_Descripcion"/>	
					
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_Tipo"
					Default="Tipo"
					returnvariable="LB_Tipo"/>				
					
					
					objForm.DInumero.required 	 	  = true;
					objForm.DInumero.description 	  = "<cfoutput>#LB_Numero#</cfoutput>";
					objForm.DInombre.required 	 	  = true;
					objForm.DInombre.description 	  = "<cfoutput>#LB_Nombre#</cfoutput>";
					objForm.DIdescripcion.required    = true;
					objForm.DIdescripcion.description = "<cfoutput>#LB_Descripcion#</cfoutput>";
					objForm.DItipo.required 	  	  = true;
					objForm.DItipo.description 		  = "<cfoutput>#LB_Tipo#</cfoutput>";
					objForm.DIlongitud.required  	  = true;
					objForm.DIlongitud.description	  = "<cfoutput>#LB_Tipo#</cfoutput>";
				</cfif>
				
				function deshabilitarValidacion(){
					qFormAPI.errorColor = "#FFFFFF";
					
					objForm._allowSubmitOnError = true;
					objForm._showAlerts = false;

					return true;
				}
				
				function validar(){
					// llama a la funcion validaDetalle(), definida en formDImportador
					validaEncabezado(false);

					<cfif modo neq 'ALTA'>
						validaDetalle(false);
						nombre(objForm.DInombre.obj)
					</cfif>	

					return true;
				}
				
				function borrar(value){
					if ( confirm('Desea eliminar el registro?') ){
						document.lista.DINUMERO.value = value;
						document.lista.action = 'SQLImportador.cfm';
						document.lista.submit();
					}
				}
				
				function regenera(){
					if ( document.form1.EIexporta.checked && (document.form1.hEIsqlexp.value != document.form1.EIsqlexp.value ) && trim(document.form1.EIsqlexp.value) != '' ){
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_DeseaRegenerarLasColumnasParaExportacion"
						Default="Desea regenerar las columnas para exportacion"
						returnvariable="LB_DeseaRegenerarLasColumnasParaExportacion"/>	
						
						if ( confirm('<cfoutput>#LB_DeseaRegenerarLasColumnasParaExportacion#</cfoutput>?') ){ 
							document.form1.regenerar.value = 1; 
						}
						else{ 
							document.form1.regenerar.value = 0; 
						}
					}	
					
					return false;
				}

				function _customValidations(){
					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					Key="LB_DebeSeleccionarLaOperacionARealizar"
					Default="Debe seleccionar la operación a realizar"
					returnvariable="LB_DebeSeleccionarLaOperacionARealizar"/>
					
					
					if (!document.form1.EIimporta.checked && !document.form1.EIexporta.checked){
						objForm.EIimporta.throwError("<cfoutput>#LB_DebeSeleccionarLaOperacionARealizar#</cfoutput>.");
					}
				}
				objForm.onValidate = _customValidations;
				
				function AsociarEmpresas(){
					document.form1.action="IMP_EmpresasXFormato.cfm";
					document.form1.submit();
				}
				

				// funcion definida en formDImportador					
				<cfif modo neq 'ALTA'>
					//vtipo(objForm.DItipo.getValue());
					combo();
				</cfif>	

			</script>

		
		<cf_web_portlet_end>
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template>