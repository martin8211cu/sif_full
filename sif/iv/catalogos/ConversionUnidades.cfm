<cf_templateheader title="Inventarios - Conversi&oacute;n de Unidades">
	
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Conversi&oacute;n de Unidades'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3">
						<cfinclude template="../../portlets/pNavegacion.cfm">
					</td>
				</tr>
				<tr> 
					<td valign="top" width="50%"> 
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
						<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
							<cfset form.Pagina = url.Pagina>
						</cfif>
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
						<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
							<cfset form.Pagina = url.PageNum_Lista>
						</cfif>
						<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
						<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
							<cfset form.Pagina = form.PageNum>
						</cfif>		
						<cfif isdefined('url.filtro_descripcion') and not isdefined('form.filtro_descripcion')>
							<cfset form.filtro_descripcion = url.filtro_descripcion>
						</cfif>
						<cfif isdefined('url.filtro_descripcionRef') and not isdefined('form.filtro_descripcionRef')>
							<cfset form.filtro_descripcionRef = url.filtro_descripcionRef>
						</cfif>
						<cfif isdefined('url.filtro_CUfactor') and not isdefined('form.filtro_CUfactor')>
							<cfset form.filtro_CUfactor = url.filtro_CUfactor>
						</cfif>
						<cfif isdefined('url.CUlinea') and not isdefined('form.CUlinea')>
							<cfset form.CUlinea = url.CUlinea>
						</cfif>
						<cfif isdefined('url.Ucodigo') and not isdefined('form.Ucodigo')>
							<cfset form.Ucodigo = url.Ucodigo>
						</cfif>
						<cfif isdefined('url.Ucodigoref') and not isdefined('form.Ucodigoref')>
							<cfset form.Ucodigoref = url.Ucodigoref>
						</cfif>												
						
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="25">											

						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="ConversionUnidades a inner join Unidades b
																  on rtrim(a.Ucodigo) = b.Ucodigo and a.Ecodigo = b.Ecodigo
																  inner join Unidades c
																  on rtrim(a.Ucodigoref) = c.Ucodigo and a.Ecodigo = c.Ecodigo"/>
							<cfinvokeargument name="columnas" value="a.CUlinea
																	, a.Ucodigo
																	, a.Ucodigoref
																	, b.Udescripcion as descripcion
																	, c.Udescripcion as descripcionRef
																	, a.CUfactor
																	, '' as espacio"/>
							<cfinvokeargument name="desplegar" value="descripcion,descripcionRef,CUfactor,espacio"/> 
							<cfinvokeargument name="etiquetas" value="Unidad Orig&eacute;n, Unidad Conversi&oacute;n, Factor, "/> 
							<cfinvokeargument name="formatos" value="S,S,V,U"/> 
							<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# 
																	order by a.Ucodigo"/> 
							<cfinvokeargument name="align" value="left,left,right,left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="ConversionUnidades.cfm"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CUlinea"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>	
							<cfinvokeargument name="filtrar_por" value="b.Udescripcion,c.Udescripcion,a.CUfactor,''"/>																													
						</cfinvoke>										
					</td>
					<td valign="top" width="50%">
						<cfinclude template="formConversionUnidades.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>	
	<cf_templatefooter>