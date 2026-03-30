<!--- VARIBLES DE TRADUCCION --->
<cfinvoke Key="LB_Noticias" Default="Noticias de Autogesti&oacute;n" returnvariable="LB_Noticias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_RecursosHumanos" Default="Recursos Humanos" returnvariable="LB_RecursosHumanos" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CODIGOCAT" Default="C&oacute;digo Categor&iacute;a" returnvariable="LB_CODIGOCAT" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Titulo" Default="Titulo" returnvariable="LB_Titulo" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Fecha" Default="Fecha" returnvariable="LB_Fecha" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_ListaDeCategorias" Default="Lista de Categor&iacute;as" returnvariable="LB_ListaDeCategorias" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_CodigoCategoria" Default="C&oacute;digo categor&iacute;a" returnvariable="LB_CodigoCategoria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_DescripcionCategoria" Default="Descripci&oacute;n categor&iacute;a" returnvariable="LB_DescripcionCategoria" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Filtrar" Default="Filtrar" returnvariable="LB_Filtrar" XmlFile="/rh/generales.xml" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Nuevo" Default="Nueva" returnvariable="LB_Nuevo"  component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="LB_Autor" Default="Autor" returnvariable="LB_Autor" component="sif.Componentes.Translate" method="Translate"/>
<!--- FIN VARIBLES DE TRADUCCION --->
<cfset va_arrayCategoria=ArrayNew(1)>

