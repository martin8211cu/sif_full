<cfif isdefined("url.CAMBIO") and not isdefined("form.CAMBIO")>
	<cfset form.CAMBIO = url.CAMBIO >
</cfif>

<cfif isdefined("url.AFMid") and not isdefined("form.AFMid")>
	<cfset form.AFMid = url.AFMid >
</cfif>

<cfif isdefined("url.fAFMcodigo") and not isdefined("form.fAFMcodigo")>
	<cfset form.fAFMcodigo = url.fAFMcodigo >
</cfif>

<cfif isdefined("url.fAFMdescripcion") and not isdefined("form.fAFMdescripcion")>
	<cfset form.fAFMdescripcion = url.fAFMdescripcion >
</cfif>

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
		Select AFMid,
				AFMcodigo,
				AFMdescripcion,
				AFMuso,
				afm.ts_rversion
		from AFMarcas afm,
			Empresas e
		where afm.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and AFMid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AFMid#">
			and afm.Ecodigo=e.Ecodigo
	</cfquery>
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigos" datasource="#session.DSN#">
	select  Upper(AFMcodigo) as AFMcodigo
	from AFMarcas 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset filtro = ''>
<cfset navegacion = ''>
<cfset colAdicionales = ''>
<cfif isdefined("form.fAFMcodigo") and len(trim(form.fAFMcodigo)) >
	<cfset filtro = " and upper(afm.AFMcodigo) like '%#Ucase(form.fAFMcodigo)#%' ">
	<cfset navegacion = '&fAFMcodigo=#form.fAFMcodigo#'>
	<cfset colAdicionales = ", '#form.fAFMcodigo#' as fAFMcodigo">
</cfif>

