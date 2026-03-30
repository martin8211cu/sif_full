<cf_templateheader title="	Aduanas">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Aduanas'>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="3" valign="top">
						<cfinclude template="../../portlets/pNavegacionAD.cfm">
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
						<cfif isdefined('url.filtro_CMAcodigo') and not isdefined('form.filtro_CMAcodigo')>
							<cfset form.filtro_CMAcodigo = url.filtro_CMAcodigo>
						</cfif>
						<cfif isdefined('url.filtro_CMAdescripcion') and not isdefined('form.filtro_CMAdescripcion')>
							<cfset form.filtro_CMAdescripcion = url.filtro_CMAdescripcion>
						</cfif>
						<cfif isdefined('url.CMAid') and not isdefined('form.CMAid')>
							<cfset form.CMAid = url.CMAid>
						</cfif>
									
						<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
						<cfparam name="form.Pagina" default="1">
						<cfparam name="form.MaxRows" default="15">					
											
						<cfinvoke 
							component="sif.Componentes.pListas"
							method="pListaRH"
							returnvariable="pListaRet">
							<cfinvokeargument name="tabla" value="CMAduanas"/>
							<cfinvokeargument name="columnas" value="CMAid
																	,CMAcodigo
																	,CMAdescripcion"/> 
							<cfinvokeargument name="desplegar" value="CMAcodigo,CMAdescripcion"/> 
							<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/> 
							<cfinvokeargument name="formatos" value="S,S"/> 
							<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
																	order by CMAdescripcion"/> 
							<cfinvokeargument name="align" value="left,left"/> 
							<cfinvokeargument name="ajustar" value="N"/> 
							<cfinvokeargument name="checkboxes" value="N"/> 
							<cfinvokeargument name="irA" value="Aduanas.cfm"/> 
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CMAid"/> 
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
							<cfinvokeargument name="mostrar_filtro" value="true"/>
							<cfinvokeargument name="filtrar_automatico" value="true"/>																													
						</cfinvoke>
					</td>
					<td valign="top" width="50%" align="center">
						<cfinclude template="formAduanas.cfm">
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
	<cf_templatefooter>