<cf_templateheader title="#LB_RecursosHumanos#">
	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cf_web_portlet_start border="true" titulo="#LB_Noticias#" skin="#Session.Preferences.Skin#">			
			<cfinclude template="/rh/portlets/pNavegacion.cfm">
			<!----Carga de los filtros--->
			<cfif isdefined("Url.IdCategoria") and not isdefined("Form.IdCategoria")>
				<cfparam name="Form.IdCategoria" default="#Url.IdCategoria#">
			</cfif>		
			<cfif isdefined("Url.FechaNoticia") and not isdefined("Form.FechaNoticia")>
				<cfparam name="Form.FechaNoticia" default="#Url.FechaNoticia#">
			</cfif>
			<cfif isdefined("Url.Autor") and not isdefined("Form.Autor")>
				<cfparam name="Form.Autor" default="#Url.Autor#">
			</cfif>
			<cfif isdefined("Url.Titulo") and not isdefined("Form.Titulo")>
				<cfparam name="Form.Titulo" default="#Url.Titulo#">
			</cfif>			
			<!---Carga de navegacion y filtro para aplicar a la lista--->
			<cfset filtro = "">
			<cfset navegacion = "">			
			<cfif isdefined("Form.IdCategoria") and len(trim(Form.IdCategoria))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "IdCategoria=" & form.IdCategoria>				
				<cfset filtro = filtro & " and a.IdCategoria =" & Form.IdCategoria>
				<!---Arreglo para el conlis de categorias--->
				<cfset ArrayAppend(va_arrayCategoria, Form.IdCategoria)>	
				<cfquery name="rsCategoria" datasource="#session.DSN#">
					select CodCategoria, DescCategoria
					from CategoriaNoticias
					where IdCategoria = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IdCategoria#">
				</cfquery>
				<cfset ArrayAppend(va_arrayCategoria, rsCategoria.CodCategoria)>	
				<cfset ArrayAppend(va_arrayCategoria, rsCategoria.DescCategoria)>	
			</cfif>
			<cfif isdefined("Form.FechaNoticia") and len(trim(Form.FechaNoticia))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FechaNoticia=" & form.FechaNoticia>				
				<cfset filtro = filtro & " and a.FechaNoticia =" & LSParseDateTime(Form.FechaNoticia)>	
			</cfif>
			<cfif isdefined("Form.Autor") and len(trim(Form.Autor))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Autor=" & form.Autor>
				<cfset filtro = filtro & " and upper(a.Autor) like '%" & UCase(Form.Autor) & "%'">				
			</cfif>
			<cfif isdefined("Form.Titulo") and len(trim(Form.Titulo))>
				<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Titulo=" & form.Titulo>			
				<cfset filtro = filtro & " and upper(a.Titulo) like '%" & UCase(Form.Titulo) & "%'">					
			</cfif>
			<table width="100%" border="0" cellspacing="1" cellpadding="1">			
				<!----FILTROS---->
				<tr>
					<td>
						<cfoutput>
						<form name="form1" method="post" action="">
							<table width="100%" border="0" cellspacing="1" cellpadding="1">
								<tr>
									<td align="right"><strong><cf_translate key="LB_Categoria">Categor&iacute;a</cf_translate>:&nbsp;</strong></td>
									<td>
										<cf_conlis title="#LB_ListaDeCategorias#"
										campos = "IdCategoria,CodCategoria,DescCategoria" 
										desplegables = "N,S,S" 
										modificables = "N,S,N" 
										size = "0,7,25"
										asignar="IdCategoria,CodCategoria,DescCategoria"
										asignarformatos="I,S,S"
										tabla="	CategoriaNoticias a"																	
										columnas="IdCategoria,CodCategoria,DescCategoria"
										filtro="a.CEcodigo =#session.CEcodigo#"
										desplegar="CodCategoria,DescCategoria"
										etiquetas="	#LB_CodigoCategoria#, 
													#LB_DescripcionCategoria#"
										formatos="S,S"
										align="left,left"
										showEmptyListMsg="true"
										debug="false"
										form="form1"
										width="800"
										height="500"
										left="70"
										top="20"
										filtrar_por="CodCategoria,DescCategoria"
										valuesarray="#va_arrayCategoria#"> 
									</td>
									<td align="right"><strong><cf_translate key="LB_FechaNoticia">Fecha Noticia</cf_translate>:&nbsp;</strong></td>
									<td>
										<cfif isdefined("Form.FechaNoticia") and len(trim(Form.FechaNoticia))>
											<cf_sifcalendario form="form1" name="FechaNoticia" index="3" value="#LSDateFormat(Form.FechaNoticia,'dd/mm/yyyy')#">	
										<cfelse>
											<cf_sifcalendario form="form1" name="FechaNoticia" index="3">	
										</cfif>										
									</td>
								</tr>
								<tr>
									<td align="right"><strong>#LB_Autor#:&nbsp;</strong></td>
									<td>
										<input name="Autor" size="40" id="Autor" type="text" maxlength="260" onfocus="this.select()" tabindex="2" value="<cfif isdefined("Form.Autor") and len(trim(Form.Autor))>#Form.Autor#</cfif>">
									</td>
									<td align="right"><strong><cf_translate key="LB_Titulo">Titulo</cf_translate>:&nbsp;</strong></td>
									<td>
										<input name="Titulo" size="40" id="Titulo" type="text" maxlength="60" onfocus="this.select()" tabindex="3" value="<cfif isdefined("Form.Titulo") and len(trim(Form.Titulo))>#Form.Titulo#</cfif>">
									</td>
								</tr>
								<tr>
									<td colspan="4" align="center">
										<table cellpadding="0" cellspacing="0" align="center" border="0">
											<tr>
												<td align="center"><input type="submit" name="btnFiltrar" value="#LB_Filtrar#"></td>
												<td align="center"><input type="button" name="btnNuevo" value="#LB_Nuevo#" onClick="javascript: funcNuevo();"></td>
											</tr>
										</table>
									</td>
								</tr>
							</table>
						</form>
						</cfoutput>
					</td>
				</tr>
				<!----LISTA---->
				<tr>
					<td>
						<table width="100%" border="0" cellspacing="1" cellpadding="1">
						  <tr>
							<td valign="top" width="45%">
								<cfquery name="rsLista" datasource="#session.DSN#">
									select a.IdNoticia, a.Titulo, a.FechaNoticia, b.CodCategoria, a.Autor
									from EncabNoticias a
										inner join CategoriaNoticias b
											on a.IdCategoria = b.IdCategoria
									where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
										#PreserveSingleQuotes(filtro)#
								</cfquery>
								<cfinvoke 
									component="rh.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pListaRet">
									<cfinvokeargument name="query" value="#rsLista#"/>
									<cfinvokeargument name="desplegar" value="CodCategoria,FechaNoticia,Autor,Titulo"/>
									<cfinvokeargument name="etiquetas" value="#LB_CODIGOCAT#,#LB_Fecha#,#LB_Autor#,#LB_Titulo#"/>
									<cfinvokeargument name="formatos" value="V,D,V,V"/>
									<cfinvokeargument name="align" value="left,left,left,left"/>
									<cfinvokeargument name="ajustar" value="N"/>
									<cfinvokeargument name="checkboxes" value="N"/>
									<cfinvokeargument name="irA" value="TabsNoticiasAutogestion.cfm"/>
									<cfinvokeargument name="keys" value="IdNoticia"/>
									<cfinvokeargument name="showEmptyListMsg" value="true"/>
									<cfinvokeargument name="maxrows" value="20"/>
									<cfinvokeargument name="navegacion" value="#navegacion#"/>
								</cfinvoke>
							</td>				
						  </tr>
						</table>		        
					</td>
				</tr>
			</table>
			<script type="text/javascript">
				function funcNuevo(){
					location.href='TabsNoticiasAutogestion.cfm?tab=1&modo=ALTA';
				}
			</script>
	<cf_web_portlet_end>
<cf_templatefooter>