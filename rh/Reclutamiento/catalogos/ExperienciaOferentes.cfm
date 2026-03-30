						
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>
<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
	<cfparam name="Form.RHOid" default="#Url.RHOid#">
</cfif>

<cfif isdefined("Url.RegCon") and not isdefined("Form.RegCon")>
	<cfparam name="Form.RegCon" default="#Url.RegCon#">
</cfif>

<cfif isdefined("Url.RHCconcurso") and not isdefined("Form.RHCconcurso")>
	<cfparam name="Form.RHCconcurso" default="#Url.RHCconcurso#">
</cfif>

<cfinclude template="../../capacitacion/expediente/experiencia.cfm">

<!----
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
<cfif modo EQ "CAMBIO" and isdefined('form.RHOid') and isdefined('form.RHEOid')>
	<cfquery name="rsExperiencia" datasource="#Session.DSN#">
		select RHEOid, RHOid, RHEOnombre, RHEOpuesto, RHEOfingreso, RHEOfsalida, 
			   RHEOjefe, RHEOrazon, RHEOtelefono
		from RHExperienciaOferentes
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and RHEOid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEOid#">
		  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
	</cfquery>	
</cfif>
<cfset filtroExpe = "">
<cfset navegacionExpe = "">
<cfset navegacionExpe = navegacionExpe & Iif(Len(Trim(navegacionExpe)) NEQ 0, DE("&"), DE("")) & "o=2">
<!--- FILTRO --->
<cfif isdefined("Form.fRHEOnombre") and Len(Trim(Form.fRHEOnombre)) NEQ 0>
	<cfset filtroExpe = filtroExpe & " and upper(RHEOnombre) like '%" & #UCase(Form.fRHEOnombre)# & "%'">
	<cfset navegacionExpe = navegacionExpe & Iif(Len(Trim(navegacionExpe)) NEQ 0, DE("&"), DE("")) & "RHEOnombre=" & Form.fRHEOnombre>
</cfif> 
 <cfif isdefined("Form.fRHEOpuesto") and form.fRHEOpuesto GT 1>
	<cfset filtroExpe = filtroExpe & " and upper(RHEOpuesto) like '%" & #UCase (Form.fRHEOpuesto)# & "%'">
	<cfset navegacionExpe = navegacionExpe & Iif(Len(Trim(navegacionExpe)) NEQ 0, DE("&"), DE("")) & "RHEOpuesto=" & Form.fRHEOpuesto>
</cfif>
 <cfif isdefined("Form.RHOid")>
	<cfset navegacionExpe = navegacionExpe & Iif(Len(Trim(navegacionExpe)) NEQ 0, DE("&"), DE("")) & "RHOid=" & Form.RHOid>
