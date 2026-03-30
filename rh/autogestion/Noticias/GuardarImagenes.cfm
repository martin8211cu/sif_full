<!--- VARIBLES DE TRADUCCION --->
<cfinvoke Key="LB_GuardarImagenes" Default="Guardar Imagenes" returnvariable="LB_GuardarImagenes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_NombreImagen" Default="Nombre Imagen" returnvariable="LB_NombreImagen" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Tipo" Default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Imagen" Default="Imagen" returnvariable="LB_Imagen" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Guardar" Default="Guardar" returnvariable="LB_Guardar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Regresar" Default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_LaExtensionDelArchivoNoEsPermitida" Default="La extensi&oacute;n del archivo no es permitida (Solo se permiten imagenes)" returnvariable="LB_Mensaje" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke Key="LB_DeseaEliminarLaImagen" Default="Desea eliminar la imagen?" returnvariable="LB_DeseaEliminarLaImagen" component="sif.Componentes.Translate" method="Translate"/>

<!--- FIN VARIBLES DE TRADUCCION --->
<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" titulo="#LB_GuardarImagenes#" skin="#Session.Preferences.Skin#">
			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>
			<cfset navBarLinks[1] = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarStatusText[1] = "/cfmx/rh/indexAdm.cfm">
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellspacing="1" cellpadding="1">
			  <tr>
				<td valign="top" width="45%">
					<!---Lista de imagenes subidas al servidor---->
					<cfset rootdir = expandpath('')>
					<cfset directorio = "#rootdir#/rh/autogestion/Noticias/Imagenes">
					<cfset directorio = replace(directorio, '\', '/', 'all') >
					<cfdirectory action="list" directory="#directorio#" name="rsLista">
					<cfquery dbtype="query" name="rsLista">
						select *					     							 							
						from rsLista 
						where  Type != 'Dir'
					</cfquery>					
					<cfset ArrayF = ArrayNew(1)>
					<cfset ArrayG = ArrayNew(1)>
					<cfset ArrayH = ArrayNew(1)>
					<cfloop query="rsLista">												
						<cfset ArrayF[rsLista.CurrentRow] ="<img src='/cfmx/rh/imagenes/Borrar01_S.gif' border='0'>">	
						<cfif isdefined("url.Noticia")>
							<cfset ArrayG[rsLista.CurrentRow] ="1">
						</cfif>						
						<cfif isdefined("url.IdNoticia") and len(trim(url.IdNoticia))>
							<cfset ArrayH[rsLista.CurrentRow] ="#url.IdNoticia#">	
						<cfelse>
							<cfset ArrayH[rsLista.CurrentRow] ="">	
						</cfif>
					</cfloop>
					<cfset QueryAddColumn(rsLista, 'Eliminar', ArrayF)>
					<cfif isdefined("url.Noticia")>
						<cfset QueryAddColumn(rsLista, 'Noticia', ArrayG)>
						<cfset QueryAddColumn(rsLista, 'IdNoticia', ArrayH)>			
					</cfif>
					<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="Name,Eliminar"/>
						<cfinvokeargument name="etiquetas" value="#LB_NombreImagen#,&nbsp;"/>
						<cfinvokeargument name="formatos" value="V,V"/>
						<cfinvokeargument name="align" value="left,left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="SQLGuardarImagenes.cfm"/>
						<cfinvokeargument name="keys" value="Name"/>
						<cfinvokeargument name="showEmptyListMsg" value="true"/>						
						<cfinvokeargument name="funcion" value="funcEliminar"/>
						<cfinvokeargument name="fparams" value="Name"/>						
						<!---<cfinvokeargument name="showLink" value="false"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>---->
					</cfinvoke>
				</td>				
				<td valign="top" width="55%" align="center">
					<cfoutput>
					<form name="form1" method="post" enctype="multipart/form-data" action="SQLGuardarImagenes.cfm" onSubmit="javascript: return funcGuardar();">
						<table>
							<tr>
								<td align="right"><strong>#LB_Imagen#:&nbsp;</strong></td>
								<td><input type="file" name="archivo" value="" size="41" ></td>
							</tr>
							<tr><td>&nbsp;</td></tr>
							<tr>
								<td colspan="2" align="center">
									<table cellpadding="0" cellspacing="0">
										<tr>
											<td align="center"><input type="submit" name="btnGuardar" value="#LB_Guardar#"></td>
											<cfif isdefined("url.Noticia")>
												<td align="center">
													<input type="button" name="btnGuardar" value="#LB_Regresar#" onClick="javascript: funcRegresar();">
												</td>
												<cfif isdefined("url.IdNoticia") and len(trim(url.IdNoticia))>
													<input type="hidden" name="IdNoticia" value="#url.IdNoticia#">
												</cfif>
												<input type="hidden" name="Noticia" value="1">
											</cfif>											
										</tr>
									</table>									
								</td>
							</tr>
							<cfif isdefined("url.msgerror") and len(trim(url.msgerror))>
								<tr>
									<td colspan="2" align="center">
										<strong>#XMLFormat(url.error)#</strong>
									</td>
								</tr>
							</cfif>
						</table>
						<input type="hidden" name="nombre_archivo" value="" >
					</form>					
					</cfoutput>
				</td>
			  </tr>
			</table>		
			<cfoutput>
				<script type="text/javascript">
					function funcGuardar(){
						document.form1.nombre_archivo.value = document.form1.archivo.value;
						return true;
					}
					function funcEliminar(pName){
						if (confirm('#LB_DeseaEliminarLaImagen#')){
							document.lista.NAME.value = pName;						
							<cfif isdefined("url.Noticia")>
								document.lista.NOTICIA.value = 1;
							</cfif>
							<cfif isdefined("url.IdNoticia") and len(trim(url.IdNoticia))>
								document.lista.IDNOTICIA.value = '#url.IdNoticia#';			
							</cfif>
							document.lista.action ='SQLGuardarImagenes.cfm';
							document.lista.submit(); 
						}							
					}
					function funcRegresar(){
						var param = '';
						<cfif isdefined("url.IdNoticia")>
							param = '?IdNoticia=#url.IdNoticia#';
						</cfif>
						location.href = 'TabsNoticiasAutogestion.cfm'+param;
					}
				</script> 
			</cfoutput>       
	<cf_web_portlet_end>
<cf_templatefooter>