<cfif isdefined("form.fAFMdescripcion") and len(trim(form.fAFMdescripcion)) >
	<cfset filtro = filtro & " and upper(afm.AFMdescripcion) like '%#Ucase(form.fAFMdescripcion)#%' ">
	<cfset navegacion = navegacion & '&fAFMdescripcion=#form.fAFMdescripcion#'>
	<cfset colAdicionales = colAdicionales & ", '#form.fAFMdescripcion#' as fAFMdescripcion">
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td width="50%" valign="top">
			<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
				tabla="AFMarcas afm,Empresas e"
				columnas="AFMid,AFMcodigo,AFMdescripcion #colAdicionales#"
				desplegar="AFMcodigo,AFMdescripcion"
				etiquetas="Código,Descripción"
				formatos="S,S"
				formName="ListaMarcas"
				filtro="afm.Ecodigo=#session.Ecodigo# and afm.Ecodigo=e.Ecodigo #filtro# Order By AFMcodigo"
				align="left,left"
				checkboxes="N"
				keys="AFMid"
				ira="MarcasMod.cfm"
				MaxRows="4"
				filtrar_automatico="true"
				mostrar_filtro="true"
				filtrar_por="AFMcodigo, AFMdescripcion"
				navegacion="#navegacion#"
				showEmptyListMsg="true"
				PageIndex="1">
		</td>
		<td width="50%" valign="top">
			<form name="form1" id="form1" method="post" action="SQLMarcas.cfm">
				<cfoutput>
					<cfif modo NEQ 'ALTA'>
						<cfset ts = "">	
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="ts">
								<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
							</cfinvoke>					
						<input type="hidden" name="ts_rversion" value="#ts#">
						<input type="hidden" name="AFMid" value="#rsForm.AFMid#">			
					</cfif>
			
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr> 
						  <td colspan="2" align="center" class="subTitulo">
								<cfif (MODO neq "ALTA")>
									Cambio de Marca #rsForm.AFMcodigo# - #rsForm.AFMdescripcion#
								<cfelse>
									Registro de Nueva Marca
								</cfif>
							</td>
						</tr>
						<tr> 
						  <td><div align="right">C&oacute;digo:&nbsp;</div></td>
						  <td>
							<input name="AFMcodigo" type="text"
								value="<cfif modo neq 'ALTA'>#Trim(rsForm.AFMcodigo)#</cfif>" tabindex="1" size="10" maxlength="10"onFocus="javascript:this.select();">							
						  </td>
							<cfif modo eq "CAMBIO">
								<td>
									<input type="hidden" name="AFMcodigoL" id="AFMcodigoL" tabindex="1"
									value="#trim(rsForm.AFMcodigo)#"></td>			
							</cfif>									  
						</tr>
						<tr> 
						  <td><div align="right">Descripci&oacute;n:&nbsp;</div></td>
						  <td><input name="AFMdescripcion" id="AFMdescripcion" type="text" tabindex="1" value="<cfif modo neq 'ALTA'>#rsForm.AFMdescripcion#</cfif>" size="40" maxlength="80" onFocus="javascript:this.select();" ></td>
						</tr>
						
						<tr>
						  <td align="right">Para uso en:&nbsp;</td>
						  <td><select name="AFMuso" tabindex="1">
                                <option value="F" <cfif modo neq "ALTA" and rsForm.AFMuso EQ 'F'> selected</cfif>>Activos Fijos</option>
                                <option value="I" <cfif modo neq "ALTA" and rsForm.AFMuso EQ 'I'> selected</cfif>>Inventarios</option>
								<option value="A" <cfif modo neq "ALTA" and rsForm.AFMuso EQ 'A'> selected</cfif>>Ambos</option>
                              </select></td>
					  </tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td colspan="2" align="center">
								<!--- <cfinclude template="/sif/portlets/pBotones.cfm">	 --->
								<cf_botones modo="#modo#" tabindex="1">
							</td>
						</tr>
						
						<cfset ts = "">	
						<cfif modo neq "ALTA">
							<cfinvoke 
								component="sif.Componentes.DButils"
								method="toTimeStamp"
								returnvariable="ts">
								<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
							</cfinvoke>
						</cfif>
					</table>  

					<!--- Campos ocultos para mantener el filtro (si existe)--->
					<cfif isdefined("form.fAFMcodigo") and len(trim(form.fAFMcodigo))>
						<input type="hidden" name="fAFMcodigo" value="#trim(form.fAFMcodigo)#">
					</cfif>
					<cfif isdefined("form.fAFMdescripcion") and len(trim(form.fAFMdescripcion))>
						<input type="hidden" name="fAFMdescripcion" value="#trim(form.fAFMdescripcion)#">
					</cfif>
					
					<input type="hidden" name="Pagina1"
						value="
							<cfif isdefined("form.pagenum1") and form.pagenum1 NEQ "">
								#form.pagenum1#
							<cfelseif isdefined("url.PageNum_lista1") and url.PageNum_lista1 NEQ "">
								#url.PageNum_lista1#
							</cfif>">
				</cfoutput>

			</form>
		</td>
	</tr>
	<cfif modo NEQ 'ALTA'>
			<tr>
				<td colspan="2" valign="top">
					<table width="100%">
						<tr><td valign="top">
							<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Modelos">
								<cfinclude template="formModelos.cfm">	
							<cf_web_portlet_end>
						</td></tr>
					</table>
				</td>
			</tr>		
	</cfif>
</table>

<cfif modo EQ 'ALTA'>
	<cf_qforms objForm="objForm" form="form1">
	<cfoutput>
	<script language="JavaScript1.2" type="text/javascript">
		//1. Definir las descripciones de los objetos
		objForm.AFMcodigo.description = "#JSStringFormat('Código')#";
		objForm.AFMdescripcion.description = "#JSStringFormat('Descripción')#";
	
		//2. Definir la función de validacion
		function habilitarValidacion(){
			objForm.AFMcodigo.required="true";
			objForm.AFMdescripcion.required="true";
		}
		
		//3. Definir la función de desabilitar la validacion
		function deshabilitarValidacion(){
			objForm.AFMcodigo.required="false";
			objForm.AFMdescripcion.required="false";
		} 
	
		function funcNuevo() {
			document.form1.AFMdescripcion.value=".";
		}

		function funcBaja() {
			funcNuevo();
		}
	
		<cfif (modo neq "CAMBIO")>
			objForm.AFMcodigo.obj.focus();
		</cfif>
	</script>
	</cfoutput>
</cfif>