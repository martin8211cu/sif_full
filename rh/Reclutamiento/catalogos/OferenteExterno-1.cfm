<cf_templateheader title="Mantenimiento Oferente Externo">
	<cf_templatearea name="body">
		<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>
		<cfinclude template="/rh/Utiles/params.cfm"> 
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0>
		
		<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
			<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
		</cfif>
		<cfif isdefined("Url.RHOidentificacionFiltro") and not isdefined("Form.RHOidentificacionFiltro")>
			<cfparam name="Form.RHOidentificacionFiltro" default="#Url.RHOidentificacionFiltro#">
		</cfif>		
		<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
			<cfparam name="Form.filtrado" default="#Url.filtrado#">
		</cfif>	
		<cfif isdefined("Url.RHOid") and not isdefined("Form.RHOid")>
			<cfparam name="Form.RHOid" default="#Url.RHOid#">
		</cfif>
		<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
			<cfparam name="Form.sel" default="#Url.sel#">
		</cfif>		
		<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
		<cfif isdefined("Url.regcon") and not isdefined("form.regcon")>
			<cfparam name="Form.regcon" default="#Url.regcon#">
		</cfif>
		<cfif isdefined("Url.RHCconcurso") and not isdefined("form.RHCconcurso")>
			<cfset Form.RHCconcurso=  Url.RHCconcurso>
		</cfif>

		<cfset filtro = "">
		<cfset navegacion = "">
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
		<cfif isdefined("Form.RHOid")>
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOid=" & #form.RHOid#>				
		</cfif>

		<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
			
			<cf_dbfunction name="concat" args=" and upper(RHOapellido1 ,' ',RHOapellido2,' ',RHOnombre) like '%" returnvariable="vCadena">
			<cfset filtro = filtro & #vCadena# & #UCase(Form.nombreFiltro)# & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
		</cfif>
		<cfif isdefined("Form.RHOidentificacionFiltro") and Len(Trim(Form.RHOidentificacionFiltro)) NEQ 0>
			<cfset filtro = filtro & " and upper(RHOidentificacion)  like '%" & UCase(Form.RHOidentificacionFiltro) & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHOidentificacionFiltro=" & Form.RHOidentificacionFiltro>
		</cfif>
		<cfif isdefined("Form.sel") and form.sel NEQ 1>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & form.sel>				
		</cfif>	
		<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
		<cfif isdefined("Form.RegCon")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RegCon=" & form.RegCon>				
		</cfif>		
		<cfif isdefined("Form.RHCconcurso")>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHCconcurso=" & form.RHCconcurso>				
		</cfif>	
	<cf_web_portlet_start border="true" titulo="Mantenimiento Oferente Externo" skin="#Session.Preferences.Skin#">
		<table width="100%" border="0" cellspacing="0" cellpadding="0" >
			<cfif isdefined("form.o") and form.o eq 4 and isdefined("form.DLLinea")>
				<cfset regresar = "javascript:history.back();">
			<cfelse>
				<cfset regresar = "/cfmx/rh/index.cfm">
			</cfif>		
			<tr><td><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>	  
			<form name="formBuscar" method="post" action="">			  	  
				<tr> 
					<td valign="middle" align="right">  
					
					<cfif not isdefined("form.regcon")>
						<label id="letiqueta1"><a href="javascript: limpiaFiltrado(); buscar();">Seleccione un oferente:  </a></label>
						<label id="letiqueta2"><a href="javascript: limpiaFiltrado(); buscar();">Datos del oferente: </a> </label>			  
						<a href="javascript: limpiaFiltrado(); buscar();">
						<img src="/cfmx/rh/imagenes/iindex.gif" name="imageBusca" border="0" id="imageBusca"> 
						</a> </td>
					</cfif>
				</tr>
			</form>	  							
			<tr><td>&nbsp;</td></tr>
			<tr style="display: ;" id="verFiltroListaEmpl"> 
				<td> 
					<form name="formFiltroListaEmpl" method="post" action="OferenteExterno.cfm">
						<input type="hidden" name="filtrado" 
						value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
						<input type="hidden" name="sel" 
						value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">				
						<cfif isdefined("Form.RegCon")>
							<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">
							<input name="RegCon" type="hidden" value="#form.RegCon#">				
						</cfif>
						<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
							<tr> 
								<td width="6%">&nbsp;</td>
								<td width="27%" height="17" class="fileLabel">Identificaci&oacute;n</td>
								<td width="62%" class="fileLabel">Nombre del oferente</td>
							</tr>
							<tr> 
								<td width="6%">&nbsp;</td>
								<td>
									<input name="RHOidentificacionFiltro" type="text" id="RHOidentificacionFiltro" 
									size="30" maxlength="60" 
									value="<cfif isdefined('form.RHOidentificacionFiltro')><cfoutput>#form.RHOidentificacionFiltro#</cfoutput></cfif>">
								</td>
								<td>
									<input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" 
									value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
								</td>
								<td width="5%" colspan="2">
                                  <input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
								</td>
							</tr>
							<tr><td>&nbsp;</td></tr>
						</table>
					</form>
				</td>
			</tr>		
			<tr><td>&nbsp;</td></tr>
			<tr style="display: ;" id="verLista"> 
				<td> 
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td>
								<cfquery name="rsLista" datasource="#session.DSN#">
									select RHOid, RHOidentificacion, 
										<cf_dbfunction name="concat" args="RHOapellido1,' ',RHOapellido2,' ',RHOnombre"> as nombreOferente,
										1 as o, 1 as sel ,'ALTA' as modo
									from DatosOferentes
									where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
									<cfif isdefined("filtro") and len(trim(filtro))>
										#PreserveSingleQuotes(filtro)#
									</cfif>
									order by RHOidentificacion, RHOapellido1, RHOapellido2, RHOnombre
								</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaEmpl">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="RHOidentificacion, nombreOferente"/>
									<cfinvokeargument name="etiquetas" value="Identificaci&oacute;n,Oferente Externo"/>
									<cfinvokeargument name="formatos" value=""/>
									<cfinvokeargument name="formName" value="listaEmpleados"/>	
									<cfinvokeargument name="align" value="left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="irA" value="OferenteExterno.cfm"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
									<cfinvokeargument name="keys" value="RHOid"/>
								</cfinvoke>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
						<tr>
							<td align="center">
								<form name="formNuevoEmplLista" method="post" action="OferenteExterno.cfm">
									<input type="hidden" name="o" value="1">
									<input type="hidden" name="sel" value="1">
									<!--- <input name="btnNuevoLista" type="submit" value="Nuevo Oferente">	 --->			
									<cf_botones include = "btnNuevoLista" includevalues = "Nuevo Oferente" 
										regresarMenu='true' exclude='Alta,Limpiar'>
									<!--- VIENE DE REGISTRO DE CONCURSANTES - RECLUTAMIENTO Y SELECCION --->
									<cfif isdefined("Form.RegCon")>
										<input name="RHCconcurso" type="hidden" value="#form.RHCconcurso#">
										<input name="RegCon" type="hidden" value="#form.RegCon#">				
									</cfif>					
								</form>
							</td>
						</tr>
						<tr><td>&nbsp;</td></tr>
					</table>
				</td>
			</tr>
			
			<tr style="display: ;" id="verPagina"> 			
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td><cfinclude template="header.cfm"></td>
						</tr>
						<tr>
							<td><!--- class="tabContent" --->
								<cfif tabChoice eq 1 and tabAccess[tabChoice]>	
									<!--- Datos del Oferente --->
									<cfinclude template="datosOferente.cfm">
								<cfelseif tabChoice eq 2 and tabAccess[tabChoice] and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>	
									<!--- Experiencia del Oferente --->
									<cfinclude template="ExperienciaOferentes.cfm"> 
								<cfelseif tabChoice eq 3 and tabAccess[tabChoice] and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>				
									<!--- Educacion del Oferente --->
									<cfinclude template="Educacion.cfm">
								<cfelseif tabChoice eq 4 and tabAccess[tabChoice] and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>				
									<!--- Participacion en concursos del Oferente --->
									<cfinclude template="ParticipacionConcursosOf.cfm">
								<cfelse>		
									<div align="center"> <b>Este m&oacute;dulo no est&aacute; disponible</b></div>
								</cfif>
								
								<!---
								<cf_tabs width="100%">
									<cf_tab text="Resumen" selected="#tabChoice eq 1#">
										<cfif tabChoice eq 1 >
											<!--- Datos del Oferente --->
											<cfinclude template="datosOferente.cfm">										
										</cfif>
									</cf_tab>
									<cf_tab text="Competencias" selected="#tabChoice eq 2#">
										<cfif tabChoice eq 2 and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>
											<!--- Experiencia del Oferente --->
											<cfinclude template="ExperienciaOferentes.cfm"> 
										</cfif>
									</cf_tab>
									<cf_tab text="Experiencia" selected="#tabChoice eq 3#">
										<cfif tabChoice eq 3 and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>
											<!--- Educacion del Oferente --->
											<cfinclude template="Educacion.cfm">
										</cfif>
									</cf_tab>
									<cf_tab text="Educaci&oacute;n" selected="#tabChoice eq 4#">
										<cfif tabChoice eq 4 and  isdefined('form.RHOid') and Len(form.RHOid) neq 0>
											<!--- Participacion en concursos del Oferente --->
											<cfinclude template="ParticipacionConcursosOf.cfm">
										</cfif>
									</cf_tab>
								</cf_tabs>
								--->
							</td>
						</tr>
					</table>
					<script language="JavaScript" type="text/javascript">
						var Bandera = "L";
						
						function buscar(){
							var connVerLista			= document.getElementById("verLista");
							var connVerPagina			= document.getElementById("verPagina");				
							var connVerFiltroListaEmpl	= document.getElementById("verFiltroListaEmpl");								
							var connVerEtiqueta1		= document.getElementById("letiqueta1");												
							var connVerEtiqueta2		= document.getElementById("letiqueta2");																
							
							//alert(document.formFiltroListaEmpl.sel.value);
							if(document.formFiltroListaEmpl.filtrado.value != "")
								Bandera = "L";
								
							if(document.formFiltroListaEmpl.sel.value == "1")
								Bandera = "P";					
						
							if(Bandera == "L"){	// Ver Lista
								Bandera = "P";
								connVerLista.style.display = "";
								connVerFiltroListaEmpl.style.display = "";					
								connVerPagina.style.display = "none";
								document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";
								connVerEtiqueta1.style.display = "none";
								connVerEtiqueta2.style.display = "";					
								document.formBuscar.imageBusca.alt="Mantenimientos";
							}else{	//Pagina
								Bandera = "L";				
								connVerLista.style.display = "none";
								connVerFiltroListaEmpl.style.display = "none";					
								connVerPagina.style.display = "";
								document.formBuscar.imageBusca.src="/cfmx/rh/imagenes/iindex.gif";					
								connVerEtiqueta1.style.display = "";
								connVerEtiqueta2.style.display = "none";										
								document.formBuscar.imageBusca.alt="Lista de Oferentes";
							}
						}				
						
						function limpiaFiltrado(){
							document.formFiltroListaEmpl.filtrado.value = "";
							document.formFiltroListaEmpl.sel.value = 0;
						}
					
						function Regresa(valor){
							location.href ='/cfmx/rh/Reclutamiento/operacion/RegistroConcursantes.cfm?paso=1&RHCconcurso=' + valor;		
						}
						
						buscar();
					</script>
					
					<script type="text/javascript">
						<!--
						function tab_set_current (n){
							location.href='OferenteExterno.cfm?DEid=<cfoutput>#JSStringFormat(navegacion)#</cfoutput>&tab='+escape(n);
						}
						//-->
					</script>
					
				</td>	
			</tr>
		</table>	
	<cf_web_portlet_end>
</cf_templatefooter>
