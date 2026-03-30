<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfparam name="Form.RHOid" default="#Url.RHOid#">
</cfif>

<cfif isdefined("Url.RegCon") and not isdefined("Form.RegCon")>
	<cfparam name="Form.RegCon" default="#Url.RegCon#">
</cfif>

<cfif isdefined("Url.RCconcurso") and not isdefined("Form.RCconcurso")>
	<cfparam name="Form.RCconcurso" default="#Url.RCconcurso#">
</cfif>

<cfinclude template="../../capacitacion/expediente/educacion.cfm">

<!---
<!--- <cfif isdefined("Url.RHPOid") and not isdefined("Form.RHPOid")>
	<cfparam name="Form.RHPOid" default="#Url.RHPOid#">
</cfif> --->
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
<cfif modo EQ "CAMBIO" and isdefined('form.RHOid') and isdefined('form.RHPOid')> <!--- OJO con RHEOid --->
	<cfquery name="rsPreparacionOferentes" datasource="#Session.DSN#">
		select RHPOid, RHOid, GAcodigo, RHPOnombre, RHPOtitulo, RHPOaingreso, RHPOmingreso, RHPOaegreso, RHPOmegreso, RHPOEstado
		from RHPreparacionOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOid#"> 
		  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
	</cfquery>	
	<cfquery name="rsGradoAcadCambio" datasource="#Session.DSN#">
		select *
		from RHPreparacionOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and RHPOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHPOid#">
	</cfquery>
