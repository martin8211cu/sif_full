<!-- Establecimiento del modoMod -->
<cfif not isdefined("Form.modoMod")>
	<cfset modoMod="ALTA">
<cfelseif form.modoMod EQ "CAMBIO">
	<cfset modoMod="CAMBIO">
<cfelse>
	<cfset modoMod="ALTA">
</cfif>

<!--- Consultas --->
<cfif modoMod neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsFormMod" datasource="#session.DSN#">
		Select 
				afmm.Ecodigo,
				AFMMid,
				AFMid,
				AFMMcodigo,
				AFMMdescripcion,
				afmm.ts_rversion
		from AFMModelos afmm,
			Empresas e
		where afmm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isDefined("form.AFMid") and len(trim(form.AFMid))>
				and AFMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMid#">
			</cfif>
			<cfif isDefined("form.AFMMid") and len(trim(form.AFMMid))>
				and AFMMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AFMMid#">
			</cfif>
			and afmm.Ecodigo=e.Ecodigo
	</cfquery>
</cfif> 

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top">
			<cfset navegacion2 = navegacion & "&CAMBIO=CAMBIO&AFMid=#form.AFMid#">
			<cfset filtro = "afmm.Ecodigo=#session.Ecodigo# and AFMid = #form.AFMid# and afmm.Ecodigo=e.Ecodigo">
						
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				tabla="AFMModelos afmm,	Empresas e"
				columnas="AFMMid, AFMid, AFMMcodigo, AFMMdescripcion,'CAMBIO' as CAMBIO, 'CAMBIO' as modoMod"
				desplegar="AFMMcodigo,AFMMdescripcion"
				etiquetas="Código,Descripción"
				formatos="V,V"
				filtro="#filtro# Order By AFMMcodigo"
				align="left,left"
				checkboxes="N"
				keys="AFMMid,AFMid"
				ira="MarcasMod.cfm"
				MaxRows="4"
 				filtrar_automatico="true"
				mostrar_filtro="true"
				filtrar_por="AFMMcodigo,AFMMdescripcion"
				navegacion="#navegacion2#"
				showEmptyListMsg="true"
				PageIndex="2">

				<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function funcFiltrar2() {
						document.lista.AFMID.value = "#form.AFMid#";
						return true;
					} 
				</script>
				</cfoutput>
		</td>
		<td width="50%" valign="top">
			<cfoutput>
			<form name="form2" id="form2" method="post" action="SQLModelos.cfm">
  					<cfif modoMod NEQ 'ALTA'>
						<cfset tsMod = "">	
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="tsMod">
								<cfinvokeargument name="arTimeStamp" value="#rsFormMod.ts_rversion#"/>
							</cfinvoke>					
						<input type="hidden" name="ts_rversion" value="#tsMod#">
						<input type="hidden" name="AFMMid" value="#rsFormMod.AFMMid#">			
					</cfif> 
					<input type="hidden" name="AFMid" value="#form.AFMid#">
					
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
						  <td colspan="2" align="center" class="subTitulo">
								<cfif (modoMod neq "ALTA")>
									Cambio de Modelo #rsFormMod.AFMMcodigo# - #rsFormMod.AFMMdescripcion#
								<cfelse>
									Registro de Nuevo Modelo
								</cfif>
							</td>
						</tr>
						<tr> 
						  <td><div align="right">C&oacute;digo:&nbsp;</div></td>
						  <td>
							<input name="AFMMcodigo" type="text" 
								value="<cfif modoMod neq 'ALTA'>#Trim(rsFormMod.AFMMcodigo)#</cfif>" tabindex="1" size="10" maxlength="10"onFocus="javascript:this.select();">
						  </td>
							<cfif modoMod eq "CAMBIO">
								<td>
									<input type="hidden" name="AFMMcodigoL" id="AFMMcodigoL" tabindex="1"
									value="#trim(rsFormMod.AFMMcodigo)#"></td>			
							</cfif>									  						  
						</tr> 
						<tr> 
						  <td><div align="right">Descripci&oacute;n:&nbsp;</div></td>
						  <td><input name="AFMMdescripcion" type="text" tabindex="1" value="<cfif modoMod neq 'ALTA'>#rsFormMod.AFMMdescripcion#</cfif>" size="40" maxlength="80" onFocus="javascript:this.select();"></td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="2" align="center">
								<input type="hidden" name="botonSel" value="" tabindex="-1">							
								<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1">
								<cf_botones modo="#modoMod#" tabindex="1">
							</td>
						</tr> 
						<tr><td>&nbsp;</td></tr>
					</table>  
				
				<!--- mantiene filtros del detalle --->
				<cfif isdefined("form.fAFMMcodigo") and len(trim(form.fAFMMcodigo))>
					<input type="hidden" name="fAFMMcodigo" value="#form.fAFMMcodigo#">
				</cfif>
				
				<!--- mantiene filtros del encabezado --->
				<cfif isdefined("form.fAFMMdescripcion") and len(trim(form.fAFMMdescripcion))>
					<input type="hidden" name="fAFMMdescripcion" value="#form.fAFMMdescripcion#">
				</cfif>

				<!--- mantiene filtros de encabezado --->
				<cfif isdefined("form.fAFMcodigo") and len(trim(form.fAFMcodigo))>
					<input type="hidden" name="fAFMcodigo" value="#form.fAFMcodigo#">
				</cfif>

				<!--- mantiene filtros de encabezado --->
				<cfif isdefined("form.fAFMdescripcion") and len(trim(form.fAFMdescripcion))>
					<input type="hidden" name="fAFMdescripcion" value="#form.fAFMdescripcion#">
				</cfif>

				<input type="hidden" name="Pagina2"
					value="
						<cfif isdefined("form.pagenum2") and form.pagenum2 NEQ "">
							#form.pagenum2#
						<cfelseif isdefined("url.PageNum_lista2") and url.PageNum_lista2 NEQ "">
							#url.PageNum_lista2#
						</cfif>">
			</form>
			</cfoutput>
		</td>
	</tr>