</cfif> 
 <cfif isdefined("Form.sel")>
	<cfset navegacionExpe = navegacionExpe & Iif(Len(Trim(navegacionExpe)) NEQ 0, DE("&"), DE("")) & "sel=" & Form.sel>
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
									<form name="formFiltroListaExper" method="post" action="OferenteExterno.cfm">
										<input type="hidden" name="RHOid" value="<cfoutput>#form.RHOid#</cfoutput>">
										<input name="sel" type="hidden" value="1">
										<input name="o" type="hidden" value="2">				
										<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
											<tr> 
												<td class="fileLabel">Empresa</td>
												<td class="fileLabel">Puesto</td>
												<td rowspan="2" class="fileLabel"></td>
											</tr>
											<tr> 
												<td>
												<input name="fRHEOnombre" type="text" id="fRHEOnombre2" size="35" maxlength="60" 
												value="<cfif isdefined('form.fRHEOnombre')><cfoutput>#form.fRHEOnombre#</cfoutput></cfif>">
												</td>
												<td>
												<input name="fRHEOpuesto" type="text" id="fRHEOpuesto2" size="27" maxlength="25" 
												value="<cfif isdefined('form.fRHEOpuesto')><cfoutput>#form.fRHEOpuesto#</cfoutput></cfif>">
												</td>  
												<td valign="top">
												<input name="btnFiltrarExpe" type="submit" id="btnFiltrarExpe4" value="Filtrar">
												</td>
											</tr>
										</table>
									</form>							
								</td>
							</tr>
							<tr>
								<td nowrap>
									<cfquery name="rsLista" datasource="#session.DSN#">
										select RHEOid, RHOid, RHEOnombre, RHEOpuesto, 2 as o, 1 as sel
										from RHExperienciaOferentes
										where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										  and RHOid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHOid#">
										<cfif isdefined("filtroExpe") and Len(trim(filtroExpe))>
										  #PreserveSingleQuotes(filtroExpe)#
										</cfif>
										order by RHEOnombre
									</cfquery>
									
									<cfinvoke 
										component="rh.Componentes.pListas"
										method="pListaQuery"
										returnvariable="pListaFam">
										<cfinvokeargument name="query" value="#rsLista#"/>
										<cfinvokeargument name="desplegar" value="RHEOnombre,RHEOpuesto"/>
										<cfinvokeargument name="etiquetas" value="Empresa,Puesto"/>
										<cfinvokeargument name="formatos" value="S,S"/>
										<cfinvokeargument name="formName" value="listaExperiencia"/>	
										<cfinvokeargument name="align" value="left,left"/>
										<cfinvokeargument name="ajustar" value="N"/>			
										<cfinvokeargument name="irA" value="OferenteExterno.cfm"/>			
										<cfinvokeargument name="navegacion" value="#navegacionExpe#"/>
									</cfinvoke>						
								</td>
							</tr>
						</table>
					</td>
					<td valign="top" nowrap> 
						<form method="post" enctype="multipart/form-data" name="formExperienciaOferente" 
							action="SQLExperienciaOferentes.cfm">
							<input type="hidden" name="RHOid" value="<cfoutput>#form.RHOid#</cfoutput>">
							<input type="hidden" name="RHEOid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOid#</cfoutput></cfif>">
							<table width="100%" border="0" cellspacing="6" cellpadding="0">
								<tr> 
									<td colspan="2" class="<cfoutput>#Session.preferences.Skin#_thcenter</cfoutput>" 
										style="padding-left: 5px;">
											Experiencia del oferente
									</td>
								</tr>
								<tr>
									<td><strong>Nombre Empresa:</strong> </td>
									<td><strong>Puesto:</strong> </td>
								</tr>
								<tr>
									<td> 
										<input name="RHEOnombre" type="text" size="50" maxlength="60" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOnombre#</cfoutput></cfif>"> 
									</td>
									<td>
										<input name="RHEOpuesto" type="text" size="25" maxlength="25" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOpuesto#</cfoutput></cfif>">
									</td>
								</tr>
								<tr> 
									<td width="223" class="fileLabel">Fecha Ingreso:</td>
									<td width="246" class="fileLabel">Fecha Salida:</td>
								</tr>
								<tr> 
									<td> 
										<cfif modo NEQ 'ALTA'>
											<cfset fechainicio = LSDateFormat(rsExperiencia.RHEOfingreso, "DD/MM/YYYY")>
										<cfelse>
											<cfset fechainicio = LSDateFormat(Now(), "DD/MM/YYYY")>
										</cfif> 
										<cf_sifcalendario form="formExperienciaOferente" value="#fechainicio#" name="RHEOfingreso"> 
									</td>
									<td>
										<cfif modo NEQ 'ALTA'>
											<cfset fsalida = LSDateFormat(rsExperiencia.RHEOfsalida, "DD/MM/YYYY")>
										<cfelse>
											<cfset fsalida = LSDateFormat(Now(), "DD/MM/YYYY")>
										</cfif> 
										<cf_sifcalendario form="formExperienciaOferente" value="#fsalida#" name="RHEOfsalida"> 
									</td>
								</tr>
								<tr><td colspan="2"><strong>Raz&oacute;n de la salida:</strong></td></tr>
								<tr>
									<td colspan="2">
										<input name="RHEOrazon" type="text" size="100" maxlength="256" width="20" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOrazon#</cfoutput></cfif>">
									</td>
								</tr>
								<tr>
									<td><strong>Jefe:</strong></td>
									<td><strong>Tel&eacute;fono:</strong></td>
								</tr>
								<tr>
									<td> 
										<input name="RHEOjefe" type="text" size="25" maxlength="25" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOjefe#</cfoutput></cfif>">
									</td>
									<td> 
										<input name="RHEOtelefono" type="text" size="15" maxlength="25" 
										value="<cfif modo NEQ "ALTA"><cfoutput>#rsExperiencia.RHEOtelefono#</cfoutput></cfif>">
									</td>								
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr> 
									<td colspan="2" align="center">
										<cfset regresa=''>
										<cfif isdefined("form.RegCon")>
											<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=1&sel=1&RHOid=" & #form.RHOid# & "&TipoConcursante=E&RHCconcurso=" & #form.RHCconcurso# & "&RegCon=" & #form.RegCon#>

										<cfelse>
											<cfset regresa ="../../Reclutamiento/catalogos/OferenteExterno.cfm?o=1&sel=1&RHOid=" & #form.RHOid#>
										</cfif>
										<cf_botones modo = #modo# regresar="#regresa#">
									</td>
								</tr>
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
//------------------------------------------------------------------------------------------
	function deshabilitarValidacion(){
		objForm.RHEOfingreso.required = false;   
		objForm.RHEOnombre.required = false;
		objForm.RHEOpuesto.required = false;
	}
//------------------------------------------------------------------------------------------
	function habilitarValidacion(){
		objForm.RHEOfingreso.required = true;
		objForm.RHEOnombre.required = true;
		objForm.RHEOpuesto.required = true;
	}
//------------------------------------------------------------------------------------------
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");			
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formExperienciaOferente");
	
	objForm.RHEOfingreso.required = true;
	objForm.RHEOfingreso.description = "Fecha de inicio";
	objForm.RHEOnombre.required = true;
	objForm.RHEOnombre.description = "Nombre Empresa";
	objForm.RHEOpuesto.required = true;
	objForm.RHEOpuesto.description = "Puesto";	
</script>
--->