</cfif>
<cfquery name="rsGradoAcad" datasource="#Session.DSN#">
	select GAcodigo, GAnombre, GAorden
	from GradoAcademico
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
</cfquery>
<cfset filtroEduc = "">
<cfset navegacionEduc = "">
<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "o=3">
<!--- FILTRO --->
<cfif isdefined("Form.fRHPOnombre") and Len(Trim(Form.fRHPOnombre)) NEQ 0>
	<cfset filtroEduc = filtroEduc & " and upper(RHPOnombre) like '%" & #UCase(Form.fRHPOnombre)# & "%'">
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHPOnombre=" & Form.fRHPOnombre>
</cfif> 
 <cfif isdefined("Form.fRHPOtitulo") and form.fRHPOtitulo GT 1>
	<cfset filtroEduc = filtroEduc & " and upper(RHPOtitulo) like '%" & #UCase (Form.fRHPOtitulo)# & "%'">
	<!--- <cfset f_tipo = "'" & Form.RHAtipoFiltro & " as RHAtipoFiltro" &  ",">		 --->
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHPOtitulo=" & Form.fRHPOtitulo>
</cfif>
 <cfif isdefined("Form.RHOid")>
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "RHOid=" & Form.RHOid>
</cfif> 
 <cfif isdefined("Form.sel")>
	<cfset navegacionEduc = navegacionEduc & Iif(Len(Trim(navegacionEduc)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
</cfif> 
<table width="100%" border="0" cellspacing="0" cellpadding="0">	
	<tr>
		<td>
			<cfinclude template="/rh/portlets/pEmpleado.cfm">
		</td>
	</tr>
	<tr>
		<td>
			<table width="95%" border="0" cellspacing="0" cellpadding="0" style="margin-left: 10px; margin-right: 10px;">
				<tr> 
					<td width="10%" align="center" valign="top">
						<table width="100%" border="0" cellspacing="3" cellpadding="3">
							<tr>
								<td>
									<form name="formFiltroListaEduc" method="post" action="OferenteExterno.cfm">
										<input name="RHOid" type="hidden" value="<cfoutput>#form.RHOid#</cfoutput>">
										<input name="sel" type="hidden" value="1">
										<input type="hidden" name="o" value="3">				
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr> 
												<td class="fileLabel">Estudio</td>
												<td class="fileLabel">T&iacute;tulo</td>
												<td rowspan="2" class="fileLabel"></td>
											</tr>
											<tr> 
												<td>
													<input name="fRHPOnombre" type="text" id="fRHPOnombre2" size="35" maxlength="60" 
													value="<cfif isdefined('form.fRHPOnombre')><cfoutput>#form.fRHPOnombre#</cfoutput></cfif>"></td>
												<td>
													<input name="fRHPOtitulo" type="text" id="fRHPOtitulo2" size="27" maxlength="25" 
													value="<cfif isdefined('form.fRHPOtitulo')><cfoutput>#form.fRHPOtitulo#</cfoutput></cfif>"></td>  
												<td valign="top">
													<input name="btnFiltrarEduc" type="submit" id="btnFiltrarEduc4" value="Filtrar">
												</td>
											</tr>
										</table>
									</form>							
								</td>
							</tr>
							<tr>
								<td nowrap>
									<cfquery name="rsLista" datasource="#session.DSN#">
										select RHPOid, RHOid, RHPOnombre, RHPOtitulo, 3 as o, 1 as sel
										from RHPreparacionOferentes
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
										<cfif isdefined("filtroEduc") and Len(trim(filtroEduc))>
										#PreserveSingleQuotes(filtroEduc)#
										</cfif>
										order by RHPOnombre
									</cfquery>
									<cfinvoke 
									 component="rh.Componentes.pListas"
									 method="pListaQuery"
									 returnvariable="pListaFam">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="RHPOnombre,RHPOtitulo"/>
										<cfinvokeargument name="etiquetas" value="Estudio,T&iacute;tulo"/>
										<cfinvokeargument name="formatos" value="S,S"/>
										<cfinvokeargument name="formName" value="listaEducacion"/>	
										<cfinvokeargument name="align" value="left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>			
										<cfinvokeargument name="irA" value="OferenteExterno.cfm"/>			
										 <cfinvokeargument name="navegacion" value="#navegacionEduc#"/>
									</cfinvoke>						
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" nowrap>
					<!----SQLeducacion.cfm---> 
						<form method="post" enctype="multipart/form-data" name="formExperienciaOferente" action="educacion-sql.cfm">
							<input type="hidden" name="RHOid" value="<cfoutput>#form.RHOid#</cfoutput>">
							<input type="hidden" name="RHPOid" 
								value="<cfif modo NEQ "ALTA"><cfoutput>#rsPreparacionOferentes.RHPOid#</cfoutput></cfif>">
							<table width="100%" border="0" cellspacing="6" cellpadding="0">
								<tr> 
									<td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" 
										style="padding-left: 5px;">
									Preparaci&oacute;n del oferente
									</td>
								</tr>
								<tr>
									<td><strong>Estudio:</strong> </td>
									<td><strong>T&iacute;tulo:</strong> </td>
								</tr>
								<tr>
									<td> 
										<input name="RHPOnombre" type="text" size="50" maxlength="60" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsPreparacionOferentes.RHPOnombre#</cfoutput></cfif>"> 
									</td>
									<td> 
										<input name="RHPOtitulo" type="text" size="25" maxlength="25" 
											value="<cfif modo NEQ "ALTA"><cfoutput>#rsPreparacionOferentes.RHPOtitulo#</cfoutput></cfif>"> 
									</td>
								</tr>
								<tr>
									<td><strong>Grado Acad&eacute;mico:</strong></td>
									<td><strong>Estado:</strong></td>
								</tr>
								<tr>
									<td>
										<cfoutput>
											<select name="GAcodigo" id="GAcodigo">
											<cfif rsGradoAcad.recordCount EQ 0>
											  <option value="">-- No Disponible --</option>
											</cfif>
											<cfloop query="rsGradoAcad">
												<option value="#rsGradoAcad.GAcodigo#"
												<cfif modo NEQ 'ALTA' and rsGradoAcadCambio.GAcodigo EQ rsGradoAcad.GAcodigo>selected</cfif>>
												#rsGradoAcad.GAnombre#
												</option>
											</cfloop>
											</select>
										</cfoutput>
									</td>
									<td>
										<select name="RHPOEstado" id="RHPOEstado">
											<option value="0" 
												<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOEstado EQ 0> selected</cfif>>
												Estudiante
											</option>
											<option value="1" 
												<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOEstado EQ 1> selected</cfif>>
												Egresado
											</option>
											<option value="2"
												<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOEstado EQ 2> selected</cfif>>
												Graduado
											</option>
										</select>							  
									</td>
								</tr>
								<tr> 
									<td width="223" class="fileLabel"><strong>A&ntilde;o de Ingreso:</strong></td>
									<td width="246" class="fileLabel"><strong>A&ntilde;o de Egreso:</strong></td>
								</tr>
								<tr> 
									<td> 
										<input name="RHPOaingreso" type="text" size="5" maxlength="4" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsPreparacionOferentes.RHPOaingreso#</cfoutput></cfif>" 
										onChange="javascript: fm(this,0); validaaingreso(this);" 
										onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"> 
									</td>
									<td>
										<input name="RHPOaegreso" type="text" size="5" maxlength="4" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsPreparacionOferentes.RHPOaegreso#</cfoutput></cfif>" 
										onChange="javascript: fm(this,0); validaaegreso(this);" 
										onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"> 
									</td>
								</tr>
								<tr>
									<td><strong>Mes Ingreso:</strong></td>
									<td><strong>Mes Egreso :</strong></td>
								</tr>
								<tr>
									<td>
										<select name="RHPOmingreso" id="RHPOmingreso">
											<option value="1" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 1> selected</cfif>>
											Enero</option>
											<option value="2" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 2> selected</cfif>>
											Febrero</option>
										  <option value="3" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 3> selected</cfif>>
											Marzo</option>
										  <option value="4" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 4> selected</cfif>>
											Abril</option>
										  <option value="5" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 5> selected</cfif>>
											Mayo</option>
										  <option value="6" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 6> selected</cfif>>
											Junio</option>
										  <option value="7" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 7> selected</cfif>>
											Julio</option>
										  <option value="8" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 8> selected</cfif>>
											Agosto</option>
										  <option value="9" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 9> selected</cfif>>
											Septiembre</option>
										  <option value="10" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 10> selected</cfif>>
											Octubre</option>
										  <option value="11" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 11> selected</cfif>>
											Noviembre</option>
										  <option value="12" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmingreso EQ 12> selected</cfif>>
											Diciembre</option>
										</select>							  
									</td>
									<td> 
										<select name="RHPOmegreso" id="RHPOmegreso">
										  <option value="1" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 1> selected</cfif>>
											Enero</option>
										  <option value="2" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 2> selected</cfif>>
											Febrero</option>
										  <option value="3" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 3> selected</cfif>>
											Marzo</option>
										  <option value="4" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 4> selected</cfif>>
											Abril</option>
										  <option value="5" 
											 <cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 5> selected</cfif>>
											 Mayo</option>
										  <option value="6" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 6> selected</cfif>>
											Junio</option>
										  <option value="7" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 7> selected</cfif>>
											Julio</option>
										  <option value="8" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 8> selected</cfif>>
											Agosto</option>
										  <option value="9" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 9> selected</cfif>>
											Septiembre</option>
										  <option value="10" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 10> selected</cfif>>
											Octubre</option>
										  <option value="11" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 11> selected</cfif>>
											Noviembre</option>
										  <option value="12" 
											<cfif modo NEQ 'ALTA' and rsPreparacionOferentes.RHPOmegreso EQ 12> selected</cfif>>
											Diciembre</option>
										</select>
									</td>								
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr> 
									<td colspan="2" align="center"> 
										<cfset regresa=''>
										<cfif isdefined("form.RegCon")>
											<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=2&sel=1&RHOid=" & #form.RHOid# & '&TipoConcursante=E&RHCconcurso=' & #form.RHCconcurso# & "&RegCon=" & #form.RegCon#>
											
										<cfelse>
											<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=2&sel=1&RHOid=" & #form.RHOid#>
										</cfif>
										<cf_botones modo = #modo# regresar="#regresa#">
									</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
							</table>
						</form>
					</td>
				</tr>	
			</table>
		</td>
	</tr>
</table>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/calendar.js">//</script>
<script language="JavaScript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//</script>
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/javascript">
function validaaingreso(year){ 
		if (year.name)
		 	p = year.value;
		else 
			p = year;
			p = qf(p);
		if (p < 1950 || p > 2080) {
			alert('El año digitado debe estar entre 1950 y 2080.');			
			eval("document.formExperienciaOferente.RHPOaingreso.value = '1950'");
			eval("document.formExperienciaOferente.RHPOaingreso.focus();");
			return false;
		}
	} 
function validaaegreso(year){ 
		if (year.name)
		 	p = year.value;
		else 
			p = year;
			p = qf(p);
		if (p < 1950 || p > 2080) {
			alert('El año digitado debe estar entre 1950 y 2080.');			
			eval("document.formExperienciaOferente.RHPOaegreso.value = '1950'");
			eval("document.formExperienciaOferente.RHPOaegreso.focus();");
			return false;
		}
	} 
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		objForm.RHPOnombre.required = false;
		objForm.RHPOtitulo.required = false;
		objForm.RHPOaingreso.required = false;
		objForm.RHPOaegreso.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.RHPOnombre.required = true;
		objForm.RHPOtitulo.required = true;
		objForm.RHPOaingreso.required = true;
		objForm.RHPOaegreso.required = true;
	}
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formExperienciaOferente");
	
	objForm.RHPOnombre.required = true;
	objForm.RHPOnombre.description = "Estudio";
	objForm.RHPOtitulo.required = true;
	objForm.RHPOtitulo.description = "Título";
	objForm.RHPOaingreso.required = true;
	objForm.RHPOaingreso.description = "Año de ingreso";
	objForm.RHPOaegreso.required = true;
	objForm.RHPOaegreso.description = "Año de egreso";
</script>
---->