</table>

<cfoutput>
<cf_qforms objForm="objForm1" form="form1">
<cf_qforms objForm="objForm2" form="form2">
<script language="JavaScript1.2" type="text/javascript">
	//1. Definir las descripciones de los objetos
	objForm1.AFMcodigo.description = "#JSStringFormat('Código')#";
	objForm2.AFMMcodigo.description = "#JSStringFormat('Código')#";
	objForm1.AFMdescripcion.description = "#JSStringFormat('Descripción')#";
	objForm2.AFMMdescripcion.description = "#JSStringFormat('Descripción')#";
		
	//2. Definir la función de validacion
	function habilitarValidacion(){
		objForm1.AFMcodigo.required="true";
		objForm2.AFMMcodigo.required="true";
		objForm1.AFMdescripcion.required="true";		
		objForm2.AFMMdescripcion.required="true";
	}
	//3. Definir la función de desabilitar la validacion
	function deshabilitarValidacion(){
		objForm1.AFMcodigo.required="false";
		objForm2.AFMMcodigo.required="false";
		objForm1.AFMdescripcion.required="false";		
		objForm2.AFMMdescripcion.required="false";
	} 

	function funcNuevo() {
		document.form1.AFMcodigo.value=".";
		document.form2.AFMMcodigo.value=".";
		document.form1.AFMdescripcion.value=".";
		document.form2.AFMMdescripcion.value=".";
	}

	function funcBaja() {
		funcNuevo();
	}
	
	<cfif (modo neq "CAMBIO")>
		objForm1.AFMcodigo.obj.focus();
	</cfif>
	
	<cfif (modoMod neq "CAMBIO")>
		objForm2.AFMMcodigo.obj.focus();
	</cfif>
</script> 
</cfoutput>